// LE BILAN DE LA SEMAINE, SES DEUX LECTEURS — étude 11 lot 6 (US-13, US-14, Q-5).
//
// DEUX COMPOSANTS DANS UN SEUL FICHIER, PARCE QU'ILS PARTAGENT UN INVARIANT
// ---------------------------------------------------------------------------
// `TutorDigestCard` s'adresse à l'élève, `TutorParentDigest` à son parent. Ils
// lisent la MÊME server fn et rendent les MÊMES quatre états — mais jamais le
// même texte : la base sépare les deux corps par la colonne `audience`, et
// `get_tutor_digest` / `get_tutor_parent_digest` sont deux RPC distinctes. Les
// garder côte à côte est ce qui rend l'asymétrie visible à la relecture ; les
// séparer en deux fichiers laisserait croire à deux fonctionnalités, et la
// première divergence de rendu passerait inaperçue.
//
// ⚠️ Q-5 — UN PARENT NE LIT JAMAIS LE BILAN ÉCRIT POUR SON ENFANT.
// Ce n'est pas une préférence d'affichage : « compteur + thèmes agrégés + digest
// hebdo, JAMAIS le verbatim ». Le bilan élève est tutoyé et adressé à l'enfant ;
// le mettre sous les yeux du parent le transformerait rétroactivement en
// rapport, et un enfant qui se sait rapporté cesse d'écrire honnêtement. La
// garde est en base (policy + `audience`), celle-ci n'est que la seconde.
//
// ⚠️ LE CORPS N'EST PAS DANS LA LANGUE DE L'INTERFACE (R-3).
// Il est rédigé dans la langue de la MATIÈRE dominante de la semaine — un élève
// dont l'interface est en français peut donc recevoir un bilan en arabe, s'il a
// passé sa semaine en arabe. D'où `lang` et `dir="auto"` sur le seul corps : le
// cadre (titre, semaine, états dégradés) suit l'interface, le texte suit son
// auteur. Forcer la direction du conteneur casserait l'un ou l'autre.
//
// R-11 : AUCUNE RÉCOMPENSE. Le bilan raconte, il ne paie pas. Ni XP, ni pièce,
// ni badge — et aucune phrase qui en promette pour la semaine suivante (la règle
// descend jusque dans les prompts système de `digest.ts`).

import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { ScrollText } from "lucide-react";

import { useI18n } from "@/lib/i18n";
import { getWeeklyDigest, type TutorDigestView } from "../digest.server";

/**
 * « Semaine du 17 août ».
 *
 * ⚠️ `weekStart` est une DATE nue (`YYYY-MM-DD`), pas un instant. `new Date(s)`
 * la lirait à minuit UTC, et tout fuseau à l'ouest de Greenwich afficherait la
 * veille — le bilan du lundi 17 daté « dimanche 16 ». On la reconstruit donc en
 * heure LOCALE, à partir de ses trois nombres.
 */
function weekLabel(weekStart: string, locale: string, template: string): string {
  const [y, m, d] = weekStart.split("-").map(Number);
  if (!y || !m || !d) return template.replace("{date}", weekStart);
  const date = new Date(y, m - 1, d);
  return template.replace(
    "{date}",
    date.toLocaleDateString(locale, { day: "numeric", month: "long" }),
  );
}

/**
 * Le corps du bilan, et rien d'autre.
 *
 * `whitespace-pre-line` parce que le modèle rend de la PROSE, pas du balisage :
 * `validateDigestOutput` rejette Markdown, HTML et LaTeX (R-10), donc la seule
 * mise en forme qui survit est le retour à la ligne. Le rendre avec un
 * `dangerouslySetInnerHTML` ou un pipeline Markdown ouvrirait une surface XSS
 * pour un texte qui, par construction, n'en a aucun besoin.
 */
function DigestBody({ view }: { view: Extract<TutorDigestView, { kind: "digest" }> }) {
  return (
    <p
      data-testid="tutor-digest-body"
      lang={view.lang}
      dir="auto"
      className="mt-2 text-sm leading-relaxed whitespace-pre-line"
    >
      {view.body}
    </p>
  );
}

/**
 * LE BILAN DE L'ÉLÈVE — sur son tableau de bord.
 *
 * POURQUOI IL PARLE MÊME QUAND IL N'A RIEN
 * ---------------------------------------------------------------------------
 * Le bilan naît le DIMANCHE : six jours sur sept, l'état nominal est « pas
 * encore ». Le réflexe du dépôt sur un panneau vide est de ne rien rendre
 * (« Tes points faibles », le compteur d'énergie, les compteurs tuteur à zéro) —
 * mais ici l'absence serait un mensonge par omission : un enfant qui n'a jamais
 * vu la carte ne saura pas qu'il y a quelque chose à revenir lire le dimanche,
 * et la fonctionnalité n'existera que pour ceux qui ouvrent l'application ce
 * jour-là. On rend donc UNE LIGNE discrète tant qu'il n'y a rien, et la carte
 * complète quand il y a un bilan. Le silence coûterait la découverte ; une
 * carte pleine de vide coûterait l'attention.
 *
 * Aucun `weekStart` n'est passé, DÉLIBÉRÉMENT : la RPC rend le plus récent et
 * annonce elle-même sa semaine. Demander « la semaine en cours » un mardi
 * rendrait vide six jours sur sept — l'écran ne suppose pas le calendrier du
 * batch, il lit ce qui existe.
 */
export function TutorDigestCard() {
  const { t, locale } = useI18n();
  const fetchDigest = useServerFn(getWeeklyDigest);

  const { data } = useQuery<TutorDigestView>({
    queryKey: ["tutor-digest", "student"],
    queryFn: () => fetchDigest({ data: {} }),
    // Un bilan hebdomadaire ne change pas dans la matinée. Le rafraîchir au
    // moindre focus ferait un aller-retour par visite pour un texte figé jusqu'à
    // dimanche prochain.
    staleTime: 30 * 60_000,
  });

  // Pendant le premier chargement il n'y a pas d'état à annoncer : afficher
  // « pas encore de bilan » puis le remplacer par un bilan ferait clignoter une
  // fausse nouvelle. On attend.
  if (!data) return null;

  if (data.kind === "none") {
    return (
      <p data-testid="tutor-digest-empty" className="text-muted-foreground mt-3 text-xs">
        {data.reason === "unavailable" ? t.tutor.digest.unavailable : t.tutor.digest.notYet}
      </p>
    );
  }

  return (
    <div
      data-testid="tutor-digest"
      className="border-border bg-surface-2 mt-3 rounded-xl border p-4"
    >
      <div className="flex flex-wrap items-center justify-between gap-2">
        <span className="flex items-center gap-1.5 text-sm font-semibold">
          <ScrollText className="size-4 shrink-0 text-[color:var(--gold)]" aria-hidden="true" />
          {t.tutor.digest.title}
        </span>
        <span className="text-muted-foreground text-xs">
          {weekLabel(data.weekStart, locale, t.tutor.digest.weekLabel)}
        </span>
      </div>
      <DigestBody view={data} />
      {/* La signature du lot 2, réutilisée : « El Ostedh » en FR/EN, « الأستاذ »
          en arabe. En écrire une jumelle ici ferait diverger le nom du tuteur
          d'un écran à l'autre — et c'est un personnage, pas un libellé. */}
      <p className="text-muted-foreground mt-2 text-xs font-medium">— {t.tutor.coach.signature}</p>
    </div>
  );
}

/**
 * LE BILAN DU PARENT — dans le rapport famille, posé par la ROUTE.
 *
 * `parent-report` n'importe pas `tutor` (une feature n'en importe jamais une
 * autre) : ce composant est passé à `ReportContent` par le slot
 * `renderTutorDigest`, motif `renderCoach` / `renderTutor` / `renderPractice`.
 *
 * ICI TOUS LES ÉTATS PARLENT, ET C'EST L'INVERSE DE L'ÉCRAN ÉLÈVE
 * ---------------------------------------------------------------------------
 * Un parent ouvre ce rapport DÉLIBÉRÉMENT, pour y chercher quelque chose. Un
 * blanc le laisserait conclure que la fonctionnalité est cassée, ou pire qu'il
 * n'y avait rien à dire de son enfant. Et surtout `not-linked` est le seul état
 * de tout le lot sur lequel un lecteur peut AGIR — le taire enverrait un parent
 * attendre un bilan qu'aucun dimanche ne produira, alors qu'un code à ressaisir
 * suffisait.
 */
export function TutorParentDigest({ studentId }: { studentId: string }) {
  const { t, locale } = useI18n();
  const fetchDigest = useServerFn(getWeeklyDigest);

  const { data } = useQuery<TutorDigestView>({
    queryKey: ["tutor-digest", "parent", studentId],
    queryFn: () => fetchDigest({ data: { audience: "parent", studentId } }),
    staleTime: 30 * 60_000,
  });

  if (!data) return null;

  return (
    <div
      className="bg-surface-2 border-border/50 rounded-xl border p-4"
      data-testid="report-tutor-digest"
    >
      <div className="flex flex-wrap items-center justify-between gap-2">
        <h3 className="text-foreground text-sm font-semibold">{t.tutor.digest.parentTitle}</h3>
        {data.kind === "digest" && (
          <span className="text-muted-foreground text-xs">
            {weekLabel(data.weekStart, locale, t.tutor.digest.weekLabel)}
          </span>
        )}
      </div>

      {data.kind === "digest" ? (
        <DigestBody view={data} />
      ) : (
        <p className="text-muted-foreground mt-1 text-xs" data-testid="report-tutor-digest-empty">
          {data.reason === "not-linked"
            ? t.tutor.digest.notLinked
            : data.reason === "unavailable"
              ? t.tutor.digest.unavailable
              : t.tutor.digest.parentNotYet}
        </p>
      )}
    </div>
  );
}
