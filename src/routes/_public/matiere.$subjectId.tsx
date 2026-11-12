import { createFileRoute, Link, notFound } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { CloudOff } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { SubjectHubSkeleton } from "@/features/quest/components/subject-hub-skeleton";
import { useT } from "@/lib/i18n";
import { getSubject, getSubjectParcours } from "@/features/quest";
import { useAuth } from "@/features/auth";
import { SubjectHub } from "@/features/quest/components/subject-hub";
import { PageShell } from "@/components/ui/page-shell";
import { isRtlText } from "@/shared/lib/utils";
import {
  breadcrumbJsonLd,
  itemListJsonLd,
  publicPageHead,
  seedOnServer,
} from "@/shared/lib/public-page-seo";
import { CatalogueNotFound } from "./-catalogue-not-found";

/**
 * Public subject page — « Référence » register (chantier C8). Thin: fetches the
 * subject (anon-capable) and hands it to <SubjectHub/>. No auth guard (under the
 * public `_public` coquille).
 */
export const Route = createFileRoute("/_public/matiere/$subjectId")({
  // Rendu serveur de la page publique (`public-page-seo.ts`) : le loader ne tourne
  // utilement qu'au SSR, où il précharge la version ANONYME de la page et calcule
  // son <head> ; le composant la montre en `placeholderData` jusqu'à ce que sa
  // propre requête réponde. Derrière `import.meta.env.SSR`, ce code (et son
  // `<head>`) sort du bundle client — le loader y rend `null`.
  loader: ({ params }) => (import.meta.env.SSR ? seedMatiere(params.subjectId) : null),
  head: ({ loaderData }) => loaderData?.head ?? { meta: [{ title: "Matière · Na9ra Nal3ab" }] },
  component: MatierePage,
  // Une matière qui n'existe pas : HTTP 404 dans la coquille publique (voir
  // `seedMatiere`), pas un écran d'erreur servi en 200.
  notFoundComponent: () => <CatalogueNotFound />,
});

/** SSR seulement : le sommaire anonyme de la matière et son <head>. */
async function seedMatiere(subjectId: string) {
  const data = await seedOnServer("matiere", async () => {
    const server = await import("@/features/quest/quest.server");
    return server.getSubject({ data: { subjectId } });
  });
  if (!data?.subject) {
    // `getSubject` lève la même erreur pour une matière absente et pour une lecture
    // en échec. On tranche par une lecture d'une ligne, sur ce chemin d'échec
    // seulement : `false` = elle n'existe pas → 404 ; `null` = la panne est
    // confirmée (ou cette lecture-ci a échoué aussi) → 200, le client recharge.
    const exists = await seedOnServer("matiere-existe", async () => {
      const server = await import("@/features/quest/quest.lesson.server");
      return server.checkSubjectExists({ data: { subjectId } });
    });
    if (exists === false) throw notFound();
    return null;
  }
  const { subject, chapters } = data;
  // Le niveau : `getSubject` ne le rend JAMAIS à l'anonyme (sa RPC lui est refusée),
  // donc jamais au rendu serveur — lecture directe, d'appoint (`null` si elle échoue).
  const parcours =
    data.parcours ??
    (await seedOnServer("matiere-niveau", async () => {
      const server = await import("@/features/quest/quest.lesson.server");
      return server.getSubjectParcours({ data: { subjectId } });
    }));
  const path = `/matiere/${subjectId}`;
  const chapterTitles = chapters.map((c) => c.title).join(" · ");
  // Le titre nomme le NIVEAU : 88 pages de matière sur 129 partageaient le leur
  // (« English » × 21, « الرياضيات » × 9) tant qu'il manquait.
  const title = parcours ? `${subject.name_fr} — ${parcours.name_fr}` : subject.name_fr;
  const head = publicPageHead({
    title,
    description:
      subject.description || `Cours, résumés et exercices corrigés, gratuits : ${chapterTitles}`,
    path,
    contentLanguage: subject.content_language,
    jsonLd: [
      // Fil d'Ariane : niveau › matière.
      breadcrumbJsonLd([
        ...(parcours ? [{ name: parcours.name_fr, path: `/niveau/${parcours.id}` }] : []),
        { name: subject.name_fr, path },
      ]),
      // Les cours de la matière, dans l'ordre du programme.
      ...(chapters.length > 0
        ? [
            itemListJsonLd(
              title,
              chapters.map((c) => ({ name: c.title, path: `/chapitre/${c.id}` })),
            ),
          ]
        : []),
    ],
  });
  return { data, parcours, head };
}

function MatierePage() {
  const { subjectId } = Route.useParams();
  const { user } = useAuth();
  const fetchSubject = useServerFn(getSubject);
  const t = useT();
  const seed = Route.useLoaderData();
  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["subject", subjectId],
    queryFn: () => fetchSubject({ data: { subjectId } }),
    placeholderData: seed?.data,
  });
  // Le niveau du visiteur SANS compte : `getSubject` ne le lui rend pas (voir
  // `seedMatiere`). Sans cette lecture, le lien de retour vers le niveau
  // n'existait que pour un élève connecté — ni pour un visiteur, ni pour un robot.
  const fetchParcours = useServerFn(getSubjectParcours);
  const { data: anonParcours } = useQuery({
    queryKey: ["subject-parcours", subjectId],
    queryFn: () => fetchParcours({ data: { subjectId } }),
    placeholderData: seed?.parcours,
    enabled: !!data && !data.parcours,
    staleTime: Infinity,
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState
          icon={CloudOff}
          tone="error"
          title={t.errors.subjectLoadFailed}
          action={
            <Button variant="outline" onClick={() => refetch()}>
              {t.common.retry}
            </Button>
          }
        />
      </div>
    );
  }

  if (isLoading || !data) {
    return <SubjectHubSkeleton />;
  }

  return (
    <>
      <SubjectHub
        subject={data.subject}
        chapters={data.chapters}
        exercises={data.exercises}
        progress={data.progress}
        quizPassedByChapter={data.quizPassedByChapter}
        parcours={data.parcours ?? anonParcours ?? null}
        recall={data.recall}
        isAuthenticated={!!user}
        unrestricted={data.viewer.unrestricted}
      />
      {/* Le sommaire, en LIENS : le hub replie ses chapitres et ne rend le lien d'un
          cours que dans l'accordéon ouvert — un seul sur N dans le HTML du serveur
          (constat du 2026-11-12). Ici chaque cours est à un clic de sa matière, pour
          l'élève qui cherche un chapitre comme pour un robot sans JavaScript. */}
      {data.chapters.length > 1 && (
        <PageShell className="pt-0">
          <nav aria-labelledby="matiere-sommaire">
            <h2
              id="matiere-sommaire"
              className="text-xs font-semibold uppercase tracking-[0.2em] text-muted-foreground"
            >
              {t.public.reader.toc}
            </h2>
            {/* `dir` sur la LISTE, d'après les titres : une matière en arabe se lit de
                droite à gauche, colonnes comprises (le n° 1 à droite). */}
            <ol
              dir={data.chapters.some((chapter) => isRtlText(chapter.title)) ? "rtl" : "ltr"}
              className="mt-3 grid gap-x-6 gap-y-1.5 sm:grid-cols-2"
            >
              {data.chapters.map((chapter, index) => (
                <li key={chapter.id}>
                  <Link
                    to="/chapitre/$chapterId"
                    params={{ chapterId: chapter.id }}
                    className="text-sm text-muted-foreground transition hover:text-primary hover:underline"
                  >
                    <span className="tabular-nums">{index + 1}.</span> {chapter.title}
                  </Link>
                </li>
              ))}
            </ol>
          </nav>
        </PageShell>
      )}
    </>
  );
}
