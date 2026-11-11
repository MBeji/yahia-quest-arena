#!/usr/bin/env node
/**
 * Gate de dérive des types Supabase — audit du 2026-09-12, constat D-1.
 *
 * `src/shared/integrations/supabase/types.ts` est GÉNÉRÉ (postgres-meta, le module que
 * `supabase gen types` fait tourner) et la DoD dit « prefer regenerating » — mais rien ne
 * vérifiait qu'il l'avait été. Le 2026-09-12, il était en retard de 28 RPC et 3 tables
 * vivantes (tout le lot é31, `export_user_data`, `client_errors`…), ce qui fabrique les
 * « vues d'ombre » (`as unknown as`) et les ponts de types tenus à la main.
 *
 * Ce gate est STATIQUE (~0,1 s, aucune base) : il rejoue la chaîne `supabase/migrations/**`
 * au niveau des NOMS — tables, vues, fonctions, enums du schéma `public` — et exige que
 * `types.ts` porte exactement ces noms, ni plus, ni moins. Il ne juge pas les signatures
 * (c'est `typecheck` qui le fait, à l'appel) : il attrape l'objet qui n'a jamais été typé et
 * l'objet fantôme qu'une génération depuis la prod aurait ramené hors chaîne.
 *
 * Ce que postgres-meta omet, et qu'on omet donc aussi : les fonctions `RETURNS TRIGGER` /
 * `EVENT_TRIGGER` (jamais appelables par `rpc()`). Les objets hors `public` (`auth.`,
 * `extensions.`, `graphql_public.`) ne sont pas suivis.
 *
 * Remède quand il rougit : `npm run db:gen-types` (régénère depuis la chaîne, sans Docker
 * ni jeton prod — docs/agents/pgtap-en-local.md), jamais une édition à la main.
 *
 *   node scripts/db/check-types-drift.mjs [--migrations <dir>] [--types <file>]
 */
import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { pathToFileURL } from "node:url";

export const DEFAULT_MIGRATIONS_DIR = "supabase/migrations";
export const DEFAULT_TYPES_FILE = "src/shared/integrations/supabase/types.ts";

/**
 * Objets que `types.ts` peut porter SANS que la chaîne les crée — chacun avec sa raison.
 * Vide aujourd'hui : `_backup_subscriptions_20260609`, reliquat de prod hors chaîne et
 * référencé nulle part, est sorti des types à la régénération du 2026-09-13.
 * @type {Record<"tables"|"views"|"functions"|"enums", string[]>}
 */
export const ALLOWED_EXTRA = { tables: [], views: [], functions: [], enums: [] };

const SECTIONS = ["tables", "views", "functions", "enums"];

/** Retire les commentaires `--` et les corps `$…$` : seule la DDL de tête compte. */
export function stripSql(sql) {
  return sql.replace(/--[^\n]*/g, "").replace(/\$([A-Za-z_]*)\$[\s\S]*?\$\1\$/g, "$$body$$");
}

/** `public.name`, `"name"`, `name` → `name` ; un autre schéma → null. */
export function publicName(raw) {
  const m = /^(?:"?([A-Za-z_][A-Za-z0-9_]*)"?\.)?"?([A-Za-z_][A-Za-z0-9_]*)"?$/.exec(raw.trim());
  if (!m) return null;
  if (m[1] && m[1] !== "public") return null;
  return m[2];
}

/**
 * Rejoue une chaîne de migrations (texte, dans l'ordre) au niveau des noms.
 * @param {string[]} sqlFiles contenus des migrations, triés par nom
 * @returns {{tables:Set<string>, views:Set<string>, functions:Set<string>, enums:Set<string>}}
 */
export function replayChain(sqlFiles) {
  const live = { tables: new Set(), views: new Set(), functions: new Set(), enums: new Set() };
  /** `nom/nbArgs` — une surcharge vivante par entrée. */
  const signatures = new Set();
  for (const raw of sqlFiles) {
    const sql = stripSql(raw);
    const statements = sql.split(";");
    for (const st of statements) {
      const s = st.replace(/\s+/g, " ").trim();
      if (!s) continue;
      let m;
      if ((m = /^create table (?:if not exists )?([^\s(]+)/i.exec(s))) {
        const n = publicName(m[1]);
        if (n) live.tables.add(n);
      } else if ((m = /^drop table (?:if exists )?(.+?)(?: cascade| restrict)?$/i.exec(s))) {
        for (const part of m[1].split(",")) {
          const n = publicName(part);
          if (n) live.tables.delete(n);
        }
      } else if (
        (m = /^alter table (?:if exists )?(?:only )?([^\s]+) rename to ([^\s]+)$/i.exec(s))
      ) {
        const from = publicName(m[1]);
        const to = publicName(m[2]);
        if (from && to && live.tables.has(from)) {
          live.tables.delete(from);
          live.tables.add(to);
        }
      } else if (
        (m = /^create (?:or replace )?(?:materialized )?view (?:if not exists )?([^\s(]+)/i.exec(s))
      ) {
        const n = publicName(m[1]);
        if (n) live.views.add(n);
      } else if (
        (m = /^drop (?:materialized )?view (?:if exists )?(.+?)(?: cascade| restrict)?$/i.exec(s))
      ) {
        for (const part of m[1].split(",")) {
          const n = publicName(part);
          if (n) live.views.delete(n);
        }
      } else if ((m = /^create type ([^\s(]+) as enum/i.exec(s))) {
        const n = publicName(m[1]);
        if (n) live.enums.add(n);
      } else if ((m = /^drop type (?:if exists )?(.+?)(?: cascade| restrict)?$/i.exec(s))) {
        for (const part of m[1].split(",")) {
          const n = publicName(part);
          if (n) live.enums.delete(n);
        }
      } else if ((m = /^create (?:or replace )?function ([^\s(]+)\s*\(([\s\S]*)$/i.exec(s))) {
        const n = publicName(m[1]);
        if (!n) continue;
        const argc = countArgs(m[2]);
        const isTrigger = /\)\s*returns\s+(?:event_)?trigger\b/i.test(s);
        if (isTrigger) signatures.delete(`${n}/${argc}`);
        else signatures.add(`${n}/${argc}`);
      } else if ((m = /^drop function (?:if exists )?(.+?)(?: cascade| restrict)?$/i.exec(s))) {
        // `DROP FUNCTION a(int), b(text)` : une surcharge par élément. Sans parenthèses,
        // toutes les surcharges du nom tombent (sémantique Postgres).
        for (const part of splitTopLevel(m[1])) {
          const paren = part.indexOf("(");
          const n = publicName(paren < 0 ? part : part.slice(0, paren));
          if (!n) continue;
          if (paren < 0) {
            for (const sig of [...signatures]) if (sig.startsWith(`${n}/`)) signatures.delete(sig);
          } else {
            signatures.delete(`${n}/${countArgs(part.slice(paren + 1))}`);
          }
        }
      }
    }
  }
  for (const sig of signatures) live.functions.add(sig.slice(0, sig.lastIndexOf("/")));
  return live;
}

/** Découpe sur les virgules de premier niveau (hors parenthèses). */
export function splitTopLevel(text) {
  const out = [];
  let depth = 0;
  let cur = "";
  for (const ch of text) {
    if (ch === "(") depth += 1;
    if (ch === ")") depth -= 1;
    if (ch === "," && depth === 0) {
      out.push(cur.trim());
      cur = "";
    } else cur += ch;
  }
  if (cur.trim()) out.push(cur.trim());
  return out;
}

/**
 * Nombre de paramètres d'une liste ouverte juste après `(` : on lit jusqu'à la parenthèse
 * fermante appariée. `OUT` et `VARIADIC` comptent comme Postgres les compte dans la
 * signature de `DROP` : les paramètres `OUT` n'en font pas partie.
 */
export function countArgs(afterOpenParen) {
  let depth = 1;
  let i = 0;
  for (; i < afterOpenParen.length; i += 1) {
    const ch = afterOpenParen[i];
    if (ch === "(") depth += 1;
    if (ch === ")") {
      depth -= 1;
      if (depth === 0) break;
    }
  }
  const inner = afterOpenParen.slice(0, i).trim();
  if (!inner) return 0;
  return splitTopLevel(inner).filter((p) => !/^out\s/i.test(p)).length;
}

/**
 * Les clés du schéma `public` de types.ts, section par section.
 * Une fonction surchargée s'écrit `name:` puis `| {` sur la ligne suivante : les deux formes
 * sont lues.
 * @param {string} ts
 */
export function parseTypes(ts) {
  const out = { tables: new Set(), views: new Set(), functions: new Set(), enums: new Set() };
  const start = ts.indexOf("\n  public: {");
  if (start < 0) throw new Error("types.ts : bloc `public: {` introuvable");
  const body = ts.slice(start);
  const heads = {
    tables: "    Tables: {",
    views: "    Views: {",
    functions: "    Functions: {",
    enums: "    Enums: {",
  };
  const order = [...SECTIONS, "composite"];
  const marks = { ...heads, composite: "    CompositeTypes: {" };
  for (let i = 0; i < SECTIONS.length; i += 1) {
    const key = order[i];
    const from = body.indexOf(marks[key]);
    if (from < 0) continue;
    const to = body.indexOf(marks[order[i + 1]], from);
    const section = body.slice(from, to < 0 ? undefined : to);
    // Une clé d'objet est à 6 espaces exactement : `name: {`, `name:` (surcharge, `| {`
    // sur la ligne suivante) ou `name: "a" | "b";` (enum). Tout le reste est plus profond.
    for (const m of section.matchAll(/^      ([A-Za-z_][A-Za-z0-9_]*):/gm)) out[key].add(m[1]);
  }
  return out;
}

/**
 * @returns {{ ok: boolean, missing: Record<string,string[]>, extra: Record<string,string[]> }}
 */
export function compare(chain, types, allowedExtra = ALLOWED_EXTRA) {
  const missing = {};
  const extra = {};
  for (const key of SECTIONS) {
    missing[key] = [...chain[key]].filter((n) => !types[key].has(n)).sort();
    extra[key] = [...types[key]]
      .filter((n) => !chain[key].has(n) && !(allowedExtra[key] ?? []).includes(n))
      .sort();
  }
  const ok = SECTIONS.every((k) => missing[k].length === 0 && extra[k].length === 0);
  return { ok, missing, extra };
}

export function formatReport({ ok, missing, extra }) {
  if (ok) return "[types-drift] OK — types.ts porte exactement les objets `public` de la chaîne.";
  const lines = ["[types-drift] types.ts a dérivé de la chaîne de migrations :"];
  for (const key of SECTIONS) {
    if (missing[key].length)
      lines.push(
        `  ${key} absents des types (${missing[key].length}) : ${missing[key].join(", ")}`,
      );
    if (extra[key].length)
      lines.push(
        `  ${key} dans les types mais hors chaîne (${extra[key].length}) : ${extra[key].join(", ")}`,
      );
  }
  lines.push("  → régénérer : npm run db:gen-types (jamais à la main — guard-generated.mjs).");
  return lines.join("\n");
}

function argOf(flag, fallback) {
  const i = process.argv.indexOf(flag);
  return i >= 0 && process.argv[i + 1] ? process.argv[i + 1] : fallback;
}

export function main() {
  const dir = argOf("--migrations", DEFAULT_MIGRATIONS_DIR);
  const typesFile = argOf("--types", DEFAULT_TYPES_FILE);
  const files = readdirSync(dir)
    .filter((f) => f.endsWith(".sql"))
    .sort()
    .map((f) => readFileSync(join(dir, f), "utf8"));
  const verdict = compare(replayChain(files), parseTypes(readFileSync(typesFile, "utf8")));
  const report = formatReport(verdict);
  if (verdict.ok) {
    console.log(report);
    return 0;
  }
  console.error(report);
  return 1;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  process.exit(main());
}
