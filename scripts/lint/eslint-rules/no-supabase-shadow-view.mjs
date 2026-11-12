/**
 * ESLint rule: le client Supabase ne se caste pas vers une « vue d'ombre ».
 *
 * LA DETTE QU'ELLE EMPÊCHE DE REVENIR
 * ---------------------------------------------------------------------------
 * Pendant des mois, chaque RPC ou colonne ajoutée après la dernière génération
 * des types a reçu le même pansement :
 *
 *     type FooRpcClient = { rpc: (fn: "foo", args: {...}) => PromiseLike<...> };
 *     const client = context.supabase as unknown as FooRpcClient;
 *
 * avec, recopiée d'un fichier à l'autre, la phrase qui le justifiait —
 * « `gen types` exige un accès DB indisponible en session ». Elle est FAUSSE :
 * `npm run db:gen-types` régénère les types depuis la chaîne de migrations, sans
 * aucun accès à une base distante.
 *
 * Le pansement coûte deux choses. Il débranche la vérification des ARGUMENTS
 * (une faute de frappe dans `p_limit` compile) et il AFFIRME la forme de retour
 * au lieu de la vérifier (une dérive SQL devient une valeur mal typée, en
 * silence). Le 2026-11-12, 22 de ces casts ont été retirés de cinq modules ;
 * cette règle est le cliquet qui les empêche de revenir.
 *
 * CE QU'ELLE REFUSE
 * ---------------------------------------------------------------------------
 *   1. `<client> as unknown as T`, où `<client>` est une expression nommée
 *      `supabase` ou `supabaseAdmin` (`supabase`, `context.supabase`, …) ;
 *   2. un paramètre `supabase: unknown` — la même vue, en plus discret : le cast
 *      suivant s'écrit alors `supabase as FooRpcClient`, sans `unknown`, et
 *      échappait au `grep` qui comptait la dette.
 *
 * QUOI FAIRE À LA PLACE
 * ---------------------------------------------------------------------------
 *   - la RPC ou la colonne manque aux types : `npm run db:gen-types` ;
 *   - un argument `DEFAULT NULL` : `?? undefined`, pas `null` ;
 *   - obligatoire mais nullable : `nullableRpcArg()` (`rpc-args.ts`) ;
 *   - la forme de RETOUR diverge (union fermée, nullabilité) : un schéma Zod
 *     dans `src/shared/integrations/supabase/rpc-rows.ts` et `parseRpcRows`.
 *
 * LA LISTE D'ATTENTE
 * ---------------------------------------------------------------------------
 * `PENDING_FILES` nomme les fichiers qui portaient encore une vue quand la règle
 * est née. Ce n'est pas une exemption durable : le test de la règle échoue dès
 * qu'un fichier de la liste ne contient plus de violation — on le retire alors
 * de la liste, et elle ne peut que rétrécir. Les `__tests__` sont hors
 * périmètre : un faux client y est partiel par nature.
 */

/** Fichiers encore à nettoyer (voir docs/dette-technique.md, « Ouvert »). */
export const PENDING_FILES = [
  "src/features/ai/ai-access.server.ts",
  "src/features/auth/auth.server.ts",
  "src/features/auth/welcome-pack.server.ts",
  "src/features/notifications/notifications.cron.server.ts",
  "src/features/parent-report/parent-report.server.ts",
  "src/features/shop/shop.server.ts",
  "src/features/tutor/digest.server.ts",
  "src/features/tutor/tutor.practice.server.ts",
  "src/shared/integrations/ai/ai-vault.server.ts",
];

const CLIENT_NAMES = new Set(["supabase", "supabaseAdmin"]);

function normalize(filename) {
  return String(filename).replace(/\\/g, "/");
}

function isExempt(filename, ignorePending) {
  const path = normalize(filename);
  if (path.includes("__tests__/") || /\.test\.[cm]?[jt]sx?$/.test(path)) return true;
  if (ignorePending) return false;
  return PENDING_FILES.some((pending) => path.endsWith(pending));
}

/** `supabase`, `context.supabase`, `ctx.context.supabaseAdmin`… */
function isSupabaseClient(node) {
  if (node.type === "Identifier") return CLIENT_NAMES.has(node.name);
  if (node.type === "MemberExpression" && !node.computed) {
    return node.property.type === "Identifier" && CLIENT_NAMES.has(node.property.name);
  }
  return false;
}

/** @type {import('eslint').Rule.RuleModule} */
export const noSupabaseShadowView = {
  meta: {
    type: "problem",
    docs: {
      description:
        "Interdit de caster le client Supabase vers une vue étroite (`as unknown as XClient`) : le cast débranche la vérification des arguments et affirme la forme de retour sans la vérifier.",
    },
    schema: [
      {
        type: "object",
        properties: { ignorePending: { type: "boolean" } },
        additionalProperties: false,
      },
    ],
    messages: {
      shadowCast:
        "Le client Supabase ne se caste pas vers une vue d'ombre. Si la RPC ou la colonne manque aux types : `npm run db:gen-types` (aucun accès DB requis). Si la forme de retour diverge : un schéma Zod dans `rpc-rows.ts` et `parseRpcRows`. Voir l'en-tête de la règle.",
      unknownParam:
        "Un paramètre `{{name}}: unknown` prépare un cast vers une vue d'ombre. Typer le paramètre `SupabaseClient<Database>` et appeler le client généré.",
    },
  },

  create(context) {
    const filename = context.filename ?? context.getFilename();
    const ignorePending = context.options[0]?.ignorePending === true;
    if (isExempt(filename, ignorePending)) return {};

    function checkParam(param) {
      const target = param.type === "AssignmentPattern" ? param.left : param;
      if (target.type !== "Identifier" || !CLIENT_NAMES.has(target.name)) return;
      const annotation = target.typeAnnotation?.typeAnnotation;
      if (annotation?.type === "TSUnknownKeyword") {
        context.report({ node: target, messageId: "unknownParam", data: { name: target.name } });
      }
    }

    function checkFunction(node) {
      for (const param of node.params) checkParam(param);
    }

    return {
      TSAsExpression(node) {
        // `X as unknown as T` : l'expression externe est un `as`, dont l'opérande
        // est lui-même `X as unknown`.
        const inner = node.expression;
        if (inner.type !== "TSAsExpression") return;
        if (inner.typeAnnotation.type !== "TSUnknownKeyword") return;
        if (!isSupabaseClient(inner.expression)) return;
        context.report({ node, messageId: "shadowCast" });
      },
      FunctionDeclaration: checkFunction,
      FunctionExpression: checkFunction,
      ArrowFunctionExpression: checkFunction,
    };
  },
};
