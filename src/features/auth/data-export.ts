import type { Json } from "@/shared/integrations/supabase/types";

/**
 * Portabilité — la part PURE : la forme du document rendu par `export_user_data()`,
 * le nom du fichier qu'on tend à l'utilisateur, et de quoi le résumer d'une phrase.
 *
 * Pourquoi un module à part plutôt que trois lignes dans la route : le document
 * est produit par du SQL (le seul endroit qui sache énumérer le catalogue), passe
 * par une server fn qui ne fait que le relayer, et n'est mis en forme qu'au
 * navigateur. Les seules décisions TypeScript de cette chaîne — comment s'appelle
 * le fichier, que dit-on à l'utilisateur de ce qu'il vient de télécharger — sont
 * ici, où elles se testent sans DOM ni base.
 *
 * ⚠️ Ce fichier ne DÉCRIT pas ce que l'export contient : la liste des tables vit
 * dans `user_data_export_plan()`, dérivée de `pg_constraint`. Une seconde liste
 * ici serait fausse à la première migration — c'est précisément le piège que la
 * migration 20260902120000 a écarté côté base, il ne faut pas le réintroduire
 * côté client.
 */

/** Une entrée du bloc « pourquoi cette colonne n'est pas dans ton fichier ». */
export type UserDataExportNote = {
  table: string;
  column: string;
  reason: string;
};

/**
 * Le document rendu par la RPC. Volontairement lâche sur le CONTENU des lignes
 * (`Json`) : leur forme est celle du schéma, elle change à chaque migration, et
 * prétendre la typer ici produirait un type qui ment un jour sur deux. Ce qui est
 * typé, c'est l'ENVELOPPE — la seule partie dont le client dépende vraiment.
 *
 * `Json` plutôt que `unknown`, et ce n'est pas un détail de style : une server fn
 * de TanStack Start VALIDE que ce qu'elle rend est sérialisable, et `unknown` ne
 * l'est pas à ses yeux. Le compilateur dit ici quelque chose de vrai — ce document
 * traverse le réseau, il ne peut contenir que du JSON.
 */
export type UserDataExport = {
  format_version: number;
  generated_at: string;
  account: { [key: string]: Json | undefined };
  tables: { [key: string]: Json[] | undefined };
  redacted: UserDataExportNote[];
  not_exported: (UserDataExportNote & { disposition: string })[];
};

/**
 * Le nom du fichier téléchargé. Trois contraintes, dans cet ordre :
 *
 * 1. Il doit se reconnaître dans un dossier « Téléchargements » six mois plus tard
 *    — d'où le nom du produit et la DATE.
 * 2. Il ne doit rien révéler de plus que son contenu : pas d'adresse e-mail, pas
 *    de pseudo. Un fichier d'export finit dans une pièce jointe, une capture, un
 *    partage d'écran ; son NOM voyage plus loin et plus souvent que lui.
 * 3. Il doit survivre à Windows, qui refuse `: \ / ? * " < > |` dans un nom de
 *    fichier — donc la date en `YYYY-MM-DD`, jamais l'horodatage ISO complet.
 *
 * L'horodatage exact reste dans le document (`generated_at`), où il ne gêne rien.
 */
export function userDataExportFileName(generatedAt: string): string {
  const day = /^(\d{4}-\d{2}-\d{2})/.exec(generatedAt)?.[1];
  return `na9ra-nal3ab-mes-donnees-${day ?? "export"}.json`;
}

/**
 * Combien de lignes le fichier contient, toutes tables confondues.
 *
 * Sert à la confirmation affichée après le téléchargement. Un « c'est fait » nu
 * laisserait l'utilisateur devant un fichier dont il ne sait pas s'il est plein
 * ou vide — et un export vide est un cas RÉEL (un compte créé la veille), qu'il
 * vaut mieux annoncer que laisser découvrir.
 *
 * Tolère un document malformé plutôt que de jeter : ce compteur sert un libellé,
 * il ne doit jamais être ce qui casse un téléchargement déjà réussi.
 */
export function countExportedRows(doc: Pick<UserDataExport, "tables">): number {
  const tables = doc?.tables;
  if (!tables || typeof tables !== "object") return 0;
  return Object.values(tables).reduce<number>(
    (total, rows) => total + (Array.isArray(rows) ? rows.length : 0),
    0,
  );
}
