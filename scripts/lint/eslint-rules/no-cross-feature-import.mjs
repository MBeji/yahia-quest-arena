/**
 * ESLint rule: une feature n'importe jamais une autre feature (AGENTS.md, Conventions).
 *
 * POURQUOI UNE RÈGLE ET PLUS UNE PHRASE
 * ---------------------------------------------------------------------------
 * La phrase est dans AGENTS.md depuis le découpage en features, et rien ne la
 * vérifiait. Re-mesurée le 2026-08-26, elle était violée cinq fois ; le
 * 2026-10-27, huit — quatre par `duel` (qui empruntait à `quest` sa saisie de
 * question, ses confettis et ses libellés) et quatre par `quest` et `tutor`, qui
 * appelaient la porte IA logée dans la feature `ai`. Une règle écrite qu'aucun
 * gate ne tient se dégrade d'une PR à l'autre, sans que personne ne le décide.
 *
 * La règle est née VERTE : les huit imports ont été déplacés avant elle (la porte
 * IA vers `src/shared/integrations/ai/`, arbitrage du propriétaire du
 * 2026-10-27 ; l'interface partagée vers `src/components/game/` et
 * `src/shared/lib/`). Dans l'autre ordre, elle naissait rouge et la première
 * envie aurait été de lui ajouter une exception.
 *
 * CE QU'ELLE VOIT
 * ---------------------------------------------------------------------------
 * Tout fichier sous `src/features/<nom>/`, tests compris — un test qui importe
 * une autre feature couple les deux suites comme le code le ferait. Sont lus :
 * `import … from`, `export … from`, `import()` et `vi.mock()` / `vi.doMock()` (un
 * mock d'une autre feature dit que le code sous test l'importe). Les chemins
 * relatifs sont résolus : `../../quest/x` est un import de `quest` comme
 * `@/features/quest/x`.
 *
 * Ce qu'il faut faire à la place : ce qui sert à deux features vit dans
 * `src/shared/` (logique, intégrations, constantes) ou `src/components/` (interface
 * transverse). C'est la route — qui, elle, peut importer plusieurs features — qui
 * compose.
 */

/** Chemin normalisé en slashes, relatif à la racine du dépôt (à partir de `src/`). */
function repoPath(filename) {
  const normalized = String(filename).replace(/\\/g, "/");
  const at = normalized.lastIndexOf("/src/");
  return at === -1 ? null : normalized.slice(at + 1);
}

/** La feature d'un chemin de dépôt (`src/features/<nom>/…`), ou null. */
function featureOf(path) {
  const match = /^src\/features\/([^/]+)\//.exec(path);
  return match ? match[1] : null;
}

/** Résout `a/b/../c` sans toucher au système de fichiers. */
function normalize(path) {
  const out = [];
  for (const part of path.split("/")) {
    if (part === "" || part === ".") continue;
    if (part === "..") out.pop();
    else out.push(part);
  }
  return out.join("/");
}

/** La feature visée par un spécificateur d'import, vu depuis `fromPath`. */
function targetFeature(specifier, fromPath) {
  if (specifier.startsWith("@/features/")) {
    return specifier.slice("@/features/".length).split("/")[0] || null;
  }
  if (specifier.startsWith(".")) {
    const dir = fromPath.slice(0, fromPath.lastIndexOf("/"));
    return featureOf(`${normalize(`${dir}/${specifier}`)}/`);
  }
  return null;
}

/** @type {import('eslint').Rule.RuleModule} */
export const noCrossFeatureImport = {
  meta: {
    type: "problem",
    docs: {
      description:
        "Interdit à une feature (`src/features/<nom>/`) d'importer une autre feature — ce qui est partagé vit dans `src/shared/` ou `src/components/`.",
    },
    schema: [],
    messages: {
      crossFeature:
        "La feature `{{from}}` importe la feature `{{to}}` (`{{specifier}}`). Une feature n'importe jamais une autre (AGENTS.md) : déplacer ce qui est partagé dans `src/shared/` (logique) ou `src/components/` (interface), ou laisser la route composer les deux.",
    },
  },

  create(context) {
    const path = repoPath(context.filename ?? context.getFilename());
    const own = path ? featureOf(path) : null;
    if (!own) return {};

    function check(node, source) {
      if (!source || source.type !== "Literal" || typeof source.value !== "string") return;
      const to = targetFeature(source.value, path);
      if (to && to !== own) {
        context.report({
          node,
          messageId: "crossFeature",
          data: { from: own, to, specifier: source.value },
        });
      }
    }

    return {
      ImportDeclaration: (node) => check(node, node.source),
      ExportNamedDeclaration: (node) => check(node, node.source),
      ExportAllDeclaration: (node) => check(node, node.source),
      ImportExpression: (node) => check(node, node.source),
      CallExpression(node) {
        const callee = node.callee;
        if (
          callee.type === "MemberExpression" &&
          callee.object.type === "Identifier" &&
          callee.object.name === "vi" &&
          callee.property.type === "Identifier" &&
          (callee.property.name === "mock" || callee.property.name === "doMock")
        ) {
          check(node, node.arguments[0]);
        }
      },
    };
  },
};
