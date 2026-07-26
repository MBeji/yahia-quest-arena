/**
 * État des lieux d'une campagne de contenu — CLI.
 *
 *   node --experimental-strip-types scripts/content/etat.ts [options]   # npm run programme:etat
 *
 * Options:
 *   --grade <slug>         Un seul niveau (ex. `1ere-sec`).
 *   --json                 Sortie machine (l'objet `EtatDesLieux`), pour un autre outil.
 *   --manifest-dir <path>  Racine des manifestes (défaut : l'arbre programmes-officiels).
 *   --content-dir <path>   Racine du contenu (défaut : content).
 *
 * Ce que la commande fait : joindre les deux moitiés de la chaîne — le registre
 * de transcription (où en est la FICHE) et l'audit de programme (où en est le
 * CONTENU) — et n'en rapporter que des faits vérifiés.
 *
 * Ce qu'elle ne fait PAS, par décision (2026-07-26) : classer, recommander,
 * désigner « le prochain couple ». La priorité de campagne reste une décision
 * humaine ; l'outil ne fait que l'informer. Toute évolution qui ajouterait un
 * classement par priorité contredirait cette décision.
 *
 * Sort en 1 uniquement si l'état n'a pas pu être ÉTABLI (registre absent,
 * manifeste invalide) — jamais parce qu'un constat déplaît : ce n'est pas un
 * gate, c'est un rapport. Le gate, c'est `programme:check`.
 */
import { resolve } from "node:path";
import { argv, cwd, exit, stderr, stdout } from "node:process";
import { auditGrade } from "../../src/shared/content/program-manifest.ts";
import { buildEtat, renderEtat } from "../../src/shared/content/etat-campagne.ts";
import {
  ContentValidationError,
  expandSubjects,
  loadAllSubjects,
} from "../../src/shared/content/loader.ts";
import { MANIFEST_DIR, loadManifests, loadRegistryInput } from "./programmes-io.ts";

function getFlag(name: string): string | undefined {
  const i = argv.indexOf(`--${name}`);
  return i !== -1 ? argv[i + 1] : undefined;
}

function main(): void {
  const onlyGrade = getFlag("grade");
  const manifestDir = resolve(cwd(), getFlag("manifest-dir") ?? MANIFEST_DIR);
  const contentDir = resolve(cwd(), getFlag("content-dir") ?? "content");

  const registry = loadRegistryInput();
  const manifests = loadManifests(manifestDir, onlyGrade);

  // Program conformity is measured on COMPILED subjects (étude 16 D-4) — the
  // same input `content:audit` uses, so the two commands can never disagree.
  const subjects = expandSubjects(loadAllSubjects(contentDir));
  const audits = manifests.map(({ manifest }) => auditGrade(manifest, subjects));

  const etat = buildEtat({ ...registry, audits, onlyGrade });

  if (argv.includes("--json")) {
    stdout.write(`${JSON.stringify(etat, null, 2)}\n`);
    return;
  }
  stdout.write(renderEtat(etat));
}

try {
  main();
} catch (err) {
  if (err instanceof ContentValidationError) {
    stderr.write(`\n✖ ${err.message}\n`);
  } else {
    stderr.write(`\n✖ Erreur inattendue: ${(err as Error).stack ?? String(err)}\n`);
  }
  exit(1);
}
