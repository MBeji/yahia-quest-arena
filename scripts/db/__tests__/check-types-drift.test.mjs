// @vitest-environment node
import { describe, it, expect } from "vitest";
import {
  replayChain,
  parseTypes,
  compare,
  formatReport,
  countArgs,
  splitTopLevel,
  publicName,
} from "../check-types-drift.mjs";

const TYPES = `export type Database = {
  graphql_public: {
    Tables: {
      [_ in never]: never;
    };
    Functions: {
      graphql: {
        Args: { query?: string };
        Returns: Json;
      };
    };
  };
  public: {
    Tables: {
      attempts: {
        Row: { id: string };
      };
      profiles: {
        Row: { id: string };
      };
    };
    Views: {
      leaderboard_ranked: {
        Row: { rank: number | null };
      };
    };
    Functions: {
      award_xp: {
        Args: { p_user: string };
        Returns: undefined;
      };
      get_report:
        | {
            Args: { p_user: string };
            Returns: Json;
          }
        | {
            Args: { p_user: string; p_from: string };
            Returns: Json;
          };
    };
    Enums: {
      hero_class: "novice" | "mage";
    };
    CompositeTypes: {
      [_ in never]: never;
    };
  };
};
`;

const CHAIN = [
  `CREATE TABLE public.profiles (id uuid PRIMARY KEY);
   CREATE TABLE IF NOT EXISTS attempts (id uuid);
   CREATE TYPE public.hero_class AS ENUM ('novice', 'mage');
   CREATE OR REPLACE FUNCTION public.award_xp(p_user uuid) RETURNS void LANGUAGE sql AS $$ SELECT 1 $$;
   -- a trigger function never reaches rpc(): postgres-meta omits it, so do we
   CREATE FUNCTION public.handle_new_user() RETURNS TRIGGER LANGUAGE plpgsql AS $$ BEGIN RETURN NEW; END $$;`,
  `CREATE MATERIALIZED VIEW IF NOT EXISTS public.leaderboard_ranked AS SELECT 1 AS rank;
   CREATE OR REPLACE FUNCTION public.get_report(p_user uuid) RETURNS jsonb LANGUAGE sql AS $body$ SELECT '{}'::jsonb $body$;
   CREATE OR REPLACE FUNCTION public.get_report(p_user uuid, p_from date DEFAULT now()) RETURNS jsonb LANGUAGE sql AS $$ SELECT '{}'::jsonb $$;`,
];

describe("publicName", () => {
  it("accepts public, quoted and bare names, refuses other schemas", () => {
    expect(publicName("public.profiles")).toBe("profiles");
    expect(publicName('"public"."profiles"')).toBe("profiles");
    expect(publicName("profiles")).toBe("profiles");
    expect(publicName("auth.users")).toBeNull();
    expect(publicName("extensions.pgcrypto")).toBeNull();
  });
});

describe("countArgs / splitTopLevel", () => {
  it("counts parameters at the top level only, ignoring defaults and nested parens", () => {
    expect(countArgs(") RETURNS void")).toBe(0);
    expect(countArgs("p_user uuid) RETURNS void")).toBe(1);
    expect(
      countArgs("p_a numeric(10,2), p_b text DEFAULT concat('a', 'b'), OUT o int) RETURNS int"),
    ).toBe(2);
    expect(splitTopLevel("public.f(uuid, text[]), public.g(int)")).toEqual([
      "public.f(uuid, text[])",
      "public.g(int)",
    ]);
  });
});

describe("replayChain", () => {
  it("replays tables, views, enums and functions of the public schema by name", () => {
    const live = replayChain(CHAIN);
    expect([...live.tables].sort()).toEqual(["attempts", "profiles"]);
    expect([...live.views]).toEqual(["leaderboard_ranked"]);
    expect([...live.enums]).toEqual(["hero_class"]);
    expect([...live.functions].sort()).toEqual(["award_xp", "get_report"]);
  });

  it("omits trigger functions, as postgres-meta does", () => {
    expect(replayChain(CHAIN).functions.has("handle_new_user")).toBe(false);
  });

  it("drops one overload by arity and keeps the other — the _scoped_attempts case", () => {
    const live = replayChain([...CHAIN, `DROP FUNCTION IF EXISTS public.get_report(uuid);`]);
    expect(live.functions.has("get_report")).toBe(true);
    const gone = replayChain([...CHAIN, `DROP FUNCTION IF EXISTS public.get_report;`]);
    expect(gone.functions.has("get_report")).toBe(false);
  });

  it("forgets dropped and renamed tables", () => {
    const live = replayChain([
      ...CHAIN,
      `DROP TABLE IF EXISTS public.attempts CASCADE; ALTER TABLE public.profiles RENAME TO heroes;`,
    ]);
    expect([...live.tables]).toEqual(["heroes"]);
  });

  it("ignores DDL that only lives inside a function body", () => {
    const live = replayChain([
      `CREATE FUNCTION public.f() RETURNS void LANGUAGE plpgsql AS $$ BEGIN EXECUTE 'CREATE TABLE public.ghost (id int)'; END $$;`,
    ]);
    expect(live.tables.size).toBe(0);
    expect(live.functions.has("f")).toBe(true);
  });
});

describe("parseTypes", () => {
  it("reads the public sections, including the overload form `name:` + `| {`", () => {
    const t = parseTypes(TYPES);
    expect([...t.tables]).toEqual(["attempts", "profiles"]);
    expect([...t.views]).toEqual(["leaderboard_ranked"]);
    expect([...t.functions]).toEqual(["award_xp", "get_report"]);
    expect([...t.enums]).toEqual(["hero_class"]);
  });

  it("never reads graphql_public as public", () => {
    expect(parseTypes(TYPES).functions.has("graphql")).toBe(false);
  });
});

describe("compare / formatReport", () => {
  it("is green when the chain and the types carry the same names", () => {
    const v = compare(replayChain(CHAIN), parseTypes(TYPES));
    expect(v.ok).toBe(true);
    expect(formatReport(v)).toContain("OK");
  });

  it("names what the types lack and what they carry beyond the chain", () => {
    const chain = replayChain([...CHAIN, `CREATE TABLE public.client_errors (id int);`]);
    const types = parseTypes(
      TYPES.replace(
        "      attempts: {",
        "      _backup_x: {\n        Row: { id: string };\n      };\n      attempts: {",
      ),
    );
    const v = compare(chain, types);
    expect(v.ok).toBe(false);
    expect(v.missing.tables).toEqual(["client_errors"]);
    expect(v.extra.tables).toEqual(["_backup_x"]);
    const report = formatReport(v);
    expect(report).toContain("client_errors");
    expect(report).toContain("_backup_x");
    expect(report).toContain("db:gen-types");
  });

  it("tolerates an explained extra object", () => {
    const types = parseTypes(
      TYPES.replace(
        "      attempts: {",
        "      _backup_x: {\n        Row: { id: string };\n      };\n      attempts: {",
      ),
    );
    const v = compare(replayChain(CHAIN), types, {
      tables: ["_backup_x"],
      views: [],
      functions: [],
      enums: [],
    });
    expect(v.ok).toBe(true);
  });
});
