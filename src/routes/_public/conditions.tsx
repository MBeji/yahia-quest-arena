import { createFileRoute, Link } from "@tanstack/react-router";
import { PageShell } from "@/components/ui/page-shell";

/**
 * Conditions d'utilisation — le second volet de GAP-024.
 *
 * Volontairement COURTES et lisibles par un parent : le service est gratuit,
 * sans engagement et sans paiement, donc l'essentiel des clauses d'un contrat
 * SaaS classique n'a rien à y faire. Ce qui compte ici : ce que la plateforme
 * promet (et ne promet pas) sur le contenu scolaire, ce qu'on attend d'un
 * compte, et à qui appartient le contenu.
 *
 * Même choix d'architecture que la politique de confidentialité : texte dans la
 * route (chunk séparé), pas dans le bundle i18n. Voir `confidentialite.tsx`.
 */
export const Route = createFileRoute("/_public/conditions")({
  head: () => ({
    meta: [
      { title: "Conditions d'utilisation · Na9ra Nal3ab" },
      {
        name: "description",
        content:
          "Les règles d'usage de Na9ra Nal3ab : service gratuit, contenu pédagogique, comptes, propriété intellectuelle.",
      },
    ],
  }),
  component: TermsPage,
});

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="mt-8">
      <h2 className="font-display text-xl font-bold text-foreground">{title}</h2>
      <div className="mt-2 space-y-3 text-sm leading-relaxed text-muted-foreground">{children}</div>
    </section>
  );
}

function TermsPage() {
  return (
    <PageShell>
      <div className="mx-auto max-w-3xl px-4 pb-16 text-start" dir="ltr">
        <h1 className="font-display text-3xl font-bold">Conditions d'utilisation</h1>
        <p className="mt-2 text-sm text-muted-foreground">Dernière mise à jour : 19 août 2026.</p>

        <Section title="Le service">
          <p>
            Na9ra Nal3ab est une plateforme d'apprentissage <strong>gratuite</strong>, alignée sur
            le programme scolaire tunisien. Il n'y a ni abonnement, ni paiement, ni option payante.
            L'accès à une partie du catalogue nécessite un compte ; le reste est consultable
            librement.
          </p>
        </Section>

        <Section title="Le compte">
          <p>
            Un compte est personnel. Le pseudonyme choisi est visible des autres élèves dans les
            classements et les duels : il ne doit pas être le nom réel de l'enfant, ni comporter de
            propos injurieux. Nous pouvons suspendre un compte qui détourne le service — triche
            systématique, contenu injurieux, tentative de nuire aux autres élèves.
          </p>
          <p>
            La création d'un compte par un enfant suppose l'accord de ses parents ou de son tuteur,
            qui peuvent le supprimer à tout moment depuis la page Paramétrage du compte.
          </p>
        </Section>

        <Section title="Le contenu pédagogique">
          <p>
            Le contenu est rédigé et relu avec soin, en suivant les programmes officiels. Il reste
            néanmoins un <strong>support de révision</strong> : il ne remplace ni le manuel
            officiel, ni le cours de l'enseignant, et une erreur y est toujours possible.
          </p>
          <p>
            Chaque exercice porte un bouton « Signaler une erreur ». C'est la meilleure façon de
            nous aider : les signalements sont relus et corrigés.
          </p>
        </Section>

        <Section title="Propriété intellectuelle">
          <p>
            Les cours, exercices, illustrations et le code de la plateforme sont protégés. Ils
            peuvent être utilisés librement pour <strong>apprendre et réviser</strong>, y compris en
            classe. En revanche, leur reproduction massive, leur revente ou leur republication sur
            un autre service ne sont pas autorisées sans accord écrit.
          </p>
          <p>
            Les références aux manuels officiels et aux programmes du ministère restent la propriété
            de leurs auteurs respectifs.
          </p>
        </Section>

        <Section title="Disponibilité">
          <p>
            Le service est fourni « tel quel », sans garantie de disponibilité continue. Il peut
            être interrompu pour maintenance ou en cas d'incident technique.
          </p>
        </Section>

        <Section title="Contact">
          <p>
            Pour toute question sur ces conditions :{" "}
            <a
              className="underline underline-offset-2 hover:text-foreground"
              href="mailto:contact@na9ranal3ab.tn"
            >
              contact@na9ranal3ab.tn
            </a>
            . Le traitement des données personnelles est décrit dans la{" "}
            <Link
              className="underline underline-offset-2 hover:text-foreground"
              to="/confidentialite"
            >
              politique de confidentialité
            </Link>
            .
          </p>
        </Section>
      </div>
    </PageShell>
  );
}
