import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { failWithClientError } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";
import { ACCOUNT_DELETE_ERROR_PREFIX, confirmsAccountEmail } from "./account-deletion";
import type { UserDataExport } from "./data-export";
import { displayNameSchema } from "./display-name";

/**
 * Bootstrap the freshly-signed-up user's profile (display name + role).
 *
 * The `handle_new_user` SQL trigger already inserts a base profile row on signup,
 * so this server fn only sets the user-chosen display name and role on top of it.
 * It is authenticated via `requireSupabaseAuth` (writes are constrained to the
 * caller's own id), so it MUST only be called once a session exists — i.e. after a
 * signup that auto-logs-in. When email confirmation is required there is no session
 * yet; in that case the trigger-created profile + signUp metadata are sufficient and
 * this fn is intentionally not called.
 *
 * SECURITY: the `role` column is no longer client-writable — direct PostgREST writes
 * to it are blocked by both a column-grant revoke and the `prevent_role_escalation`
 * trigger (see 20260606150000_security_p0_hardening.sql). The only sanctioned way for
 * a normal user to set their own onboarding role is the `set_profile_role` SECURITY
 * DEFINER RPC, which self-scopes and only permits 'student' | 'parent'. So we set the
 * display name via the (still client-writable) upsert and the role via that RPC.
 */
export const bootstrapProfile = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        displayName: displayNameSchema,
        role: z.enum(["student", "parent"]),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const { error: nameError } = await supabase.from("profiles").upsert(
      {
        id: userId,
        display_name: data.displayName,
      },
      { onConflict: "id" },
    );

    if (nameError) {
      failWithClientError(
        "auth.bootstrapProfile upsert failed",
        nameError,
        "profile_bootstrap_failed",
      );
    }

    const { error: roleError } = await supabase.rpc("set_profile_role", { p_role: data.role });

    if (roleError) {
      failWithClientError(
        "auth.bootstrapProfile set_profile_role failed",
        roleError,
        "profile_bootstrap_failed",
      );
    }

    return { ok: true as const };
  });

/**
 * Persist the student's active parcours (chosen at onboarding).
 *
 * Goes through the `set_current_parcours` SECURITY DEFINER RPC, which self-scopes
 * (writes only the caller's own profile), sets `current_parcours_id`, and — for
 * concours parcours — syncs `current_grade_id` so the school-theme catalogue scopes
 * to the right level. Returns the updated profile row.
 */
export const setCurrentParcours = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ parcoursId: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { data: profile, error } = await supabase.rpc("set_current_parcours", {
      p_parcours: data.parcoursId,
    });
    if (error) {
      failWithClientError(
        "auth.setCurrentParcours",
        error,
        "Impossible d'enregistrer ton parcours.",
      );
    }
    return { profile };
  });

/**
 * Rename the signed-in user — the only way to change a pseudo after signup.
 *
 * Until now `display_name` was written once, at signup, and never again: no screen
 * in the app could touch it, while the dashboard, the Shop and the parent report
 * all showed it.
 *
 * NO migration was needed for this, and that is worth stating rather than
 * re-deriving: `display_name` is ALREADY writable by its owner, through the two
 * halves the app requires — the RLS policy « Users can update own profile »
 * (`FOR UPDATE USING ((SELECT auth.uid()) = id)`) and the column grant
 * `GRANT UPDATE (display_name, …) ON public.profiles TO authenticated` from
 * 20260606150000_security_p0_hardening.sql. That same pair is what `bootstrapProfile`
 * above has been writing through since signup. Unlike `role`, the pseudo was never
 * revoked from the client-writable set, so no SECURITY DEFINER RPC is warranted here
 * — adding one would buy nothing and hide the RLS path that actually guards the row.
 *
 * The `.eq("id", userId)` is therefore not what makes the write safe (RLS does), but
 * it keeps the statement self-scoped at the call site, the way every other write in
 * this codebase reads.
 */
export const updateDisplayName = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ displayName: displayNameSchema }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const { data: profile, error } = await supabase
      .from("profiles")
      .update({ display_name: data.displayName })
      .eq("id", userId)
      .select("display_name")
      .single();

    // `!profile` cannot happen without `error` — `.single()` turns a zero-row match
    // into PGRST116 — but the two are destructured apart, so only testing both lets
    // the compiler see the row as present below.
    if (error || !profile) {
      failWithClientError("auth.updateDisplayName", error, "display_name_update_failed");
    }

    // The persisted (trimmed) value, so the caller renders what the database holds
    // rather than what the user typed.
    return { displayName: profile.display_name };
  });

/**
 * Supprimer DÉFINITIVEMENT le compte de l'appelant, et tout ce qui en dépend.
 *
 * C'est la moitié « suppression » de GAP-024 (STATUS.md §5) — le seul verrou légal
 * du lancement qui soit du code, et le geste que la politique de confidentialité
 * promettait déjà (« à la suppression du compte, elles sont effacées ») sans que
 * rien dans `src/` ne sache le faire.
 *
 * EFFACEMENT DUR, décidé le 2026-08-19. Un seul DELETE sur `auth.users` : les 32
 * clés étrangères `ON DELETE CASCADE` du schéma emportent le reste en une
 * transaction — profil, tentatives, séries, révisions SM-2, badges, duels, liens
 * parentaux, abonnements push. Rien n'est réécrit ligne à ligne ici, et c'est
 * voulu : une boucle de suppressions applicative oublierait la prochaine table
 * ajoutée au schéma, alors que la clé étrangère, elle, est écrite au moment où la
 * table naît. Le contrat correspondant est tenu en pgTAP
 * (`supabase/tests/60_account_deletion.test.sql`), pas ici.
 *
 * POURQUOI LE SERVICE-ROLE. `auth.admin.deleteUser` n'existe que sur la clé
 * service-role : elle ne peut pas descendre au client, et il n'y a rien à faire
 * passer par une Edge Function — `supabaseAdmin` vit déjà côté serveur, avec un
 * précédent d'usage (`notifications.cron.server.ts`). Cette fonction est le SEUL
 * chemin par lequel il supprime un utilisateur, et elle ne supprime jamais que
 * `context.userId` : l'identifiant vient du jeton vérifié par le middleware,
 * JAMAIS de l'entrée. C'est ce qui empêche d'en faire une arme (« supprime le
 * compte de quelqu'un d'autre ») ; aucun paramètre de cette fonction ne désigne
 * une personne.
 *
 * LA CONFIRMATION est la re-saisie de l'adresse du compte. Le client arme son
 * bouton avec la même fonction pure (`confirmsAccountEmail`), mais la garde qui
 * compte est celle-ci — on peut appeler une server fn sans passer par le
 * formulaire. L'adresse de référence est relue à l'instant sur l'Auth plutôt que
 * prise dans les claims du jeton : un jeton peut avoir été émis avant un
 * changement d'adresse, et la confirmation porterait alors sur une adresse que
 * l'utilisateur ne reconnaît plus.
 *
 * ⚠️ Suppose que le compte A une adresse — c'est le cas de tous aujourd'hui,
 * l'inscription e-mail + mot de passe étant l'unique chemin. Le jour où un
 * fournisseur sans adresse serait branché, c'est le GESTE de confirmation qu'il
 * faudrait repenser, pas seulement ce garde-fou.
 */
export const deleteAccount = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    // 320 = la longueur maximale d'une adresse e-mail (64 + @ + 255).
    z.object({ confirmEmail: z.string().trim().min(1).max(320) }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { userId } = context;

    const { data: account, error: lookupError } =
      await supabaseAdmin.auth.admin.getUserById(userId);
    const accountEmail = account?.user?.email ?? null;

    if (lookupError || !accountEmail) {
      failWithClientError(
        "auth.deleteAccount: compte introuvable ou sans adresse",
        lookupError ?? new Error("no email on account"),
        `${ACCOUNT_DELETE_ERROR_PREFIX}generic`,
      );
    }

    if (!confirmsAccountEmail(data.confirmEmail, accountEmail)) {
      // L'identifiant n'est journalisé que sur les REFUS : là, le compte existe
      // encore et l'incident s'instruit. Le succès, lui, ne laisse aucune trace
      // nominative — garder l'identifiant d'un compte qu'on vient d'effacer
      // contredirait l'effacement lui-même.
      logger.warn("auth.deleteAccount: confirmation refusée", { userId });
      throw new Error(`${ACCOUNT_DELETE_ERROR_PREFIX}email_mismatch`);
    }

    const { error: deleteError } = await supabaseAdmin.auth.admin.deleteUser(userId);
    if (deleteError) {
      failWithClientError(
        "auth.deleteAccount: suppression refusée par l'Auth",
        deleteError,
        `${ACCOUNT_DELETE_ERROR_PREFIX}generic`,
      );
    }

    logger.info("auth.deleteAccount: un compte a été supprimé");
    return { ok: true as const };
  });

/**
 * Rendre à l'appelant TOUT ce que la base sait de lui, en un document JSON.
 *
 * C'est la moitié « accès & portabilité » de GAP-024 (STATUS.md §5), et le
 * dernier volet CODE de ce verrou : les pages légales (#701) et la suppression
 * (#791) sont livrées, l'accès renvoyait encore la personne vers
 * `contact@na9ranal3ab.tn` — c'est-à-dire vers un geste humain, sur une boîte que
 * personne ne relève. La politique de confidentialité promet ce droit ; à partir
 * d'ici il s'exerce en un clic, comme la suppression.
 *
 * TOUT LE TRAVAIL EST DANS LE SQL, et ce n'est pas un raccourci. `export_user_data()`
 * énumère `pg_constraint` pour trouver les tables où l'utilisateur existe
 * (20260902120000_export_user_data.sql, D-1) : une table créée demain entre dans
 * l'export sans que personne n'y pense. La même liste écrite ici serait vraie le
 * jour de sa PR et fausse en silence à la suivante — et un export incomplet
 * ressemble trait pour trait à un export complet. Cette fonction ne fait donc que
 * relayer, délibérément : lui ajouter la moindre décision sur CE QUI sort
 * rouvrirait la deuxième liste.
 *
 * AUCUNE ENTRÉE, et c'est le garde-fou : rien dans cet appel ne désigne une
 * personne, donc rien n'en fait une arme (« exporte les données de quelqu'un
 * d'autre »). Le sujet est `auth.uid()`, lu par la base dans le jeton que le
 * middleware a vérifié — même posture que `deleteAccount` juste au-dessus.
 *
 * POURQUOI `POST` POUR UNE LECTURE. Les lectures de ce dépôt sont en `GET`
 * (`getCompetencyExercises`, `getLearningState`). Celle-ci ne l'est pas : elle
 * rend, en une réponse, la totalité du dossier d'une personne. Un `GET` est ce
 * qu'on préfetche, ce qu'un intermédiaire met en cache, ce qui atterrit dans un
 * journal d'accès avec son URL. Le geste est rare et explicite ; il n'a aucun
 * besoin de la sémantique de cache d'un `GET`, et beaucoup à perdre à l'avoir.
 */
export const exportUserData = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    // Même patron que les RPC de `progression.server.ts` : la fonction est
    // postérieure aux types Supabase générés, qui ne peuvent pas être régénérés
    // sans accès à une base. On fige donc son contrat ici — sans argument, ce qui
    // est aussi ce que le pgTAP 85 vérifie côté SQL.
    const client = context.supabase as unknown as {
      rpc: (
        fn: "export_user_data",
      ) => PromiseLike<{ data: UserDataExport | null; error: { message: string } | null }>;
    };

    const { data, error } = await client.rpc("export_user_data");

    if (error || !data) {
      failWithClientError(
        "auth.exportUserData",
        error ?? new Error("export_user_data returned no document"),
        "data_export_failed",
      );
    }

    // Le SUCCÈS ne laisse aucune trace nominative — même règle que la suppression
    // juste au-dessus : journaliser qui a demandé son dossier, et quand, créerait
    // une donnée personnelle de plus à l'endroit exact où l'on rend les siennes.
    logger.info("auth.exportUserData: un dossier a été servi");
    return { document: data };
  });

/**
 * Étude 31 lot 4 (R-17) — la LANGUE DU PROFIL, pour que les notifications
 * parlent celle de l'élève.
 *
 * Avant ce lot, la langue vivait dans un cookie et un `localStorage` : le serveur
 * ne la connaissait pas, et les trois payloads push partaient en français pour
 * tout le monde — y compris pour l'élève qui lit l'application en arabe. C'est un
 * réglage d'INTERFACE qui devient une donnée de PROFIL, pour la seule raison
 * qu'un canal asynchrone ne peut pas lire un cookie.
 *
 * Écriture par RPC `SECURITY DEFINER` : `locale` n'est pas dans les colonnes que
 * le grant client autorise (20260606150000), et l'y ajouter ouvrirait une
 * surface d'écriture directe pour un besoin qui tient en un verbe.
 */
export const setProfileLocale = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z.object({ locale: z.union([z.literal("fr"), z.literal("en"), z.literal("ar")]) }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const client = context.supabase as unknown as {
      rpc: (
        fn: "set_profile_locale",
        args: { p_locale: string },
      ) => PromiseLike<{ error: { message: string } | null }>;
    };
    const { error } = await client.rpc("set_profile_locale", { p_locale: data.locale });
    if (error) {
      // Une langue non enregistrée ne casse rien à l'écran : elle coûte une
      // notification en français. On journalise, on ne fait pas échouer la page.
      failWithClientError("auth.setProfileLocale", error, "Langue non enregistrée.");
    }
    return { locale: data.locale };
  });
