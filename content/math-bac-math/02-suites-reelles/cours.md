# ⚔️ Suites réelles — apprivoiser l'infini pas à pas

> 💡 «Une suite, c'est une armée de nombres qui avance vers l'infini : apprends à lire sa destination et tu domineras tout le combat.»

Tu as franchi la porte de l'Analyse avec les fonctions ; voici son second grand domaine, celui qui reviendra à coup sûr le jour du concours. Une **suite réelle** (Uₙ) est une fonction qui à chaque entier n associe un réel Uₙ. Ici, une seule question compte vraiment : **vers quoi tend (Uₙ) quand n grandit sans fin ?** Tu vas forger les outils pour répondre — récurrence, encadrements, monotonie, point fixe, suites adjacentes — et t'en servir jusqu'au dernier chapitre de l'année.

## 🏰 Le raisonnement par récurrence

C'est ton arme de base : elle prouve qu'une propriété P(n) est vraie pour **tous** les entiers n ≥ n₀, sans les tester un par un. Trois étapes obligatoires :

- **Initialisation** : on vérifie que P(n₀) est vraie (souvent n₀ = 0 ou 1).
- **Hérédité** : on suppose P(n) vraie pour un entier n ≥ n₀ quelconque (l'**hypothèse de récurrence**), et on démontre que P(n + 1) l'est aussi.
- **Conclusion** : P(n) est alors vraie pour tout entier n ≥ n₀.

_Exemple détaillé_ — montrons que pour tout n ≥ 1, 1 + 2 + 3 + … + n = n(n + 1)/2.

**Initialisation** : pour n = 1, le membre de gauche vaut 1 et n(n + 1)/2 = 1 × 2/2 = 1. ✓

**Hérédité** : supposons 1 + 2 + … + n = n(n + 1)/2. On ajoute (n + 1) aux deux membres :

$$ 1 + 2 + … + n + (n + 1) = n(n + 1)/2 + (n + 1) = (n + 1)(n + 2)/2 $$

C'est exactement la formule au rang n + 1 : la propriété se transmet, elle est donc vraie pour tout n ≥ 1.

> ⚠️ Sans l'**initialisation**, l'hérédité seule ne prouve rien : une propriété peut « s'hériter » tout en étant fausse partout si aucun premier cas ne la déclenche.

## 🗡️ Rappels : suites arithmétiques et géométriques

Tu les connais depuis la 3ème ; elles sont le socle de tout le chapitre.

| Type                        | Relation      | Terme général | Somme des termes                             |
| --------------------------- | ------------- | ------------- | -------------------------------------------- |
| **Arithmétique** (raison r) | Uₙ₊₁ = Uₙ + r | Uₙ = U₀ + nr  | (nombre de termes) × (premier + dernier) / 2 |
| **Géométrique** (raison q)  | Uₙ₊₁ = q × Uₙ | Uₙ = U₀ × qⁿ  | U₀ × (1 − q^(n+1))/(1 − q), pour q ≠ 1       |

En particulier, la somme géométrique de référence (q ≠ 1) :

$$ 1 + q + q² + … + qⁿ = (1 − q^(n+1))/(1 − q) $$

_Exemple_ : 1 + 5/3 + (5/3)² + … + (5/3)ⁿ = (1 − (5/3)^(n+1))/(1 − 5/3) = (3/2)((5/3)^(n+1) − 1).

**Notation Σ.** Pour écrire une longue somme sans pointillés, on utilise le symbole **sigma** :

$$ Σ (k = 1 → n) aₖ = a₁ + a₂ + … + aₙ $$

_Exemple_ : Σ (k = 1 → n) k = 1 + 2 + … + n = n(n + 1)/2.

## ⚡ Suites majorées, minorées, bornées et monotonie

Avant de parler de limite, on décrit la « forme » de la suite.

- (Uₙ) est **majorée** s'il existe un réel M tel que Uₙ ≤ M pour tout n ; **minorée** s'il existe m tel que Uₙ ≥ m pour tout n.
- (Uₙ) est **bornée** si elle est à la fois majorée et minorée : il existe m et M tels que m ≤ Uₙ ≤ M pour tout n. De façon équivalente, il existe un réel K > 0 tel que |Uₙ| ≤ K.
- (Uₙ) est **croissante** si Uₙ₊₁ ≥ Uₙ pour tout n ; **décroissante** si Uₙ₊₁ ≤ Uₙ pour tout n ; **monotone** si elle est croissante ou décroissante.

_Exemple_ : pour Uₙ = (−1)ⁿ, on a −1 ≤ Uₙ ≤ 1 : la suite est **bornée**. Elle n'est ni croissante ni décroissante (elle alterne).

> 🗡️ Pour étudier la monotonie, calcule le **signe de Uₙ₊₁ − Uₙ**. Si les termes sont strictement positifs, tu peux aussi comparer le **quotient Uₙ₊₁/Uₙ à 1**.

## 🔮 Limite d'une suite : convergence et divergence

Dire que **lim Uₙ = a** (a fini) signifie que Uₙ devient aussi proche de a qu'on veut dès que n est assez grand : la suite est alors **convergente**. Si Uₙ dépasse tout seuil (respectivement descend sous tout seuil), on écrit **lim Uₙ = +∞** (respectivement −∞) : la suite **diverge** vers l'infini. Une suite qui n'a aucune limite (finie ou infinie) est aussi dite divergente.

> **Encadré** — « La limite d'une suite (Uₙ) ne dépend que des grandes valeurs de n. »

Autrement dit, modifier les premiers termes ne change jamais la limite. Un outil décisif en découle : on **découpe** la suite selon les indices pairs et impairs.

> **Théorème (sous-suites paire et impaire)** — « Soit (Uₙ) une suite réelle et a fini ou infini. lim Uₙ = a si et seulement si lim U₂ₙ = a et lim U₂ₙ₊₁ = a. »

_Exemple_ : pour Uₙ = (−1)ⁿ, on a U₂ₙ = 1 → 1 et U₂ₙ₊₁ = −1 → −1. Les deux limites diffèrent : **(Uₙ) n'a pas de limite**.

Deux propriétés fondamentales encadrent toute suite convergente :

> **Théorème** — « Toute suite convergente est bornée. »

> **Théorème (signe de la limite)** — « Soit (Uₙ) convergente vers un réel a. S'il existe N₀ tel que Uₙ ≥ 0 pour tout n ≥ N₀, alors a ≥ 0. S'il existe N₀ tel que Uₙ ≤ 0 pour tout n ≥ N₀, alors a ≤ 0. »

> **Conséquence (passage à la limite dans un encadrement)** — si m ≤ Uₙ ≤ M à partir d'un certain rang et si (Uₙ) converge vers a, alors **m ≤ a ≤ M**.

> ⚠️ Les inégalités **strictes** ne se conservent pas à la limite : Uₙ = 1/n vérifie Uₙ > 0 pour tout n, pourtant sa limite est 0, pas strictement positive. À la limite, `<` devient `≤`.

## 🧮 Opérations sur les limites

On combine les limites connues comme pour les fonctions. En notant a, b des réels :

| Opération                 | Résultats (hors formes indéterminées)                                       |
| ------------------------- | --------------------------------------------------------------------------- |
| **Somme** lim(Uₙ + Vₙ)    | a + b ; (+∞) + b = +∞ ; (−∞) + b = −∞ ; (+∞) + (+∞) = +∞ ; (−∞) + (−∞) = −∞ |
| **Produit** lim(Uₙ × Vₙ)  | ab ; ∞ × (b ≠ 0) = ∞ (règle des signes) ; ∞ × ∞ = ∞ (règle des signes)      |
| **Quotient** lim(Uₙ / Vₙ) | a/b (b ≠ 0) ; ∞/(b ≠ 0) = ∞ ; a/(±∞) = 0 ; (a ≠ 0)/0 = ∞ (règle des signes) |

Les **formes indéterminées** sont les mêmes que pour les fonctions : **∞ − ∞**, **0 × ∞**, **∞/∞**, **0/0**. Face à elles, on transforme l'expression (terme dominant, factorisation, quantité conjuguée) avant de conclure.

_Exemple_ : Uₙ = (n² − 3n)/(2n² + 1). On divise par le terme dominant : Uₙ = (1 − 3/n)/(2 + 1/n²) → (1 − 0)/(2 + 0) = 1/2.

## 📐 La limite de référence : suites géométriques qⁿ

Une seule limite à mémoriser gouverne quasiment toutes les suites du chapitre.

> **Théorème** — « Soit Uₙ = qⁿ, n ≥ 0, q réel non nul. Si q > 1, alors lim qⁿ = +∞. Si |q| < 1, alors lim qⁿ = 0. Si q ≤ −1, alors (qⁿ) n'a pas de limite. Si q = 1, alors (qⁿ) est constante égale à 1. »

_Exemple_ : (1/5)ⁿ → 0 car |1/5| < 1 ; (√π)ⁿ → +∞ car √π > 1 ; ((−√5)/2)ⁿ n'a pas de limite car |−√5/2| = √5/2 > 1 et la base est négative (l'amplitude grandit et le signe alterne).

> ⚠️ Ne confonds pas |q| < 1 et q < 1 : pour q = −3, on a q < 1 mais |q| = 3 > 1, donc (qⁿ) **ne tend pas** vers 0 — elle diverge en alternant de signe.

## 🔮 Suites du type Vₙ = f(Uₙ) : continuité et composition

Beaucoup de suites s'écrivent Vₙ = f(Uₙ). On calcule leur limite en « faisant passer » la limite à travers f, à condition de contrôler f près de la limite de (Uₙ).

> **Théorème (continuité)** — « Soit f continue sur un intervalle ouvert I et (Uₙ) une suite d'éléments de I. Si (Uₙ) tend vers un réel a de I, alors (f(Uₙ)) tend vers f(a). »

> **Théorème (composition limite ∘ suite)** — « Soit f définie sur I et (Uₙ) d'éléments de I. Si lim Uₙ = ℓ (fini ou infini) et si lim (x → ℓ) f(x) = L (fini ou infini), alors lim f(Uₙ) = L. »

_Exemple_ : Uₙ = n × sin(π/(2n)). Posons xₙ = π/(2n) → 0. Alors Uₙ = (π/2) × sin(xₙ)/xₙ. Comme sin(x)/x → 1 quand x → 0 (rappel de 3ème), on obtient lim Uₙ = π/2.

## 🛡️ Limites et ordre : comparaison, gendarmes, valeur absolue

Quand une limite résiste au calcul direct, on **encadre** la suite entre deux suites plus simples.

> **Théorème (comparaison des limites finies)** — « Soit (Uₙ) et (Vₙ) convergeant vers a et b. S'il existe N₀ tel que Uₙ ≤ Vₙ pour tout n ≥ N₀, alors a ≤ b. »

> **Théorème des gendarmes (encadrement)** — « Soit (Uₙ), (Vₙ), (Wₙ) et a un réel. S'il existe N₀ tel que Vₙ ≤ Uₙ ≤ Wₙ pour tout n ≥ N₀, et si lim Vₙ = lim Wₙ = a, alors lim Uₙ = a. »

> **Corollaire (valeur absolue)** — « Si 0 ≤ |Uₙ| ≤ Vₙ à partir d'un certain rang et si lim Vₙ = 0, alors lim Uₙ = 0. »

> **Théorème (comparaison vers l'infini)** — « Si Uₙ ≤ Vₙ à partir d'un rang et si lim Uₙ = +∞, alors lim Vₙ = +∞. Si Uₙ ≤ Vₙ à partir d'un rang et si lim Vₙ = −∞, alors lim Uₙ = −∞. »

_Exemple (gendarmes)_ : Uₙ = 1/(n + cos n). Comme −1 ≤ cos n ≤ 1, on a n − 1 ≤ n + cos n, donc pour n ≥ 2, 0 ≤ Uₙ ≤ 1/(n − 1). Les deux bornes tendent vers 0, donc **lim Uₙ = 0**.

_Exemple (valeur absolue)_ : Vₙ = (cos(5n) + sin(2n))/(5n² + 1). Alors 0 ≤ |Vₙ| ≤ 2/(5n² + 1) → 0, donc **lim Vₙ = 0**.

## 🧗 Convergence des suites monotones

Voici le théorème qui « fabrique » des limites sans les calculer — l'outil clé des suites récurrentes.

> **Théorème (admis)** — « Si (Uₙ) est croissante et majorée, alors elle converge vers un réel a, et Uₙ ≤ a pour tout n. Si (Uₙ) est décroissante et minorée, alors elle converge vers un réel b, et Uₙ ≥ b pour tout n. »

> **Théorème** — « Toute suite croissante et non majorée tend vers +∞. Toute suite décroissante et non minorée tend vers −∞. »

_Exemple_ : la suite Uₙ = 1 + 1/2 + 1/3 + … + 1/n est croissante (on ajoute 1/(n + 1) > 0). On montre qu'elle **n'est pas majorée** ; par le second théorème, **lim Uₙ = +∞**.

> ⚠️ « Croissante et majorée » garantit la convergence, mais **pas** que la limite vaut le majorant : Uₙ = 1 − 1/n est majorée par 100, et pourtant sa limite est 1. Le théorème donne l'**existence** d'une limite, pas sa valeur.

## 🌀 Suites récurrentes Uₙ₊₁ = f(Uₙ) et point fixe

Une suite **récurrente** est définie par un premier terme et une relation Uₙ₊₁ = f(Uₙ). La stratégie type est en trois temps : montrer par récurrence que (Uₙ) reste dans un intervalle, prouver qu'elle est monotone et bornée (donc convergente), puis trouver la limite grâce au théorème du **point fixe**.

> **Théorème (point fixe)** — « Soit (Uₙ) vérifiant Uₙ₊₁ = f(Uₙ), n ≥ 0, où f est une fonction. Si (Uₙ) converge vers un réel a et si f est continue en a, alors a = f(a). »

La limite est donc à chercher parmi les **solutions de l'équation f(x) = x**.

::: figure L'escalier grimpe entre la courbe y = f(x) et la droite y = x : les termes U₀, U₁, U₂ montent vers le point fixe ℓ, où les deux courbes se croisent
<svg viewBox="0 0 330 250"><path d="M45 210 H310" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M45 210 V25" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M310 210 l-7 -3.5 l0 7 z" fill="#0f172a"/><path d="M45 25 l-3.5 7 l7 0 z" fill="#0f172a"/><line x1="45" y1="210" x2="230" y2="40" stroke="#94a3b8" stroke-width="1.6" stroke-dasharray="6 4"/><text x="236" y="42" font-size="12" font-weight="700" fill="#94a3b8">y = x</text><path d="M45 150 Q 120 78 200 62 T 300 50" fill="none" stroke="#0f6e56" stroke-width="2.6" stroke-linecap="round"/><text x="120" y="72" font-size="12" font-weight="700" fill="#0f6e56">y = f(x)</text><polyline points="75,210 75,130 130,130 130,102 158,102 158,88 172,88 172,79" fill="none" stroke="#b45309" stroke-width="2" stroke-linejoin="round"/><circle cx="185" cy="70" r="4" fill="#0f172a"/><line x1="185" y1="70" x2="185" y2="210" stroke="#94a3b8" stroke-width="1.1" stroke-dasharray="3 3"/><text x="185" y="226" text-anchor="middle" font-size="12" font-weight="700" fill="#0f172a">ℓ</text><text x="75" y="226" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">U₀</text><text x="130" y="226" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">U₁</text><text x="160" y="226" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">U₂</text></svg>
:::

_Exemple_ : U₀ = 1 et Uₙ₊₁ = √(Uₙ + 1). On montre par récurrence que 1 ≤ Uₙ ≤ 2, que (Uₙ) est croissante, donc croissante et majorée : elle **converge** vers un réel ℓ. Comme f : x ↦ √(x + 1) est continue, ℓ vérifie ℓ = √(ℓ + 1), soit ℓ² − ℓ − 1 = 0 avec ℓ ≥ 0 : **ℓ = (1 + √5)/2**.

> ⚠️ Trouver le point fixe ne prouve **jamais** à lui seul que la suite converge. L'équation a = f(a) ne donne la limite **qu'après** avoir établi que (Uₙ) converge (via monotone + bornée). Sauter cette étape est l'erreur la plus sanctionnée du chapitre.

## 🎯 Suites adjacentes

Deux suites qui se rapprochent l'une de l'autre en « pinçant » un réel finissent par le capturer ensemble — c'est l'idée des suites adjacentes, l'outil des valeurs approchées (approximation de e, de √a…).

> **Définition et théorème** — « Deux suites (Uₙ) et (Vₙ) sont **adjacentes** lorsque : pour tout n, Uₙ ≤ Vₙ ; (Uₙ) est croissante et (Vₙ) est décroissante ; (Vₙ − Uₙ) converge vers 0. Dans ce cas, (Uₙ) et (Vₙ) convergent vers la **même limite**. »

::: figure (Uₙ) monte par la gauche, (Vₙ) descend par la droite ; l'écart Vₙ − Uₙ s'annule et les deux suites enferment la même limite α
<svg viewBox="0 0 340 130"><path d="M25 70 H325" fill="none" stroke="#0f172a" stroke-width="1.6"/><path d="M325 70 l-7 -3.5 l0 7 z" fill="#0f172a"/><line x1="180" y1="42" x2="180" y2="70" stroke="#0f172a" stroke-width="1.6"/><text x="180" y="34" text-anchor="middle" font-size="13" font-weight="700" fill="#0f172a">α</text><circle cx="55" cy="70" r="3.5" fill="#0f6e56"/><circle cx="98" cy="70" r="3.5" fill="#0f6e56"/><circle cx="132" cy="70" r="3.5" fill="#0f6e56"/><circle cx="158" cy="70" r="3.5" fill="#0f6e56"/><text x="55" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#0f6e56">U₀</text><text x="98" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#0f6e56">U₁</text><text x="132" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#0f6e56">U₂</text><path d="M60 62 H150" fill="none" stroke="#0f6e56" stroke-width="1.4"/><path d="M150 62 l-7 -3 l0 6 z" fill="#0f6e56"/><circle cx="305" cy="70" r="3.5" fill="#b45309"/><circle cx="262" cy="70" r="3.5" fill="#b45309"/><circle cx="228" cy="70" r="3.5" fill="#b45309"/><circle cx="202" cy="70" r="3.5" fill="#b45309"/><text x="305" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">V₀</text><text x="262" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">V₁</text><text x="228" y="90" text-anchor="middle" font-size="11" font-weight="700" fill="#b45309">V₂</text><path d="M300 62 H210" fill="none" stroke="#b45309" stroke-width="1.4"/><path d="M210 62 l7 -3 l0 6 z" fill="#b45309"/></svg>
:::

_Exemple_ : Uₙ = 1 + 1/1! + 1/2! + … + 1/n! et Vₙ = Uₙ + 1/(n × n!). Alors (Uₙ) croît, (Vₙ) décroît, et Vₙ − Uₙ = 1/(n × n!) → 0 : les deux suites sont adjacentes et convergent vers un même réel, le célèbre nombre **e**.

> 🏆 Deuxième porte franchie, héros : tu sais lire la destination d'une suite, l'encadrer, prouver sa convergence par la monotonie et capturer sa limite par le point fixe ou l'adjacence. Ces armes serviront à la dérivation et à l'intégration — l'Analyse continue de te forger.
