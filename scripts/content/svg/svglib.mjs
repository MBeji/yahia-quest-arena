// Tiny dependency-free SVG builder for authoring pedagogical figures ("schémas
// explicatifs") that get embedded in content (cours.md and question prompts).
//
// Every helper returns a plain SVG-fragment string. Compose them and wrap with
// svg(). Output uses ONLY the drawing primitives allowed by the content
// sanitizer (src/shared/lib/figure.ts → DOMPurify SVG profile):
//   svg, title, g, line, path, polygon, polyline, rect, circle, ellipse, text
// No <image>/<use>/<foreignObject>/href/script/style/marker/defs.
//
// House style: dark strokes (#0f172a), accent colours for rays/highlights,
// Western digits only (0–9) in labels, min stroke-width ~2, labels carry a white
// halo (paint-order stroke) so they stay legible over any background.
//
// See scripts/content/svg/README.md for the full authoring → render → verify loop.

export const DARK = "#0f172a",
  GREY = "#64748b",
  BLUE = "#2563eb",
  RED = "#ef4444",
  GREEN = "#0f6e56",
  AMBER = "#d97706",
  PURPLE = "#7c3aed";

const n = (x) => Math.round(x * 100) / 100;

/** Wrap a body in an <svg> with a viewBox and an accessible <title> (first child). */
export function svg(w, h, title, body) {
  return `<svg viewBox="0 0 ${w} ${h}">\n<title>${title}</title>\n${body}\n</svg>`;
}

export function line(x1, y1, x2, y2, color = DARK, sw = 2, dash = null) {
  return `<line x1="${n(x1)}" y1="${n(y1)}" x2="${n(x2)}" y2="${n(y2)}" stroke="${color}" stroke-width="${sw}"${dash ? ` stroke-dasharray="${dash}"` : ""}/>`;
}

// Arrowhead triangle at point (x,y) pointing along angle (radians), size px.
function head(x, y, ang, color, size = 9) {
  const back = size,
    half = size * 0.5;
  const bx = x - back * Math.cos(ang),
    by = y - back * Math.sin(ang);
  const px = -Math.sin(ang),
    py = Math.cos(ang);
  const p1 = `${n(bx + half * px)},${n(by + half * py)}`;
  const p2 = `${n(bx - half * px)},${n(by - half * py)}`;
  return `<polygon points="${n(x)},${n(y)} ${p1} ${p2}" fill="${color}"/>`;
}

// Ray from (x1,y1) to (x2,y2) with an arrowhead. at: 'end'|'mid'|'start'.
export function ray(x1, y1, x2, y2, color = DARK, { sw = 2.5, at = "end", size = 9 } = {}) {
  const ang = Math.atan2(y2 - y1, x2 - x1);
  let hx = x2,
    hy = y2,
    hang = ang;
  if (at === "mid") {
    hx = (x1 + x2) / 2 + Math.cos(ang) * size * 0.5;
    hy = (y1 + y2) / 2 + Math.sin(ang) * size * 0.5;
  } else if (at === "start") {
    hx = x1;
    hy = y1;
    hang = ang + Math.PI;
  }
  return line(x1, y1, x2, y2, color, sw) + "\n" + head(hx, hy, hang, color, size);
}

export function circle(cx, cy, r, { fill = "none", stroke = DARK, sw = 2 } = {}) {
  return `<circle cx="${n(cx)}" cy="${n(cy)}" r="${n(r)}" fill="${fill}"${stroke ? ` stroke="${stroke}" stroke-width="${sw}"` : ""}/>`;
}
export function ellipse(cx, cy, rx, ry, { fill = "none", stroke = DARK, sw = 2 } = {}) {
  return `<ellipse cx="${n(cx)}" cy="${n(cy)}" rx="${n(rx)}" ry="${n(ry)}" fill="${fill}"${stroke ? ` stroke="${stroke}" stroke-width="${sw}"` : ""}/>`;
}
export function rect(x, y, w, h, { fill = "none", stroke = DARK, sw = 2, rx = 0 } = {}) {
  return `<rect x="${n(x)}" y="${n(y)}" width="${n(w)}" height="${n(h)}"${rx ? ` rx="${rx}"` : ""} fill="${fill}"${stroke ? ` stroke="${stroke}" stroke-width="${sw}"` : ""}/>`;
}
export function polygon(pts, { fill = "none", stroke = DARK, sw = 2 } = {}) {
  return `<polygon points="${pts.map(([x, y]) => `${n(x)},${n(y)}`).join(" ")}" fill="${fill}"${stroke ? ` stroke="${stroke}" stroke-width="${sw}"` : ""}/>`;
}
export function polyline(pts, { stroke = DARK, sw = 2, dash = null } = {}) {
  return `<polyline points="${pts.map(([x, y]) => `${n(x)},${n(y)}`).join(" ")}" fill="none" stroke="${stroke}" stroke-width="${sw}"${dash ? ` stroke-dasharray="${dash}"` : ""}/>`;
}

// Angle arc centered at (cx,cy), radius r, from angle a1 to a2 (radians, screen coords).
export function arc(cx, cy, r, a1, a2, { color = DARK, sw = 1.2 } = {}) {
  const x1 = cx + r * Math.cos(a1),
    y1 = cy + r * Math.sin(a1);
  const x2 = cx + r * Math.cos(a2),
    y2 = cy + r * Math.sin(a2);
  let d = a2 - a1;
  while (d <= -Math.PI) d += 2 * Math.PI;
  while (d > Math.PI) d -= 2 * Math.PI;
  const sweep = d > 0 ? 1 : 0,
    large = Math.abs(d) > Math.PI ? 1 : 0;
  return `<path d="M ${n(x1)} ${n(y1)} A ${r} ${r} 0 ${large} ${sweep} ${n(x2)} ${n(y2)}" fill="none" stroke="${color}" stroke-width="${sw}"/>`;
}

// Text with a white halo (house style). anchor: start|middle|end.
export function label(
  x,
  y,
  text,
  { color = DARK, size = 13, anchor = "middle", weight = 700 } = {},
) {
  return `<text x="${n(x)}" y="${n(y)}" text-anchor="${anchor}" fill="${color}" font-size="${size}" font-weight="${weight}" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">${text}</text>`;
}
// Group of labels sharing one halo (cheaper markup) — pass array of [x,y,text,opts].
export function labels(items) {
  return (
    `<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">` +
    items
      .map(
        ([x, y, t, o = {}]) =>
          `<text x="${n(x)}" y="${n(y)}" text-anchor="${o.anchor || "middle"}" fill="${o.color || DARK}" font-size="${o.size || 13}">${t}</text>`,
      )
      .join("") +
    `</g>`
  );
}
// Hatching under a horizontal line y, from x0..x1 (ground / mirror back).
export function hatch(x0, x1, y, { step = 12, len = 9, color = GREY, sw = 1.5, dir = 1 } = {}) {
  let s = "";
  for (let x = x0; x <= x1; x += step) s += `M${n(x)} ${y} L${n(x - len * dir)} ${n(y + len)} `;
  return `<path d="${s.trim()}" stroke="${color}" stroke-width="${sw}"/>`;
}

// ---- Geometry annotations (equal-segment ticks, parallel chevrons, right angle) ----

/**
 * Equal-length tick marks straddling a point at parameter t along P1→P2.
 * `count` ticks (1, 2, 3…) distinguish different equal-length families.
 * P1/P2 are [x,y]. Use to mark "I is the midpoint of [AB]" (one tick on each half)
 * or matching sides of congruent/isosceles figures.
 */
export function tick(p1, p2, t = 0.5, count = 1, color = GREEN) {
  const mx = p1[0] + t * (p2[0] - p1[0]),
    my = p1[1] + t * (p2[1] - p1[1]);
  const dx = p2[0] - p1[0],
    dy = p2[1] - p1[1],
    len = Math.hypot(dx, dy) || 1;
  const ux = dx / len,
    uy = dy / len,
    px = -uy,
    py = ux;
  let s = "";
  for (let i = 0; i < count; i++) {
    const off = (i - (count - 1) / 2) * 4;
    const cx = mx + ux * off,
      cy = my + uy * off;
    s += line(cx + px * 4, cy + py * 4, cx - px * 4, cy - py * 4, color, 1.6);
  }
  return s;
}

/**
 * Parallel-mark chevron (">") at parameter t along P1→P2. Put the same chevron
 * on two segments to show they are parallel (e.g. (MN) // (BC)).
 */
export function chevron(p1, p2, t = 0.5, color = BLUE) {
  const mx = p1[0] + t * (p2[0] - p1[0]),
    my = p1[1] + t * (p2[1] - p1[1]);
  const dx = p2[0] - p1[0],
    dy = p2[1] - p1[1],
    len = Math.hypot(dx, dy) || 1;
  const ux = dx / len,
    uy = dy / len,
    px = -uy,
    py = ux;
  const tip = [mx + ux * 3, my + uy * 3];
  return (
    line(tip[0], tip[1], mx - ux * 3 + px * 4, my - uy * 3 + py * 4, color, 1.6) +
    line(tip[0], tip[1], mx - ux * 3 - px * 4, my - uy * 3 - py * 4, color, 1.6)
  );
}

/**
 * Small right-angle square at the corner `v`, between the two rays v→a and v→b.
 * size in px. Use to mark the given right angle of a right triangle / perpendicular.
 */
export function rightAngle(v, a, b, size = 8, color = DARK) {
  const u = (p) => {
    const dx = p[0] - v[0],
      dy = p[1] - v[1],
      len = Math.hypot(dx, dy) || 1;
    return [dx / len, dy / len];
  };
  const [ax, ay] = u(a),
    [bx, by] = u(b);
  const p1 = [v[0] + ax * size, v[1] + ay * size];
  const p3 = [v[0] + bx * size, v[1] + by * size];
  const p2 = [p1[0] + bx * size, p1[1] + by * size];
  return `<path d="M ${n(p1[0])} ${n(p1[1])} L ${n(p2[0])} ${n(p2[1])} L ${n(p3[0])} ${n(p3[1])}" fill="none" stroke="${color}" stroke-width="1.2"/>`;
}
