#!/usr/bin/env python3
"""Decide whether the regression-guard sweep really failed.

`anthropics/claude-code-action@v1` exits 0 even when Claude itself errored
(e.g. a 401 auth failure: a single `result` event with is_error=true, $0, 1
turn). This reads the saved execution log and exits NON-ZERO only when the final
SDK `result` event has is_error == true — so a genuinely broken guard is visibly
red, while a successful run (is_error=false) passes.

Robustness (this is the second fix — the previous `jq -s` version failed with a
parse error on the real log, which mixes non-JSON lines between JSON events, and
a naive whole-file grep mis-fired on report text mentioning "is_error"):
  * parse the whole file as JSON (array/object) first;
  * else decode concatenated / pretty-printed / JSONL events, tolerating
    interleaved non-JSON lines (skip to the next line on a decode error);
  * inspect ONLY the last `type == "result"` object's is_error field;
  * if the log is missing or has no result event, WARN and pass (never cry wolf
    on an unpar, while the 401 case always yields a clean parseable result).

Usage: check-claude-result.py <path-to-claude-execution-output.json>
"""

import json
import os
import sys


def load_events(raw: str) -> list:
    # 1) Whole-file JSON: a single array of events, or one object.
    try:
        doc = json.loads(raw)
        return doc if isinstance(doc, list) else [doc]
    except Exception:
        pass
    # 2) Concatenated / pretty-printed / JSONL stream, tolerant of non-JSON lines.
    decoder = json.JSONDecoder()
    i, n, events = 0, len(raw), []
    while i < n:
        while i < n and raw[i] in " \t\r\n":
            i += 1
        if i >= n:
            break
        try:
            obj, end = decoder.raw_decode(raw, i)
            events.append(obj)
            i = end
        except json.JSONDecodeError:
            nl = raw.find("\n", i)
            if nl == -1:
                break
            i = nl + 1
    return events


def main() -> int:
    path = sys.argv[1] if len(sys.argv) > 1 else ""
    if not path or not os.path.exists(path):
        print("::warning::Claude execution output not found — cannot verify the sweep; not failing.")
        return 0

    raw = open(path, encoding="utf-8", errors="replace").read()
    results = [
        e for e in load_events(raw)
        if isinstance(e, dict) and e.get("type") == "result"
    ]
    if not results:
        print("::warning::No SDK result event found in the execution log — not failing the job.")
        return 0

    result = results[-1]
    if result.get("is_error") is True:
        print(
            "::error::regression-guard sweep failed at the Claude level:",
            result.get("result", "(no message)"),
        )
        return 1

    print(
        f"Sweep OK — is_error={result.get('is_error')}, "
        f"turns={result.get('num_turns')}, cost=${result.get('total_cost_usd')}"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
