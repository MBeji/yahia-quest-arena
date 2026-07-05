import { useEffect, useMemo, type ReactNode } from "react";
import {
  DndContext,
  KeyboardSensor,
  PointerSensor,
  closestCenter,
  useSensor,
  useSensors,
  type DragEndEvent,
} from "@dnd-kit/core";
import {
  SortableContext,
  arrayMove,
  sortableKeyboardCoordinates,
  useSortable,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import { ArrowDown, ArrowUp, GripVertical } from "lucide-react";
import { OptionContent } from "@/components/ui/svg-figure";
import { splitMatchingOptions, type DisplayOption } from "@/shared/lib/question-utils";
import type { QuestionInputLabels } from "@/features/quest/components/question-input";

// =============================================================================
// Drag-&-drop answer boards (Tier B, phase B2 — docs/interactive-question-types.md).
//
// OrderingBoard — arrange every step into the right sequence. The answer is the
// arranged id CSV ("b,a,d,c"); the INITIAL (shuffled) arrangement is already an
// answer, auto-filled so the run can always be validated.
//
// MatchingBoard — the left column is fixed, the right column reorders; row i
// pairs left[i] with the right item facing it. The answer is the pair CSV
// ("l1:r2,l2:r1").
//
// Both support drag (pointer + keyboard via @dnd-kit) AND tap-to-order arrows
// (accessibility / small screens), and work under RTL (vertical lists — R-4
// only concerns embedded math, which OptionContent already isolates).
// =============================================================================

type BoardProps = {
  options: DisplayOption[];
  value: string | null;
  onChange: (choice: string) => void;
  disabled?: boolean;
  rtl?: boolean;
  labels: QuestionInputLabels;
};

/** ids of `value`'s CSV when it is a permutation of `ids`; null otherwise. */
function parseArrangement(value: string | null, ids: string[]): string[] | null {
  if (!value) return null;
  const parts = value.replace(/\s+/g, "").split(",");
  if (parts.length !== ids.length) return null;
  const known = new Set(ids);
  if (!parts.every((p) => known.has(p))) return null;
  if (new Set(parts).size !== parts.length) return null;
  return parts;
}

function useBoardSensors() {
  return useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 4 } }),
    useSensor(KeyboardSensor, { coordinateGetter: sortableKeyboardCoordinates }),
  );
}

function SortableRow({
  id,
  disabled,
  children,
}: {
  id: string;
  disabled?: boolean;
  children: (dragHandle: ReactNode) => ReactNode;
}) {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } = useSortable({
    id,
    disabled,
  });
  const handle = (
    <span
      {...attributes}
      {...listeners}
      className="grid h-7 w-7 shrink-0 cursor-grab place-items-center rounded-md text-muted-foreground/70 hover:text-foreground"
      aria-hidden="true"
    >
      <GripVertical className="h-4 w-4" />
    </span>
  );
  return (
    <div
      ref={setNodeRef}
      style={{ transform: CSS.Transform.toString(transform), transition }}
      className={isDragging ? "z-10 opacity-80" : undefined}
    >
      {children(handle)}
    </div>
  );
}

function MoveArrows({
  index,
  count,
  disabled,
  onMove,
  labels,
}: {
  index: number;
  count: number;
  disabled?: boolean;
  onMove: (from: number, to: number) => void;
  labels: QuestionInputLabels;
}) {
  const arrowClass =
    "grid h-7 w-7 place-items-center rounded-md border border-border/60 text-muted-foreground transition hover:border-(--gold)/60 hover:text-foreground disabled:opacity-30";
  return (
    <span className="flex shrink-0 items-center gap-1">
      <button
        type="button"
        className={arrowClass}
        disabled={disabled || index === 0}
        onClick={() => onMove(index, index - 1)}
        aria-label={labels.moveUp}
      >
        <ArrowUp className="h-3.5 w-3.5" />
      </button>
      <button
        type="button"
        className={arrowClass}
        disabled={disabled || index === count - 1}
        onClick={() => onMove(index, index + 1)}
        aria-label={labels.moveDown}
      >
        <ArrowDown className="h-3.5 w-3.5" />
      </button>
    </span>
  );
}

/** Arrange the shuffled steps into the right order (choice = id CSV). */
export function OrderingBoard({ options, value, onChange, disabled, rtl, labels }: BoardProps) {
  const ids = useMemo(() => options.map((o) => o.id), [options]);
  const arrangement = parseArrangement(value, ids) ?? ids;
  const textById = useMemo(() => new Map(options.map((o) => [o.id, o.text])), [options]);
  const sensors = useBoardSensors();

  // The initial (shuffled) arrangement IS an answer — register it so the
  // validate button enables and a submit always carries a well-formed CSV.
  useEffect(() => {
    if (parseArrangement(value, ids) === null && ids.length > 0) onChange(ids.join(","));
  }, [value, ids, onChange]);

  const commit = (next: string[]) => onChange(next.join(","));
  const move = (from: number, to: number) => commit(arrayMove(arrangement, from, to));
  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;
    if (!over || active.id === over.id) return;
    move(arrangement.indexOf(String(active.id)), arrangement.indexOf(String(over.id)));
  };

  return (
    <div className="mt-6" data-testid="ordering-board">
      <p className="text-xs text-muted-foreground/70" dir={rtl ? "rtl" : undefined}>
        {labels.orderingHint}
      </p>
      <DndContext sensors={sensors} collisionDetection={closestCenter} onDragEnd={handleDragEnd}>
        <SortableContext items={arrangement} strategy={verticalListSortingStrategy}>
          <ol className="mt-3 space-y-2">
            {arrangement.map((id, index) => (
              <li key={id} data-testid="ordering-item" data-option-id={id}>
                <SortableRow id={id} disabled={disabled}>
                  {(handle) => (
                    <div className="flex w-full items-center gap-3 rounded-xl border border-border bg-black/40 px-3 py-3 text-sm">
                      {handle}
                      <span className="grid h-7 w-7 shrink-0 place-items-center rounded-md border border-current font-mono text-xs">
                        {index + 1}
                      </span>
                      <span className="min-w-0 flex-1">
                        <OptionContent raw={textById.get(id) ?? id} />
                      </span>
                      <MoveArrows
                        index={index}
                        count={arrangement.length}
                        disabled={disabled}
                        onMove={move}
                        labels={labels}
                      />
                    </div>
                  )}
                </SortableRow>
              </li>
            ))}
          </ol>
        </SortableContext>
      </DndContext>
    </div>
  );
}

/** Pair CSV from the fixed lefts + the current right-column arrangement. */
function pairsCsv(lefts: DisplayOption[], rightOrder: string[]): string {
  return lefts.map((left, i) => `${left.id}:${rightOrder[i]}`).join(",");
}

/** Align each right-hand item with its left partner (choice = pair CSV). */
export function MatchingBoard({ options, value, onChange, disabled, rtl, labels }: BoardProps) {
  const { lefts, rights } = useMemo(() => splitMatchingOptions(options), [options]);
  const rightIds = useMemo(() => rights.map((r) => r.id), [rights]);
  const textById = useMemo(() => new Map(options.map((o) => [o.id, o.text])), [options]);
  const sensors = useBoardSensors();

  // Recover the right-column arrangement from the pair CSV (rows follow lefts).
  const rightOrder = useMemo(() => {
    if (value) {
      const parts = value.replace(/\s+/g, "").split(",");
      if (parts.length === lefts.length) {
        const order = lefts.map((left, i) => {
          const [l, r] = (parts[i] ?? "").split(":");
          return l === left.id ? r : undefined;
        });
        if (
          order.every((r): r is string => typeof r === "string" && rightIds.includes(r)) &&
          new Set(order).size === order.length
        ) {
          return order as string[];
        }
      }
    }
    return rightIds;
  }, [value, lefts, rightIds]);

  const usable = lefts.length >= 2 && lefts.length === rights.length;

  // Auto-fill the initial alignment (it IS an answer) — same posture as ordering.
  useEffect(() => {
    if (!usable) return;
    const initial = pairsCsv(lefts, rightOrder);
    if (value !== initial && !value) onChange(initial);
  }, [usable, value, lefts, rightOrder, onChange]);

  if (!usable) {
    // Malformed authored options (sides missing/unbalanced): clean R-3 notice.
    return (
      <div
        data-testid="question-unsupported"
        className="mt-6 rounded-2xl border border-[color:var(--gold)]/40 bg-[color:var(--gold)]/5 p-5 text-sm"
        dir={rtl ? "rtl" : undefined}
      >
        <div className="font-display font-bold">{labels.unsupportedTitle}</div>
        <p className="mt-1 text-muted-foreground">{labels.unsupportedBody}</p>
      </div>
    );
  }

  const commit = (next: string[]) => onChange(pairsCsv(lefts, next));
  const move = (from: number, to: number) => commit(arrayMove(rightOrder, from, to));
  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;
    if (!over || active.id === over.id) return;
    move(rightOrder.indexOf(String(active.id)), rightOrder.indexOf(String(over.id)));
  };

  return (
    <div className="mt-6" data-testid="matching-board">
      <p className="text-xs text-muted-foreground/70" dir={rtl ? "rtl" : undefined}>
        {labels.matchingHint}
      </p>
      <DndContext sensors={sensors} collisionDetection={closestCenter} onDragEnd={handleDragEnd}>
        <SortableContext items={rightOrder} strategy={verticalListSortingStrategy}>
          <div className="mt-3 space-y-2">
            {lefts.map((left, index) => {
              const rightId = rightOrder[index];
              return (
                <div
                  key={left.id}
                  className="grid grid-cols-[1fr_1fr] items-stretch gap-2"
                  data-testid="matching-row"
                  data-pair={`${left.id}:${rightId}`}
                >
                  <div className="flex items-center gap-2 rounded-xl border border-border/60 bg-black/30 px-3 py-3 text-sm">
                    <span className="min-w-0 flex-1">
                      <OptionContent raw={left.text} />
                    </span>
                  </div>
                  <SortableRow id={rightId} disabled={disabled}>
                    {(handle) => (
                      <div className="flex h-full w-full items-center gap-2 rounded-xl border border-border bg-black/40 px-3 py-3 text-sm">
                        {handle}
                        <span className="min-w-0 flex-1">
                          <OptionContent raw={textById.get(rightId) ?? rightId} />
                        </span>
                        <MoveArrows
                          index={index}
                          count={rightOrder.length}
                          disabled={disabled}
                          onMove={move}
                          labels={labels}
                        />
                      </div>
                    )}
                  </SortableRow>
                </div>
              );
            })}
          </div>
        </SortableContext>
      </DndContext>
    </div>
  );
}
