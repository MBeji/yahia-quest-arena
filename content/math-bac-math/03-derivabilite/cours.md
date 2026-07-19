# ⚔️ Dérivabilité — lire la pente et dompter les variations

> 💡 «La dérivée est l'œil qui lit la pente d'une courbe en chaque point : maîtrise-la et aucune variation ne t'échappera.»

Tu as ouvert l'Analyse avec les limites et la continuité ; voici l'arme qui en découle directement. Le **nombre dérivé** f′(a) n'est rien d'autre qu'une limite : celle du taux d'accroissement de f en a. À partir de cette seule idée, tu vas savoir tracer une tangente, approcher un nombre, prouver une inégalité, trouver les extrema et décrire entièrement la forme d'une courbe. C'est le cœur de l'analyse du concours : presque chaque problème de fonction repose sur ce chapitre.

## 🏰 Nombre dérivé, tangente et approximation affine

Soit f définie sur un intervalle ouvert I et a un réel de I.

> **Encadré — dérivable en un réel** — « Une fonction f définie sur un intervalle ouvert I est dérivable en un réel a de I s'il existe un réel, noté f′(a) tel que lim x→a (f(x) − f(a))/(x − a) = f′(a). »

Le quotient (f(x) − f(a))/(x − a) est le **taux d'accroissement** : la pente de la corde entre les points d'abscisses a et x. Quand x se rapproche de a, cette corde bascule vers la **tangente**, et sa pente limite est le nombre dérivé f′(a). L'équation de la tangente à C_f au point d'abscisse a est donc :

$$ y = f′(a)(x − a) + f(a) $$

::: figure La tangente en A épouse la courbe en ce seul point ; sa pente est exactement le nombre dérivé f′(a).
<svg viewBox="0 0 320 210"><path d="M40 185 H305" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M40 195 V20" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M305 185 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M40 20 l-3.5 7 l7 0 z" fill="#0f172a"/><path d="M60 160 Q180 50 300 120" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linecap="round"/><line x1="42" y1="177" x2="168" y2="61" stroke="#b45309" stroke-width="2"/><circle cx="60" cy="160" r="4" fill="#0f172a"/><line x1="60" y1="160" x2="60" y2="185" stroke="#94a3b8" stroke-width="1.1" stroke-dasharray="3 3"/><text x="60" y="200" text-anchor="middle" font-size="12" font-weight="700" fill="#0f172a">a</text><text x="50" y="152" font-size="12" font-weight="700" fill="#0f172a">A</text><text x="150" y="70" font-size="12" font-weight="700" fill="#b45309">pente f′(a)</text><text x="240" y="105" font-size="12" font-weight="700" fill="#0f6e56">C_f</text></svg>
:::

_Exemple détaillé_ — soit f(x) = x³ + 3x² + 3x + 1. Sa dérivée (polynôme) est f′(x) = 3x² + 6x + 3. En a = 1 : f(1) = 1 + 3 + 3 + 1 = 8 et f′(1) = 3 + 6 + 3 = 12. La tangente au point d'abscisse 1 est y = 12(x − 1) + 8, soit **y = 12x − 4**.

Quand la corde et la tangente se confondent presque, f(a + h) ≈ f(a) + f′(a)h pour h petit : c'est l'**approximation affine**.

> **Encadré — approximation affine** — « Si f est dérivable en a, alors le réel f(a) + f′(a)h est une approximation affine de f(a + h). »

_Exemple_ — pour g(x) = x³, g′(x) = 3x², approchons (2,0001)³. On prend a = 2, h = 0,0001 : g(2 + h) ≈ g(2) + g′(2)h = 8 + 12 × 0,0001 = **8,0012** (la valeur exacte est 8,00120006…).

## 🗡️ Dérivabilité à gauche et à droite

Parfois la corde ne bascule pas vers la même pente selon qu'on approche a par la gauche ou par la droite. On distingue alors deux nombres dérivés :

$$ f′_g(a) = lim x→a⁻ (f(x) − f(a))/(x − a)     et     f′_d(a) = lim x→a⁺ (f(x) − f(a))/(x − a) $$

> **Encadré — dérivabilité à gauche et à droite** — « Une fonction f définie sur un intervalle ouvert I est dérivable en un réel a de I, si et seulement si, elle est dérivable à gauche et à droite en a et f′_g(a) = f′_d(a). »

::: figure Les deux demi-tangentes en 0 ont des pentes différentes : la courbe forme un angle, f n'est pas dérivable en 0.
<svg viewBox="0 0 300 190"><path d="M30 150 H280" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M150 175 V20" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M280 150 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M150 20 l-3.5 7 l7 0 z" fill="#0f172a"/><line x1="75" y1="70" x2="150" y2="150" stroke="#0f6e56" stroke-width="2.6"/><line x1="225" y1="70" x2="150" y2="150" stroke="#b45309" stroke-width="2.6"/><circle cx="150" cy="150" r="4" fill="#0f172a"/><text x="95" y="70" font-size="12" font-weight="700" fill="#0f6e56">pente f′g</text><text x="205" y="70" font-size="12" font-weight="700" fill="#b45309">pente f′d</text><text x="150" y="168" text-anchor="middle" font-size="12" font-weight="700" fill="#0f172a">0</text></svg>
:::

_Exemple détaillé_ — soit f(x) = |x| en a = 0. À gauche, f(x) = −x : f′_g(0) = lim x→0⁻ (−x − 0)/(x − 0) = −1. À droite, f(x) = x : f′_d(0) = lim x→0⁺ (x)/(x) = 1. Comme −1 ≠ 1, **f n'est pas dérivable en 0** : la courbe y présente un point anguleux.

> ⚠️ Une fonction peut être **continue sans être dérivable** en a : x ↦ |x| est continue partout, mais son point anguleux en 0 la rend non dérivable en 0. Dérivable ⟹ continue, jamais l'inverse.

## ⚡ Dérivable sur un intervalle

On passe du point à l'intervalle en recollant tous les points.

> **Encadré — dérivable sur un intervalle** — « Une fonction est dérivable sur un intervalle ouvert I si elle est dérivable en tout réel de I. Une fonction est dérivable sur [a, b] si elle est dérivable sur ]a, b[, à droite en a et à gauche en b. On définit de façon analogue la dérivabilité sur les intervalles [a, b[, ]a, b], a et b finis ou infinis. »

_Exemple_ — x ↦ √x est dérivable sur ]0, +∞[, de dérivée 1/(2√x). En 0 en revanche, le taux (√x − 0)/(x − 0) = 1/√x tend vers +∞ : la fonction n'est **pas** dérivable à droite en 0 (tangente verticale), bien qu'elle y soit continue.

## 🔮 Dérivées usuelles et opérations

Voici la table de référence, à connaître par cœur. Elle prolonge tes acquis de 3ème.

| Fonction f        | Dérivée f′          | Sur                   |
| ----------------- | ------------------- | --------------------- |
| xⁿ (n ∈ ℕ, n ≥ 2) | nxⁿ⁻¹               | ℝ                     |
| 1/xⁿ (n ∈ ℕ*)     | −n/xⁿ⁺¹             | tout intervalle de ℝ* |
| sin(ax + b)       | a cos(ax + b)       | ℝ                     |
| cos(ax + b)       | −a sin(ax + b)      | ℝ                     |
| tan(ax + b)       | a(1 + tan²(ax + b)) | où tan est définie    |

Les opérations se combinent alors mécaniquement (f et g dérivables sur I) :

| Opération               | Dérivée        |
| ----------------------- | -------------- |
| (f + g)′                | f′ + g′        |
| (af)′ (a ∈ ℝ)           | af′            |
| (f × g)′                | f′g + g′f      |
| (1/f)′ (f ≠ 0)          | −f′/f²         |
| (1/fⁿ)′ (n ∈ ℕ*, f ≠ 0) | −nf′f⁻ⁿ⁻¹      |
| (f/g)′ (g ≠ 0)          | (f′g − g′f)/g² |
| (fⁿ)′ (n ≥ 2)           | nf′fⁿ⁻¹        |

_Exemple détaillé_ — soit f(x) = (2x − 1)/(x² + 1). On applique (f/g)′ avec f′ = 2 et g′ = 2x :

$$ f′(x) = (2(x² + 1) − (2x − 1)(2x))/(x² + 1)² = (2x² + 2 − 4x² + 2x)/(x² + 1)² = (−2x² + 2x + 2)/(x² + 1)² $$

## 🌀 Dérivée d'une fonction composée

Quand une fonction en emboîte une autre — comme √(1 + x²) — on dérive « de l'extérieur vers l'intérieur ».

> **Théorème — dérivabilité d'une composée** — « Soit f dérivable en a et g dérivable en f(a). Alors g∘f est dérivable en a et (g∘f)′(a) = f′(a) × g′(f(a)). »

> **Corollaire** — « Si f est dérivable sur I et g dérivable sur un intervalle J contenant f(I), alors g∘f est dérivable sur I et (g∘f)′(x) = f′(x) × g′[f(x)], pour tout x de I. »

Deux cas très fréquents en découlent : (uⁿ)′ = nu′uⁿ⁻¹ (déjà dans la table) et, avec g = √ :

$$ (√u)′ = u′/(2√u)     (là où u > 0) $$

_Exemple détaillé_ — soit h(x) = √(1 + x²) sur ℝ. On pose u(x) = 1 + x², donc u′(x) = 2x. Alors :

$$ h′(x) = u′/(2√u) = 2x/(2√(1 + x²)) = x/√(1 + x²) $$

_Exemple_ — pour k(x) = (1 + sin(2x))³, avec u = 1 + sin(2x) et u′ = 2cos(2x) : k′(x) = 3u′u² = 6cos(2x)(1 + sin(2x))².

## 🧮 Dérivées successives

Si f′ est elle-même dérivable, on peut la dériver à nouveau, et recommencer.

> **Dérivées successives** — « La dérivée f′ de f est appelée dérivée première. Si f′ est dérivable, sa dérivée est la dérivée seconde, notée f⁽²⁾ ou f″. Par itération, si f⁽ⁿ⁻¹⁾ (n ≥ 2) est dérivable, sa dérivée est la dérivée nᵉᵐᵉ (ou dérivée d'ordre n), notée f⁽ⁿ⁾. »

_Exemple détaillé_ — soit f(x) = 2x³ − 4x² + x − 1. Alors f′(x) = 6x² − 8x + 1 ; f″(x) = 12x − 8 ; f⁽³⁾(x) = 12 ; f⁽⁴⁾(x) = 0.

> 🗡️ **Racine double** (rappel utile) : α est racine double d'un polynôme P (de degré ≥ 2) si et seulement si P(α) = P′(α) = 0 et P″(α) ≠ 0. C'est un test rapide de factorisation par (x − α)².

## 🛡️ Théorème de Rolle

Voici le premier grand théorème d'existence : il garantit une tangente horizontale, sans jamais la calculer.

> **Théorème de Rolle** — « Soit a et b deux réels tels que a < b. Soit f continue sur [a, b], dérivable sur ]a, b[ et telle que f(a) = f(b). Alors il existe un réel c de ]a, b[ tel que f′(c) = 0. »

::: figure Comme f(a) = f(b), la courbe monte puis redescend : quelque part entre a et b, en c, sa tangente est horizontale.
<svg viewBox="0 0 320 210"><path d="M40 180 H305" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M45 195 V20" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M305 180 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M45 20 l-3.5 7 l7 0 z" fill="#0f172a"/><path d="M70 160 Q160 30 270 160" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linecap="round"/><line x1="70" y1="160" x2="270" y2="160" stroke="#94a3b8" stroke-width="1.1" stroke-dasharray="4 3"/><line x1="110" y1="95" x2="220" y2="95" stroke="#b45309" stroke-width="2" stroke-dasharray="6 4"/><circle cx="165" cy="95" r="4" fill="#0f172a"/><circle cx="70" cy="160" r="3.5" fill="#0f172a"/><circle cx="270" cy="160" r="3.5" fill="#0f172a"/><line x1="165" y1="95" x2="165" y2="180" stroke="#94a3b8" stroke-width="1.1" stroke-dasharray="3 3"/><text x="70" y="174" text-anchor="middle" font-size="12" font-weight="700" fill="#0f172a">a</text><text x="270" y="174" text-anchor="middle" font-size="12" font-weight="700" fill="#0f172a">b</text><text x="165" y="174" text-anchor="middle" font-size="12" font-weight="700" fill="#0f172a">c</text><text x="222" y="90" font-size="11" font-weight="700" fill="#b45309">f′(c) = 0</text></svg>
:::

_Exemple détaillé_ — soit f(x) = x⁵ − 3x⁴ − 5x³ + 15x² + 4x + 2. On calcule f(−1) = −1 − 3 + 5 + 15 − 4 + 2 = 14 et f(1) = 1 − 3 − 5 + 15 + 4 + 2 = 14. Donc f(−1) = f(1) ; f est continue et dérivable sur ℝ. Par Rolle, il existe c ∈ ]−1, 1[ tel que f′(c) = 0 : la courbe admet **au moins une tangente parallèle à l'axe des abscisses**.

## 📐 Théorème des accroissements finis (TAF)

Le théorème de Rolle se généralise : quand f(a) ≠ f(b), la tangente n'est plus horizontale, mais elle est **parallèle à la corde** [AB].

> **Théorème des accroissements finis** — « Soit a et b tels que a < b et f continue sur [a, b], dérivable sur ]a, b[. Alors il existe un réel c de ]a, b[ tel que f(b) − f(a) = f′(c)(b − a). »

::: figure Il existe un point d'abscisse c où la tangente à la courbe est parallèle à la corde [AB].
<svg viewBox="0 0 320 210"><path d="M40 185 H305" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M45 195 V20" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M305 185 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M45 20 l-3.5 7 l7 0 z" fill="#0f172a"/><path d="M70 170 Q150 150 270 60" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linecap="round"/><line x1="70" y1="170" x2="270" y2="60" stroke="#94a3b8" stroke-width="1.6"/><line x1="90" y1="171" x2="230" y2="94" stroke="#b45309" stroke-width="2"/><circle cx="70" cy="170" r="3.5" fill="#0f172a"/><circle cx="270" cy="60" r="3.5" fill="#0f172a"/><circle cx="160" cy="132" r="4" fill="#0f172a"/><line x1="160" y1="132" x2="160" y2="185" stroke="#94a3b8" stroke-width="1.1" stroke-dasharray="3 3"/><text x="62" y="184" font-size="12" font-weight="700" fill="#0f172a">A</text><text x="276" y="58" font-size="12" font-weight="700" fill="#0f172a">B</text><text x="160" y="199" text-anchor="middle" font-size="12" font-weight="700" fill="#0f172a">c</text></svg>
:::

_Exemple détaillé_ — soit f(x) = x² sur [0, 2]. Alors f(2) − f(0) = 4 − 0 = 4, et le TAF cherche c tel que 4 = f′(c)(2 − 0) = 2c × 2 = 4c, d'où **c = 1** ∈ ]0, 2[. En ce point la tangente a la même pente que la corde.

## 🔒 Inégalité des accroissements finis

Le TAF sert surtout à **encadrer** un accroissement : si l'on borne la pente f′, on borne la variation de f.

> **Théorème** — « Soit f continue sur [a, b] (a < b) et dérivable sur ]a, b[. Soit deux réels m et M. Si m ≤ f′(x) ≤ M pour tout x de ]a, b[, alors m(b − a) ≤ f(b) − f(a) ≤ M(b − a). »

> **Corollaire** — « Soit f dérivable sur un intervalle I et M > 0. Si |f′(x)| ≤ M pour tout x de I, alors |f(b) − f(a)| ≤ M|b − a|, pour tous réels a et b de I. »

_Exemple détaillé_ — soit f(x) = tan x sur [0, π/4]. Sa dérivée f′(x) = 1 + tan²x vérifie 1 ≤ f′(x) ≤ 2 (car tan x ∈ [0, 1] sur cet intervalle). En appliquant l'inégalité sur [0, t] avec t ∈ [0, π/4] : 1 × (t − 0) ≤ tan t − tan 0 ≤ 2 × (t − 0), c'est-à-dire **t ≤ tan t ≤ 2t**.

_Exemple (corollaire)_ — pour f = cos, |f′(x)| = |−sin x| ≤ 1, donc |cos x − cos y| ≤ |x − y| pour tous réels x et y. C'est l'outil des suites récurrentes et des valeurs approchées.

## 🧗 Sens de variation et signe de f′

Le signe de la dérivée gouverne la montée et la descente de la courbe.

> **Théorème (signe strict)** — « Soit f dérivable sur un intervalle I. Si f′ est strictement positive sur I, alors f est strictement croissante sur I. Si f′ est strictement négative sur I, alors f est strictement décroissante sur I. »

> **Théorème (dérivée ne s'annulant sur aucun intervalle)** — « Si f′ est positive et ne s'annule sur aucun intervalle ouvert contenu dans I, alors f est strictement croissante sur I. Si f′ est négative et ne s'annule sur aucun intervalle ouvert contenu dans I, alors f est strictement décroissante sur I. »

> **Théorème (prolongement aux bornes)** — « Soit f continue sur [a, b] et dérivable sur ]a, b[. Si f est (strictement) croissante sur ]a, b[, alors elle l'est sur [a, b] ; de même pour la décroissance. »

En pratique, on étudie le signe de f′ pour dresser le **tableau de variation** de f.

_Exemple détaillé_ — soit f(x) = x³. Alors f′(x) = 3x² ≥ 0, et f′ ne s'annule qu'en 0 (donc sur **aucun intervalle**). Par le deuxième théorème, f est **strictement croissante sur ℝ**, bien que sa tangente en 0 soit horizontale.

> ⚠️ « f′ ≥ 0 » ne suffit pas pour la stricte croissance si f′ s'annule sur tout un intervalle (f y serait constante). Il faut f′ > 0, ou f′ ≥ 0 s'annulant seulement en des points isolés.

## 🎯 Extrema locaux

Un sommet ou un creux de la courbe est un extremum local.

> **Encadré — extrema locaux** — « f admet un maximum local en a s'il existe un intervalle ouvert J contenant a tel que f(x) ≤ f(a) pour tout x de J. f admet un minimum local en a s'il existe un tel J avec f(x) ≥ f(a). Un minimum ou un maximum local est un extremum local. »

> **Encadré — condition d'extremum** — « Soit f dérivable sur un intervalle ouvert I et a ∈ I. Si f admet un extremum local en a alors f′(a) = 0. Si f′(x) s'annule en a en changeant de signe alors f admet un extremum local en a. »

_Exemple détaillé_ — soit f(x) = x². Alors f′(x) = 2x s'annule en 0 en changeant de signe (négative avant, positive après) : f admet un **minimum local en 0**, égal à f(0) = 0.

> ⚠️ f′(a) = 0 est **nécessaire** mais **pas suffisant** : pour f(x) = x³, f′(0) = 0, pourtant f n'a aucun extremum en 0 (f′ = 3x² ne change pas de signe). Il faut vérifier le **changement de signe** de f′.

## 🔭 Point d'inflexion et centre de symétrie

Un **point d'inflexion** est un point où la courbe change de « courbure » et traverse sa tangente.

> **Définition — point d'inflexion** — « Soit f dérivable en a et C_f sa courbe. Le point A(a, f(a)) est un point d'inflexion de C_f si C_f traverse sa tangente en ce point. »

> **Théorème (dérivée seconde)** — « Soit f deux fois dérivable sur ]a − h, a + h[ (h > 0). Si f″ s'annule en a en changeant de signe, alors le point I(a, f(a)) est un point d'inflexion de C_f. »

::: figure En I la courbe traverse sa tangente (ici horizontale) : elle passe d'un côté à l'autre — c'est un point d'inflexion.
<svg viewBox="0 0 320 200"><polyline points="70,168 92,140 115,126 138,121 160,120 182,119 205,114 228,100 250,72" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round"/><line x1="100" y1="120" x2="220" y2="120" stroke="#b45309" stroke-width="2" stroke-dasharray="6 4"/><circle cx="160" cy="120" r="4" fill="#0f172a"/><text x="166" y="114" font-size="12" font-weight="700" fill="#0f172a">I</text><text x="222" y="116" font-size="11" font-weight="700" fill="#b45309">tangente</text><text x="255" y="70" font-size="12" font-weight="700" fill="#0f6e56">C_f</text></svg>
:::

_Exemple détaillé_ — soit f(x) = x³ − 3x + 1. Alors f′(x) = 3x² − 3 et f″(x) = 6x. f″ s'annule en 0 en changeant de signe (négative pour x < 0, positive pour x > 0) : **I(0, f(0)) = I(0, 1) est un point d'inflexion**. La tangente en 0 est y = f′(0)x + f(0) = −3x + 1, et f(x) − (−3x + 1) = x³ change de signe en 0 : la courbe traverse bien sa tangente.

Une courbe peut aussi posséder un **centre de symétrie** : un point autour duquel elle est invariante par demi-tour.

> **Encadré — centre de symétrie** — « Soit f de courbe C et O′(a, b). Le point O′ est un centre de symétrie de C si, pour tout x du domaine, 2a − x appartient au domaine et f(2a − x) = 2b − f(x). »

_Exemple_ — pour f(x) = x³ − 3x + 1 et le point I(0, 1) : f(2×0 − x) = f(−x) = −x³ + 3x + 1, tandis que 2×1 − f(x) = 2 − (x³ − 3x + 1) = −x³ + 3x + 1. Les deux sont égaux : **I(0, 1) est centre de symétrie** de C_f (et aussi son point d'inflexion).

> 🏆 Troisième porte franchie, héros : tu sais lire une pente, tracer une tangente, garantir une racine par Rolle, encadrer une variation par le TAF, décrire montée, descente, extrema et inflexions d'une courbe. Ces armes te serviront à étudier n'importe quelle fonction — et à aborder les réciproques, les primitives et les intégrales qui t'attendent.
