import { createFileRoute } from "@tanstack/react-router";
import { PageShell } from "@/components/ui/page-shell";

/**
 * Politique de confidentialité — GAP-024, et le prérequis de GAP-003
 * (conformité mineurs / INPDP) comme de la déclaration « child-directed »
 * auprès de Google (étude 23 Q-3), qui exigent toutes deux une URL STABLE.
 * D'où une route, là où les mentions légales se contentent d'une modale.
 *
 * Le texte vit ICI et non dans le bundle i18n : le chunk i18n est à 123 sur
 * 128 kB de budget, et trois pages légales en trois langues le feraient
 * exploser. Une route est un chunk à part, chargé seulement si on la visite.
 *
 * ⚠️ Rédigé à partir de ce que le code fait RÉELLEMENT (inventaire du
 * 2026-07-31 : `analytics.ts`, `product-analytics.ts`, `monitoring.ts`,
 * `video-embed.tsx`, `csp.ts` ; révisé le 2026-08-19, quand la suppression de
 * compte a cessé d'être une promesse pour devenir un bouton — `deleteAccount`
 * et `/parametrage`, section « Zone sensible ») — pas d'un modèle générique.
 * Toute nouvelle destination de données doit être ajoutée ici DANS LA MÊME PR
 * que le code qui l'introduit, sinon cette page devient un mensonge.
 *
 * Ce n'est pas un avis juridique. La page n'affirme QUE ce que le code prouve :
 * elle ne nomme aucune région d'hébergement qu'on n'a pas vérifiée, ne promet
 * aucune durée de conservation chiffrée qu'on ne tient pas, et ne prétend pas
 * qu'une déclaration INPDP a été faite. Ce qui manque encore — l'identité de
 * l'éditeur pour des mentions légales complètes, et la formalité INPDP
 * elle-même — relève de l'humain et est listé dans la PR, pas laissé en
 * « à compléter » visible par un parent.
 */
export const Route = createFileRoute("/_public/confidentialite")({
  head: () => ({
    meta: [
      { title: "Politique de confidentialité · Na9ra Nal3ab" },
      {
        name: "description",
        content:
          "Quelles données Na9ra Nal3ab collecte, pourquoi, avec qui elles sont partagées, et comment exercer vos droits. Service destiné à des enfants : aucune publicité, aucun enregistrement d'écran.",
      },
    ],
  }),
  component: PrivacyPage,
});

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="mt-8">
      <h2 className="font-display text-xl font-bold text-foreground">{title}</h2>
      <div className="mt-2 space-y-3 text-sm leading-relaxed text-muted-foreground">{children}</div>
    </section>
  );
}

function PrivacyPage() {
  return (
    <PageShell>
      <div className="mx-auto max-w-3xl px-4 pb-16 text-start" dir="ltr">
        <h1 className="font-display text-3xl font-bold">Politique de confidentialité</h1>
        <p className="mt-2 text-sm text-muted-foreground">
          Dernière mise à jour : 19 août 2026. Cette page décrit ce que Na9ra Nal3ab collecte,
          pourquoi, et avec qui ces données sont partagées.
        </p>

        <Section title="À qui s'adresse ce service">
          <p>
            Na9ra Nal3ab est une plateforme d'apprentissage destinée à des <strong>enfants</strong>{" "}
            scolarisés en Tunisie, de la 1<sup>re</sup> année de base au baccalauréat. Nous partons
            donc du principe que la plupart de nos utilisateurs sont <strong>mineurs</strong>, et
            trois conséquences en découlent, écrites dans le code avant de l'être ici :
          </p>
          <ul className="list-disc space-y-1 ps-5">
            <li>
              <strong>aucune publicité</strong>, aucun traceur publicitaire, aucune revente de
              données ;
            </li>
            <li>
              <strong>aucun enregistrement d'écran</strong> ni « session replay » — c'est une
              décision, pas une option que nous aurions oublié d'activer ;
            </li>
            <li>
              <strong>aucun profil individuel</strong> n'est construit chez nos prestataires de
              mesure d'audience.
            </li>
          </ul>
          <p>
            La création d'un compte par un enfant suppose l'accord de ses parents ou de son tuteur.
            Un parent peut à tout moment supprimer le compte de son enfant depuis la page
            Paramétrage de ce compte, ou en demander la suppression à l'adresse ci-dessous.
          </p>
        </Section>

        <Section title="Ce que nous collectons, et pourquoi">
          <p>
            <strong>Le compte</strong> — adresse e-mail et pseudonyme. L'e-mail sert à se connecter
            et à réinitialiser un mot de passe. Nous ne demandons ni nom réel, ni date de naissance,
            ni adresse, ni numéro de téléphone.
          </p>
          <p>
            <strong>La progression</strong> — les réponses aux exercices, les points d'expérience,
            les badges, les révisions programmées. Ces données existent pour une seule raison :
            afficher à l'élève où il en est, et adapter ses révisions à ses erreurs.
          </p>
          <p>
            <strong>La mesure d'audience</strong> — pages consultées et actions clés (commencer un
            exercice, le terminer). Elles nous disent si la plateforme sert à quelque chose ; elles
            ne servent ni à cibler, ni à comparer des élèves entre eux.
          </p>
          <p>
            <strong>Les incidents techniques</strong> — quand l'application plante, un rapport
            d'erreur est envoyé pour que nous puissions la réparer.
          </p>
          <p>
            Le site n'utilise <strong>pas de cookies publicitaires</strong>. Il utilise le stockage
            local du navigateur pour garder la session ouverte et retenir la langue choisie.
          </p>
        </Section>

        <Section title="Avec qui ces données sont partagées">
          <p>
            Nous ne vendons aucune donnée. Nous nous appuyons sur des prestataires techniques,
            chacun pour une fonction précise :
          </p>
          <ul className="list-disc space-y-1 ps-5">
            <li>
              <strong>Supabase</strong> — base de données et authentification (le compte et la
              progression) ;
            </li>
            <li>
              <strong>Vercel</strong> — hébergement du site ;
            </li>
            <li>
              <strong>Google Analytics 4</strong> — fréquentation du site ;
            </li>
            <li>
              <strong>PostHog</strong> — parcours et rétention, sur des serveurs de l'
              <strong>Union européenne</strong>, sans profil individuel et sans identifiant
              personnel : chaque visiteur reçoit un identifiant aléatoire, propre à ce site ;
            </li>
            <li>
              <strong>Sentry</strong> — rapports d'erreur techniques, sur des serveurs situés en{" "}
              <strong>Allemagne</strong> ;
            </li>
            <li>
              <strong>Resend</strong> — envoi des e-mails du service (confirmation, mot de passe
              oublié) ;
            </li>
            <li>
              <strong>YouTube (Google)</strong> — voir la section suivante.
            </li>
          </ul>
        </Section>

        <Section title="Les vidéos YouTube">
          <p>
            Certains chapitres proposent une vidéo explicative hébergée sur YouTube. Deux
            précautions&nbsp;:
          </p>
          <ul className="list-disc space-y-1 ps-5">
            <li>
              la vidéo est intégrée en <strong>mode sans cookie</strong> (
              <code>youtube-nocookie.com</code>) ;
            </li>
            <li>
              elle ne se charge <strong>qu'après un clic délibéré</strong> de l'élève. Tant qu'il
              n'a pas cliqué, aucune donnée n'est envoyée à Google ; l'aperçu affiché provient de
              notre propre page.
            </li>
          </ul>
          <p>
            Une fois la vidéo lancée, la lecture est soumise aux conditions et à la politique de
            confidentialité de YouTube, sur lesquelles nous n'avons pas la main.
          </p>
        </Section>

        {/* Étude 29 lot 2, §3.8 : « À faire dans le lot 2, pas plus tard ». Cette
            section dit aussi, explicitement, ce que nous NE POUVONS PAS garantir
            — ce que le fournisseur choisi par la famille fait des données après
            réception. Le taire serait la seule ligne malhonnête de cette page. */}
        <Section title="Le mode IA (clé apportée par la famille)">
          <p>
            Le mode IA est <strong>éteint par défaut</strong> pour tout le monde, et l'application
            est complète sans lui. Il ne s'allume que si un membre de la famille branche sa propre
            clé d'API, dans <strong>Paramétrage → Mode IA</strong>, puis l'active explicitement pour
            un élève donné. Nous ne facturons rien&nbsp;: la relation commerciale reste entre la
            famille et son fournisseur.
          </p>
          <p>Quand le mode est actif, voici ce qui part chez ce fournisseur&nbsp;:</p>
          <ul className="list-disc space-y-1 ps-5">
            <li>
              la question travaillée, la réponse donnée, la matière, la classe et une{" "}
              <strong>tranche d'âge</strong> ;
            </li>
            <li>
              <strong>jamais</strong> le nom, l'adresse e-mail ni l'identifiant de l'élève.
            </li>
          </ul>
          <p>
            Les explications produites peuvent être{" "}
            <strong>réutilisées pour d'autres élèves</strong>. C'est possible parce qu'elles
            dépendent de la question et de la réponse choisie, pas de qui les a posées&nbsp;: rien
            de personnel n'entre dans ce fonds commun.
          </p>
          <p>
            La clé elle-même est <strong>chiffrée</strong> avant d'être stockée, avec une clé de
            chiffrement qui ne vit pas dans la même base. Elle n'est jamais réaffichée&nbsp;: ni à
            son propriétaire, ni à nous. La révoquer depuis <strong>Paramétrage</strong> supprime
            immédiatement notre copie — mais <strong>ne la révoque pas chez le fournisseur</strong>,
            ce que nous ne pouvons pas faire à votre place.
          </p>
          <p>
            <strong>Ce que nous ne pouvons pas garantir&nbsp;:</strong> ce que le fournisseur choisi
            par la famille fait des données après réception. Sa politique de rétention et
            d'entraînement lui appartient, et certaines offres gratuites entraînent leurs modèles
            sur ce qu'on leur envoie. Nous recommandons une offre payante.
          </p>
        </Section>

        <Section title="Combien de temps nous les gardons">
          <p>
            Les données de compte et de progression sont conservées tant que le compte existe. À la
            suppression du compte, elles sont effacées. Les rapports d'erreur et les mesures
            d'audience sont conservés de façon limitée dans le temps, selon les réglages de chaque
            prestataire.
          </p>
        </Section>

        <Section title="Vos droits">
          <p>
            Conformément à la loi organique tunisienne n° 2004-63 relative à la protection des
            données à caractère personnel, vous disposez d'un droit d'accès, de rectification et de
            suppression de vos données. Pour un enfant, ces droits sont exercés par ses parents ou
            son tuteur.
          </p>
          <p>
            <strong>La suppression se fait sans nous écrire</strong> : depuis un compte connecté,
            page <strong>Paramétrage</strong>, section « Zone sensible ». Elle est immédiate et
            définitive — le compte et toute la progression qui s'y rattache sont effacés, et rien ne
            peut être restauré ensuite.
          </p>
          <p>
            Pour l'accès et la rectification, ou si vous ne pouvez plus vous connecter au compte,
            écrivez à{" "}
            <a
              className="underline underline-offset-2 hover:text-foreground"
              href="mailto:contact@na9ranal3ab.tn"
            >
              contact@na9ranal3ab.tn
            </a>{" "}
            en indiquant l'adresse e-mail du compte concerné. Nous répondons dans les meilleurs
            délais.
          </p>
        </Section>

        <Section title="Modifications">
          <p>
            Toute évolution de cette politique sera publiée sur cette page, avec sa date de mise à
            jour. Si un changement touche à la nature des données collectées, il sera signalé dans
            l'application.
          </p>
        </Section>
      </div>
    </PageShell>
  );
}
