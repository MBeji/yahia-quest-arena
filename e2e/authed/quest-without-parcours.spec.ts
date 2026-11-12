import { test, expect } from "../fixtures";
import { E2E_PASSWORD } from "../helpers/users";

/**
 * Étude 38, lot 2 — l'accueil n'est plus un péage (R-5, US-2).
 *
 * Un élève qui vient de créer son compte et qui arrive sur une quête la JOUE :
 * l'assistant d'accueil ne s'interpose plus sur `/quest/*`. Au-dessus du lecteur,
 * une carte lui propose la classe du chapitre ; « Choisir » fait ce que fait
 * l'assistant (`set_current_parcours`).
 *
 * Le compte est JETABLE (créé par l'API d'administration, supprimé en fin de test) :
 * les comptes seedés ont déjà leur classe, et la leur retirer casserait les specs
 * voisines, qui tournent en parallèle. On joue le QUIZ d'un chapitre scolaire :
 * un quiz n'est jamais verrouillé, et une matière scolaire a toujours un parcours.
 */
test.use({ storageState: { cookies: [], origins: [] } });

test.describe("Quête sans classe (étude 38, lot 2)", () => {
  test.describe.configure({ timeout: 120_000 });

  let createdEmail = "";

  test.afterEach(async ({ adminDb }) => {
    if (createdEmail) {
      await adminDb.deleteUserByEmail(createdEmail).catch(() => {});
      createdEmail = "";
    }
  });

  test("un compte neuf joue la quête demandée et y choisit sa classe, sans assistant", async ({
    auth,
    quest,
    page,
    adminDb,
  }) => {
    const subjectId = await adminDb.freeSchoolSubjectId();
    const pair = await adminDb.chapterQuizAndMission(subjectId);
    test.skip(!pair, "No chapter with a quiz on the test project.");
    if (!pair) return; // narrow the type (test.skip already aborted when null)

    // La classe attendue, lue à la source comme le fait `resolve_subject_parcours` :
    // le parcours de même thème et de même niveau que la matière.
    const { data: subject, error: subjectError } = await adminDb.client
      .from("subjects")
      .select("theme_id, grade_id")
      .eq("id", subjectId)
      .single();
    if (subjectError) throw new Error(`subject lookup: ${subjectError.message}`);
    const { data: parcours, error: parcoursError } = await adminDb.client
      .from("parcours")
      .select("id")
      .eq("theme_id", subject.theme_id as string)
      .eq("grade_id", subject.grade_id as string)
      .limit(1)
      .maybeSingle();
    if (parcoursError) throw new Error(`parcours lookup: ${parcoursError.message}`);
    test.skip(!parcours, "The school subject has no parcours on the test project.");
    if (!parcours) return;

    createdEmail = `e2e-sans-classe-${Date.now()}@example.com`;
    const { data: created, error: createError } = await adminDb.client.auth.admin.createUser({
      email: createdEmail,
      password: E2E_PASSWORD,
      email_confirm: true,
      user_metadata: { display_name: "E2E Sans Classe" },
    });
    if (createError) throw new Error(`createUser: ${createError.message}`);
    const userId = created.user.id;

    await auth.attemptLogin(createdEmail, E2E_PASSWORD);
    await page.waitForURL((url) => !url.pathname.startsWith("/auth"), { timeout: 20_000 });

    await quest.goto(pair.quizId);

    // La quête se joue : le QCM est rendu, et l'adresse est toujours la sienne une
    // fois le profil lu — c'est ce moment-là que la garde d'accueil attendait pour
    // rediriger.
    await expect(quest.options.first()).toBeVisible({ timeout: 25_000 });
    const card = page.getByTestId("parcours-quick-pick");
    await expect(card).toBeVisible({ timeout: 15_000 });
    await expect(page).toHaveURL(new RegExp(`/quest/${pair.quizId}`));

    await card.getByRole("button", { name: /choisir|choose|اختيار/i }).click();
    await expect(card).toBeHidden({ timeout: 15_000 });

    // Le choix est en base, et la quête n'a pas bougé.
    await expect
      .poll(
        async () => {
          const { data } = await adminDb.client
            .from("profiles")
            .select("current_parcours_id")
            .eq("id", userId)
            .single();
          return data?.current_parcours_id ?? null;
        },
        { timeout: 15_000 },
      )
      .toBe(parcours.id);
    await expect(page).toHaveURL(new RegExp(`/quest/${pair.quizId}`));
    await expect(quest.options.first()).toBeVisible();
  });
});
