<!-- Fiche de transcription — profil ecole-secondaire (METHODE-GENERATION-CONTENU.md, LOT A).
     Source de référence : manuels élèves officiels CNP de mathématiques, 4ème année secondaire,
     section Mathématiques (Bac). Aucun guide enseignant au corpus pour ce couple ⇒ le manuel
     élève fait référence. Campagne LOT A EN COURS : ce fichier se remplit chapitre par chapitre ;
     tant que la fiche n'est pas 100 % transcrite à profondeur de génération, le registre
     suivi/bac-math.json la garde en statut `partielle` (⛔ génération LOT B interdite). Page PDF =
     page imprimée (offset 0), vérifié sur le pied de page. -->

# Mathématiques — Bac section Mathématiques (`bac-math`) · manuel officiel CNP

> **Sources (corpus CNP, `cnp-officiel/manuels/secondaire/c4/eleve/`)** :
>
> - **Manuel élève, tome 1 « Analyse »** : code **222445P00** (207 p.) — chapitres 1 à 9.
> - **Manuel élève, tome 2 « Algèbre · Géométrie · Probabilités »** : code **222446P00** (230 p.)
>   — chapitres 1 à 10.
> - **Guide enseignant** : _aucun au corpus pour ce couple_ ⇒ le **manuel élève fait référence**
>   (profil ecole-secondaire, décision méthode). Le programme officiel ministériel n'est pas
>   intégré au corpus ; à confronter si publié (R-3), le manuel prime tant qu'il est seul.
> - **Langue d'enseignement** : **fr** (bascule ar→fr acquise depuis la 1ère année secondaire ;
>   aucun pont linguistique au Bac — conditions d'examen). Le manuel est rédigé en français.
> - **subject id** : `math-bac-math` · **gradeSlug** : `bac-math`.
> - **Notation** : chiffres occidentaux 0-9, équations LTR, unités SI (fidélité méthode).

## 1. Cadre & compétences

Année du **concours national du baccalauréat** (coefficient majeur de la section). Compétences
terminales : mobiliser l'**analyse** (limites, continuité, dérivabilité, fonctions réciproques,
primitives et calcul intégral, ln, exp, équations différentielles, suites), l'**algèbre &
arithmétique** (nombres complexes, divisibilité, Bézout), la **géométrie** (isométries,
déplacements/antidéplacements, similitudes, coniques, géométrie dans l'espace) et les
**probabilités & statistiques** pour résoudre des problèmes, conduire un raisonnement rigoureux
(implication, équivalence, contre-exemple, récurrence, dichotomie) et interpréter des résultats.
Chaque chapitre du manuel est structuré en trois rubriques : **Cours** (activités de découverte +
résultats/théorèmes à retenir + exercices/problèmes résolus), **QCM / Vrai ou faux**, puis
**Exercices et problèmes**. Calibration d'épreuve : exercices multi-étapes enchaînant sous-résultats,
style annales session principale.

## 2. Plan annuel (carte des chapitres = tables des matières des deux tomes)

> Statut de transcription par chapitre — `generation` = transcrit à profondeur de génération
> (chaque activité/exercice décrit, encadrés verbatim) ; `bloc` = titre + périmètre seulement, à
> transcrire. La couverture de pages réelle vit dans `suivi/bac-math.json`.

### Tome 1 — Analyse (222445P00, 207 p.)

| #   | Chapitre                     | pages (PDF = imprimées) | profondeur   |
| --- | ---------------------------- | ----------------------- | ------------ |
| 1   | Continuité et limites        | 5–27                    | `generation` |
| 2   | Suites réelles               | 28–52                   | `generation` |
| 3   | Dérivabilité                 | 53–76                   | `generation` |
| 4   | Fonctions réciproques        | 77–95                   | `generation` |
| 5   | Primitives                   | 96–108                  | `generation` |
| 6   | Intégrales                   | 109–136                 | `generation` |
| 7   | Fonction logarithme népérien | 137–157                 | `generation` |
| 8   | Fonction exponentielle       | 158–188                 | `generation` |
| 9   | Équations différentielles    | 189–207                 | `generation` |

### Tome 2 — Algèbre · Géométrie · Probabilités (222446P00, 230 p.)

| #   | Chapitre                        | pages (PDF = imprimées) | profondeur   |
| --- | ------------------------------- | ----------------------- | ------------ |
| 10  | Nombres complexes               | 5–34                    | `generation` |
| 11  | Isométries du plan              | 35–53                   | `generation` |
| 12  | Déplacements – Antidéplacements | 54–73                   | `generation` |
| 13  | Similitudes                     | 74–95                   | `generation` |
| 14  | Coniques                        | 96–120                  | `generation` |
| 15  | Géométrie dans l'espace         | 121–146                 | `generation` |
| 16  | Divisibilité dans ℤ             | 147–160                 | `generation` |
| 17  | Identité de Bézout              | 161–178                 | `generation` |
| 18  | Probabilités                    | 179–207                 | `generation` |
| 19  | Statistiques                    | 208–230                 | `generation` |

## 2.1 Chapitre 1 — Continuité et limites (manuel 222445, p.5–27)

**Page de garde (p.5)** — Titre : « Continuité et limites », Chapitre 1. Citation liminaire sur
Bolzano (1817) et la démonstration rigoureuse du théorème des valeurs intermédiaires (le manuel
attribue la référence à « E. Haier [sic] et al, _L'analyse au fil de l'histoire_, 2000 » — coquille
source pour Ernst Hairer). Le chapitre est structuré en 6 parties
(I à VI), suivies d'un QCM / Vrai-Faux, puis d'une rubrique « Exercices et problèmes ».

### Cours — Activités

**I. Rappels** (p.6) — « Dans ce paragraphe nous rappelons les principaux théorèmes vus en
troisième année. »

**I.1 Continuité et limite en un réel**

- **Activité 1** (p.6) : déterminer l'ensemble de définition et justifier la continuité de f en
  tout réel de son ensemble de définition, pour f : x ↦ 1 − x + x² ; x ↦ x − 1/(x−1) ;
  x ↦ (sin x + 1)/(2 + cos x) ; x ↦ (|−5x + 1| − 2)/(x + 3) ; x ↦ √((x² + 1)/(x − 1)).
  (Aide : polynômes et rationnelles continues sur leur ensemble de définition ; sin, cos continues
  sur ℝ.)
- **Activité 2** (p.6) : f : x ↦ (2x² − 4x + 2)/|x − 1|. Vérifier que pour x ≠ 1, f(x) = 2|x − 1| ;
  en déduire lim_{x→1} f(x).
- **Activité 3** (p.7) : f définie sur ℝ* par f(x) = (x² + sin x)/x. Montrer que f est prolongeable
  par continuité en 0 et déterminer son prolongement. (Aide : lim_{x→0} (sin x)/x = 1.)
- **Activité 4** (p.7) : f(x) = −4(x² + x − 2)/(3√(1 − x)) si x < 1 ; (x² − 1)/(√x − 1) si x > 1 ;
  0 si x = 1. Calculer les limites à gauche et à droite en 1 ; f est-elle continue en 1 ?
  (Encadré : continuité en a ⟺ limites à gauche = à droite = f(a).)
- **Activité 5** (p.7) : f : x ↦ |x + 1|/(x + 1). f admet-elle une limite en −1 ?

**I.2 Continuité sur un intervalle** (p.7)

- **Activité** (p.7) : f sur [0, π] par f(x) = (1 − cos x)/x si x ∈ ]0, π], f(0) = 0. Montrer que f
  est continue sur [0, π]. (Encadré : définition de la continuité sur un intervalle ouvert, sur
  [a, b], et sur les intervalles semi-ouverts / infinis.)

**I.3 Opérations sur les limites** (p.8) — tableaux d'opérations (voir « Résultats à retenir »).

- **Activité** (p.8) : déterminer lim_{x→−∞} 2x + 1/(x² + 1) ; lim_{x→−∞} √(−5x + 1) − 3x ;
  lim_{x→+∞} (−x² − x)² + √2·x ; lim_{x→2} 5x³ + ((3x − 1)/|x − 2|)⁵ ;
  lim_{x→3} √(2x − 3)·(3/(x − 3)² − 2) ; lim_{x→+∞} (5/√(x² + 1) − 2x)(x³ + x) ;
  lim_{x→+∞} √x − x.

**II. Branches infinies** (p.9)

- **Activité 1** (p.9) : lecture graphique de limites (asymptotes x = −1, x = 1, y = 0,
  y = −x − 3) pour f définie sur ]−∞, −1[ ∪ ]1, +∞[.
- **Activité 2** (p.9–10) : f(x) = √(x² + x + 1) — limites en ±∞, f(x)/x, f(x) − x, asymptote
  oblique.
- **Activité 3** (p.10) : f(x) = 2x + √(x + 1) sur [−1, +∞[ — variations, nature de la branche
  infinie en +∞, tracé.
- **Activité 4** (p.11) : f(x) = OM où M ∈ Δ : y = 1 − x d'abscisse x — variations géométriques,
  axe de symétrie x = 1/2, asymptote y = √2·x − √2/2 en +∞. (Encadré : définition d'un axe de
  symétrie Δ : x = a.)

**III. Continuité et limite d'une fonction composée**

**III.1 Composée de deux fonctions** (p.11)

- **Activité 1** (p.11) : lectures graphiques d'images par f, g, puis par h = g∘f et k = f∘g.
- **Activité 2** (p.12) : décomposer f = v∘u pour f : x ↦ cos(πx + 1) ; x·sin(1/x) ; tan(π/(2x)).

**III.2 Continuité d'une fonction composée** (p.12) — Théorème + démonstration + corollaire (voir
« Résultats à retenir »).

- **Activité** (p.12) : continuité de f : x ↦ sin(x² + π/4) sur ℝ ; x ↦ cos((x + 1)/(x − 1)) sur
  ]1, +∞[.

**III.3 Limite d'une fonction composée** (p.12) — théorème admis (voir « Résultats à retenir »).

- **Activité 1** (p.12) : lim en a de f : x ↦ (cos(x²) − 1)/x² (a = 0) ; x ↦ sin(√x − 1)/(√x − 1)
  (a = 1).
- **Activité 2** (p.13) : f : x ↦ sin(π(x² + x − 12)/(x − 3)) prolongeable par continuité en 3 ?
- **Activité 3** (p.13) : lectures graphiques lim_{x→2} f(2/x), lim_{x→4} f((x − 4)/x),
  lim_{x→0} f(sin x − 1).
- **Activité 4** (p.13) : lim_{x→+∞} x·sin(1/x).
- **Activité 5** (p.13) : lim_{x→1⁺} tan(π/(2x)) ; lim_{x→+∞} (x − 1)·cos(πx/(x − 1)).

**IV. Limites et ordre** (p.13)

- **Activité 1** (p.13) : encadrement g ≤ f ≤ h avec f(x) = x²·sin(1/x) + 1, g(x) = −x² + 1,
  h(x) = x² + 1 ; conjecture de lim en 0.
- **Activité 2** (p.14) : position relative et conjecture de limite en −∞ pour
  f(x) = √(−x) + cos x, g(x) = √(−x) − 1.
- **Activité 3** (p.15) : lim en ±∞ de f : x ↦ (−cos x)/x.
- **Activité 4** (p.15) : f(x) = 1/x² + cos²(1/x) + √x — minorer par 1/x², en déduire lim_{0⁺}.

**V. Image d'un intervalle par une fonction continue**

**V.1 Théorème des valeurs intermédiaires** (p.15)

- **Activité 1** (p.15) : lecture graphique de f(I) pour I = ]−1, 3[, [1, 4], ]0, 2].
- **Activité 2** (p.15) : g([−6, 4]) et g([−3, 5]) par lecture graphique.
- **Activité 3** (p.16) : montrer la stricte monotonie de x ↦ 1/(1 + x²) sur ℝ₊ ; x ↦ cos²x sur
  [π/6, π/3] ; x ↦ (1 + x)²⁰ sur [0, 4]. (Encadré : définitions strictement croissante/décroissante/monotone.)
- **Activité 4** (p.16) : f : x ↦ 2x − cos x — continuité, variations sur [0, π/2], unicité de la
  solution de f(x) = π/6, localisation et encadrement d'amplitude π/8.
- **Activité 5** (p.17) : f : x ↦ x³ + x − 1 — unique solution α de f(x) = 0 dans [0, 1] ;
  **méthode de dichotomie** (encadrements successifs d'amplitude 10⁻¹, 10⁻², puis 10⁻³ via une
  feuille de calcul Excel dont les formules sont données ; α ≈ 0,6823).
- **Activité 6** (p.18) : signe constant sur ℝ de x ↦ 1 + x + … + x¹⁰ et de x ↦ 1 + sin x + … + sin¹⁰x.

**V.2 Image d'un intervalle fermé borné par une fonction continue** (p.18)

- **Activité 1** (p.18) : f([−5, 4]), min m et max M, résolution graphique de f(x) = m et f(x) = M.
- **Activité 2** (p.18) : f(x) = sin²x — min/max et image sur [−π/6, π/6], [π/6, 4π/3], [π/6, 11π/6].
- **Activité 3** (p.19) : f(x) = x + 4/x — f([1, 4]) et f([−10, −1]).
- **Activité 4** (p.19) : rectangle OPMQ inscrit dans le cercle trigonométrique — aire 𝒜(x) et
  périmètre 𝒫(x), leurs images sur [0, π/2] et valeurs maximales.

**VI. Image d'un intervalle par une fonction strictement monotone** (p.19) — théorèmes admis (voir
« Résultats à retenir »).

- **Activité 1** (p.19) : f croissante sur ℝ₊, f(n) = n + 1 — limite en +∞.
- **Activité 2** (p.20) : image de I par f pour f : x ↦ (x + 1)/(x − 2) sur ]2, +∞[ ;
  x ↦ √(x² − 2x) sur ]−∞, 0] ; x ↦ tan(xπ) sur ]−1/2, 0[. (Précédée d'un tableau d'exemples f(I)
  selon le type d'intervalle et la monotonie.)

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Théorème** (p.6) — « Soit f et g deux fonctions définies sur un intervalle ouvert I et a un réel
> de I. • Si f est continue en a, alors αf (α ∈ ℝ), |f| et fⁿ (n ∈ ℕ*) sont continues en a. • Si f
> est continue en a et f(a) ≠ 0, alors 1/f et 1/fⁿ sont continues en a. • Si f et g sont continues
> en a, alors f + g et f × g sont continues en a. • Si f et g sont continues en a et g(a) ≠ 0, alors
> f/g est continue en a. • Si f est positive sur I et continue en a, alors √f est continue en a. »

> **Théorème** (p.6) — « Soit f définie sur un intervalle ouvert I, sauf peut-être en un réel a de
> I. S'il existe une fonction g définie sur I, continue en a et telle que g(x) = f(x) pour tout
> x ≠ a, alors lim_{x→a} f(x) = g(a). »

> **Théorème** (p.7) — « Soit f définie sur un intervalle ouvert I, sauf en un réel a de I. Si f
> admet une limite finie ℓ lorsque x tend vers a, alors la fonction g définie par g(x) = f(x) si
> x ≠ a, g(a) = ℓ, est continue en a. »

> **Tableaux d'opérations sur les limites** (p.8) — L, L′ deux réels. Somme lim(f+g) : L,L′→L+L′ ;
> L,+∞→+∞ ; −∞,L′→−∞ ; +∞,+∞→+∞ ; −∞,−∞→−∞. Produit lim(f×g) : L,L′→L×L′ ; +∞,L′>0→+∞ ;
> +∞,L′<0→−∞ ; +∞,+∞→+∞ ; +∞,−∞→−∞ ; −∞,−∞→+∞. Quotient lim(f/g) : L,L′≠0→L/L′ ; +∞,L′>0→+∞ ;
> +∞,L′<0→−∞ ; L,±∞→0 ; L≠0,0→∞ (règle des signes). |f| et √f : lim f = L → |L|, √L ;
> lim f = ±∞ → +∞, +∞. Formes indéterminées (règles inapplicables) : ∞ − ∞, 0 × ∞, ∞/∞, 0/0 — à
> lever par transformation d'écriture.

> **Théorème** (p.8) — « La limite d'une fonction polynôme à l'infini est celle de son terme de plus
> haut degré. La limite d'une fonction rationnelle à l'infini est celle du quotient des termes de
> plus haut degré. »

> **Tableau — branches infinies** (p.9) — asymptote verticale x = a si lim en a± = ±∞ ; horizontale
> y = L si lim en ±∞ = L ; oblique y = ax + b si lim(f(x) − (ax + b)) = 0 en ±∞.

> **Encadré — nature de la branche infinie** (p.10) — selon lim_{x→±∞} f(x)/x : infinie → branche
> parabolique de direction (O, j⃗) ; nulle → branche parabolique de direction (O, i⃗) ; = a ∈ ℝ* →
> selon lim(f(x) − ax) : finie b → asymptote oblique y = ax + b ; infinie → direction asymptotique
> y = ax.

> **Définition** (p.11) — composée v∘u : « Soit u une fonction définie sur un ensemble I et v une
> fonction définie sur un ensemble J tel que u(I) est inclus dans J. La fonction notée v∘u, définie
> sur I par v∘u(x) = v(u(x)), est appelée fonction composée de u et v. »

> **Théorème** (p.12) — « Soit u une fonction définie sur un intervalle ouvert I contenant un réel a
> et v une fonction définie sur un intervalle ouvert J contenant le réel u(a). Si u est continue en a
> et v est continue en u(a), alors la fonction v∘u est continue en a. » **Corollaire** (p.12) — « La
> composée de deux fonctions continues est continue. »

> **Théorèmes admis** (p.12–13) — limite d'une composée : si lim_{x→a} u = b et lim_{x→b} v = c
> (finis ou infinis), alors lim_{x→a} v∘u = c.

> **Théorèmes de comparaison / encadrement** (p.14) — si u ≤ f ≤ v près de a et lim u = lim v = ℓ,
> alors lim f = ℓ (« gendarmes ») ; si f ≥ u et lim u = +∞ alors lim f = +∞ (et minoration
> symétrique en −∞). Valables aux limites à l'infini, à droite ou à gauche.

> **Rappel** (p.15) — « L'image d'un intervalle par une fonction continue est un intervalle. »

> **Théorème des valeurs intermédiaires** (p.16) — « Soit f continue sur I, a < b dans I. Pour tout
> réel k compris entre f(a) et f(b), l'équation f(x) = k possède au moins une solution dans [a, b].
> En particulier si f(a)·f(b) < 0, f(x) = 0 admet au moins une solution dans ]a, b[. »

> **Théorème** (p.16) — « Soit f continue et strictement monotone sur I, a < b dans I. Pour tout k
> compris entre f(a) et f(b), l'équation f(x) = k admet une **unique** solution dans [a, b]. »

> **Théorème** (p.17) — « Soit f continue sur I. Si f ne s'annule en aucun point de I, elle garde un
> signe constant sur I. »

> **Théorème** (p.18) — « L'image d'un intervalle fermé borné [a, b] par une fonction continue est
> un intervalle fermé borné [m, M] (m = minimum, M = maximum de f sur [a, b]). »

> **Théorèmes admis** (p.19) — limite d'une fonction monotone sur [a, b[ (croissante majorée →
> limite finie ; croissante non majorée → +∞ ; etc.) ; « L'image d'un intervalle I par une fonction
> continue et strictement monotone sur I est un intervalle de même nature. »

> **Tableau « Exemples »** (p.20) — f(I) selon le type d'intervalle et la monotonie : [a, b] →
> [f(a), f(b)] (croissante) / [f(b), f(a)] (décroissante) ; [a, b[ → [f(a), lim_{b⁻} f[ /
> ]lim_{b⁻} f, f(a)] ; [a, +∞[ → [f(a), lim_{+∞} f[ / ]lim_{+∞} f, f(a)] ; ]a, b[ →
> ]lim_{a⁺} f, lim_{b⁻} f[ / ]lim_{b⁻} f, lim_{a⁺} f[.

### Cours — Problème résolu (p.20–22)

Problème résolu en deux parties, solution intégrale imprimée (p.21–22) : **I.** f(x) = 16x²(1 − x)²
sur [0, 1] — majoration par f(1/2), image f([0, 1]) = [0, 1], puis existence d'une solution de
f(x + 1/n) = f(x) sur [0, 1 − 1/n] (via h(x) = f(x) − f(x + 1/n), TVI). **II.** Généralisation : f
continue sur [0, 1] avec f(0) = f(1) et f([0, 1]) = [0, 1] ⇒ pour tout n ≥ 2, f(x + 1/n) = f(x) a
une solution (g = f − f∘u avec u(x) = x + 1/n, somme télescopique Σ g(k/n) = 0, raisonnement par
l'absurde sur le signe constant).

### QCM (p.23) — « Cocher la réponse exacte. »

1. lim_{+∞} f = +∞ et g(x) = sin(1/x) − f(x) : lim_{+∞} g = ? (☐ +∞ / ☐ n'existe pas / ☐ −∞)
2. f continue décroissante sur [2, 5] avec f([2, 5]) = [1, 3] : (☐ f(2) = 3 et f(5) = 1 /
   ☐ f(2) = 1 et f(5) = 3 / ☐ 1 < f(2) < 3)
3. f continue sur [−2, 5], f(−2) = 3, f(5) = −2 : l'équation f(x) = −1 (☐ n'admet pas de solution /
   ☐ au moins une solution / ☐ exactement une solution) dans [−2, 5].

### Vrai ou faux (p.23) — « Répondre par vrai ou faux en justifiant. » (réponses non fournies)

1. f paire et lim_{x→−∞} f = −∞ ⇒ lim_{x→+∞} f = −∞.
2. Toute fonction croissante sur ℝ admet une limite finie en +∞.
3. f de limite finie en −∞ et en +∞ ⇒ f bornée.
4. f non définie en a ⇒ nécessairement Δ : x = a asymptote verticale à C_f.
5. g ≤ f ≤ h sur ℝ, lim_{+∞} g = 3, lim_{+∞} h = 5 ⇒ f admet une limite en +∞.

### Exercices et problèmes (p.24–27) — 29 exercices

- **Ex. 1** (p.24) : continuité sur ℝ de f(x) = (x/|x|)·√(2|x|) si x ≠ 0, f(0) = 0.
- **Ex. 2** (p.24) : continuité de f(x) = (1 + 1/(x − 2))·|x − 2| si x ≠ 2, f(2) = 1.
- **Ex. 3** (p.24) : f(x) = (−3x² − x + 10)/(x³ + x² − 8x − 12) — prolongeable en 3 ? en −2 ?
- **Ex. 4** (p.24) : f : x ↦ (x + 3)/√(|x² + x − 6|) — ensemble de définition, prolongement en −3.
- **Ex. 5** (p.24) : limites à gauche/droite de −3/(x − 1) en 1, −3x/(x² − 1) en −1,
  1/(x² − 3x + 2) en 1, et √(1 + x²)/x en ±∞.
- **Ex. 6** (p.24–25) : prolongement par continuité de (x³ + 3x² − 2x − 4)/(x + 1) en −1 ;
  (1 − √2·cos x)/(1 − √2·sin x) en π/4 ; (cos 4x − 1)/x² en 0 ; sin((x − 1)²π)/(x − 1)² en 1 ;
  (cos(x² − 1) − 1)/(x⁴ − 2x² + 1) en 1.
- **Ex. 7** (p.24) : lectures graphiques (asymptotes x = 0, x = 2, y = 0, Δ), tableau de variation,
  discussion du nombre de solutions de f(x) = m.
- **Ex. 8** (p.24) : limites de cos((πx + 1)/x) en −∞ ; sin(3/√x) en +∞ ; sin(√x)/x en 0⁺.
- **Ex. 9** (p.25) : f(x) = (√(x + 2) − √x)·sin x — forme conjuguée, majoration |f| ≤ 2/√x, limite
  en +∞.
- **Ex. 10** (p.25) : f(x) = x + √(x² + 1) — asymptote y = 0 en −∞, asymptote y = 2x en +∞.
- **Ex. 11** (p.25) : f(x) = x³/(x − 1)² — limites, asymptote y = x + 2, variations, tracé.
- **Ex. 12** (p.25) : f(x) = √(x² − x + 1) — forme canonique, asymptote y = x − 1/2 en +∞, branche
  en −∞, tracé.
- **Ex. 13** (p.25) : identifier les courbes de f(x) = x² + 1, g(x) = √x, h(x) = x − 2/(x + 1) et la
  nature de leurs branches.
- **Ex. 14** (p.25) : branches infinies de 2x − 3√(x − 1) ; 1/x − √(x + 2) ; x·√((x − 1)/(x + 1)).
- **Ex. 15** (p.25) : limites en 0 par comparaison de x·sin(2/x) ; 1 + x²·cos(1/x) ; 1/x + cos(1/x).
- **Ex. 16** (p.25–26) : limites en ±∞ par comparaison de (2 + cos x)/x ; (1 + cos x)/√|x| ;
  x·sin x/(x⁴ + x² + 1) ; cos x − x.
- **Ex. 17** (p.26) : majorations puis limites en +∞ de (1 + cos x)/√x ; x·sin⁴x/(2x³ + 1) ;
  −x³ + 3 sin x.
- **Ex. 18** (p.26) : f(x) = (2 − sin(1/x))/x — encadrements et limites en 0⁺ et 0⁻.
- **Ex. 19** (p.26) : f(x) = 2x·sin x/(1 + x²) — |x·f(x)| ≤ 2, limites en ±∞ ; puis une limite
  composée en −∞.
- **Ex. 20** (p.26) : encadrement de 1/(2 − cos x), limites en +∞ de x/(2 − cos x) et
  (x + cos x)/(2 − cos x).
- **Ex. 21** (p.26) : limites en +∞ de cos(3x − 1)/x ; 4x² − 3 cos x ; sin x/(1 − 2x) ;
  (2√x + sin√x)/√x.
- **Ex. 22** (p.26) : f périodique de période 2 (triangle sur [0, 1]) — tracé sur [0, 4],
  encadrement, h = f + g avec g(x) = 2x, limites en ±∞.
- **Ex. 23** (p.26) : image de I par (x + 1)/(x − 2) sur ]2, +∞[ ; √(x² − 2x) sur ]−∞, 0] ;
  tan(πx) sur ]−1/2, 0].
- **Ex. 24** (p.26–27) : f(x) = −2x³ + 2x − 3 — tracé, nombre de solutions de f(x) = 0, valeur
  approchée à 10⁻¹.
- **Ex. 25** (p.27) : lecture graphique de f sur [−6, 4] \ {2}, images d'intervalles, h = 1/f et son
  prolongement en 2.
- **Ex. 26** (p.27) : f(x) = 2√x + 1/x − 3 sur ]0, 5] — continuité, variations, images, solutions de
  2√x + 1/x = 4 (valeur approchée à 10⁻¹).
- **Ex. 27** (p.27) : f(x) = √x − 1/(x − 1) — stricte croissance sur [0, 1[ et ]1, +∞[, images,
  unique solution α de (x − 1)√x = 1 dans [3/2, 2] (valeur approchée à 10⁻¹).
- **Ex. 28** (p.27) : aire du triangle AHM (M sur le demi-cercle f(x) = √(1 − x²)) — maximisation,
  image, position M₀ (encadrement d'amplitude 10⁻²).
- **Ex. 29** (p.27) : f continue sur [a, b] avec f([a, b]) ⊂ [a, b] ⇒ f possède un point fixe ;
  interprétation graphique.

### Bornes de scope observées (chapitre 1)

- ✅ INCLUS : rappels de 3ème (continuité/limite en un réel, prolongement, continuité sur un
  intervalle) ; opérations sur les limites, limites de polynômes/rationnelles à l'infini ; branches
  infinies (asymptotes verticales/horizontales/obliques, branches paraboliques, directions
  asymptotiques) ; axe de symétrie ; continuité et limite d'une composée ; théorèmes d'encadrement
  et de comparaison (« gendarmes ») ; TVI, unicité par stricte monotonie, signe constant,
  dichotomie ; image d'un intervalle (continue, fermé borné, strictement monotone) ; point fixe.
- ⛔ NON traité dans ce chapitre : dérivation, fonctions dérivées et lien continuité↔dérivabilité
  (études de variations ici admises ou géométriques) ; suites et limites de suites ; définition
  formelle ε de la limite (seule la définition ε-α de la continuité sert dans deux démonstrations).

## 2.2 Chapitre 2 — Suites réelles (manuel 222445, p.28–52)

**Page de garde (p.28)** — Titre : « Suites réelles », Chapitre 2. Citation liminaire d'As-Samaw'al
(1172), extraite de son traité d'Arithmétique, sur l'approximation indéfinie des racines
irrationnelles par des quantités rationnelles de plus en plus proches (référence donnée :
« R. Rashed, _Entre Arithmétique et Algèbre_, 1984 » ; reproduction du « Tableau d'As-Samawal »).
Le chapitre est structuré en 7 parties (I à VII), suivies d'un QCM / Vrai-Faux, puis d'une rubrique
« Exercices et problèmes ».

### Cours — Activités

**I. Rappels et compléments sur les limites de suites** (p.29)

- **Activité 1** (p.29) : calculer la limite de (Uₙ) pour Uₙ = 1/n (n ≥ 1) ; Uₙ = n² + 1 (n ≥ 0) ;
  Uₙ = 10ⁿ (n ≥ 0).
- **Activité 2** (p.29) : calculer lim de (Uₙ) pour Uₙ = 0 si n ≤ 10²⁰⁰⁷, −n/3 si n > 10²⁰⁰⁷ ;
  puis Uₙ = n si n ≤ 10²⁰⁰⁷, 1/n si n > 10²⁰⁰⁷. (Encadré : « La limite d'une suite (Uₙ) ne dépend
  que des grandes valeurs de n. »)
- **Activité 3** (p.29) : Uₙ = cos(nπ)/(2n + (−1)ⁿ), n ≥ 1. 1. Donner l'expression de U₂ₙ et
  U₂ₙ₊₁. 2. Que peut-on dire de la limite de Uₙ ? (Suivie du théorème U₂ₙ / U₂ₙ₊₁.)
- **Activité 4** (p.30) : étudier la convergence de Uₙ = (−1)ⁿ ; Uₙ = (cos(nπ) + (−1)ⁿ)/n (n ≥ 1) ;
  Uₙ = 1/n si n pair, −n/3 si n impair (n ≥ 1).
- **Activité 5** (p.30) : 1. montrer que Uₙ = (−1)ⁿ (n ≥ 0) est bornée. 2. reprendre pour
  Wₙ = 1/n si n pair, −(n + 1)/(3n²) si n impair (n ≥ 1).
- **Activité 6** (p.32) : calculer lim de (Uₙ) pour Uₙ = 1/(2 − 1/√n) − 3n³ (n ≥ 1) ;
  Uₙ = (1/n² − 1/2)(n³ + 3n − 1) (n ≥ 1) ; Uₙ = −n + √((5n + 3)/(2n + 9)) (n ≥ 0) ;
  Uₙ = (√(n + 1) − √n)·√(n + 1/2) (n ≥ 0).
- **Activité 7** (p.32) : 1. Uₙ = 2(1 + 1/2)(1 + 1/3)…(1 + 1/n) (n ≥ 1) — calculer Uₙ et sa limite. 2. limite de Vₙ = Uₙ/n².

**II. Suites géométriques et applications** (p.32)

- **Activité 1** (p.32) : lim de (Uₙ) pour Uₙ = (1/5)ⁿ ; Uₙ = (−2/√5)ⁿ ; Uₙ = (√π)ⁿ (n ≥ 0).
- **Activité 2** (p.32) : Uₙ = (cos(πa))²ⁿ (n non nul). 1. limite si a est un entier ; 2. limite si
  a n'est pas un entier.
- **Activité 3** (p.33) : yₙ = (sin(n!πa))ⁿ (n non nul). 1. calculer yₙ pour a rationnel de la forme
  1/q avec q < n ; 2. en déduire lim yₙ pour tout rationnel a.
- **Activité 4** (p.33) : lim de (Uₙ) pour Uₙ = (1 − (−1/3)ⁿ)/(1 − n³) (n ≥ 2) ;
  Uₙ = ((−2)ⁿ − 3)/(4(−2)ⁿ + 5) − 2(8/3)ⁿ (n ≥ 0) ; Uₙ = 1 + 5/3 + … + (5/3)ⁿ (n ≥ 0) ;
  Uₙ = −3 − 9/π − … − 3(3/π)ⁿ (n ≥ 0).
- **Activité 5** (p.33) : suites (aₙ) et (bₙ) : a₁ = 4,2 ; a₂ = 4,22 ; aₙ = 4,22…2 (n chiffres) ;
  b₁ = 4,23 ; b₂ = 4,223 ; bₙ = 4,22…23 (n+1 chiffres). 1. via aₙ = 4 + 2(10⁻¹ + … + 10⁻ⁿ),
  calculer lim aₙ ; 2. calculer lim bₙ.
- **Activité 6** (p.33) : (Uₙ) définie par U₀ = 2, Uₙ₊₁ = 2Uₙ − 1 (n ≥ 0). 1. solution α de
  x = 2x − 1 ; 2. Vₙ = Uₙ − α, montrer que (Vₙ) est géométrique ; 3. en déduire Uₙ en fonction de n
  et lim Uₙ.

**III. Suites du type vₙ = f(uₙ)** (p.35)

- **Activité 1** (p.36) : lim de (Uₙ) pour Uₙ = sin((0,75)ⁿ) (n ≥ 1) ; Uₙ = n·sin(π/(2n)) (n ≥ 1) ;
  Uₙ = tan(πn/(2n + 1)) (n ≥ 0) ; Uₙ = (1 − cos((0,25)ⁿ))/(0,25)ⁿ (n ≥ 1).
- **Activité 2** (p.36–37) : 1. cercle 𝒞 de rayon 1, centre O, M et N sur 𝒞 avec l'angle MON = 2a,
  I milieu de [MN], J intersection de [OI) avec 𝒞, tangente en J coupant [OM) et [ON) en M′ et N′ ;
  A et A′ aires de MON et M′ON′ — montrer A′/A = 1/cos²(a). 2. Pₙ polygone régulier à n côtés inscrit
  et P′ₙ circonscrit à 𝒞 (rayon 1), d'aires Aₙ et A′ₙ ; a. les exprimer et montrer qu'elles ont même
  limite ; b. établir 2√2 < π < 8√2/(2 + √2).

**IV. Limites et ordre** (p.37)

- **Activité 1** (p.37) : Vₙ = n/(n² + 1) + n/(n² + 2) + … + n/(n² + n) (n ≥ 1). 1. encadrement
  n²/(n² + n) ≤ Vₙ ≤ n²/(n² + 1) ; 2. valeurs approchées à 10⁻³ de V₁₀₀₀ et V₁₀⁶ ; 3. conjecture de
  lim Vₙ. (Suivie du théorème des « gendarmes ».)
- **Activité 2** (p.38) : 1. Uₙ = 1/(n + cos n) (n ≥ 0) — encadrement 0 ≤ Uₙ ≤ 1/(n − 1) et limite ; 2. Vₙ = (cos(5n) + sin(2n))/(5n² + 1) (n ≥ 0) — encadrement 0 ≤ |Vₙ| ≤ 2/(5n² + 1) et limite.
- **Activité 3** (p.38–39) : Uₙ = 10ⁿ/n!. 1. montrer 0 < Uₙ₊₁/Uₙ ≤ 10/11 pour n ≥ 10 ; 2. convergence
  et limite ; 3. à la calculatrice, un entier n₀ tel que |Uₙ| ≤ 10⁻⁶ pour n ≥ n₀.
- **Activité 4** (p.39) : Uₙ = n¹⁰⁰/(1,01)ⁿ. 1. montrer (1,01)ⁿ ≥ n(n−1)(n−2)…(n−100)·10⁻²⁰²/101!
  pour n ≥ 101 (binôme de Newton) ; 2. en déduire la limite.
- **Activité 5** (p.39) : lim de (Uₙ) pour Uₙ = (3n + 1)ⁿ (n ≥ 1) ; Uₙ = n³/(2 + sin(3n)) (n ≥ 1) ;
  Uₙ = 1/n² + n³(sin n − 3) (n ≥ 1) ; Uₙ = −n⁶/(n⁴ − π) + cos²(2n)/n³ (n ≥ 1).
- **Activité 6** (p.40) : symbole Σ. 1. écrire avec Σ : A = 1 + 2 + 3 + … + n ;
  B = −1/2 + 1/4 − 1/8 + … − 1/512. 2. calculer C = Σ_{k=10}^{500} 1 ; D = Σ_{k=0}^{20} (3k − 1) ;
  E = Σ_{k=3}^{10} 10⁻ᵏ. (Encadré de notation Σ.)
- **Activité 7** (p.40) : 1. vérifier 1/(k(k+1)) = 1/k − 1/(k+1) (k non nul) ; 2. en déduire la
  limite de Wₙ = Σ_{k=1}^{n} 1/(k(k+1)) (n ≥ 1).

**V. Convergence des suites monotones** (p.40)

- **Activité 1** (p.40) : 1. Wₙ = 1/n² + 2/n² + … + n/n² (n ≥ 1) — a. calculer Wₙ ; b. décroissante
  et minorée ; c. convergente + limite. 2. Vₙ = 1/n + 2/n + … + n/n (n ≥ 1) — a. croissante ;
  b. convergente ?
- **Activité 2** (p.41) : suite de rectangles ; le n-ième est limité par y = 0, y = (−1)ⁿ⁺¹/n,
  x = n − 1, x = n, d'aire algébrique (−1)ⁿ⁺¹/n ; Uₙ = somme des aires des n premiers. 1. a. calculer
  U₁, U₂, U₃, U₆ ; b. vérifier Uₙ = 1 − 1/2 + 1/3 − 1/4 + … − (−1)ⁿ/n. 2. (U₂ₙ) croissante ;
  U₂ₙ ≤ 1 − 1/(2n). 3. (U₂ₙ₊₁) décroissante ; U₂ₙ₊₁ ≥ 0,5 + 1/(2n+1). 4. U₂ₙ₊₁ − U₂ₙ ; même limite
  a. 5. a. (Uₙ) converge vers a ; b. U₁₀, U₁₁ et encadrement de a.
- **Activité 3** (p.42) : Uₙ = 1 + 1/2 + 1/3 + … + 1/n (n ≥ 1). 1. croissante ; 2. U₂ₙ − Uₙ ≥ 1/2 ; 3. non majorée ; 4. déterminer lim Uₙ.

**VI. Suites récurrentes** (p.42)

- **Activité 1** (p.42) : aₙ avec a₁ = √2, a₂ = √(2√2), a₃ = √(2√(2√2)), … 1. exprimer aₙ₊₁ en
  fonction de aₙ ; 2. a. a₁ irrationnel ; b. aₙ irrationnel pour tout n ≥ 1 ; 3. croissante et
  majorée par 2 ; 4. sa limite.
- **Activité 2** (p.43) : (aₙ) définie par a₀ = 1, aₙ₊₁ = √(aₙ + 1) (n ≥ 0). 1. croissante et
  majorée par 2 ; 2. sa limite.

**VII. Suites adjacentes** (p.43)

- **Activité 1** (p.43) : Uₙ = 1 − 1/2² + 1/3² + … + (−1)ⁿ⁺¹/n² (n ≥ 1). 1. (U₂ₙ) croissante et
  majorée ; 2. (U₂ₙ₊₁) décroissante et minorée ; 3. (Uₙ) converge vers un réel α ; 4. a. vérifier
  U₂ₙ ≤ α ≤ U₂ₙ₊₁ ; b. U₄, U₅ et encadrement de α ; c. à la calculatrice, un entier n donnant un
  encadrement de α d'amplitude 10⁻⁸.
- **Activité 2** (p.44) : (Uₙ), (Vₙ) avec U₀ = 1, V₀ = 2, Uₙ₊₁ = (2Uₙ + Vₙ)/3, Vₙ₊₁ = (Uₙ + 2Vₙ)/3.
  1. a. (Vₙ − Uₙ) géométrique ; b. Uₙ ≤ Vₙ ; c. (Uₙ) croissante, (Vₙ) décroissante ; d. adjacentes,
     même limite α. 2. (Vₙ + Uₙ) constante. 3. Uₙ et Vₙ en fonction de n. 4. calculer α.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Théorème** (p.29) — « Soit (Uₙ) une suite réelle et a fini ou infini. lim_{n→+∞} Uₙ = a, si et
> seulement si, lim_{n→+∞} U₂ₙ = a et lim_{n→+∞} U₂ₙ₊₁ = a. »

> **Encadré** (p.29) — « La limite d'une suite (Uₙ) ne dépend que des grandes valeurs de n. »

> **Théorème** (p.30) — « Toute suite convergente est bornée. »

> **Théorème** (p.30) — « Soit une suite (Uₙ) convergente vers un réel a. • S'il existe un entier N₀
> tel que 0 ≤ Uₙ pour tout n ≥ N₀, alors 0 ≤ a. • S'il existe un entier N₀ tel que Uₙ ≤ 0 pour tout
> n ≥ N₀, alors a ≤ 0. »

> **Conséquence** (p.31) — « Soit un entier naturel N₀ et une suite (Uₙ), n ≥ 0. On suppose qu'il
> existe deux réel [sic] m et M tel que m ≤ Uₙ ≤ M, n ≥ N₀. Si la suite (Uₙ) est convergente vers un
> réel a, alors m ≤ a ≤ M. »

> **Tableaux — opérations sur les limites de suites** (p.31) — a, b deux réels. Somme lim(Uₙ + Vₙ) :
> a,b→a+b ; +∞,b→+∞ ; −∞,b→−∞ ; +∞,+∞→+∞ ; −∞,−∞→−∞. Produit lim(Uₙ·Vₙ) : a,b→ab ; ∞,b≠0→∞ (règle des
> signes) ; ∞,∞→∞ (règle des signes). Quotient lim(Uₙ/Vₙ) : a,b≠0→a/b ; ∞,b≠0→∞ (règle des signes) ;
> a,+∞→0 ; a,−∞→0 ; a≠0,0→∞ (règle des signes).

> **Théorème** (p.32) — « Soit (Uₙ) une suite géométrique définie par Uₙ = qⁿ, n ≥ 0, où q est un
> réel non nul. • Si q > 1, alors lim_{n→+∞} Uₙ = +∞. • Si |q| < 1, alors lim_{n→+∞} Uₙ = 0. • Si
> q ≤ −1, alors la suite (Uₙ) n'a pas de limite. • Si q = 1, alors la suite (Uₙ) est constante. »

> **Théorème** (p.35) — « Soit f une fonction continue sur un intervalle ouvert I et (Uₙ) une suite
> d'éléments de I. Si (Uₙ) tend vers un réel a de I alors (f(Uₙ)) tend vers f(a). »

> **Théorème** (p.35) — « Soit f une fonction définie sur un intervalle I et (Uₙ) une suite
> d'éléments de I. Si lim_{n→+∞} Uₙ = ℓ (fini ou infini) et si lim_{x→ℓ} f(x) = L (fini ou infini),
> alors lim_{n→+∞} f(Uₙ) = L. »

> **Théorème** (p.37) — « Soit deux suites (Uₙ) et (Vₙ) convergentes respectivement vers deux réels a
> et b. S'il existe un entier N₀ tel que Uₙ ≤ Vₙ pour tout n ≥ N₀ alors a ≤ b. »

> **Théorème** (p.37) — « Soit trois suites réelles (Uₙ), (Vₙ) et (Wₙ). Soit a un réel. On suppose
> qu'il existe un entier N₀ tel que Vₙ ≤ Uₙ ≤ Wₙ, n ≥ N₀. Si lim_{n→+∞} Vₙ = lim_{n→+∞} Wₙ = a alors
> lim_{n→+∞} Uₙ = a. » (Théorème d'encadrement / des « gendarmes ».)

> **Corollaire** (p.38) — « Soit deux suites réelles (Uₙ) et (Vₙ). On suppose qu'il existe un entier
> N tel que 0 ≤ |Uₙ| ≤ Vₙ, n ≥ N. Si lim_{n→+∞} Vₙ = 0 alors lim_{n→+∞} Uₙ = 0. »

> **Encadré — notation Σ** (p.40) — « On note Σ_{k=1}^{n} aₖ et on lit "sigma pour k variant de 1 à
> n des réels aₖ" le réel obtenu en faisant la somme des réels a₁, a₂, …, aₙ. On a donc
> Σ_{k=1}^{n} aₖ = a₁ + a₂ + … + aₙ. »

> **Théorème** (p.39) — « Soit deux suites réelles (Uₙ) et (Vₙ). • S'il existe un entier N₀ tel que
> Uₙ ≤ Vₙ, n ≥ N₀ et si lim_{n→+∞} Uₙ = +∞ alors lim_{n→+∞} Vₙ = +∞. • S'il existe un entier N₀ tel
> que Uₙ ≤ Vₙ, n ≥ N₀ et si lim_{n→+∞} Vₙ = −∞ alors lim_{n→+∞} Uₙ = −∞. »

> **Théorème (admis)** (p.40) — « Soit (Uₙ) une suite définie pour n ≥ 0. Si la suite (Uₙ) est
> croissante et majorée, alors elle converge vers un réel a et pour tout n ≥ 0, Uₙ ≤ a. Si la suite
> (Uₙ) est décroissante et minorée, alors elle converge vers un réel b et pour tout n ≥ 0, Uₙ ≥ b. »

> **Théorème** (p.41) — « • Toute suite croissante et non majorée tend vers +∞. • Toute suite
> décroissante et non minorée tend vers −∞. »

> **Théorème** (p.42) — « Soit une suite (Uₙ) vérifiant la relation de récurrence Uₙ₊₁ = f(Uₙ),
> n ≥ 0 où f est une fonction. Si la suite (Uₙ) est convergente vers un réel a et si la fonction f
> est continue en a alors a = f(a). »

> **Définition et théorème** (p.43) — « Deux suites (Uₙ)_{n≥0} et (Vₙ)_{n≥0} sont adjacentes
> lorsqu'elles vérifient les conditions • pour tout n ≥ 0, Uₙ ≤ Vₙ, • la suite (Uₙ) est croissante et
> la suite (Vₙ) est décroissante, • la suite (Vₙ − Uₙ) converge vers 0. Dans ce cas les suites (Uₙ)
> et (Vₙ) convergent vers la même limite. »

### Cours — Exercice résolu (p.34–35)

Exercice résolu, solution intégrale imprimée (p.34–35) : f : x ↦ 1 + 2/(x + 1). 1. points fixes
f(x) = x (⇒ f(√3) = √3, f(−√3) = −√3). 2. pour x, y ≠ −1, f(x) − f(y) = 2(y − x)/((x + 1)(y + 1)). 3. suite (Uₙ) : U₀ = 1, Uₙ₊₁ = f(Uₙ) ; a. Uₙ positif (récurrence) ; b. représentation de f et de
y = x ; c. U₁ = 2, U₂ = 5/3, U₃ = 7/4. 4. Vₙ = (Uₙ − √3)/(Uₙ + √3) : a. via la question 2, (Vₙ) est
géométrique de raison (1 − √3)/(1 + √3) et de premier terme (1 − √3)/(1 + √3) ; b. (Vₙ) converge
vers 0, Uₙ = (√3 + √3·Vₙ)/(1 − Vₙ), donc (Uₙ) converge vers √3.

### Cours — Problème corrigé (p.44–45)

Problème corrigé, solution intégrale imprimée (p.45) : Uₙ = 1 + 1/1! + 1/2! + … + 1/n! et
Vₙ = 1 + 1/1! + 1/2! + … + 1/n! + 1/(n·n!), n ≥ 1. 1. (Uₙ) strictement croissante (Uₙ₊₁ − Uₙ =
1/(n+1)!), (Vₙ) strictement décroissante (Vₙ₊₁ − Vₙ = −1/(n(n+1)(n+1)!)). 2. Uₙ − Vₙ = −1/(n·n!) → 0
⇒ (Uₙ) et (Vₙ) adjacentes, limite commune notée e. 3. irrationalité de e : a. e > 0 et Uₙ < e < Vₙ ;
b. Uq = a/q! (a entier non nul), et de e = p/q on tire a < p(q − 1)! < a + 1 ; c. contradiction avec
a et p(q − 1)! entiers ⇒ e est irrationnel.

### QCM (p.46) — « Cocher la réponse exacte. »

1. u définie sur ℕ* par Uₙ = (n² + 2)/n : (☐ lim Uₙ = 0 / ☐ Uₙ ≥ n pour tout n de ℕ* /
   ☐ (Uₙ) est majorée par 1)
2. Uₙ = (n + cos n)/(n + 1) : (☐ lim Uₙ = 0 / ☐ lim Uₙ = −1 / ☐ lim Uₙ = 1)
3. u définie sur ℕ* par Uₙ = n·sin(1/n) : (☐ lim Uₙ = 0 / ☐ lim Uₙ = +∞ / ☐ lim Uₙ = 1)

### Vrai ou faux (p.46) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. Si (Uₙ) prend un nombre fini de valeurs alors (Uₙ) est convergente.
2. Si (Uₙ + Vₙ) est convergente alors (Uₙ) et (Vₙ) sont convergentes.
3. Si (Uₙ²) converge vers L, alors (Uₙ) converge vers √L ou vers −√L.
4. Si lim_{+∞} Uₙ = lim_{+∞} Vₙ alors (Uₙ) et (Vₙ) sont adjacentes.
5. Si (U₂ₙ) et (U₂ₙ₊₁) sont convergentes alors (Uₙ) est convergente.

### Exercices et problèmes (p.47–52) — 32 exercices

- **Ex. 1** (p.47) : Uₙ = 2 + 1/5ⁿ (n ≥ 0), Vₙ = √(4 + 1/n) (n ≥ 1) — limites ; entiers n₀, n₁ (à la
  calculatrice) tels que |Uₙ − 2| ≤ 10⁻⁶ et |Vₙ − 2| ≤ 10⁻⁶.
- **Ex. 2** (p.47) : aₙ = (n + (−1)ⁿ)/(2n + (−1)ⁿ⁺¹) (n ≥ 0) — a₂ₙ, a₂ₙ₊₁, convergence et limite.
- **Ex. 3** (p.47) : Uₙ = 2^((−1)ⁿ·n)/(−5)ⁿ⁺¹ (n ≥ 0) — (Uₙ) est-elle convergente ?
- **Ex. 4** (p.47) : limite de Uₙ = 1 + √n/(2n + (−1)ⁿ) (n ≥ 0).
- **Ex. 5** (p.47) : limite de Uₙ = (1 − 1/2)(1 − 1/3)…(1 − 1/n) (n ≥ 1).
- **Ex. 6** (p.47) : suites décimales (xₙ), (yₙ), (zₙ) : xₙ = 0,33…3 (n chiffres) ; yₙ = 0,3535…35
  (n fois 35) ; zₙ = 0,33…3 55…5 (n chiffres puis n chiffres). 1. a. xₙ = 3(10⁻¹ + … + 10⁻ⁿ) ;
  b. convergence et limite de (xₙ) ; 2. lim yₙ et lim zₙ.
- **Ex. 7** (p.47) : 1. vérifier Σ_{k=1}^{n} k = n(n+1)/2 ; 2. (Uₙ) : U₀ = 1, Uₙ₊₁ = Uₙ + 2n + 3 —
  expression de Uₙ en fonction de n et lim Uₙ.
- **Ex. 8** (p.47) : 1. Uₙ = (2/n)ⁿ (n ≥ 1) — a. Uₙ ≤ (1/2)ⁿ pour n ≥ 4 ; b. lim Uₙ. 2. Vₙ = n²ⁿ − (2n)ⁿ (n ≥ 1) — lim Vₙ.
- **Ex. 9** (p.47) : suites (Uₙ), (Sₙ) : Uₙ = (3ⁿ − 4ⁿ)/(3ⁿ + 4ⁿ), Sₙ = Σ_{k=0}^{n} 1/(Uₖ − 1)
  (n ≥ 0). 1. convergence et limite de (Uₙ) ; 2. a. Sₙ en fonction de n ; b. lim Sₙ.
- **Ex. 10** (p.48) : Wₙ = n!/3ⁿ (n ≥ 0). 1. Wₙ₊₁/Wₙ ≥ 4/3 pour n ≥ 3 ; 2. lim Wₙ.
- **Ex. 11** (p.48) : Uₙ = n²/2ⁿ (n ≥ 0). 1. a. placer les points Aᵢ(i, Uᵢ), i ∈ {0,…,7} ;
  b. Uₙ₊₁/Uₙ ≤ 8/9 pour n ≥ 3 ; c. lim Uₙ. 2. Sₙ = Σ_{k=3}^{n} Uₖ (n ≥ 3) — a. Sₙ ≤ 9U₃ ;
  b. (Sₙ) convergente.
- **Ex. 12** (p.48) : Vₙ = 1 + 1/√2 + … + 1/√n (n ≥ 1). 1. Vₙ ≥ √n ; 2. lim Vₙ.
- **Ex. 13** (p.48) : f : x ↦ sin x / x. 1. lim_{x→0} f et lim_{x→+∞} f ; 2. convergence de
  Uₙ = f(1/3ⁿ), Vₙ = f(2ⁿ), Wₙ = f((−0,3)ⁿ) (n ≥ 0).
- **Ex. 14** (p.48) : calculer la limite de (Uₙ) : 1. −3/(3ⁿ − 1) ; 2. 1/(0,8 + (0,2)ⁿ) ; 3. cos(4n) − 4ⁿ ; 4. (√2/2)ⁿ·cos n ; 5. sin(1/n) − 1/n ; 6. (n² + sin n)/n³ ; 7. (n + (−1)ⁿ√n)/(3n + 2) ; 8. tan(−πn/(2n − 1)).
- **Ex. 15** (p.48) : θ ∈ ]0, π/2] ; (Uₙ) : U₀ = 2cos θ, Uₙ₊₁ = √(2 + Uₙ) (n ≥ 1). 1. U₁ et U₂ en
  fonction de θ ; 2. Uₙ = 2cos(θ/2ⁿ) pour n ≥ 1 ; 3. lim Uₙ.
- **Ex. 16** (p.48) : Uₙ = (E(π) + E(2π) + … + E(nπ))/n² (n ≥ 1, E = partie entière). 1. encadrement
  π/2 + π/(2n) − 1/n ≤ Uₙ ≤ π/2 + π/(2n) ; 2. lim Uₙ.
- **Ex. 17** (p.48–49) : Uₙ = sin(1/n²) + sin(2/n²) + … + sin(n/n²) (n ≥ 1) — étude de la limite.
  1. Vₙ = 1/n² + 2/n² + … + n/n² (n ≥ 1), converge vers 1/2 ; 2. 1³ + 2³ + … + n³ ≤ n⁴ ; 3. pour
     x ≥ 0, x − x³/6 ≤ sin x ≤ x ; 4. Vₙ − 1/(6n²) ≤ Uₙ ≤ Vₙ ; 5. en déduire lim Uₙ.
- **Ex. 18** (p.49) : (Uₙ) : U₁ = 1, Uₙ₊₁ = √(3Uₙ) (n ≥ 1). 1. Uₙ ≤ 3 ; 2. (Uₙ) croissante ; 3. convergente + limite.
- **Ex. 19** (p.49) : (Uₙ) : U₀ = a ∈ ]0, π/2[, Uₙ₊₁ = sin(Uₙ) (n ≥ 0). 1. variations de x ↦ sin x − x
  sur [0, π/2] ; 2. sin x ≤ x sur [0, π/2] ; 3. Uₙ ∈ [0, π/2] (récurrence) ; 4. (Uₙ) décroissante ; 5. convergente + limite.
- **Ex. 20** (p.49) : f(x) = 1 + 1/x sur ]0, +∞[. 1. variations et f(]0, +∞[) ; 2. représenter f et
  y = x ; 3. φ = (1 + √5)/2, montrer f(φ) = φ ; 4. suite (xₙ) de rationnels convergeant vers φ :
  x₀ = 2, xₙ₊₁ = f(xₙ) — a. x₁, x₂, x₃, x₄ ; b. xₙ rationnel positif ; c. |xₙ₊₁ − φ| ≤ (4/9)|xₙ − φ| ;
  d. conclure.
- **Ex. 21** (p.49–50) : Uₙ = Σ_{k=1}^{n} 1/k² (n ≥ 1). 1. a. U₁, U₂, U₃ ; b. croissante ; 2. a. 1/k² ≤ 1/(k−1) − 1/k pour k ≥ 2 ; b. Uₙ ≤ 2 − 1/n ; c. converge vers ℓ, 49/36 ≤ ℓ ≤ 2 ; 3. p entier ≥ 3 ; 4. Vₙ = Σ_{k=1}^{n} 1/k^p (n ≥ 1) — a. croissante ; b. Vₙ ≤ Uₙ ; c. converge vers
  ℓ′ ≤ 2 ; d. avec p = 3, trois premiers termes de (Vₙ) et encadrement de ℓ′.
- **Ex. 22** (p.50) : Uₙ = (1·3·5·…·(2n−1))/(2·4·6·…·(2n)) et Vₙ = (2·4·6·…·(2n))/(3·5·…·(2n+1))
  (n ≥ 1). 1. (Uₙ) décroissante, converge vers ℓ ≥ 0 ; 2. (Vₙ) décroissante, converge vers ℓ′ ≥ 0 ; 3. Wₙ = Uₙ·Vₙ — convergence, expression, ℓℓ′ = 0 ; 4. a. Uₙ < Vₙ ; b. ℓ = 0 ; c. 2Uₙ₊₁ > Vₙ ;
  d. ℓ′.
- **Ex. 23** (p.50) : f(x) = (4x − 3)/x sur ]0, +∞[ ; variations et tracé. (Uₙ) : U₀ ∈ ]0, +∞[,
  Uₙ₊₁ = (4Uₙ − 3)/Uₙ. 2. U₀ = 3/4 — a. U₁, représenter U₀, U₁ ; b. (Uₙ) est-elle définie ? 3. U₀ = 3
  — a. représenter U₁, U₂, U₃ ; b. (Uₙ) constante. 4. U₀ = 5 — a. représenter U₀…U₃ ; b. décroissante,
  Uₙ ≥ 3 ; c. converge vers α ; d. entier n₀ (calculatrice) tel que Uₙ − α ≤ 10⁻⁵.
- **Ex. 24** (p.50) : dire si (Uₙ) et (Vₙ) sont adjacentes : 1. Uₙ = 2/n, Vₙ = −3/n (n ≥ 2) ; 2. Uₙ = (n+2)/(n−1), Vₙ = (2n+3)/(2n+5) (n ≥ 4) ; 3. Uₙ = sin(1/n), Vₙ = cos(1/n) − 1 (n ≥ 2) ; 4. Uₙ = Σ_{k=0}^{n} 1/2ᵏ, Vₙ = 2 + 3/n (n ≥ 2) ; 5. Uₙ = √(n+1) − √n, Vₙ = √n − √(n+1) (n ≥ 1).
- **Ex. 25** (p.50) : (Uₙ), (Vₙ) : U₀ = 12, V₀ = 1, Uₙ₊₁ = (Uₙ + 2Vₙ)/3, Vₙ₊₁ = (Uₙ + 3Vₙ)/4 (n ≥ 0).
  1. Uₙ ≥ Vₙ ; 2. adjacentes, même limite α ; 3. tₙ = 3Uₙ + 8Vₙ — a. (tₙ) constante ; b. valeur de α.
- **Ex. 26** (p.51) : a > 0, bₙ = n/(1 + a)ⁿ (n non nul). 1. (1 + a)ⁿ ≥ n(n−1)a²/2 ; 2. lim bₙ ; 3. (xₙ) géométrique de raison q, −1 < q < 1 : lim n|xₙ| = 0, en déduire lim nxₙ ; 4. calculer
  lim n/2^(n−1) ; lim n(−1/3)^(n+2) ; lim (n+1)(−1/√2)ⁿ.
- **Ex. 27** (p.51) : 1. pour n > 1 et x ∈ ]−1, 1[ non nul, Σ_{k=0}^{n} xᵏ = (1 − x^(n+1))/(1 − x) ; 2. Σ_{k=1}^{n} k·x^(k−1) = (nx^(n+1) − (n+1)xⁿ + 1)/(1 − x)² ; 3. limites de
  Uₙ = 1 + 2(5/3) + … + (n+1)(5/3)ⁿ et Vₙ = 2 − 2√2 + … + 2(n+1)(−1/√2)ⁿ (n ≥ 0).
- **Ex. 28** (p.51) : a, b réels strictement positifs avec a < b ; (Uₙ) : U₁ = a + b,
  Uₙ₊₁ = a + b − ab/Uₙ (n ≥ 0). 1. vérifier U₂ = (b³ − a³)/(b² − a²) ; 2. Uₙ₊₁ = (b^(n+2) − a^(n+2))/
  (b^(n+1) − a^(n+1)) ; 3. lim Uₙ.
- **Ex. 29** (p.51) : (aₙ) : a₀ donné, aₙ₊₁ = aₙ² + aₙ (n ≥ 0). 1. croissante ; 2. si converge, limite
  nulle ; 3. si a₀ > 0, diverge ; 4. si a₀ < −1, a₁ > 0, en déduire divergence ; 5. si −1 < a₀ < 0 :
  a. bornée par −1 et 0 ; b. converge, limite ; 6. limite si a₀ = 0 ; si a₀ = −1.
- **Ex. 30** (p.51–52) : (Uₙ) : U₀ = 0,1, Uₙ₊₁ = 1,6Uₙ(1 − Uₙ) (n ≥ 0). 1. variations de
  f : x ↦ 1,6x(1 − x) ; 2. 0,1 ≤ Uₙ ≤ 3/8 ; 3. convergence. 4. a. 3/8 − Uₙ₊₁ = 1,6(5/8 − Uₙ)(3/8 − Uₙ) ;
  b. Vₙ = 3/8 − Uₙ ≥ 0 et Vₙ₊₁/Vₙ ≤ 0,84 ; c. 0 ≤ Vₙ ≤ 0,84ⁿ (récurrence) ; d. lim Uₙ ; e. entier n₀
  tel que 0 ≤ 3/8 − Uₙ ≤ 10⁻⁵.
- **Ex. 31** (p.52) : a > 0, f(x) = (1/2)(x + a/x) sur ℝ*. 1. f′(x) = (x − √a)(x + √a)/(2x²) et
  variations. 2. (Uₙ) : U₀ = E(√a) + 1, Uₙ₊₁ = f(Uₙ) (E = partie entière) — a. √a < Uₙ₊₁ < Uₙ ≤ U₀,
  convergente ; b. Uₙ₊₁ − √a < (1/2)(Uₙ − √a) ; c. 0 < Uₙ − √a < (1/2)ⁿ(U₀ − √a) ; d. lim Uₙ.
- **Ex. 32** (p.52) : 1. a, b réels 0 < b < a — a. √(ab) ≤ (a + b)/2 ; b. (a − b)² ≤ a² − b² [sic].
  (aₙ), (bₙ) : a₀ = a, b₀ = b, aₙ₊₁ = (aₙ + bₙ)/2, bₙ₊₁ = √(aₙbₙ) (n ≥ 0). 2. a. bₙ ≤ aₙ ;
  b. (aₙ) décroissante, (bₙ) croissante. 3. a. (aₙ₊₁ − bₙ₊₁)² ≤ ((aₙ − bₙ)/2)² ; b. aₙ − bₙ ≤
  (a − b)/2ⁿ. 4. adjacentes, même limite α. 5. a = 2, b = 1 — entier n donnant un encadrement de α
  d'amplitude 10⁻¹⁰.

### Bornes de scope observées (chapitre 2)

- ✅ INCLUS : rappels/compléments sur les limites de suites (limite via sous-suites paire/impaire,
  suite bornée, suites convergentes bornées, signe de la limite, encadrement m ≤ a ≤ M, opérations
  sur les limites) ; suites géométriques (qⁿ) et applications décimales/télescopiques ; suites du
  type Vₙ = f(Uₙ) (continuité et composition limite∘suite) ; limites et ordre (théorème des
  gendarmes, corollaire de valeur absolue, minoration/majoration vers ±∞) ; convergence des suites
  monotones (croissante majorée / décroissante minorée ; non majorée → +∞) ; suites récurrentes
  Uₙ₊₁ = f(Uₙ) et point fixe a = f(a) ; suites adjacentes (définition, convergence commune,
  approximation de e, moyennes arithmético-géométriques). Notation Σ introduite ici.
- ⛔ NON traité dans ce chapitre : dérivation utilisée sans démonstration dans quelques études de
  variations (Ex. 31 par exemple) — la dérivabilité est le chapitre 3 ; les fonctions ln/exp
  (l'irrationalité de e est traitée par les suites, sans la fonction exp) ; définition formelle ε de
  la limite de suite (seule la caractérisation |Uₙ − a| < β « dès que n ≥ N₀ » sert dans les
  démonstrations).

## 2.3 Chapitre 3 — Dérivabilité (manuel 222445, p.53–76)

**Page de garde (p.53)** — Titre : « Dérivabilité », Chapitre 3. Citation liminaire (référence :
« R. Ras[?]hed, _Entre Arithmétique et Algèbre_, 1984 » — coupure typographique « Ras hed » dans
la source pour Roshdi Rashed) sur Sharaf Al-Din Al-Tusi (mathématicien arabe, traité vers 1213)
qui, pour résoudre des équations, étudie le maximum des expressions algébriques en prenant « la
dérivée première » qu'il annule. Reproduction de la couverture de l'ouvrage cité. Le chapitre est
structuré en 9 parties (I à IX), suivies d'un QCM / Vrai-Faux, puis d'une rubrique « Exercices et
problèmes ».

### Cours — Activités

**I. Rappels** (p.54) — « Dans ce paragraphe nous rappelons les principaux résultats vus en
troisième année. »

- **Activité 1** (p.54) : figure d'une fonction f dérivable sur ℝ, tangentes aux points d'abscisses
  −2 et 0 (courbe donnée, allure de parabole). 1. Déterminer les nombres dérivés de f en −2 et 0. 2. Déterminer lim_{h→0} (f(h) − 1)/h et lim_{x→−2} f(x)/(x + 2).
- **Activité 2** (p.54) : f(x) = x³ + 3x² + 3x + 1, C_f dans un repère orthonormé (O, i⃗, j⃗).
  1. nombre dérivé de f en 0 et en 1 ; 2. tangentes à C_f aux points d'abscisses 0 et 1 ;
  2. approximation affine de (1,0002)³ et (2,0001)³. (Encadrés : définition « dérivable en a » via
     lim_{x→a} (f(x) − f(a))/(x − a) = f′(a) ; dérivée d'un polynôme ; approximation affine
     f(a) + f′(a)h de f(a + h).)
- **Activité 3** (p.54) : approximation affine de sin(0,0001) et cos(0,0001).
- **Activité 4** (p.54) : f(x) = x/(x − 2) si x ≤ 1, (x − 2)|x − 2| si x > 1. 1. f continue sur ℝ ; 2. a. dérivabilité à droite et à gauche en 1 ; b. f dérivable en 2 ; 3. tangentes à C_f aux points
  d'abscisses 0 et 2, demi-tangentes au point d'abscisse 1. (Encadré : dérivable en a ⟺ dérivable à
  gauche et à droite en a et f′_g(a) = f′_d(a).)
- **Activité 5** (p.55) : étudier la dérivabilité de f sur I pour f : x ↦ sin x/(1 + cos²x), I = ℝ ;
  x ↦ (1 + x + x²)/(1 − x²), I = [0, 1/2] ; x ↦ x|x + 1|/(1 − x²), I = [−3, −1[. (Encadré : dérivable
  sur un intervalle ouvert / sur [a, b] / sur les intervalles semi-ouverts et infinis.)
- **Activité 6** (p.56) : α réel, P polynôme de degré n ≥ 2 ; α racine double si P(x) = (x − α)²Q(x)
  avec Q(α) ≠ 0. 1. si α racine double, P(α) = P′(α) = 0 et P″(α) ≠ 0 ; 2. si P(α) = 0 et
  P(x) = (x − α)f(x), montrer que P′(α) = 0 ⇒ f(α) = 0 ; 3. condition suffisante pour que α soit
  racine double ; 4. a. 2 est racine double de P(x) = x⁴ − 4x³ + 5x² − 4x + 4 ; b. factoriser P(x).

**II. Dérivées successives** (p.56) — définitions (voir « Résultats à retenir »).

- **Activité 1** (p.56) : dérivées d'ordre 1, 2, 3 et 4 de f pour f : x ↦ 2x³ − 4x² + x − 1 ;
  x ↦ sin(2x).
- **Activité 2** (p.56) : f(x) = 1/(x − 2) sur ]2, +∞[. a. calculer f′(x), f″(x), f⁽³⁾(x) ;
  b. montrer que pour tout n ≥ 1, f⁽ⁿ⁾(x) = (−1)ⁿ·n!/(x − 2)ⁿ⁺¹.

**III. Dérivabilité des fonctions composées** (p.56)

- **Activité 1** (p.56–57) : f(x) = √(1 − x²) sur [0, 1]. 1. dérivabilité de f à gauche en 1. 2. h(t) = f(sin t) sur [0, π/2] : a. vérifier h(t) = cos t ; b. h dérivable sur [0, π/2],
  déterminer h′(t) ; c. vérifier h′(t) = cos t·f′(sin t) sur [0, π/2[.
- **Activité 2** (p.57) : montrer que f est dérivable sur I et déterminer sa dérivée pour
  f : x ↦ √(1 − cos(πx)), I = ]0, 2[ ; g : x ↦ sin(√(πx²/(1 − x))), I = ]−∞, 0[.

**IV. Théorème des accroissements finis** (p.58)

- **Activité 1** (p.58) : f définie sur [−3, 2], dérivable sur ]−3, 2[, courbe C_f donnée avec
  tangentes aux points d'abscisses −2, 0 et 3/2. Lire les abscisses des points où la tangente est
  parallèle à l'axe des abscisses. (Précède le théorème de Rolle.)
- **Activité 2** (p.58) : f(x) = x⁵ − 3x⁴ − 5x³ + 15x² + 4x + 2, 𝒞 dans (O, i⃗, j⃗). 1. calculer
  f(1) et f(−1) ; 2. en déduire que 𝒞 admet au moins une tangente parallèle à l'axe des abscisses.
- **Activité 3** (p.59) : f(x) = (1/3)x³ − x² sur ℝ, 𝒞 dans (O, i⃗, j⃗), A et B les points
  d'abscisses 3 et 1. Existe-t-il des points de 𝒞 où la tangente est parallèle à (AB) ? (Précède le
  théorème des accroissements finis.)
- **Activité 4** (p.59) : f(x) = x²√(x − 1) sur [1, +∞[, C_f. Montrer que f′(x) = 4 admet au moins
  une solution dans ]1, 2[ et interpréter graphiquement.

**V. Inégalité des accroissements finis** (p.59) — théorème + corollaire (voir « Résultats à
retenir »).

- **Activité 1** (p.60) : f : [0, π/4] → ℝ, x ↦ tan x. 1. montrer 1 ≤ f′(x) ≤ 2 sur [0, π/4] ; 2. en déduire t ≤ tan(t) ≤ 2t sur [0, π/4].
- **Activité 2** (p.60) : 1. montrer 1 + x/√6 ≤ √(1 + x) ≤ 1 + x/2 sur [0, 1/2] ; 2. en déduire un
  encadrement de √(1 + 10⁻¹⁰).
- **Activité 3** (p.60) : 1. pour tout réel positif x, sin x ≤ x et 1 − x²/2 ≤ cos x ; 2. en déduire
  x − x³/6 ≤ sin x ≤ x pour x ≥ 0 ; 3. montrer que φ(x) = (x − sin x)/x si x ≠ 0, φ(0) = 0, est
  dérivable en 0.

**VI. Variations d'une fonction** (p.60) — théorèmes (voir « Résultats à retenir »).

- **Activité 1** (p.60) : graphique d'une fonction f dérivable sur [−7, 7]. Déterminer
  graphiquement les intervalles de stricte monotonie et le signe de f′(x).
- **Activité 2** (p.61) : figure de f(x) = x − sin x sur ℝ. 1. sens de variation graphique ; 2. a. déterminer f′ ; b. résoudre f′(x) = 0 dans ℝ et interpréter graphiquement.
- **Activité 3** (p.62) : étudier les variations de x ↦ √(1 − sin³x) sur [−π/2, π/2].

**VII. Extrema** (p.62)

- **Activité 1** (p.62) : figure d'une fonction f définie sur ]−4, 7[. Déterminer graphiquement les
  extrema locaux de f. (Encadré : définitions de maximum local, minimum local, extremum local.)
- **Activité 2** (p.62) : restriction de f : x ↦ 1 − x² sur [0, 1], tangente en un point M
  d'abscisse a ∈ ]0, 1] (figure : triangle OPQ). Déterminer M pour que l'aire du triangle OPQ soit
  minimale. (Encadré : f dérivable, extremum local en a ⇒ f′(a) = 0 ; si f′(x) s'annule en a en
  changeant de signe, extremum local en a.)

**VIII. Point d'inflexion** (p.63)

- **Activité 1** (p.63) : f(x) = x³ − 3x + 1 sur ℝ, C_f. 1. équation de la tangente T à C_f au point
  d'abscisse 0 ; 2. position relative de C_f et T ; 3. variations de f, tracer T et C_f. (Encadré :
  définition d'un point d'inflexion — C_f traverse sa tangente en A(a, f(a)).)
- **Activité 2** (p.63) : f(x) = 2 − √(2 − x) si x < 1, √x si x ≥ 1, C_f dans (O, i⃗, j⃗). 1. a. I(1, 1)
  centre de symétrie de C_f ; b. I point d'inflexion de C_f ; 2. variations de f ; 3. tracer la
  tangente en I et C_f. (Encadré : centre de symétrie O′(a, b) — 2a − x ∈ D et f(2a − x) = 2b − f(x).)
- **Activité 3** (p.63–64) : a réel, f deux fois dérivable sur ]a − h, a + h[ (h > 0), C_f dans
  (O, i⃗, j⃗). 1. équation de la tangente T à C_f au point d'abscisse a ; 2. φ(x) = f(x) − [f′(a)(x − a) +
  f(a)] sur ]a − h, a + h[ : a. φ deux fois dérivable ; b. tableau de variation de φ′ dans deux cas
  (f″(a) = 0 avec f″ changeant de signe) ; c. en déduire que I(a, f(a)) est un point d'inflexion.
- **Activité 4** (p.64) : f(x) = x⁴ − 6x² + 1 sur ℝ, C_f dans (O, i⃗, j⃗). Montrer que C_f admet deux
  points d'inflexion que l'on précisera.

**IX. Exemples d'étude de fonctions** (p.64) — trois problèmes résolus (résumés ci-dessous).

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Encadré — dérivable en un réel** (p.54) — « Une fonction f définie sur un intervalle ouvert I est
> dérivable en un réel a de I s'il existe un réel, noté f′(a) tel que lim_{x→a} (f(x) − f(a))/(x − a) =
> f′(a). »

> **Encadré — dérivée d'un polynôme** (p.54) — « Soit f : x ↦ aₙxⁿ + … + a₁x + a₀ une fonction
> polynôme. La fonction f est dérivable en tout réel x et f′(x) = naₙxⁿ⁻¹ + … + a₁. »

> **Encadré — approximation affine** (p.54) — « Si f est dérivable en a, alors le réel f(a) + f′(a)h
> est une approximation affine de f(a + h). »

> **Encadré — dérivabilité à gauche et à droite** (p.54) — « Une fonction f définie sur un intervalle
> ouvert I est dérivable en un réel a de I, si et seulement si, elle est dérivable à gauche et à
> droite en a et f′_g(a) = f′_d(a). »

> **Encadré — dérivable sur un intervalle** (p.55) — « • Une fonction est dérivable sur un intervalle
> ouvert I si elle est dérivable en tout réel de I. • Soit deux réels a et b tels que a < b. Une
> fonction est dérivable sur [a, b] si elle est dérivable sur ]a, b[, à droite en a et à gauche en b.
> • On définit de façon analogue la dérivabilité d'une fonction sur les intervalles [a, b[, ]a, b],
> a et b finis ou infinis. »

> **Tableau — dérivées des fonctions usuelles** (p.55) — x ↦ xⁿ (n ∈ ℕ\{0,1}) sur ℝ : f′ = nxⁿ⁻¹ ;
> x ↦ 1/xⁿ (n ∈ ℕ*) sur tout intervalle inclus dans ℝ* : f′ = −nx⁻ⁿ⁻¹ ; x ↦ sin(ax + b) sur ℝ :
> f′ = a cos(ax + b) ; x ↦ cos(ax + b) sur ℝ : f′ = −a sin(ax + b) ; x ↦ tan(ax + b) sur tout
> intervalle inclus dans l'ensemble de définition : f′ = a(1 + tan²(ax + b)).

> **Tableau — opérations sur les fonctions dérivables** (p.55) — f, g dérivables sur un intervalle I :
> (f + g)′ = f′ + g′ ; (af)′ = af′ (a ∈ ℝ) ; (f × g)′ = f′g + g′f ; (1/f)′ = −f′/f² (là où f ≠ 0) ;
> (f/g)′ = (f′g − g′f)/g² (là où g ≠ 0) ; (fⁿ)′ = nf′fⁿ⁻¹ (n ∈ ℕ\{0,1}) ; (1/fⁿ)′ = −nf′f⁻ⁿ⁻¹
> (n ∈ ℕ*, là où f ≠ 0).

> **Dérivées successives** (p.56) — « Soit f une fonction dérivable sur un intervalle I. La dérivée f′
> de f est appelée la dérivée première de f. Si la fonction f′ est dérivable sur I, sa fonction dérivée
> est appelée dérivée seconde de f et notée f⁽²⁾ ou f″. Par itération, si la fonction f⁽ⁿ⁻¹⁾ (n ≥ 2) est
> dérivable sur I, sa fonction dérivée est appelée dérivée nᵉᵐᵉ de f et est notée f⁽ⁿ⁾. La dérivée nᵉᵐᵉ
> de f est aussi appelée dérivée d'ordre n de f. »

> **Théorème — dérivabilité d'une composée** (p.57) — « Soit f une fonction définie sur un intervalle
> ouvert I contenant un réel a et g une fonction définie sur un intervalle ouvert J contenant f(a).
> Si f est dérivable en a et g est dérivable en f(a), alors g∘f est dérivable en a et
> (g∘f)′(a) = f′(a) × g′(f(a)). » (Suivi d'une démonstration via la fonction auxiliaire φ.)

> **Corollaire** (p.57) — « Si f est dérivable sur un intervalle I et g est dérivable sur un intervalle
> J contenant f(I), alors g∘f est dérivable sur I et (g∘f)′(x) = f′(x) × g′[f(x)], pour tout x de I. »

> **Théorème de Rolle** (p.58) — « Soit a et b deux réels tels que a < b. Soit f une fonction continue
> sur [a, b], dérivable sur ]a, b[ et telle que f(a) = f(b). Alors il existe un réel c de ]a, b[ tel
> que f′(c) = 0. » (Interprétation : au moins une tangente à C_f parallèle à l'axe des abscisses ;
> démonstration via l'atteinte des bornes m et M par une fonction continue.)

> **Théorème des accroissements finis** (p.59) — « Soit a et b deux réels tels que a < b et f une
> fonction définie sur [a, b]. Si f est continue sur [a, b] et dérivable sur ]a, b[, alors il existe un
> réel c de ]a, b[ tel que f(b) − f(a) = f′(c)(b − a). » (Interprétation : tangente parallèle à (AB) ;
> démonstration via g(x) = f(x) − ((f(b) − f(a))/(b − a))(x − a) et le théorème de Rolle.)

> **Théorème — inégalité des accroissements finis** (p.59) — « Soit f une fonction continue sur [a, b]
> (a < b) et dérivable sur ]a, b[. Soit deux réels m et M. Si m ≤ f′(x) ≤ M pour tout x de ]a, b[,
> alors m(b − a) ≤ f(b) − f(a) ≤ M(b − a). »

> **Corollaire** (p.60) — « Soit f une fonction dérivable sur un intervalle I et M > 0. Si |f′(x)| ≤ M
> pour tout x de I, alors |f(b) − f(a)| ≤ M|b − a|, pour tous réels a et b de I. »

> **Théorème — variations (dérivée de signe strict)** (p.61) — « Soit f une fonction dérivable sur un
> intervalle I. Si la dérivée de f est strictement positive sur I, alors la fonction f est strictement
> croissante sur I. Si la dérivée de f est strictement négative sur I, alors la fonction f est
> strictement décroissante sur I. »

> **Théorème — variations (dérivée positive ne s'annulant sur aucun intervalle)** (p.61) — « Soit f une
> fonction dérivable sur un intervalle I. Si f′ est positive et ne s'annule sur aucun intervalle ouvert
> contenu dans I, alors f est strictement croissante sur I. Si f′ est négative et ne s'annule sur aucun
> intervalle ouvert contenu dans I, alors f est strictement décroissante sur I. »

> **Théorème — prolongement de la monotonie aux bornes** (p.62) — « Soit f une fonction continue sur un
> intervalle [a, b] et dérivable sur ]a, b[. • Si f est croissante (respectivement strictement
> croissante) sur ]a, b[ alors f est croissante (respectivement strictement croissante) sur [a, b].
> • Si f est décroissante (respectivement strictement décroissante) sur ]a, b[ alors f est décroissante
> (respectivement strictement décroissante) sur [a, b]. »

> **Encadré — extrema locaux** (p.62) — « Soit f une fonction définie sur un intervalle I et a un réel
> de I. On dit que f admet un maximum local en a, s'il existe un intervalle ouvert J contenant a et
> inclus dans I tel que pour tout x de J, f(x) ≤ f(a). On dit que f admet un minimum local en a, s'il
> existe un intervalle ouvert J contenant a et inclus dans I tel que pour tout x de J, f(x) ≥ f(a).
> Lorsque f admet un minimum local ou un maximum local en a on dit que f admet un extremum local en a. »

> **Encadré — condition d'extremum** (p.62) — « Soit f une fonction dérivable sur un intervalle ouvert I
> et a un réel de I. Si f admet un extremum local en a alors f′(a) = 0. Si f′(x) s'annule en a en
> changeant de signe alors f admet un extremum local en a. »

> **Définition — point d'inflexion** (p.63) — « Soit f une fonction définie sur un intervalle ouvert I
> et dérivable en un réel a de I et C_f sa courbe dans un repère orthogonal (O, i⃗, j⃗). On dit que le
> point A(a, f(a)) est un point d'inflexion de C_f si C_f traverse sa tangente en ce point. »

> **Encadré — centre de symétrie** (p.63) — « Le plan est muni d'un repère orthogonal (O, i⃗, j⃗). Soit f
> une fonction définie sur un ensemble D, de courbe représentative C. Soit O′ le point de coordonnées
> (a, b). Le point O′ est un centre de symétrie de C, si pour tout x appartenant à D, 2a − x appartient
> à D et f(2a − x) = 2b − f(x). »

> **Théorème — point d'inflexion (dérivée seconde)** (p.64) — « Soit f une fonction deux fois dérivable
> sur ]a − h, a + h[, (h > 0) et C_f sa représentation graphique dans un repère orthonormé. Si la
> fonction dérivée seconde f″ de f s'annule en a en changeant de signe, alors le point I(a, f(a)) est un
> point d'inflexion de la courbe C_f. »

### Cours — Problèmes résolus (p.64–69)

Trois problèmes résolus, solutions intégrales imprimées.

- **Problème résolu 1** (p.64–66) : A/ g(x) = x³ + 3x + 2 (étude complète : limites et branches
  paraboliques de direction (O, j⃗), g′(x) = 3x² + 3 > 0 donc g strictement croissante, unique solution
  α de g(x) = 0 dans ]−1, 0[ avec −0,6 < α < −0,5 par dichotomie, signe de g, point d'inflexion I(0, 2)
  via g″(x) = 6x, tangente D : y = 3x + 2, position relative). B/ f(x) = (x³ − 1)/(x² + 1) (limites,
  asymptote y = x, f′(x) = xg(x)/(x² + 1)² de même signe que xg(x), tableau de variation, tracé).
- **Problème résolu 2** (p.66–67) : f(x) = 1 + 1/√x sur [1, +∞[. 1. variations (f′(x) = −1/(2x√x)),
  asymptote y = 1, tracé ; 2. f(x) = x admet une unique solution α dans ]1, 2[ (via g = f − x
  strictement décroissante) ; 3. a. |f′(x)| ≤ 1/2 ; b. |f(x) − α| ≤ (1/2)|x − α| par l'inégalité des
  accroissements finis ; 4. suite (uₙ) : u₀ = 2, uₙ₊₁ = 1 + 1/√uₙ — a. sept premiers termes
  (2 ; 1,7071 ; 1,7654 ; 1,7526 ; 1,7554 ; 1,7548 ; 1,7549) ; b. |uₙ₊₁ − α| ≤ (1/2)|uₙ − α| ;
  c. |uₙ − α| ≤ (1/2)ⁿ|u₀ − α| ; d. n₀ = 7 ; e. α ≈ 1,7549.
- **Problème résolu 3** (p.68–69) : configuration géométrique (cercle 𝒞 de centre O rayon 2, droites
  parallèles tangentes D₁, D₂, triangle isocèle ABC, droite variable D coupant 𝒞 en I, J et les côtés
  en K, L). f(x) = IJ + KL = 2√(4x − x²) + 4 − x sur [0, 4]. 1. établir l'expression (via OHI rectangle
  et le théorème de Thalès) ; 2. a. non-dérivabilité à droite en 0 et à gauche en 4 (dérivées infinies) ;
  b. f′(x) = 2(2 − x)/√(4x − x²) − 1 sur ]0, 4[ ; c. tableau de variation, maximum de IJ + KL =
  2√5 + 2 atteint en x = 2 − 2√5/5 ; d. tracé ; 3. a. f(a) = 4 ⟺ a = 16/5 ; b. discussion graphique du
  nombre de solutions de f(x) = f(a) selon a (deux solutions si a ∈ ]0, 16/5[, une seule si a ∈ [16/5, 4[).

### QCM (p.70) — « Cocher la réponse exacte. » (réponses non fournies)

1. La fonction x ↦ cos(πx²) est dérivable sur ℝ et sa dérivée est (☐ x ↦ 2π sin(πx²) /
   ☐ x ↦ 2πx sin(πx²) / ☐ x ↦ −2πx sin(πx²)).
2. f dérivable sur [−2, 2] dont le tableau de variation de f′ est donné (f′ passe par 1 en −2, 0 en
   −1, −1 en 1, −2 puis −1/4). • Alors (☐ f(−2) < f(−1) / ☐ f(−1) < f(0) / ☐ f(0) < f(1)). • La
   courbe de f admet exactement deux tangentes parallèles à la droite d'équation (☐ y = −1/2 /
   ☐ y = (1/2)x / ☐ y = −(1/2)x).
3. L'image de [1, +∞[ par la fonction x ↦ √(x² − 1) − 1 est (☐ ]0, +∞[ / ☐ [−1, +∞[ / ☐ ]−∞, 0]).
4. La courbe représentative de la fonction x ↦ (1/20)x⁵ − 4x² admet un point d'inflexion d'abscisse
   (☐ x = 0 / ☐ x = −2 / ☐ x = 2).
5. f(x) = (x − 1)(x − 2)(x − 3) sur ℝ. La courbe de f dans un repère orthogonal admet exactement
   (☐ deux tangentes horizontales / ☐ une tangente horizontale / ☐ aucune tangente horizontale).

### Vrai ou faux (p.70) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. f dérivable sur [−1, 2] telle que f(−1) = 2, f(2) = −1 ⇒ l'équation f′(x) = −1 admet au moins une
   solution dans [−1, 2].
2. Si le produit de deux fonctions est dérivable en un réel a alors chacune des deux fonctions est
   dérivable en a.
3. Dans un repère orthogonal, la courbe de f : x ↦ (x² − x)(x − 2) admet exactement deux tangentes
   horizontales.
4. f dérivable sur [2, 5] telle que |f′(t)| ≤ 2 pour t ∈ [2, 5] ⇒ |f(5) − f(2)| ≤ 6.

### Exercices et problèmes (p.71–76) — 42 exercices

- **Ex. 1** (p.71) : équation de la tangente à C_f au point d'abscisse a pour f : x ↦ (x − 1)²(x − 3),
  a = 2 ; x ↦ 2x⁴/(x + 2)², a = −1 ; x ↦ x(2√x − 3), a = 4 ; x ↦ cos³x + sin x, a = π/6.
- **Ex. 2** (p.71) : 1. approximation affine de 1/(1 + h)² pour h voisin de 0 ; 2. estimation de
  1/(1,0000000002)² et 1/(0,9999999998)².
- **Ex. 3** (p.71) : vérifier que f est dérivable sur I et déterminer sa dérivée pour
  f : x ↦ 3x¹⁰ − (5/4)x⁸ + 3x − 10, I = ℝ ; x ↦ (1 − x − 3x³)(x + 2x)³ [sic], I = ℝ ; x ↦ x²/(1 − x),
  I = ]1, +∞[ ; x ↦ (x + 1)³/x², I = [1, +∞[ ; x ↦ cos(3x) − sin(2x), I = ℝ ; x ↦ sin x/(1 − cos x),
  I = ]0, π] ; x ↦ (1 + sin(2x))³, I = ℝ ; x ↦ tan²((π/2)x), I = [0, 1[ ; x ↦ √((x − 1)/(x + 1)),
  I = ]1, +∞[ ; x ↦ (√x − 2)/(√x + 2), I = ]0, +∞[.
- **Ex. 4** (p.71) : dérivées successives de f : x ↦ x⁵ − 2x³ + 3x + 4 ; x ↦ cos x ; x ↦ sin(2x).
- **Ex. 5** (p.71) : déterminer une fonction polynôme f de degré 3 telle que f(1) = f′(1) = f″(1) =
  f⁽³⁾(1) = 1.
- **Ex. 6** (p.71) : 1. dérivées d'ordre 3 de f : x ↦ 1/(x − 1) et g : x ↦ 1/(x + 1) ; 2. h(x) =
  x/(x² − 1) sur ℝ\{−1, 1} — a. montrer qu'il existe a, b tels que h(x) = a/(x + 1) + b/(x − 1) ;
  b. en déduire la dérivée d'ordre 3 de h.
- **Ex. 7** (p.71) : f dérivable sur ℝ, f(2) = 0 et f′(2) = 3. Déterminer les limites :
  1. lim_{x→2} f(√(2 + x))/(x − 2) ; 2. lim_{x→2} f(2 sin(πx/4))/(x − 2) ; 3. lim_{x→2} sin(f(x))/(x − 2) ;
  2. lim_{x→0} f(x² + x + 2)/x.
- **Ex. 8** (p.71) : vérifier que f est dérivable sur I et déterminer sa dérivée pour
  f : x ↦ √(x + √x), I = ]0, +∞[ ; x ↦ √(sin x), I = ]0, π/2] ; x ↦ sin(π/x), I = [1, +∞[ ;
  x ↦ tan(sin x), I = ℝ.
- **Ex. 9** (p.72) : f(x) = 1 + x + x² + x³ + x⁴ sur ℝ. 1. montrer 0 ≤ f′(x) ≤ 1,234 sur [0, 1/10] ; 2. en déduire 1 ≤ f(x) < 1 + 1,234x sur [0, 1/10] ; 3. encadrement d'amplitude 10⁻⁸ de
  f(0,0000000011).
- **Ex. 10** (p.72) : f(x) = 1/√(1 + x) sur [0, 1]. 1. f dérivable sur [0, 1] et |f′(x)| ≤ 1/2 ; 2. 1 − (1/2)x ≤ f(x) ≤ 1 sur [0, 1] ; 3. encadrement d'amplitude 10⁻¹⁰ de f(0,0000000002).
- **Ex. 11** (p.72) : montrer que |cos x − cos y| ≤ |x − y| pour tous réels x et y.
- **Ex. 12** (p.72) : 1. montrer (√2/2)(y − x) ≤ sin y − sin x ≤ (√3/2)(y − x) pour x, y de
  [π/6, π/4], x < y ; 2. en déduire √2/12 ≤ (√2 − 1)/π ≤ √3/12.
- **Ex. 13** (p.72) : f(x) = 1/tan x si x ≠ π/2, f(π/2) = 0, sur [π/4, π/2]. 1. f dérivable sur
  [π/4, π/2] ; 2. −2 ≤ f′(x) ≤ −1 sur [π/4, π/2] ; 3. en déduire π/2 − 2x ≤ (1 − tan x)/tan x ≤
  π/4 − x sur [π/4, π/2[.
- **Ex. 14** (p.72) : 1. a. par l'inégalité des accroissements finis, x ≤ tan x sur [0, π/2[ ;
  b. en déduire que f : x ↦ sin x/x est décroissante sur ]0, π/2[ ; 2. a. montrer
  (y − x)/cos²x ≤ tan y − tan x ≤ (y − x)/cos²y pour x, y de [0, π/2[, x < y ; b. en déduire
  x ≤ tan x ≤ x/cos²x sur [0, π/2[ ; c. cos x ≤ sin x/x ≤ 1/cos x sur ]0, π/2[ ; 3. g(x) = sin x/x si
  x ≠ 0, g(0) = 1 : montrer g dérivable en 0 et calculer g′(0).
- **Ex. 15** (p.73) : f dérivable sur [0, 1], f(0) = f′(0) = 0 et f(1) = 0 ; g(x) = f(x)/x si x ≠ 0,
  g(0) = 0. 1. g continue sur [0, 1] ; 2. a. il existe c ∈ ]0, 1[ tel que cf′(c) − f(c) = 0 ;
  b. 𝒞 courbe de g, montrer que 𝒞 possède au moins une tangente passant par l'origine.
- **Ex. 16** (p.73) : 𝒫 parabole y = x² + ax + b, A et B deux points distincts de 𝒫 d'abscisses x_A,
  x_B. Montrer que 𝒫 possède au point d'abscisse (x_A + x_B)/2 une tangente parallèle à (AB).
- **Ex. 17** (p.73) : f dérivable sur [a, b]. 1. si la courbe de f coupe l'axe des abscisses en deux
  points distincts, elle admet au moins une tangente parallèle à l'axe des abscisses ; 2. si elle le
  coupe en n points distincts (n ≥ 2), elle admet au moins n − 1 tangentes parallèles à l'axe des
  abscisses.
- **Ex. 18** (p.73) : f(x) = (x² − 1)³(x⁴ − 16)² sur ℝ. Montrer que f′ admet au moins trois racines
  distinctes autres que −2, −1, 1 et 2.
- **Ex. 19** (p.73) : f n fois dérivable sur [a, b] et s'annulant pour n + 1 valeurs distinctes de
  [a, b] (n ≥ 1). Montrer que sa dérivée nᵉᵐᵉ s'annule au moins une fois dans [a, b].
- **Ex. 20** (p.73) : f(x) = 0 si x = 0, x²sin(1/x) si x ≠ 0, sur ℝ. 1. f continue sur ℝ ; 2. a. pour
  tout x non nul, |f(x)/x| ≤ |x| ; b. en déduire f dérivable en 0 ; 3. a. f dérivable sur ℝ,
  déterminer f′ ; b. calculer |f′(1/(nπ))| (n entier non nul) ; c. f′ est-elle continue en 0 ?
- **Ex. 21** (p.73) : figure d'une fonction f sur ℝ (Δ asymptote oblique en +∞, axe des abscisses
  asymptote horizontale en −∞). 1. tableau de variation de f ; 2. déterminer graphiquement
  lim_{x→(−2)⁻} (f(x) − f(−2))/(x + 2), lim_{x→(−2)⁺} (f(x) − f(−2))/(x + 2), lim_{x→1} (f(x) + 2)/(x − 1),
  lim_{x→+∞} (f(x) − x + 4).
- **Ex. 22** (p.73) : étudier et représenter f : x ↦ 4x³ + 6x − 2.
- **Ex. 23** (p.73) : étudier et représenter f : x ↦ (x³ + 2x + 2)/(2x).
- **Ex. 24** (p.74) : étudier et représenter f : x ↦ x((x + 1)/(x − 1))².
- **Ex. 25** (p.74) : étudier et représenter f : x ↦ √(x² + 2x + 3).
- **Ex. 26** (p.74) : étudier et représenter f : x ↦ 5x + 3√(x² − 1).
- **Ex. 27** (p.74) : étudier et représenter f : x ↦ x + √(4 − x²).
- **Ex. 28** (p.74) : étudier et représenter f : x ↦ x√((x − 1)/(x + 1)).
- **Ex. 29** (p.74) : f(x) = sin²x + cos x sur ℝ, C_f dans (O, i⃗, j⃗). 1. a. 2π période de f ;
  b. l'axe des ordonnées axe de symétrie de C_f ; 2. a. variations de f ; b. f(x) = 0 admet une
  unique solution α dans [0, π], encadrement d'amplitude 10⁻¹ ; c. tracer la restriction de f à
  [−π, 2π].
- **Ex. 30** (p.74) : I. étudier et représenter f : x ↦ x³/(x − 1)². II. h : x ↦ sin³x/(sin x − 1)²,
  C_h dans un repère orthonormé. 1. a. ensemble de définition de h ; b. 2π période de h ; c. la droite
  x = π/2 axe de symétrie pour C_h ; 2. a. lim_{x→(π/2)⁻} h(x) ; b. en écrivant h = f∘sin, sens de
  variation de h sur [−π/2, π/2[ ; c. résoudre h′(x) = 0 ; d. l'origine point d'inflexion de C_h ; 3. tracer C_h.
- **Ex. 31** (p.74) : 1. étudier et représenter f : x ↦ x(x + 1)/(x − 2) ; 2. discussion graphique
  selon m du nombre de solutions de x² + (1 − m)x + 2m = 0 ; 3. discussion selon m du nombre de
  solutions de cos²x + (1 − m)cos x + 2m = 0 dans [0, 2π[.
- **Ex. 32** (p.74) : étudier et représenter f : x ↦ sin x + (1/2)sin(2x).
- **Ex. 33** (p.74) : étudier et représenter f : x ↦ cos x/(2 cos x − 1).
- **Ex. 34** (p.74) : f(x) = |x² + x| si x < 0, x√x si x ≥ 0, sur ℝ, C_f dans un repère orthogonal.
  1. f continue sur ℝ ; 2. dérivabilité de f en 0 et en −1 ; 3. étudier f et tracer C_f.
- **Ex. 35** (p.75) : 1. g(x) = 2x³ + 3x² + 1 sur ℝ — a. variations ; b. g(x) = 0 admet une unique
  solution α, valeur approchée à 10⁻¹ ; c. signe de g ; 2. f(x) = (x + x³)/(1 − x³), C_f dans
  (O, i⃗, j⃗) — a. variations ; b. tangente T au point d'abscisse 0 ; c. position de C_f par rapport à
  T ; d. tracer C_f et T.
- **Ex. 36** (p.75) : 1. g(x) = 2x³ + x − 2 sur ℝ — a. tableau de variation ; b. g(x) = 0 admet une
  unique solution α dans ℝ ; c. valeur approchée de α à 10⁻² ; d. signe de g ; 2. f(x) =
  √(x⁴ + (x − 2)²) sur ℝ — a. f dérivable sur ℝ, déterminer f′ ; b. tableau de variation et tracé de
  C_f ; c. intersection graphique de C_f et de y = x.
- **Ex. 37** (p.75) : (uₙ) définie pour n ≥ 1 par uₙ = 1 + 1/2³ + 1/3³ + … + 1/n³. 1. (uₙ)
  croissante ; 2. f(x) = 1/x² sur ]0, +∞[ — a. pour k ≥ 1, 2/(k + 1)³ ≤ f(k) − f(k + 1) ≤ 2/k³ ;
  b. 1/2 − 1/(2n²) ≤ uₙ ≤ 3/2 − 1/(2n²) pour n > 1 ; c. (uₙ) majorée ; d. (uₙ) convergente,
  encadrement de sa limite.
- **Ex. 38** (p.75) : f(x) = tan x sur [0, π/2[. 1. a. étudier f, tracer sa courbe (demi-tangente au
  point d'abscisse 0) ; b. tan(x) ≥ x sur [0, π/2[ ; 2. a. tan x = 2x admet une unique solution α
  dans ]0, π/2[, α > π/3 ; b. signe de tan x − 2x sur [0, π/2[ ; 3. (uₙ) : u₀ = π/3, uₙ₊₁ =
  tan(uₙ) − uₙ — a. 0 ≤ uₙ ≤ π/3 ; b. (uₙ) décroissante ; c. (uₙ) converge vers 0.
- **Ex. 39** (p.75) : pour tout entier n ≥ 1, équation (Eₙ) : x² + x³ = n. 1. (Eₙ) admet une solution
  unique aₙ ; 2. a. (aₙ) croissante ; b. (aₙ) non majorée ; c. limite de (aₙ).
- **Ex. 40** (p.76) : I. f : x ↦ sin x, C_f dans (O, i⃗, j⃗). 1. a. représenter la restriction de f à
  [−π, 3π] ; b. A, B distincts de C_f, coefficient directeur de (AB) compris entre −1 et 1. II. g : x ↦
  sin(sin x), C_g. 1. a. 2π période de g ; b. g impaire ; c. variations de g sur [0, π] ; d. représenter
  la restriction de g à [−π, 2π].
- **Ex. 41** (p.76) : I. f(x) = x√(|x² − x|) sur ℝ, C_f dans (O, i⃗, j⃗). 1. C_f admet deux branches
  paraboliques (directions à préciser) ; 2. a. f dérivable en 0 ; b. f dérivable en 1 ? interpréter ; 3. a. variations de f ; b. tracer C_f ; 4. g restriction de f à [0, 1], extrema locaux de g. II. n
  entier non nul, gₙ(x) = xⁿ√(x(1 − x)) sur [0, 1], Cₙ dans (O, i⃗, j⃗). 1. pour n ≥ 2, Cₙ au-dessous de
  C₁ ; 2. a. dérivabilité de gₙ à droite en 0 et à gauche en 1 ; b. gₙ dérivable sur ]0, 1[, gₙ′(x) =
  xⁿ(n + 1/2 − (n + 1)x)/√(x(1 − x)) ; c. maximum local αₙ (à préciser) ; d. calculer lim_{n→+∞} αₙ ; 3. (uₙ) : uₙ = gₙ(αₙ), n ≥ 1 — a. (uₙ) bornée ; b. 0 ≤ uₙ ≤ g₁(αₙ) ; c. (uₙ) convergente, sa limite.
- **Ex. 42** (p.76) : 1. (E) : x³ − 10x² − 1 = 0 admet dans ℝ une unique solution a, a ∈ ]10, 11[ ; 2. (E) équivalente à x = 10 + 1/x² ; 3. f(x) = 10 + 1/x² sur [10, +∞[ — a. déterminer f([10, +∞[) ;
  b. (uₙ) : u₀ = 10, uₙ₊₁ = f(uₙ) — montrer |uₙ₊₁ − a| ≤ (1/500)|uₙ − a|, déterminer les six premières
  décimales de a.

### Bornes de scope observées (chapitre 3)

- ✅ INCLUS : rappels de 3ème (nombre dérivé, tangente, approximation affine, dérivabilité à
  gauche/à droite, dérivées usuelles xⁿ, 1/xⁿ, sin/cos/tan(ax + b), opérations sur les dérivées,
  racine double d'un polynôme) ; dérivées successives et dérivée nᵉᵐᵉ ; dérivabilité et dérivée d'une
  composée (théorème + corollaire, démonstration) ; théorème de Rolle ; théorème des accroissements
  finis ; inégalité des accroissements finis (+ corollaire |f(b) − f(a)| ≤ M|b − a|) ; variations à
  partir du signe de f′ (strict, et f′ ≥ 0 ne s'annulant sur aucun intervalle ; prolongement aux
  bornes) ; extrema locaux (condition f′(a) = 0, changement de signe) ; point d'inflexion (définition
  géométrique + critère f″ change de signe), centre de symétrie ; études complètes de fonctions
  (limites/branches, tableau, asymptotes, tracé) et applications aux suites récurrentes via
  l'inégalité des accroissements finis.
- ⛔ NON traité dans ce chapitre : fonctions réciproques et dérivée d'une réciproque (chapitre 4) ;
  primitives et intégrales (chapitres 5–6) ; fonctions ln/exp (chapitres 7–8) ; convexité formelle
  (le point d'inflexion est traité par « traverse sa tangente » / changement de signe de f″, sans le
  vocabulaire convexe/concave) ; formule de Taylor-Lagrange (seule l'inégalité des accroissements
  finis sert d'outil d'approximation).

## 2.4 Chapitre 4 — Fonctions réciproques (manuel 222445, p.77–95)

**Page de garde (p.77)** — Titre : « Fonctions réciproques », Chapitre 4. Citation liminaire
(référence : « J. Dieudonné, _Abrégé d'Histoire des Mathématiques_, 1978 ») : le 29 novembre 1873
Cantor écrit à Dedekind pour lui soumettre la question de l'existence d'une bijection entre ℕ et ℝ ;
sa lettre du 7 décembre 1873 contient la première démonstration de la non-existence d'une bijection
entre ℕ et ]0, 1[ ; le 20 juin 1877 Cantor envoie à Dedekind sa première démonstration de la
bijection entre [0, 1] et [0, 1]×[0, 1] (« je le vois, mais je ne le crois pas »). Le chapitre est
structuré en 4 parties (I à IV), suivies d'un QCM / Vrai-Faux, puis d'une rubrique « Exercices et
problèmes ».

### Cours — Activités

**I. Définition** (p.78)

- **Activité 1** (p.78) : g définie sur ]−∞, 0] par g(x) = 2x² − 3. 1.a. déterminer g(]−∞, 0]) ;
  b. montrer que pour tout réel y de [−3, +∞[, l'équation g(x) = y admet une unique solution dans
  ]−∞, 0] que l'on déterminera. 2. h définie sur [−3, +∞[ par h(x) = −√((x + 3)/2) : montrer que pour
  tout réel y de ]−∞, 0], l'équation h(x) = y admet une unique solution dans [−3, +∞[. 3. déterminer
  g∘h et h∘g. (Encadrés : définition « f réalise une bijection de I sur f(I) » ; théorème « f
  strictement monotone ⇒ f bijection », avec démonstration.)
- **Activité 2** (p.78–79) : parmi les fonctions f_i, i ∈ {1, 2, 3, 4} représentées graphiquement,
  identifier celles qui réalisent une bijection de I sur f_i(I). (Quatre figures données : ① I = [−5, 2],
  f₁(I) = [−2, 3] ; ② I = [−6, 4], f₂(I) = [−3, 4] ; ③ I = ]−4, 4[, f₃(I) = ]−4, 4[ ; ④ I = [−2, 3[,
  f₄(I) = ]−3, 1].) (Encadrés : définition de la fonction réciproque f⁻¹ ; conséquence f(x) = y ⟺
  f⁻¹(y) = x, f⁻¹∘f et f∘f⁻¹.)
- **Activité 3** (p.79) : figure représentant une bijection de [−2, +∞[ sur [−1, +∞[. Déterminer
  f⁻¹(−1), f⁻¹(1), f⁻¹(3).
- **Activité 4** (p.80) : 1. f : x ↦ 1/x — a. montrer que f réalise une bijection de ℝ*₊ sur ℝ*₊ ;
  b. expliciter f⁻¹(x) pour tout réel x de ℝ*₊. 2. g : x ↦ √(1 + x²) — a. montrer que g réalise une
  bijection de ℝ₊ sur [1, +∞[ ; b. déterminer g⁻¹.
- **Représentation graphique de f⁻¹** (p.80) : C₁ et C₂ courbes de f et f⁻¹ dans un repère orthonormé ;
  M₁(x, y) point du plan, M₂(y, x) son symétrique par rapport à Δ : y = x ; M₁(x, y) ∈ C₁ ⟺ (y = f(x)
  et x ∈ I) ⟺ (x = f⁻¹(y) et y ∈ f(I)) ⟺ M₂ ∈ C₂. (Encadré : conséquence — symétrie par rapport à
  Δ : y = x.)
- **Activité 5** (p.80) : figure représentant les courbes de deux bijections f et g définies
  respectivement sur [0, 7] et [−2, 5], ainsi que celles de leurs réciproques. Identifier la courbe de
  chacune des fonctions f, f⁻¹, g et g⁻¹.

**II. Fonction réciproque d'une fonction strictement monotone** (p.80)

- **Activité 1** (p.81) : f définie sur [−π/2, π/2] par f(x) = sin x. 1. montrer que f admet une
  fonction réciproque f⁻¹, continue sur un intervalle J que l'on précisera ; 2. donner les valeurs de
  f⁻¹(1/2), f⁻¹(−√3/2), f⁻¹(√2/2), f⁻¹(1).
- **Activité 2** (p.81) : f définie sur [1, +∞[ par f(x) = x/(1 + x²). 1.a. montrer que f réalise une
  bijection de [1, +∞[ sur un intervalle J que l'on précisera ; b. expliciter f⁻¹(y) pour y ∈ J ; 2. en utilisant f∘f⁻¹(y) = y pour tout y ∈ ]0, 1/2[, montrer que (f⁻¹)′(y) = 1/(f′(f⁻¹(y))).
  (Encadrés : théorème « dérivée de f⁻¹ en b » + démonstration ; corollaire « dérivée de f⁻¹ sur
  f(I) ».)
- **Activité 3** (p.82) : figure représentant une bijection f de [−6, 5] sur [−4, 4] et les tangentes
  aux points d'abscisses −4, −2 et −1. Étudier la dérivabilité de f⁻¹ aux points d'abscisses −2, 0 et 1.
- **Activité 4** (p.82) : f définie sur [0, π] par f(x) = cos x, C_f dans un repère orthonormé.
  1. tracer C_f ; 2. montrer que f réalise une bijection de [0, π] sur [−1, 1] ; 3.a. étudier la
     dérivabilité de f⁻¹ en 0 et calculer (f⁻¹)′(0) ; b. étudier la dérivabilité de f⁻¹ à droite en −1 et
     à gauche en 1 ; 4. tracer la courbe de f⁻¹ dans le même repère orthonormé.

**III. Fonction x ↦ ⁿ√x, n ≥ 2** (p.82) — théorème et définition, notation, conséquences (voir
« Résultats à retenir »).

- **Activité 1** (p.83) : écrire plus simplement les réels ⁶√64, ⁶√(2⁻¹²), √(∛729), ∛(2⁶·3³),
  (⁸√16)/(⁸√81), ∛(2√2).
- **Activité 2** (p.83) : 1. comparer ⁶√(2⁴) et ⁴√(2³) ; 2. pour un réel x ≥ 0, comparer ⁶√(x⁴) et
  ⁴√(x³).
- **Activité 3** (p.83) : étudier la dérivabilité à droite en 0 de la fonction x ↦ ⁿ√x, n ≥ 2.
  Interpréter. (Précédée du théorème « dérivée de ⁿ√x » et de sa démonstration.)

**IV. Fonction x ↦ ⁿ√(u(x))** (p.84) — théorème + démonstration (voir « Résultats à retenir »), suivi
de deux exercices résolus (résumés ci-dessous).

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Définition — bijection** (p.78) — « Soit I un intervalle de ℝ et f une fonction définie sur I. On
> dit que f réalise une bijection de I sur f(I) (ou que f est une bijection de I sur f(I)), si pour
> tout y de f(I), l'équation f(x) = y admet une unique solution dans I. »

> **Théorème — monotonie stricte ⇒ bijection** (p.78) — « Si f est une fonction strictement monotone
> sur un intervalle I, alors f réalise une bijection de I sur f(I). » (Démonstration : existence par
> définition de f(I), unicité par la stricte monotonie de f.)

> **Définition — fonction réciproque** (p.79) — « Soit f une bijection d'un intervalle I sur f(I). On
> appelle fonction réciproque de f et on note f⁻¹ la fonction définie sur f(I) qui à tout y de f(I)
> associe l'unique solution dans I de l'équation f(x) = y. »

> **Conséquence** (p.79) — « Soit f une bijection d'un intervalle I sur f(I) et f⁻¹ sa fonction
> réciproque. Pour tout x de I et tout y de f(I), f(x) = y, si et seulement si, f⁻¹(y) = x.
> f⁻¹∘f(x) = x, pour tout x de I et f∘f⁻¹(y) = y, pour tout y de f(I). »

> **Conséquence — symétrie des courbes** (p.80) — « Les courbes respectives d'une bijection f et de sa
> réciproque f⁻¹ dans un repère orthonormé sont symétriques par rapport à la droite Δ : y = x. »

> **Théorème — réciproque d'une fonction strictement monotone** (p.80) — « Si f est une fonction
> continue et strictement monotone sur un intervalle I alors sa réciproque f⁻¹ est continue et
> strictement monotone sur l'intervalle f(I) et varie dans le même sens que f. » (Suivi d'une
> démonstration : la continuité de f⁻¹ est admise, la stricte monotonie établie par l'absurde.)

> **Théorème — dérivée de la réciproque en un point** (p.81) — « Soit f une fonction strictement
> monotone d'un intervalle I sur f(I), a un réel de I et b = f(a). Si f est dérivable en a et si
> f′(a) ≠ 0, alors f⁻¹ est dérivable en b et (f⁻¹)′(b) = 1/f′(a). » (Remarque imprimée : « Ce résultat
> reste valable lorsqu'il s'agit de dérivée à droite ou à gauche en a. » ; suivi d'une démonstration
> via le taux d'accroissement.)

> **Corollaire — dérivée de la réciproque sur f(I)** (p.82) — « Soit f une bijection d'un intervalle I
> sur f(I). Si f est dérivable sur I et f′(x) ≠ 0 pour tout x de I, alors f⁻¹ est dérivable sur f(I) et
> (f⁻¹)′(y) = 1/f′[f⁻¹(y)], pour tout y de f(I). »

> **Théorème et définition — fonction racine nᵉᵐᵉ** (p.82) — « Soit n un entier supérieur ou égal à 2.
> La fonction x ↦ xⁿ réalise une bijection de ℝ₊ sur ℝ₊. Elle admet une fonction réciproque strictement
> croissante de ℝ₊ sur ℝ₊, appelée fonction racine nᵉᵐᵉ. »

> **Notation** (p.83) — « L'image d'un réel positif x par la fonction racine nᵉᵐᵉ est noté ⁿ√x et se lit
> « racine nᵉᵐᵉ de x ». Lorsque n = 2 et pour x positif ²√x = √x. »

> **Conséquence** (p.83) — « • Pour tous réels positifs x et y, y = xⁿ, si et seulement si, x = ⁿ√y.
> • lim_{x→+∞} ⁿ√x = +∞. »

> **Conséquence — opérations sur les radicaux** (p.83) — « Soit deux entiers n et p tels que n ≥ 2 et
> p ≥ 2 et deux réels positifs a et b. Alors ⁿ√(aⁿ) = a ; (ⁿ√a)ⁿ = a ; ⁿ√(a·b) = ⁿ√a·ⁿ√b ;
> ⁿ√(a/b) = ⁿ√a/ⁿ√b, b ≠ 0 ; ⁿ√a = ⁿᵖ√(aᵖ) ; (ⁿ√a)ᵖ = ⁿ√(aᵖ) ; ⁿ√(ᵖ√a) = ⁿᵖ√a. »

> **Théorème — dérivée de x ↦ ⁿ√x** (p.83) — « Pour tout entier n ≥ 2, la fonction f : x ↦ ⁿ√x est
> continue sur [0, +∞[ et dérivable sur ]0, +∞[. De plus, f′(x) = 1/(n·ⁿ√(xⁿ⁻¹)), pour tout x > 0. »
> (Suivi d'une démonstration via la dérivée de la réciproque de g : x ↦ xⁿ.)

> **Théorème — dérivée de x ↦ ⁿ√(u(x))** (p.84) — « Soit u une fonction dérivable et positive sur un
> intervalle I et un entier n ≥ 2. La fonction f : x ↦ ⁿ√(u(x)) est continue sur I et dérivable en tout
> réel x de I tel que u(x) ≠ 0. De plus, f′(x) = u′(x)/(n·ⁿ√(u(x)ⁿ⁻¹)), pour tout x de I tel que
> u(x) > 0. » (Démonstration : f est la composée de x ↦ u(x) et de x ↦ ⁿ√x.)

### Cours — Exercices résolus (p.84–86)

Deux exercices résolus, solutions intégrales imprimées.

- **Exercice résolu 1** (p.84–85) : f : x ↦ ∛(x² + 1), C_f dans un repère orthonormé (O, i⃗, j⃗).
  1. justifier que f est dérivable sur ℝ et f′(x) = 2x/(3·∛((x² + 1)²)) ; 2. étudier les branches
     infinies de C_f (f paire, branche parabolique de direction (O, i⃗) en ±∞) ; 3. étudier les variations
     de f et construire C_f ; 4. g restriction de f à [0, +∞[ — a. montrer que g réalise une bijection de
     [0, +∞[ sur g([0, +∞[) = [1, +∞[ ; b. construire dans le repère les courbes de f et g⁻¹.
- **Exercice résolu 2** (p.85–86) : I. k définie sur [0, +∞[ par k(x) = −2x⁴ + x³ + 1 ; dresser le
  tableau de variation de k (k′(x) = x²(3 − 8x), maximum en 3/8) et en déduire le signe de k
  (k(x) > 0 si x < 1, k(1) = 0, k(x) < 0 si x > 1). II. f définie sur ]0, +∞[ par f(x) = √x − 1/(2x),
  courbe C dans un repère orthonormé (O, i⃗, j⃗). 1. étudier les variations de f (f′(x) = 1/(2√x) +
  1/(2x²)) ; 2. tangente T à C au point d'abscisse 1 : y = x − 1/2 (f(1) = 1/2, f′(1) = 1) ; 3. g(x) =
  f(x) − x + 1/2 sur ]0, +∞[ — a. g′(x) = k(√x)/(2x²) ; b. tableau de variation de g, C au-dessous de T ; 4. tracer T et C ; 5.a. f réalise une bijection de ]0, +∞[ sur ℝ ; b. C′ courbe de f⁻¹, T′ tangente à
  C′ au point d'abscisse 1/2 : T et T′ parallèles (symétrie par rapport à Δ : y = x) ; c. tracer T′ et
  C′.

### QCM (p.87) — « Cocher la réponse exacte. » (réponses non fournies)

1. f définie sur ℝ par f(x) = sin x réalise une bijection de I sur [−1, 1] pour (☐ I = [0, 2π] /
   ☐ I = [0, π] / ☐ I = [−π/2, π/2]).
2. f définie sur [0, π] par f(x) = cos x. (f⁻¹)′(1/2) est égal à (☐ 2/√3 / ☐ −2 / ☐ −2/√3).
3. f dont la représentation graphique est donnée réalise une bijection de (☐ [1, 4] sur [1, 4] /
   ☐ [1, 2] sur [1, 2] / ☐ [1, 3] sur [1, 3]).
4. La fonction f : x ↦ ∛x est dérivable sur (☐ [0, +∞[ / ☐ ]0, +∞[ / ☐ ℝ*).

### Vrai ou faux (p.87) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. f continue sur [1, +∞[ telle que f(1) = 2 et lim_{+∞} f = 3 ⇒ f réalise une bijection de [1, +∞[
   sur [2, 3[.
2. Toute fonction affine réalise une bijection de ℝ sur ℝ.
3. Pour tout réel x > 0, ⁴√x ≥ ∛x.
4. La fonction réciproque de la fonction définie sur ℝ₊ par f(x) = ⁿ√x est dérivable à droite en 0.
5. Si f est strictement monotone et dérivable sur un intervalle I et si f garde un signe constant sur
   I, alors sa réciproque garde un signe constant sur f(I).

### Exercices et problèmes (p.88–95) — 28 exercices

- **Ex. 1** (p.88) : montrer que f réalise une bijection de I sur un intervalle J à préciser et
  déterminer f⁻¹(x) : 1. f(x) = 1 − 4x, I = ]−∞, 1] ; 2. f(x) = x² − 4x + 1, I = [2, +∞[ ; 3. f(x) = (2x − 1)/(x + 1), I = ]−1, +∞[ ; 4. f(x) = √(x − 3) + x, I = [3, +∞[.
- **Ex. 2** (p.88) : g(x) = ax + b (a, b réels, a ≠ 0). 1. montrer que g réalise une bijection de ℝ sur
  ℝ ; 2. déterminer a et b pour que g⁻¹ = g.
- **Ex. 3** (p.88) : f définie sur [0, 1] par f(x) = (1/2)x⁴ − x². 1. étudier f et tracer C_f dans un
  repère orthonormé ; 2.a. montrer que f réalise une bijection de [0, 1] sur un intervalle J à préciser ;
  b. tracer la courbe de f⁻¹ ; c. déterminer f⁻¹(x) pour tout x de J.
- **Ex. 4** (p.88) : f définie sur [0, 1] par f(x) = cos(πx). 1. montrer que f réalise une bijection de
  [0, 1] sur un intervalle J à préciser ; 2. tracer les courbes de f et f⁻¹ ; 3. montrer que pour tout
  x de J, f⁻¹(x) + f⁻¹(−x) = 1 et interpréter graphiquement.
- **Ex. 5** (p.88) : f définie sur ℝ₊ par f(x) = √x + √(4 + x), C_f dans un repère orthonormé.
  1. étudier la dérivabilité de f en 0 ; 2.a. montrer que f réalise une bijection de ℝ₊ sur un
     intervalle J à préciser ; étudier la dérivabilité de f⁻¹ sur J ; b. tracer C_f et C_{f⁻¹}.
- **Ex. 6** (p.88) : graphique de la courbe d'une fonction f bijective de ℝ sur ℝ ; g = f⁻¹. 1. que
  peut-on dire de la dérivabilité de g en −1 et en 1 ? 2. dresser le tableau de variation de g ; 3. reproduire C_f et représenter la courbe de g.
- **Ex. 7** (p.88) : graphique de la courbe C d'une fonction f bijective de ]−1, 2] sur ]−4, −∞[ [sic],
  admettant une asymptote verticale d'équation x = −1 ; g = f⁻¹. 1. dérivabilité de g en −1 et en −4 ; 2. tableau de variation de g ; 3. reproduire C et représenter la courbe de g.
- **Ex. 8** (p.89) : A/ g définie sur [−π/4, π/4] par g(x) = sin(2x) − x — 1. étudier les variations de
  g ; 2. montrer que l'équation sin(2x) = x admet une unique solution α dans ]−π/4, π/4[. B/ f définie
  sur [−π/4, π/4] par f(x) = sin(2x), C_f — 1.a. équation de la tangente à C_f au point d'abscisse 0 ;
  b. l'origine est un point d'inflexion de C_f ; 2. étudier f et tracer C_f ; 3.a. f réalise une
  bijection de [−π/4, π/4] sur [−1, 1] (f⁻¹, C_{f⁻¹}) ; b. tracer C_{f⁻¹} ; 4. montrer que f⁻¹ est
  dérivable sur ]−1, 1[ et calculer (f⁻¹)′(x).
- **Ex. 9** (p.89) : f définie sur [0, 1[ par f(x) = √(x/(1 − x²)). 1.a. dérivabilité de f à droite en 0
  et interprétation ; b. variations et tableau de variation de f ; c. tracer C_f dans un repère
  orthonormé ; 2. f réalise une bijection de [0, 1[ sur un intervalle I à préciser (f⁻¹, C_{f⁻¹}) ;
  3.a. f⁻¹ est-elle dérivable à droite en 0 ? b. calculer f⁻¹(x) pour tout réel x de I ; c. tracer
  C_{f⁻¹}.
- **Ex. 10** (p.89) : f définie sur [−1, 1[ par f(x) = √((1 + x)/(1 − x)). 1.a. f dérivable sur ]−1, 1[,
  calculer f′(x) ; b. dérivabilité de f à droite en −1 et interprétation ; c. lim_{x→1⁻} f(x) et
  interprétation ; d. tableau de variation de f ; 2.a. tangente T à C_f en son point A d'abscisse 0 ;
  b. position relative de C_f et T, construire C_f et T ; 3.a. f réalise une bijection de [−1, 1[ sur un
  intervalle J (f⁻¹, C_{f⁻¹}) ; b. tracer C_{f⁻¹}.
- **Ex. 11** (p.89) : f définie sur ℝ par f(x) = (x + 1)/√(x² + 2x + 2), C_f. 1. étudier les variations
  de f ; 2.a. montrer que I(−1, 0) est un centre de symétrie de C_f ; b. I point d'inflexion de C_f ;
  3.a. la droite Δ : y = x coupe C_f en un seul point d'abscisse α avec 0 < α < 1 ; b. position relative
  de C_f et Δ ; 4. construire C_f et sa tangente T au point I ; 5.a. f réalise une bijection de ℝ sur un
  intervalle J (f⁻¹, C_{f⁻¹}) ; b. tracer C_f et C_{f⁻¹}.
- **Ex. 12** (p.90) : g définie sur ]−1/2, 1/2[ par g(x) = tan(πx). 1. étudier g et tracer C_g ; 2. montrer que g réalise une bijection de I sur ℝ ; 3. montrer que g⁻¹ est dérivable sur ]−∞, 0[ ; 4. G définie sur ]−∞, 0[ par G(x) = g⁻¹(x) + g⁻¹(1/x) — a. G dérivable sur ]−∞, 0[, déterminer G′(x) ;
  b. en déduire que pour tout x de ]−∞, 0[, g⁻¹(x) = −1/2 − g⁻¹(1/x).
- **Ex. 13** (p.90) : h définie sur ]0, π] par h(x) = cotan(x/2). 1. montrer que h réalise une bijection
  de ]0, π] sur ℝ₊ ; φ = h⁻¹. 2.a. montrer que φ est dérivable sur ℝ₊ et φ′(x) = −2/(1 + x²) ;
  b. Ψ définie sur ]0, +∞[ par Ψ(x) = φ(1/x) : calculer Ψ′ sur ]0, +∞[ ; c. calculer φ(1) et en déduire
  que pour tout x > 0, φ(x) + Ψ(x) = π.
- **Ex. 14** (p.90) : A/ f définie sur [0, 1] par f(x) = x√(1 − x²), C_f. 1. variations et tableau de
  variation de f ; 2. g restriction de f à [0, √2/2] — a. g réalise une bijection de [0, √2/2] sur I à
  déterminer ; b. propriétés de g⁻¹ et g⁻¹(x) pour tout x de I ; 3. suite (uₙ) : u₀ = 1/2,
  uₙ₊₁ = f(uₙ) — a. pour tout n, 0 ≤ uₙ ≤ 1/2 ; b. (uₙ) décroissante ; c. (uₙ) convergente, calculer sa
  limite.
- **Ex. 15** (p.90) : pour tout entier n ≥ 2, fₙ définie sur [0, 1] par fₙ(x) = xⁿ + xⁿ⁻¹ + … + x − 1.
  1. montrer que fₙ réalise une bijection de [0, 1] sur [−1, n − 1] ; 2.a. l'équation fₙ(x) = 0 admet
     une unique solution αₙ dans ]0, 1[ ; b. pour tout n ≥ 1, (αₙ)ⁿ⁺¹ = 2αₙ − 1 ; 3.a. (αₙ) décroissante ;
     b. (αₙ) convergente, calculer sa limite.
- **Ex. 16** (p.91) : A/ f définie sur ℝ par f(x) = −x + √(x² + 8), C_f. 1.a. calculer lim_{x→+∞} f(x),
  lim_{x→−∞} f(x) et lim_{x→−∞} f(x) + 2x ; b. interprétation graphique ; 2. variations de f ; 3. f
  réalise une bijection de ℝ sur un intervalle J (f⁻¹, C_{f⁻¹}) ; 4.a. résoudre f(x) = x ; b. points
  d'intersection de C_f et C_{f⁻¹} ; 5. tracer C_f et C_{f⁻¹}. B/ 1. montrer que f([1, 2]) ⊂ [1, 2] ; 2. montrer que |f′(x)| ≤ 2/3 pour tout x de [1, 2] ; 3. suite (uₙ) : u₀ = 1, uₙ₊₁ = f(uₙ) — a. pour
  tout n, 1 ≤ uₙ ≤ 2 ; b. |uₙ₊₁ − √(8/3)| ≤ (2/3)|uₙ − √(8/3)| ; c. (uₙ) converge vers √(8/3).
- **Ex. 17** (p.91) : 1. simplifier x = (∛3·∛27·∛8)/∛81, y = ∛4/∛32, t = ∛(8²) ; 2. montrer que
  (∛1024·√(√64)·⁵√7776)/(√18·√(∛256)) = 16 ; 3.a. développer (2 + √5)³ ; b. simplifier
  ∛(38 + 17√5) − ∛(38 − 17√5).
- **Ex. 18** (p.91) : résoudre dans ℝ : 1. ∛x = ⁴√2 ; 2. ⁵√(x²) = ∛3 ; 3. ∛(x²) − 3·³√x + 2 = 0 [sic] ; 4. (1 − ⁴√x)³ + 8 = 0.
- **Ex. 19** (p.91) : calculer les limites : lim_{x→+∞} (∛(x² − x + 1)) ; lim_{x→0} ∛((x² + x)/sin x) ;
  lim_{x→+∞} (x − ∛x) ; lim_{x→2} (∛x − ∛2)/(x − 2) ; lim_{x→0} (∛(cos x) − 1)/x ;
  lim_{x→+∞} (∛x − √x)/⁴√x.
- **Ex. 20** (p.91) : f définie sur ℝ₊ par f(x) = x² + ⁴√x. 1. variations de f ; 2. f réalise une
  bijection de ℝ₊ sur un intervalle J à préciser (f⁻¹) ; 3. tracer les courbes de f et f⁻¹ dans un
  repère orthonormé.
- **Ex. 21** (p.91) : f définie sur ℝ₊ par f(x) = x·∛x, courbe C dans un repère orthonormé.
  1. dérivabilité de f à droite en 0 ; 2.a. f dérivable sur ℝ*₊ et f′(x) = (4/3)·∛x ; 3. variations de
     f ; 4. tangente à C au point d'abscisse 1, tracer C ; 5.a. f réalise une bijection de ℝ₊ sur ℝ₊ (h =
     f⁻¹) ; b. h dérivable en 1, calculer h′(1) ; c. abscisses des points d'intersection de Δ : y = x et
     de C ; d. tracer la courbe de h.
- **Ex. 22** (p.92) : f : x ↦ ⁴√(x² − 1), C_f dans un repère orthonormé. 1. vérifier que f est paire ;
  2.a. pour tout x ≥ 1, f(x) = √x·⁴√(1 − 1/x²) ; b. en déduire lim_{x→+∞} f(x) et lim_{x→+∞} f(x)/x ;
  3.a. dérivabilité de f à droite en 1 ; b. f dérivable sur ]1, +∞[, calculer f′(x) ; c. variations de f ;
  4.a. Δ : y = x, position relative de C_f et Δ ; b. tracer C_f ; 5.a. f réalise une bijection de
  [1, +∞[ sur ℝ₊ ; b. f⁻¹ dérivable sur ℝ*₊ ; c. tracer la courbe C′ de f⁻¹.
- **Ex. 23** (p.92) : A/ f définie sur ℝ₊ par f(x) = ∛x − x/3 + 3, C_f dans un repère orthonormé.
  1.a. pour tout réel x > 0, f(x) = x(1/∛(x²) − 1/3) + 3 ; b. calculer lim_{x→+∞} f(x) et
  lim_{x→+∞} f(x)/x ; c. nature de la branche infinie de C_f ; 2.a. dérivabilité de f à droite en 0 ;
  b. f dérivable sur ℝ*₊, calculer f′(x) ; c. variations de f ; d. l'équation f(x) = 0 admet une unique
  solution α dans ℝ*₊, valeur approchée de α à 10⁻¹ près ; e. tracer C_f.
- **Ex. 24** (p.92–93) : A/ pour tout entier naturel non nul n, fₙ définie sur ℝ par fₙ(x) = x²ⁿ⁺¹ +
  3x − 2, courbe Cₙ. 1.a. tableau de variation de fₙ ; b. I(0, −2) centre de symétrie de Cₙ ; c. point
  d'inflexion de Cₙ ; 2.a. position relative de Cₙ et Cₙ₊₁ ; b. toutes les courbes passent par trois
  points fixes I, A, B à déterminer ; 3.a. fₙ bijection de ℝ sur ℝ ; b. dérivabilité de fₙ⁻¹ sur ℝ,
  calculer (fₙ⁻¹)′(−6), (fₙ⁻¹)′(−2), (fₙ⁻¹)′(2) ; 4.a. fₙ(x) = 0 admet une unique solution xₙ avec
  0 < xₙ < 2/3 ; b. xₙ = (2 − xₙ²ⁿ⁺¹)/3 ; c. 0 ≤ xₙ²ⁿ⁺¹ ≤ (2/3)²ⁿ⁺¹ ; d. lim_{n→+∞} xₙ²ⁿ⁺¹ puis
  lim_{n→+∞} xₙ. B/ n = 1, f = f₁, α = x₁. 1. φ définie sur [0, 2/3] par φ(x) = x − f(x)/f′(x) —
  a. φ([0, 2/3]) ⊂ [0, 2/3] ; b. φ(x) − α = (x − α)²·(2x + α)/(3(x² + 1)) ; c. ((2x + α)|x − α|)/(3(x² +
  1)) ≤ 2/3 ; d. |φ(x) − α| ≤ (2/3)|x − α| ; 2. suite (uₙ) : u₀ = 0, uₙ₊₁ = φ(uₙ) — a. 0 ≤ uₙ ≤ 2/3 ;
  b. |uₙ₊₁ − α| ≤ (2/3)|uₙ − α| ; c. (uₙ) converge vers α et α = ∛(√2 + 1) − ∛(√2 − 1).
- **Ex. 25** (p.93) : A/ f définie sur [0, 1[ par f(x) = √(x³/(1 − x)), courbe C₁ dans un repère
  orthonormé. 1.a. dérivabilité de f à droite en 0 ; b. variations de f ; c. tangente T à C₁ au point
  d'abscisse 1/2 ; d. tracer C₁ et T ; 2. tracer C₂ courbe de (−f) ; 3. C = C₁ ∪ C₂ a pour équation
  cartésienne x(x² + y²) − y² = 0. B/ A(1, 0), 𝒞 cercle de diamètre [OA], Δ tangente à 𝒞 en A ; droite D
  passant par O recoupe 𝒞 en N et Δ en Q, M tel que OM⃗ = NQ⃗, Γ l'ensemble des M. 1. équation
  cartésienne de Δ et 𝒞 ; 2. m coefficient directeur de D, équation cartésienne de D ; 3.a. N a pour
  coordonnées (1/(1 + m²), m/(1 + m²)) ; b. M a pour coordonnées (m²/(1 + m²), m³/(1 + m²)) ; c. vérifier
  que M appartient à C ; 4. M(x, y) point de C — a. si x = 0 alors M ∈ Γ ; b. x ≠ 0, m = y/x : exprimer
  x et y en fonction de m, M ∈ Γ ; c. montrer que Γ = C. C/ t réel strictement positif, D_t : y = tx ;
  D_t coupe Γ en M et Δ en Q, (AM) coupe l'axe des ordonnées en P. 1.a. P a pour coordonnées (0, t³) ;
  b. vérifier que AQ = t ; 2. construction d'un segment de longueur ∛t en utilisant la courbe Γ.
- **Ex. 26** (p.93) : A/ f définie sur [0, 1] par f(x) = sin((π/2)x). 1.a. f réalise une bijection de
  [0, 1] sur [0, 1] (f⁻¹) ; b. calculer f⁻¹(1/2) et f⁻¹(√2/2) ; 2.a. f⁻¹ dérivable sur [0, 1[ ;
  b. calculer (f⁻¹)′(1/2) ; c. pour tout x de [0, 1[, (f⁻¹)′(x) = 2/(π√(1 − x²)) ; 3. tracer C_f et
  C_{f⁻¹} dans un repère orthonormé.
- **Ex. 27** (p.94) : A/ f définie sur ℝ₊ par f(x) = (−1 + √(1 + x²))/x si x > 0, f(0) = 0, C_f dans un
  repère orthonormé. 1.a. f continue à droite en 0 ; b. f dérivable à droite en 0 ; c. position de C_f
  par rapport à sa demi-tangente au point d'abscisse 0 ; d. variations de f ; e. nature de la branche
  infinie de C_f au voisinage de +∞, construire C_f ; 2.a. f réalise une bijection de ℝ₊ sur un
  intervalle J à déterminer ; b. déterminer f⁻¹(x) pour x ∈ J ; c. construire la courbe C′ de f⁻¹.
  B/ g restriction de f à [0, 1] ; (uₙ) : u₀ = 1, uₙ₊₁ = g(uₙ) — 1.a. 0 < uₙ ≤ 1 ; b. g(x) = x/(1 +
  √(x² + 1)) sur ]0, 1], uₙ₊₁ ≤ (1/2)uₙ ; c. uₙ ≤ 1/2ⁿ, (uₙ) convergente ; 2.a. uₙ = 2uₙ₊₁/(1 −
  (uₙ₊₁)²) ; b. en déduire uₙ = tan(π/2ⁿ⁺²) ; 3. (vₙ) : vₙ = 2ⁿ·uₙ, montrer que (vₙ) converge et
  calculer sa limite.
- **Ex. 28** (p.95) : A/ f définie sur I = [−π/4, π/2[ par f(x) = √(1 + tan x), C_f dans un repère
  orthonormé. 1.a. f dérivable sur ]−π/4, π/2[, calculer f′(x) ; b. dérivabilité de f à droite en −π/4
  et interprétation ; c. tableau de variation de f, construire C_f ; 2.a. f réalise une bijection de
  [−π/4, π/2[ sur un intervalle J à préciser (g = f⁻¹) ; b. calculer g(0), g(1), g(√2) ; c. construire
  C_g ; 3. g dérivable sur J et g′(x) = 2x/(x⁴ − 2x² + 2) ; 4. (uₙ) : uₙ = (1/(n + 1))·Σ_{k=n}^{2n} g(k)
  — a. g(n) ≤ uₙ ≤ g(2n) ; b. (uₙ) convergente, déterminer sa limite. B/ h définie sur ℝ₊ par
  h(x) = (1/2)·g(√(1 + 1/x)) si x > 0, h(0) = π/4. 1.a. h continue sur ℝ₊ ; b. h dérivable sur ℝ*₊ et
  h′(x) = −1/(2(x² + 1)) ; 2.a. pour x ∈ ℝ*₊, il existe un réel c ∈ ]0, x[ tel que h(x) − π/4 =
  −x/(2(c² + 1)) ; b. h dérivable à droite en 0 et h′_d(0) = −1/2 ; c. tableau de variation de h ;
  3.a. l'équation h(x) = x admet dans ℝ₊ une solution unique α avec α ∈ ]0, 1[ ; b. pour tout réel
  x ∈ ℝ₊, |h′(x)| ≤ 1/2 ; 4. (vₙ) : v₀ ∈ ℝ₊\{α}, vₙ₊₁ = h(vₙ) — a. pour tout n, |vₙ₊₁ − α| ≤
  (1/2)|vₙ − α| ; b. (vₙ) convergente, donner sa limite.

### Bornes de scope observées (chapitre 4)

- ✅ INCLUS : notion de bijection d'un intervalle I sur f(I) (définition par unicité de la solution de
  f(x) = y ; théorème « strictement monotone ⇒ bijection ») ; fonction réciproque f⁻¹, relations
  f⁻¹∘f = id_I, f∘f⁻¹ = id_{f(I)} ; représentation graphique de f⁻¹ (symétrie par rapport à Δ : y = x
  en repère orthonormé) ; réciproque d'une fonction continue strictement monotone (continuité admise,
  même sens de variation) ; dérivabilité de la réciproque (théorème en un point (f⁻¹)′(b) = 1/f′(a) +
  corollaire sur f(I), valable pour les dérivées à droite/à gauche) ; fonction racine nᵉᵐᵉ x ↦ ⁿ√x
  (n ≥ 2) comme réciproque de x ↦ xⁿ sur ℝ₊, notation ⁿ√x, opérations sur les radicaux, continuité sur
  [0, +∞[ et dérivabilité sur ]0, +∞[ avec f′(x) = 1/(n·ⁿ√(xⁿ⁻¹)) ; fonction composée x ↦ ⁿ√(u(x)) et
  sa dérivée ; applications aux suites récurrentes (inégalité des accroissements finis) et à des études
  de fonctions complètes.
- ⛔ NON traité dans ce chapitre : fonctions Arcsin/Arccos/Arctan nommées comme telles (les
  réciproques de sin, cos, tan sont manipulées via f⁻¹ dans les activités/exercices, sans notation
  Arc) ; puissances à exposant rationnel/réel notées x^(p/q) (seule la notation radicale ⁿ√ est
  employée) ; primitives et intégrales (chapitres 5–6) ; fonctions ln/exp (chapitres 7–8).

## 2.5 Chapitre 5 — Primitives (manuel 222445, p.96–108)

**Page de garde (p.96)** — Titre : « Primitives », Chapitre 5. Citation liminaire de Lagrange
(1797) : « Nous appellerons la fonction fx, fonction primitive, par rapport aux fonctions f'x,
f''x, &c.qui en dérivent, et nous appellerons celles-ci, fonctions dérivées, par rapport à
celle-là » (référence donnée : « Cité dans E. Haier [sic] et al, _L'analyse au fil de l'histoire_,
2000 » — même coquille source pour Ernst Hairer qu'au chapitre 1). Le chapitre est structuré en
3 parties (I à III), suivies d'un QCM / Vrai-Faux, puis d'une rubrique « Exercices et problèmes ».

### Cours — Activités

**I. Définition** (p.97)

- **Activité 1** (p.97) : f et F définies sur ℝ par f(x) = 3x² + 4x − 1 et F(x) = x³ + 2x² − x + 2.
  Vérifier que F′ = f. Déterminer une fonction G dérivable sur ℝ et distincte de F telle que G′ = f.
  (Encadré : définition d'une primitive.)
- **Activité 2** (p.97) : dans chacun des cas, vérifier que F est une primitive de f sur l'intervalle
  I. 1. F(x) = 1/x ; f(x) = −1/x² ; I = [1, +∞[. 2. F(x) = x² ; f(x) = 2x ; I = ℝ. 3. F(x) = tan x ; f(x) = 1/cos²x ; I = ]−π/2, π/2[. (Suivie du théorème admis d'existence.)
- **Activité 3** (p.97–98) : dans le plan muni d'un repère orthogonal (O, i⃗, j⃗), on a représenté la
  courbe C_F de la fonction F définie sur [0, 3] par F(x) = x³ − x² − 4x. Les courbes C₁, C₂ sont les
  images respectives de C_F par des translations de vecteurs colinéaires à j⃗ ; G₁, G₂ désignent les
  fonctions de courbes respectives C₁, C₂. 1. déterminer la dérivée f de F ; que représente F pour f ? 2. déterminer G₁, G₂ ; 3. soit H une primitive de f sur [0, 3] : justifier que la courbe de H est
  l'image de celle de F par une translation. (Encadrés : théorème « F − G constante » + démonstration,
  corollaire « unique primitive telle que F(x₀) = y₀ » + démonstration.)
- **Activité 4** (p.98) : f, g, h définies sur ]0, +∞[ par f(x) = 1/√x + 2/(x + 2)² ;
  g : x ↦ sin x + cos x ; h : x ↦ sin x − cos x. Identifier parmi les fonctions suivantes celles qui
  sont des primitives sur ]0, +∞[ de l'une des fonctions précédentes : F₁ : x ↦ 2√x − 2/(x + 2) − 4 ;
  F₂ : x ↦ π − sin x − cos x ; F₃ : x ↦ −sin x − cos x − 1 ; F₄ : x ↦ sin x − cos x + π ;
  F₅ : x ↦ sin x − cos x.
- **Activité 5** (p.98) : F et f définies sur ]0, +∞[ par F(x) = (2/3)x√x − (1/2)x² et f(x) = √x − x.
  1. montrer que F est une primitive de f sur ]0, +∞[ ; 2. déterminer la primitive G de f sur ]0, +∞[
     telle que G(1) = 2.

**II. Primitives des fonctions usuelles et opérations** (p.99) — table des primitives usuelles (voir
« Résultats à retenir ») + théorème de linéarité.

- **Activité 1** (p.99–100) : déterminer, dans chaque cas, une primitive de f sur l'intervalle I.
  1. f : x ↦ −2x² + 3x, I = ℝ. 2. f : x ↦ −3/x² + 2/√x, I = ]0, +∞[. 3. f : x ↦ −2 cos x + 5 sin x,
     I = ℝ. 4. f : x ↦ cos(−2x) + sin(5x), I = ℝ. 5. f : x ↦ tan²(x), I = ]−π/2, π/2[.
  2. f : x ↦ 2/x³ − 3/x⁴, I = [−3, −1].
- **Activité 2** (p.100) : la quantité d'une substance chimique produite au cours des dix premières
  secondes d'une expérience a été de 12 g. Au bout de t secondes, le taux de production instantané
  (en g/s) a été de Q′(t) = 40/t² + 200/t³, t ≥ 10. 1. déterminer la fonction Q qui à tout t ≥ 10
  associe la quantité Q(t) produite au bout de t secondes ; 2. tracer dans un repère la courbe de Q ; 3. peut-on avoir 20 g de quantité produite ? Pourquoi ?

**III. Calcul de primitives** (p.100) — table des primitives par opérations (voir « Résultats à
retenir »).

- **Activité 1** (p.101) : vérifier dans chaque cas que f possède des primitives sur I et déterminer
  sa primitive F telle que F(x₀) = y₀. 1. f : x ↦ (2x − 1)(x² − x + 3), I = ℝ, x₀ = 1 et y₀ = 2. 2. f : x ↦ (6x − 1)/(3x² − x)², I = ]1, +∞[, x₀ = 2 et y₀ = 0. 3. f : x ↦ tan³x/cos²x,
  I = ]−π/2, π/2[, x₀ = −π/4 et y₀ = −1. 4. f : x ↦ 2x√x + (x² + 1)/(2√x), I = ]0, +∞[, x₀ = 1 et
  y₀ = −1. 5. f : x ↦ √(2 − x), I = ]−∞, 2], x₀ = 1 et y₀ = 0.
- **Activité 2** (p.101) : un physicien étudie le mouvement d'une particule. La vitesse initiale est de
  3 m/s et t secondes après le début, son accélération (en cm/s²) est a(t) = 1 − 1/(2(√t + 1)³).
  1. déterminer la vitesse de la particule t secondes après le début ; 2. déterminer la distance
     parcourue t secondes après le début.
- **Activité 3** (p.101) : f définie sur ]2, +∞[ par f(x) = (2x³ − 11x² + 20x − 10)/(x − 2)².
  1. déterminer les réels a, b et c tels que f(x) = ax + b + c/(x − 2)² ; 2. en déduire une primitive
     de f sur ]2, +∞[.
- **Activité 4** (p.101) : 1. f(x) = sin²x — utiliser l'égalité sin²x = (1 − cos 2x)/2 pour déterminer
  une primitive de f sur ℝ. 2. g(x) = sin³x — utiliser l'égalité sin³x = sin x(1 − cos²x) pour
  déterminer une primitive de g sur ℝ. 3. déterminer une primitive sur ℝ de x ↦ cos²x et une primitive
  sur ℝ de x ↦ cos³x.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Définition — primitive** (p.97) — « Soit f et F deux fonctions définies sur un intervalle I. On
> dit que F est une primitive de f sur I lorsque F est dérivable sur I et F′(x) = f(x), pour tout x
> de I. »

> **Théorème (admis) — existence** (p.97) — « Toute fonction continue sur un intervalle I admet au
> moins une primitive sur I. »

> **Théorème — deux primitives diffèrent d'une constante** (p.98) — « Soit f une fonction continue sur
> un intervalle I. Si F et G sont deux primitives de f sur I, alors la fonction F − G est constante sur
> I. » (Démonstration : F′(x) − G′(x) = 0 pour tout x de I, donc F − G est constante sur I.)

> **Corollaire — primitive vérifiant une condition initiale** (p.98) — « Soit f une fonction continue
> sur un intervalle I. Soit x₀ un réel de I et y₀ un réel. Alors il existe une unique primitive F de f
> sur I telle que F(x₀) = y₀. » (Démonstration : unicité par le théorème précédent ; si G est une
> primitive de f sur I, la fonction F définie par F(x) = G(x) − G(x₀) + y₀ est la primitive de f qui
> prend la valeur y₀ en x₀.)

> **Table — primitives des fonctions usuelles** (p.99) — « Dans le tableau ci-dessous F désigne une
> primitive de la fonction f sur l'intervalle I et a, c, ω et φ des réels avec ω ≠ 0. » Lignes
> (f | I | F) : x ↦ a | ℝ | x ↦ ax + c ; x ↦ xⁿ, n ∈ ℕ* | ℝ | x ↦ x^(n+1)/(n+1) + c ;
> x ↦ 1/xⁿ, n ∈ ℕ\{0,1} | ]0, +∞[ (ou ]−∞, 0[) | x ↦ x^(−n+1)/(−n+1) + c ;
> x ↦ √x | [0, +∞[ | x ↦ (2/3)x√x + c ; x ↦ 1/√x | ]0, +∞[ | x ↦ 2√x + c ;
> x ↦ cos x | ℝ | x ↦ sin x + c ; x ↦ sin x | ℝ | x ↦ −cos x + c ;
> x ↦ cos(ωx + φ) | ℝ | x ↦ (1/ω) sin(ωx + φ) + c ;
> x ↦ sin(ωx + φ) | ℝ | x ↦ −(1/ω) cos(ωx + φ) + c ;
> x ↦ 1 + tan²x | ]−π/2, π/2[ | x ↦ tan x + c.

> **Théorème — linéarité** (p.99) — « Soit F et G deux primitives respectives de deux fonctions f et g
> sur un intervalle I. • La fonction F + G est une primitive sur I de f + g. • Soit λ un réel. La
> fonction λF est une primitive sur I de λf. »

> **Table — calcul de primitives (opérations)** (p.100) — « Dans le tableau suivant F désigne une
> primitive de la fonction f sur un intervalle I et u et v désignent deux fonctions dérivables sur I. »
> Lignes (f | Condition | F) : u′uⁿ, n entier naturel non nul | (aucune) | u^(n+1)/(n+1) ;
> u′v + v′u | (aucune) | u.v ; u′/uⁿ, n ∈ ℕ\{0,1} | u ne s'annule pas sur I | u^(−n+1)/(−n+1) ;
> (u′v − v′u)/v² | v ne s'annule pas sur I | u/v ; u′/√u | u strictement positive sur I | 2√u ;
> u′√u | u positive sur I | (2/3)u√u ; u′·ⁿ√(u^(1−n)), n ∈ ℕ*\{1} | u est strictement positive sur I |
> n·ⁿ√u ; u′(w′∘u) | w une fonction dérivable sur u(I) | w∘u.

### Cours — Exercice résolu (p.102–103)

Exercice résolu, solution intégrale imprimée. Énoncé : f définie sur [0, +∞[ par
f(x) = (1 + x²)/(1 + x + x²), C_f sa courbe représentative dans un repère orthonormé (O, i⃗, j⃗).
1.a. étudier f et tracer C_f ; b. en déduire que pour tout réel t de [0, +∞[, 2/3 ≤ f(t) ≤ 1. 2. F la primitive de f sur [0, +∞[ qui s'annule en 0 — a. montrer que pour tout réel x de [0, +∞[,
(2/3)x ≤ F(x) ≤ x ; b. en déduire la limite de F en +∞ ; c. dresser le tableau de variation de F. 3. G définie sur [0, +∞[ par G(x) = F(x²) — a. montrer que G est dérivable à droite en 0 ; b. étudier
les variations de G sur [0, +∞[ ; c. donner l'allure de la courbe de G dans un autre repère
orthonormé (O, u⃗, v⃗). (Solution : f′(x) = (x² − 1)/(1 + x + x²)² ; tableau de variation de f
(décroissante de 1 à 2/3 sur [0, 1], croissante de 2/3 à 1 sur [1, +∞[) et courbe de f avec
asymptote y = 1 ; encadrement par le théorème des inégalités des accroissements finis sur [0, x] ;
lim_{x→+∞} F(x) = +∞ ; G = F∘u avec u : x ↦ x², G′_d(0) = 0, G′(x) = f(x²)·2x, branche parabolique
de direction (O, j⃗), courbe C_G.)

### QCM (p.104) — « Cocher la réponse exacte. » (réponses non fournies)

1. La fonction x ↦ tan x est la primitive sur ]−π/2, π/2[ qui s'annule en 0 de la fonction
   (☐ x ↦ 1 + tan²x / ☐ x ↦ 1/sin²x / ☐ x ↦ sin²x).
2. La primitive de la fonction x ↦ sin x sur ℝ, qui s'annule en 0, est la fonction
   (☐ x ↦ 1 − cos x / ☐ x ↦ −cos x / ☐ x ↦ cos x − 1).
3. La primitive qui s'annule en 0 de la fonction x ↦ 1 + cos x sur ℝ est (☐ paire / ☐ impaire /
   ☐ ni paire ni impaire).
4. La primitive sur ]−1, +∞[ de la fonction x ↦ 1/(1 − x)³, qui s'annule en 0, est
   (☐ x ↦ 1/(2(1 − x)²) − 1/2 / ☐ x ↦ 1/(4(1 − x)⁴) − 1/4 / ☐ x ↦ −1/(2(1 − x)²) + 1/2).
5. La primitive sur ℝ de la fonction x ↦ x cos x, qui prend la valeur 1 en 0, est
   (☐ x ↦ (x²/2) sin x + 1 / ☐ x ↦ x sin x + cos x / ☐ x ↦ cos x − x sin x).

### Vrai ou faux (p.104) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. La primitive sur ℝ d'une fonction continue est une fonction continue sur ℝ.
2. La fonction x ↦ { x² sin(1/x) si x ∈ ℝ*, 0 si x = 0 } est une primitive sur ℝ de la fonction
   x ↦ { −cos(1/x) + 2x sin(1/x) si x ∈ ℝ*, 0 si x = 0 }.
3. Si F est une primitive d'une fonction f sur ℝ et G est une primitive d'une fonction g sur ℝ, alors
   F·G est une primitive de f·g sur ℝ.
4. Si F est une primitive d'une fonction f sur ℝ, alors la fonction x ↦ F(2x) est une primitive de la
   fonction x ↦ f(2x) sur ℝ.
5. Si deux primitives d'une fonction f sur un intervalle I coïncident en un réel x₀ de I, alors elles
   sont égales.

### Exercices et problèmes (p.105–108) — 22 exercices

- **Ex. 1** (p.105) : déterminer les primitives F sur I de chacune des fonctions. 1. f : x ↦ −5x⁴ + 2x
  − 3, I = ℝ. 2. f : x ↦ x + 2 − 3/x², I = ]−∞, 0[. 3. f : x ↦ 3x/(3x² + 2)², I = ℝ. 4. f : x ↦ (−x + 3)⁶, I = ℝ. 5. f : x ↦ (x − 1)(x² − 2x + 7)⁴, I = ℝ. 6. f : x ↦ 1/√(−4x + 3),
  I = ]−∞, 3/4[. 7. f : x ↦ cos(√x)/√x, I = ]0, +∞[. 8. f : x ↦ (x² + 1)/(x³ + 3x)⁵, I = ]−∞, −√3[. 9. f : x ↦ sin(2x + 1) cos⁴(2x + 1), I = ℝ. 10. f : x ↦ x² sin(x³ + 1), I = ℝ. 11. f : x ↦ sin x/(cos x + 1)³, I = ]−π, π[. 12. f : x ↦ (3x² + 4x − 2)/x⁴, I = ]−∞, 0[. 13. f : x ↦ (2x − 1)/√(x² − x), I = ]1, +∞[. 14. f : x ↦ tan²x, I = ]−π/2, π/2[.
- **Ex. 2** (p.105) : on a représenté les courbes de trois fonctions g, f et h, définies et dérivables
  sur [−2, 2] (figures : C_g, C_f, C_h données). 1. on sait que f admet une primitive parmi les
  fonctions g et h sur [−2, 2] : laquelle ? justifier ; 2. on sait que h admet une primitive parmi les
  fonctions f et g sur [−2, 2] : laquelle ? justifier.
- **Ex. 3** (p.105) : déterminer une primitive sur I de chacune des fonctions. 1. f : x ↦ √(x + 1),
  I = ℝ*₊. 2. f : x ↦ x√(x² + 1), I = ℝ. 3. f : x ↦ (x − 3)√(x² − 6x), I = [6, +∞[. 4. f : x ↦ (x + 1)/√(x − 1), I = ]1, +∞[ (on pourra écrire f(x) sous la forme a√(x − 1) + b/√(x − 1),
  a ∈ ℝ et b ∈ ℝ). 5. f : x ↦ (x² + x)⁷(x + 1/2), I = ℝ. 6. f : x ↦ (1/x²)√((3 + x)/(2x)), I = ℝ*₊. 7. f : x ↦ x(x + 1)²⁰⁰⁸, I = ℝ (on pourra vérifier que f(x) = (x + 1)²⁰⁰⁹ − (x + 1)²⁰⁰⁸).
- **Ex. 4** (p.105–106) : dans chacun des cas, vérifier que f possède des primitives sur I et déterminer
  sa primitive F vérifiant F(x₀) = y₀. 1. f(x) = tan x + tan³x, I = [0, π/2[, F(π/4) = 1. 2. f(x) = cos x − cos³x, I = ℝ, F(π/2) = −1. 3. f(x) = sin x − sin³x, I = ℝ, F(−π/4) = 2. 4. f(x) = (1 + tan x)/cos²x, I = [0, π/2[, F(π/4) = 0.
- **Ex. 5** (p.106) : 1. f et g définies sur ℝ par f(x) = cos x·cos(3x) et g(x) = sin x·sin(3x).
  a. déterminer une primitive sur ℝ de chacune des fonctions f + g et f − g ; b. en déduire les
  primitives sur ℝ des fonctions f et g. 2. déterminer la primitive sur ℝ qui s'annule en π de la
  fonction h définie par h(x) = (1 + cos x) sin(4x).
- **Ex. 6** (p.106) : f définie sur ℝ par f(x) = x sin x. 1. montrer que f est deux fois dérivable sur
  ℝ et que pour tout réel x, f(x) = 2 cos x − f″(x) ; 2. en déduire la primitive de f sur ℝ qui
  s'annule en π.
- **Ex. 7** (p.106) : f définie sur ]−1, +∞[ par f(x) = (x² + 2)/(x + 1)⁴. On se propose de déterminer
  des réels a, b, c et d tels que pour tout x de ]−1, +∞[, f(x) = a/(x + 1) + b/(x + 1)² + c/(x + 1)³
  - d/(x + 1)⁴. 1.a. calculer lim_{x→(−1)⁺} (x + 1)⁴ f(x) et lim_{x→+∞} (x + 1) f(x) ; b. en déduire que
    d = 3 et a = 0. 2.a. vérifier que pour tout réel x de ]−1, +∞[, (x − 1 − c)/(x + 1)³ = b/(x + 1)² ;
    b. en déduire les valeurs des réels b et c. 3. déterminer la primitive de f sur ]−1, +∞[ égale à 2 en 0.
- **Ex. 8** (p.106) : f définie sur ℝ\{2} par f(x) = (2x + 1)/(x − 2)³. 1. déterminer les réels a et b
  tels que pour tout x de ℝ\{2}, f(x) = a/(x − 2)² + b/(x − 2)³ ; 2. en déduire une primitive de f sur
  ]−∞, 2[.
- **Ex. 9** (p.106) : f définie sur ]−1, 1[ par f(x) = 1/√(1 − x²). Soit F la primitive de f sur
  ]−1, 1[ qui s'annule en 0, et g la fonction définie sur ]−π/2, π/2[ par g(x) = F(sin x). 1. montrer que
  g est dérivable sur ]−π/2, π/2[ et déterminer sa fonction dérivée ; 2. en déduire que pour tout
  x ∈ ]−π/2, π/2[, g(x) = x ; 3. calculer F(√2/2), F(1/2) et F(−√3/2).
- **Ex. 10** (p.106) : f définie sur [0, 1] par f(x) = √(1 − x²). Soit F la primitive de f sur [0, 1]
  qui s'annule en 0, et g la fonction définie sur [0, π/2] par g(x) = F(cos x). 1. montrer que g est
  dérivable sur [0, π/2] et déterminer sa fonction dérivée ; 2. en déduire que pour tout x ∈ [0, π/2],
  g(x) = −(1/2)x + (1/4) sin(2x) + π/4 ; 3. calculer F(1) et F(1/√2).
- **Ex. 11** (p.106) : déterminer toutes les fonctions deux fois dérivable [sic] sur I telles que :
  1. f″(x) = 0, I = ℝ. 2. f″(x) = sin x, I = ℝ.
- **Ex. 12** (p.107) : 1. f définie sur ℝ par f(x) = |x| — a. montrer que f admet au moins une primitive
  sur ℝ ; b. déterminer la primitive F de f sur ℝ qui prend la valeur 0 en 4. 2. g définie sur ℝ par
  g(x) = |x| + |x − 1| — a. montrer que g admet au moins une primitive sur ℝ ; b. déterminer une
  primitive G de g sur ℝ.
- **Ex. 13** (p.107) : f définie sur ℝ par f(x) = sin³(x) + sin⁵(x). Déterminer une primitive de f sur ℝ.
- **Ex. 14** (p.107) : un mobile sur un axe subit une accélération a(t) dépendant du temps t (en
  secondes) tel que a(t) = 1 − 1/(t + 1)², t ∈ [0, 10]. À l'instant t = 0, le mobile est placé à
  l'origine de l'axe avec une vitesse nulle. 1. déterminer l'expression de sa vitesse instantanée
  v(t) ; 2. déterminer sa vitesse et sa position pour t = 10.
- **Ex. 15** (p.107) : f définie sur [−2, 2] par f(x) = √(4 − x²). 1.a. montrer que f admet au moins une
  primitive sur [−2, 2] ; b. soit F la primitive de f sur [−2, 2] qui s'annule en 0 : étudier la parité
  de F. 2. G définie sur [0, π] par G(x) = F(2 cos x) et C sa courbe représentative dans un repère
  orthonormé (O, i⃗, j⃗) — a. montrer que le point I(π/2, 0) est un centre de symétrie de C ; b. calculer
  G′(x) et en déduire que pour tout x de [0, π], G(x) = π − 2x + sin(2x) ; c. calculer alors F(1), F(2)
  et F(√2).
- **Ex. 16** (p.107) : u définie sur ℝ par u(x) = x + √(x² + 1). 1. exprimer √(x² + 1) à l'aide de u(x)
  et u′(x) ; 2. déterminer des primitives pour chacune des fonctions f : x ↦ 1/((x + √(x² + 1))√(x² + 1))
  et g : x ↦ (x + √(x² + 1))²/√(x² + 1).
- **Ex. 17** (p.107) : les fonctions f : x ↦ x cos x et g : x ↦ x sin x. 1. en calculant f′(x) + g(x),
  trouver une primitive G de g sur ℝ ; 2. en procédant de même, déterminer une primitive F de f sur ℝ.
- **Ex. 18** (p.107) : pour tout entier naturel n supérieur à 2, Pₙ définie sur ℝ par
  Pₙ(x) = 1 + 2x + 3x² + … + n x^(n−1). 1. déterminer la primitive Fₙ de Pₙ sur ℝ égale à 1 en 0 ; 2. déduire une autre expression de Pₙ(x).
- **Ex. 19** (p.107–108) : 1. g définie sur [0, π] par g(x) = x sin x + cos x − 1. a. étudier les
  variations de g sur [0, π] ; b. montrer que l'équation g(x) = 0 admet une solution α appartenant à
  ]2π/3, π[ ; préciser le signe de g(x). 2. f définie par f(x) = { (1 − cos x)/x si x ∈ ]0, π], 0 si
  x = 0 } — a. étudier la continuité et la dérivabilité de f en 0 ; b. étudier les variations de f sur
  [0, π] ; c. vérifier que f(α) = sin α. 3. on donne α ≈ 2,34 et f(α) ≈ 0,72 : construire la courbe
  représentative de f dans un repère orthonormé (O, i⃗, j⃗). 4. déduire de ce qui précède que la
  restriction de f à [α, π] est une bijection de [α, π] sur un intervalle I que l'on précisera. 5. on pose h(x) = g(x) − 2 cos x, x ∈ [0, π] : montrer que h admet des primitives sur [0, π] ; donner
  la primitive H de h sur [0, π] qui prend la valeur 1 en 0.
- **Ex. 20** (p.108) : pour tout réel x, on pose φ(x) = 1/(1 + x²) et on désigne par G la primitive de
  φ sur ℝ qui s'annule en 0. 1. montrer que G est une fonction impaire. 2.a. on pose pour tout x de ℝ*,
  ψ(x) = G(x) + G(1/x) : montrer que ψ est constante sur chacun des intervalles ]−∞, 0[ et ]0, +∞[ ;
  en déduire que lim_{x→+∞} Ψ(x) = 2G(1) ; b. on pose u(t) = G(tan t), t ∈ ]−π/2, π/2[ : calculer u′(t)
  et en déduire u(t). 3. déterminer G(1) et en déduire lim_{x→+∞} ψ(x) et lim_{x→+∞} G(x). 4. construire la courbe représentative de G dans un repère orthonormé.
- **Ex. 21** (p.108) : f définie sur [0, π] par f(x) = √(1 + cos x). 1.a. montrer que f est une
  bijection de [0, π] sur [0, √2] ; b. montrer que la fonction f⁻¹ est dérivable sur ]0, √2[ et
  expliciter (f⁻¹)′(x). 2. g définie sur ]−√2, √2[ par g(x) = 2/√(2 − x²) : on note G la primitive de g
  sur ]−√2, √2[ telle que G(0) = 0. a. calculer la dérivée de la fonction x ↦ G(x) + G(−x) ; en déduire
  que G est impaire ; b. montrer que pour tout x de [0, √2[, G(x) = π − f⁻¹(x) ; en déduire G(1).
- **Ex. 22** (p.108) : f une fonction continue sur [0, 1] et dérivable sur ]0, 1[. On suppose que
  f(0) = 1, f(1) = 0 et f′(x) = −2/(π√(1 − x²)), x ∈ ]0, 1[. 1. montrer que f est une bijection de [0, 1]
  sur [0, 1]. 2.a. montrer que pour tout x de [0, π/2], f(cos x) = (2/π)x ; b. en déduire f⁻¹(x) pour
  tout x de [0, 1]. 3. on pose pour tout x de [0, π/2], h(x) = f(cos x) + f(sin x). a. montrer que h est
  dérivable sur ]0, π/2[ et calculer h′(x) ; b. en déduire que pour tout x de [0, π/2], h(x) = 1. 4. pour tout n de ℕ*, on pose φₙ(x) = cos((π/2)x) − xⁿ, x ∈ [0, 1]. a. montrer que pour tout n de ℕ*,
  il existe un unique réel aₙ ∈ ]0, 1[ tel que φₙ(aₙ) = 0 ; b. montrer que pour tout x de ]0, 1[, si
  n > p alors φₙ(x) > φₚ(x) ; c. en déduire que la suite (aₙ) est strictement croissante et convergente.

### Bornes de scope observées (chapitre 5)

- ✅ INCLUS : définition d'une primitive (F dérivable sur I, F′ = f) ; existence (toute fonction
  continue sur un intervalle admet au moins une primitive — théorème admis) ; unicité à une constante
  près (deux primitives diffèrent d'une constante « + c ») et unique primitive vérifiant une condition
  initiale F(x₀) = y₀ ; table des primitives des fonctions usuelles (a, xⁿ, 1/xⁿ, √x, 1/√x, cos, sin,
  cos(ωx + φ), sin(ωx + φ), 1 + tan²x) ; linéarité (F + G primitive de f + g, λF primitive de λf) ;
  table de calcul par opérations (u′uⁿ, u′v + v′u, u′/uⁿ, (u′v − v′u)/v², u′/√u, u′√u,
  u′·ⁿ√(u^(1−n)), u′(w′∘u)) ; techniques de calcul (décomposition en éléments simples, changement
  d'écriture, linéarisation trigonométrique sin²/sin³/cos²/cos³) ; applications en physique
  (taux de production → quantité, accélération → vitesse → position) ; ponts avec la bijection/dérivée
  de la réciproque (ch.4) et les suites récurrentes.
- ⛔ NON traité dans ce chapitre : notion d'intégrale et primitive comme aire, notation ∫ (chapitre 6) ;
  intégration par parties nommée comme telle (seule la table « u′v + v′u ↦ u.v » est fournie, sans le
  procédé formalisé) ; fonctions ln/exp et leurs primitives (chapitres 7–8) ; équations différentielles
  (chapitre 9).

## 2.6 Chapitre 6 — Intégrales (manuel 222445, p.109–136)

**Page de garde (p.109)** — Titre : « Intégrales », Chapitre 6. Citation liminaire sur Thabit
Ibn Qurra (mathématicien arabe du Xe siècle) : la parabole qu'il considère est définie par une
propriété « que nous traduisons aujourd'hui par l'équation y² = px » et la quadrature de la parabole
est équivalente au calcul de l'intégrale ∫₀ᵃ √(px) ; le calcul immédiat aurait exigé la sommation
de √1 + √2 + … + √n, difficulté qu'Ibn Qurra étudie « en recourant à un artifice astucieux »
(référence donnée : « AP. Youachkevitch, _Les mathématiques arabes_, 1976 »). Le chapitre est
structuré en 7 parties (I à VII), suivies d'un QCM / Vrai-Faux, puis d'une rubrique « Exercices et
problèmes ».

### Cours — Activités

**I. Définition**

**I.1 Intégrale d'une fonction continue et positive** (p.110) — encadré liminaire : dans un repère
orthogonal (O, i⃗, j⃗), l'**unité d'aire** (u.a) est l'aire du rectangle de dimensions ‖i⃗‖ et ‖j⃗‖.

- **Activité 1** (p.110) : g par morceaux (g(x) = −x − 1 si x < −2 ; 1 si −2 ≤ x ≤ 1 ; 3x − 2 si
  x > 1). 1. tracer la courbe de g ; 2. hachurer la partie 𝒫 limitée par l'axe des abscisses, la
  courbe de g et les droites x = −3 et x = 3.5 ; 3. calculer l'aire de 𝒫.
- **Activité 2** (p.110) : f(x) = √(1 − x²) sur [−1, 1] ; 𝒜 l'aire limitée par l'axe des abscisses,
  C_f et les droites x = −1 et x = 1. 1. représenter C_f ; 2. calculer 𝒜.
- **Activité 3** (p.110–111) : f(x) = x² sur ℝ ; pour t ∈ [1, +∞[, 𝒜(t) l'aire limitée par C_f,
  l'axe des abscisses et les droites x = 1 et x = t ; 𝒜 : t ↦ 𝒜(t). 1. 𝒜(1) ? 2. h > 0 : a. montrer
  hf(t) ≤ 𝒜(t + h) − 𝒜(t) ≤ hf(t + h) ; b. en déduire 𝒜 dérivable à droite en t et 𝒜′_d(t) = f(t). 3. 1 < t − h < t : a. hf(t − h) ≤ 𝒜(t) − 𝒜(t − h) ≤ hf(t) ; b. 𝒜 dérivable à gauche, 𝒜′_g(t) = f(t). 4. a. 𝒜(t) − 𝒜(1) = t³/3 − 1/3 ; b. aire pour x = 1 et x = 2 ? 5. F primitive de f sur [1, +∞[ :
  F(t) − F(1) = 𝒜(t) − 𝒜(1).
- **Activité 4** (p.111) : f : x ↦ x³ − x. 1. représenter la partie 𝒫 limitée par l'axe des
  abscisses, C_f et les droites x = 1 et x = 2 ; 2. calculer l'aire de 𝒫.

**I.2 Intégrale d'une fonction continue** (p.112) — Définition + vocabulaire (voir « Résultats à
retenir »).

- **Activité 1** (p.112) : calculer ∫*{1/2}^1 (x⁴ − 1)dx ; ∫₀¹ sin(πx)dx ; ∫*{−1}¹ 2x/(x² + 1)² dx.
- **Activité 2** (p.112) : f(x) = −1/x² sur ]0, +∞[. 1. représenter f ; 2. calculer l'aire limitée
  par la courbe de −f, l'axe des abscisses et x = 1, x = 2 ; 3. en déduire que l'aire limitée par la
  courbe de f, l'axe des abscisses et x = 1, x = 2 est égale à ∫₁² −f(x)dx.

**II. Propriétés algébriques de l'intégrale** (p.113) — encadré (∫ₐᵃ = 0, ∫ₐᵇ = −∫ᵦᵃ, relation de
Chasles) + démonstration (voir « Résultats à retenir »).

- **Activité 1** (p.113) : f(x) = x³ sur ℝ. 1. tracer C′ représentant |f| ; 2. a. représenter P′
  limitée par l'axe des abscisses, C′ et x = −2, x = 3 ; b. calculer l'aire de P′ ; 3. en déduire
  l'aire de P limitée par l'axe des abscisses, C et x = −2, x = 3. (Suivie de la Définition de l'aire
  via ∫ₐᵇ|f(x)|dx — voir « Résultats à retenir ».)
- **Activité 2** (p.114) : calculer l'aire limitée par l'axe, C_f et x = a, x = b pour 1. f : x ↦
  sin(2x), a = −π/3 et b = π/4 ; 2. f : x ↦ x/(x² + 1)⁴, a = −2 et b = 1.
- **Activité 3** (p.114) : calculer ∫₁² x²/(x + 1)² dx + ∫₁² (2x + 1)/(x + 1)² dx.
- **Activité 4** (p.114) : I = ∫₀^{π/2} sin²x dx et J = ∫₀^{π/2} (cos²x)/2 dx. 1. calculer I + 2J et
  2J − I ; 2. en déduire les valeurs de I et J.

**III. Intégrales et inégalités** (p.114) — Théorème de positivité + corollaires (voir « Résultats à
retenir »).

- **Activité 1** (p.115) : 1. montrer ∫*{π/6}^{π/3} dx/cos x > ∫*{π/6}^{π/3} tan x dx ; 2. montrer
  ∫₀^{1/2} (1 + x + x² + x³ + x⁴)dx < ∫₀^{1/2} dx/(1 − x).
- **Activité 2** (p.115) : f dérivable sur [−1, 4], tangentes aux points d'abscisses 0 et 3 tracées.
  1. vérifier graphiquement que pour tout x de [0, 3], x/2 ≤ f(x) ≤ (x + 1)/2 ; 2. en déduire
     9/4 ≤ ∫₀³ f(x)dx ≤ 15/4.
- **Activité 3** (p.116) : uₙ = ∫₀¹ x^{n+1}/(1 + x²) dx (n ∈ ℕ). 1. pour x de [0, 1],
  0 ≤ x^{n+1}/(1 + x²) ≤ x^{n+1} ; 2. en déduire 0 ≤ uₙ ≤ 1/(n + 2) ; 3. a. valeur approchée de u₁₀₀
  et erreur ; b. valeur approchée de u₁₀₀₀₀ et erreur.
- **Activité 4** (p.116) : C_f et C_g de f(x) = x et g(x) = x³ sur [−1/2, 1] ; aire limitée par C_f,
  C_g et x = −1/2, x = 1. 1. a. aire sous C_f (x = 0 à x = 1) ; b. aire sous C_g (x = 0 à x = 1) ;
  c. en déduire l'aire entre C_f et C_g (x = 0 à x = 1) ; 2. aire entre C_f et C_g (x = −1/2 à x = 0) ; 3. conclure. (Suivie de la Définition de l'aire entre deux courbes via ∫ₐᵇ|f(x) − g(x)|dx — voir
  « Résultats à retenir ».)
- **Activité 5** (p.116–117) : f(x) = sin x et g(x) = cos x sur [0, π/2]. 1. représenter C_f et C_g ; 2. étudier le signe de f − g ; 3. calculer l'aire entre C_f, C_g et x = 0, x = π/2.
- **Activité 6** (p.117) : f(x) = 4x² et h(x) = x/2 sur [0, +∞[ ; g(x) = 4/x² sur ]0, +∞[ ; aire de
  la partie 𝒟 limitée par les trois courbes et x = 0.5, x = 2. 1. résoudre f(x) = g(x) et g(x) = h(x) ; 2. aire entre C_f, C_h (x = 0.5 à x = 1) ; 3. aire entre C_g, C_h (x = 1 à x = 2) ; 4. en déduire
  l'aire de 𝒟.

**IV. Calculs d'intégrales**

**IV.1 Calcul au moyen d'une primitive** (p.117)

- **Activité 1** (p.117) : calculer ∫₀³ (5x⁴ − x³ − 2)dx ; ∫*{−2}^{−1} 1/t² dt ; ∫₀^{π/4} 1/cos²x dx ;
  ∫*{−1}² (3x² + 1)(x³ + x − 2)dx ; ∫₀¹ −2u/(u² + 2)³ du ; ∫_{π/2}^{π/6} cos t/sin³t dt ;
  ∫₀¹ x³/√(x⁴ + 1) dx.
- **Activité 2** (p.117) : calculer ∫₀^{π/2} sin³x dx ; ∫_{π/6}^{π/4} (1 + tan²x)/tan⁴x dx.

**IV.2 Intégration par parties** (p.118) — Théorème + démonstration (voir « Résultats à retenir »).

- **Activité** (p.118) : calculer ∫₀^{π/2} x sin x dx ; ∫₀^{π/2} x cos x dx ; ∫₀^{π/2} x² cos x dx.

**IV.3 Calcul approché d'intégrales (Méthode des rectangles)** (p.118)

- **Activité** (p.118–119) : f(x) = 1/x sur ]0, +∞[ ; A l'aire limitée par l'axe, 𝒞 et x = 1, x = 2.
  1. vérifier A = ∫₁² dx/x ; 2. rectangles r₁, R₁ : vérifier 1/2 ≤ A ≤ 1 ; 3. partage de [1, 2] en 2
     intervalles de longueur 0.5, rectangles r₁, r₂, R₁, R₂ : vérifier 7/12 ≤ A ≤ 5/6 ; 4. partage en 5
     intervalles de longueur 1/5, rectangles rᵢ, Rᵢ (1 ≤ i ≤ 5) : donner un nouvel encadrement de A.

**IV.4 Valeur moyenne et inégalité de la moyenne** (p.119) — Définition + interprétation géométrique
(voir « Résultats à retenir »).

- **Activité 1** (p.119) : f(x) = 3x − 1 sur [0, 2] ; calculer la valeur moyenne de f sur [0, 2], puis
  la comparer à f(1).
- **Activité 2** (p.119) : valeur moyenne de f(x) = cos x sur [0, π/2].
- **Activité 3** (p.119) : parabole P d'équation y = −x² + 2x ; A intersection de P avec l'axe des
  abscisses distincte de O. Déterminer la largeur du rectangle dont un côté est [OA] et dont l'aire
  égale celle de la partie D limitée par P et l'axe des abscisses. (Suivie du Théorème « Inégalité de
  la moyenne » + démonstration, et du Corollaire « il existe c tel que f̄ = f(c) » — voir « Résultats à
  retenir ».)
- **Activité 4** (p.120) : montrer 0.5 ≤ ∫₀¹ 1/(1 + x²) dx ≤ 1 et 1/2 ≤ ∫₀^{1/2} 1/√(1 − x²) dx ≤ √3/3.

**V. Calcul de volumes de solides de révolution** (p.120) — définition de la surface / du solide de
révolution + formule du volume (voir « Résultats à retenir »).

- **Activité 1** (p.121) : demi-cercle AB d'équation y = f(x), A(R, 0), B(−R, 0) ; sa rotation autour
  de (Ox) engendre la sphère de rayon R et centre O. Déterminer f(x) ; retrouver le volume de la
  sphère de centre O et rayon R.
- **Activité 2** (p.122) : solide S obtenu en faisant tourner la portion de parabole y = √x
  (0 ≤ x ≤ 4) autour de (Ox). Déterminer le volume de S.

**VI. Fonctions définies par une intégrale** (p.122) — Théorème + Conséquence (voir « Résultats à
retenir »).

- **Activité 1** (p.122) : justifier la dérivabilité de F sur I et calculer F′ pour 1. F(x) =
  ∫₁ˣ √(1 − t²) dt, I = [−1, 1] ; 2. F(x) = ∫₀ˣ 1/(1 + t²) dt, I = ℝ ; 3. F(x) = ∫₁ˣ (sin t)/t dt,
  I = ]0, +∞[ ; 4. F(x) = ∫₀ˣ dt/√(1 − t²), I = ]−1, 1[.
- **Théorème (composée)** (p.124) : F(x) = ∫ₐ^{u(x)} f(t)dt dérivable, F′(x) = f(u(x))·u′(x) (voir
  « Résultats à retenir »).
- **Activité 2** (p.124) : f(x) = ∫₀ˣ dt/√(1 − t²) sur [0, 1[. 1. f dérivable, f′ ; 2. g(x) =
  ∫₀^{sin x} dt/√(1 − t²) sur [0, π/2[ : a. g dérivable, g′ ; b. en déduire g(x) = x ; 3. calculer
  ∫₀^{1/2} dt/√(1 − t²) et ∫₀^{√3/2} dt/√(1 − t²) ; 4. a. pour x ∈ [0, 1[, unique t ∈ [0, π/2[ avec
  sin t = x ; b. montrer lim_{x→1⁻} f(x) = π/2 ; 5. représenter f.
- **Activité 3** (p.125) : f continue sur I centré en 0 ; g(x) = ∫*{−x}^x f(t)dt. 1. g dérivable,
  dérivée ; 2. f impaire : a. g(x) = 0 ; b. ∫*{−x}^0 f = −∫₀ˣ f ; 3. f paire : a. g primitive de
  t ↦ 2f(t) s'annulant en 0 ; b. ∫*{−x}^x f = 2∫₀ˣ f et ∫*{−x}^0 f = ∫₀ˣ f. (Suivie du Théorème de
  parité — voir « Résultats à retenir ».)
- **Activité 4** (p.125) : calculer ∫*{−5π}^{5π} x⁵ sin⁶(x)dx ; ∫*{−1}¹ t⁵/(t⁶ + 1) dt ;
  ∫*{−5π}^{5π} x^{1001} cos^{100}(x)dx ; ∫*{−1}¹ |t³ + t| dt.
- **Activité 5** (p.125) : f continue sur ℝ, périodique de période T ; g(x) = ∫ₓ^{x+T} f(t)dt.
  Montrer que pour tout réel x, g(x) = ∫₀ᵀ f(t)dt. (Suivie du Théorème de périodicité — voir
  « Résultats à retenir ».)
- **Activité 6** (p.126) : calculer ∫₀^{20π} |sin x| dx ; ∫_{−10π}^{10π} |cos x| dx.

**VII. Exemples de suites définies par une intégrale** (p.126)

- **Activité 1** (p.126) : I₁ = ∫₀^{π/2} x sin x dx, J₁ = ∫₀^{π/2} x cos x dx. 1. montrer I₁ = 1 et
  J₁ = π/2 − 1 ; 2. pour n ≥ 2, Iₙ = ∫₀^{π/2} xⁿ sin x dx, Jₙ = ∫₀^{π/2} xⁿ cos x dx : a. calculer I₂,
  J₂ ; b. montrer Iₙ = nJₙ₋₁ et Jₙ = (π/2)ⁿ − nIₙ₋₁ ; c. calculer I₃, J₃, I₄, J₄.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Propriété** (p.111) — « Soit f une fonction continue sur un intervalle I. Si F et G sont deux
> primitives de f sur I alors pour tous a et b de I, F(b) − F(a) = G(b) − G(a). »

> **Définition — intégrale d'une fonction continue et positive** (p.111) — « Le plan est muni d'un
> repère orthogonal. Soit f une fonction continue et positive sur un intervalle [a, b] et F une
> primitive de f sur [a, b]. L'aire (en u.a) de la partie du plan limitée par la courbe de f, l'axe
> des abscisses et les droites d'équations x = a et x = b est le réel F(b) − F(a). Le réel F(b) − F(a)
> est appelé intégrale de f de a à b et est noté ∫ₐᵇ f(x)dx. »

> **Définition — intégrale d'une fonction continue** (p.112) — « Soit f une fonction continue sur un
> intervalle I, a et b deux réels de I et F une primitive de f sur I. On appelle intégrale de f entre
> a et b le réel, noté ∫ₐᵇ f(x)dx, défini par ∫ₐᵇ f(x)dx = F(b) − F(a). »

> **Vocabulaire et notations** (p.112) — « Le réel ∫ₐᵇ f(x)dx est appelé intégrale de f sur [a, b], ou
> encore de a à b, ou encore entre a et b. Dans l'écriture ∫ₐᵇ f(x)dx, on peut remplacer la lettre x
> par n'importe quelle lettre et on peut écrire ∫ₐᵇ f(x)dx = ∫ₐᵇ f(u)du = ∫ₐᵇ f(t)dt. On dit que x est
> une variable muette. Pour toute primitive F de f, on écrit ∫ₐᵇ f(x)dx = [F(x)]ₐᵇ = F(b) − F(a).
> L'expression [F(x)]ₐᵇ se lit "F(x) pris entre a et b". »

> **Propriétés algébriques** (p.113) — « Soit f une fonction continue sur un intervalle I, a, b et c
> des réels de I. Alors ∫ₐᵃ f(x)dx = 0 ; ∫ₐᵇ f(x)dx = −∫ᵦᵃ f(x)dx. ∫ₐᶜ f(x)dx + ∫꜀ᵇ f(x)dx =
> ∫ₐᵇ f(x)dx (Relation de Chasles). » (Démonstration par F primitive : F(a) − F(a) = 0 ;
> F(b) − F(a) = −(F(a) − F(b)) ; (F(c) − F(a)) + (F(b) − F(c)) = F(b) − F(a).)

> **Définition — aire (fonction de signe quelconque)** (p.113) — « Le plan est muni d'un repère
> orthogonal. Soit f une fonction continue sur [a, b]. L'aire (en u.a) de la partie du plan limitée
> par l'axe des abscisses, la courbe de f, les droites d'équations x = a et x = b est le réel
> ∫ₐᵇ |f(x)|dx. »

> **Théorème (linéarité)** (p.114) — « Soit f et g deux fonctions continues sur [a, b]. Pour tous
> réels α et β, ∫ₐᵇ (αf(x) + βg(x))dx = α∫ₐᵇ f(x)dx + β∫ₐᵇ g(x)dx. »

> **Définition — aire entre deux courbes** (p.116) — « Le plan est muni d'un repère orthogonal. Soit f
> et g deux fonctions continues sur [a, b]. L'aire (en u.a) de la partie du plan limitée par la courbe
> de f, la courbe de g et les droites d'équations x = a et x = b est le réel ∫ₐᵇ |f(x) − g(x)|dx. »

> **Théorème (positivité)** (p.114) — « Soit f une fonction continue sur [a, b]. Si f est positive sur
> [a, b], alors ∫ₐᵇ f(x)dx ≥ 0. » (Démonstration : toute primitive sur [a, b] d'une fonction positive
> est croissante sur [a, b].)

> **Corollaire** (p.115) — « Soit f une fonction continue sur [a, b] où a < b. Si f est positive et ne
> s'annule qu'en un nombre fini de réels de [a, b], alors ∫ₐᵇ f(x)dx > 0. »

> **Corollaire (comparaison)** (p.115) — « Soit f, g et h trois fonctions continues sur [a, b]. Si
> h ≤ f ≤ g, alors ∫ₐᵇ h(x)dx ≤ ∫ₐᵇ f(x)dx ≤ ∫ₐᵇ g(x)dx. »

> **Corollaire** (p.115) — « Si f est une fonction continue sur [a, b], alors |∫ₐᵇ f(x)dx| ≤
> ∫ₐᵇ |f(x)|dx. » (Démonstration : découle du corollaire précédent et de −|f| ≤ f ≤ |f|.)

> **Théorème d'intégration par parties** (p.118) — « Soit f et g deux fonctions dérivables sur [a, b]
> et telles que leurs dérivées f′ et g′ sont continues sur [a, b]. Alors ∫ₐᵇ f(t)g′(t)dt =
> [f(t)g(t)]ₐᵇ − ∫ₐᵇ f′(t)g(t)dt. » (Démonstration à partir de (fg)′ = f′g + g′f.)

> **Définition — valeur moyenne** (p.119) — « Soit f une fonction continue sur [a, b] (a < b). On
> appelle valeur moyenne de f sur [a, b] le réel, noté f̄, défini par f̄ = 1/(b − a) · ∫ₐᵇ f(x)dx. »

> **Interprétation géométrique de la valeur moyenne** (p.119) — « L'aire (en u.a) de la partie du plan
> limitée par la courbe de f, les droites d'équations x = a, x = b et y = 0 est égale à celle du
> rectangle de côtés (b − a) et f̄. » (f continue et positive sur [a, b].)

> **Théorème (Inégalité de la moyenne)** (p.120) — « Soit f une fonction continue sur [a, b] (a < b).
> Soit m et M deux réels. Si pour tout x de [a, b], m ≤ f(x) ≤ M, alors m ≤ f̄ ≤ M. »

> **Corollaire** (p.120) — « Soit f une fonction continue sur [a, b] (a < b). Il existe c ∈ [a, b],
> tel que f̄ = f(c). »

> **Formule du volume d'un solide de révolution** (p.121) — « L'espace est muni d'un repère
> orthonormé (O, i⃗, j⃗, k⃗). Soit f une fonction continue et positive sur [a, b]. Le volume V du solide
> de révolution engendré par la rotation de l'arc AB = {M(x, y) tels que y = f(x) et a ≤ x ≤ b} autour
> de l'axe (O, i⃗) est le réel V = π ∫ₐᵇ f²(x)dx. » (Aire de la section : S(x) = πy² = πf²(x).)

> **Théorème — fonction définie par une intégrale** (p.122) — « Soit f une fonction continue sur un
> intervalle I et a un réel de I. Alors la fonction F définie sur I par F(x) = ∫ₐˣ f(t)dt est la
> primitive de f qui s'annule en a. » **Conséquence** (p.122) — « … la fonction F : x ↦ ∫ₐˣ f(t)dt est
> dérivable sur I et F′(x) = f(x), pour tout x de I. »

> **Théorème — dérivée de x ↦ ∫ₐ^{u(x)} f(t)dt** (p.124) — « Soit f une fonction continue sur un
> intervalle I, u une fonction dérivable sur un intervalle J telle que u(J) ⊂ I et a un réel de I.
> Alors la fonction F définie sur J par F(x) = ∫ₐ^{u(x)} f(t)dt est dérivable sur J et F′(x) =
> f(u(x))·u′(x), pour tout x de J. » (Démonstration : F = G∘u avec G : x ↦ ∫ₐˣ f(t)dt.)

> **Théorème — parité** (p.125) — « Soit f une fonction continue sur un intervalle I centré en 0 et
> soit a un réel de I. Si f est impaire alors ∫*{−a}^a f(x)dx = 0. Si f est paire alors
> ∫*{−a}^a f(x)dx = 2∫₀ᵃ f(x)dx. »

> **Théorème — périodicité** (p.125) — « Soit f une fonction continue sur ℝ, périodique de période T.
> Pour tout réel a, ∫ₐ^{a+T} f(t)dt = ∫₀ᵀ f(t)dt. »

### Cours — Exercices / problème résolus

- **Exercice résolu 1** (p.123–124) : F(x) = ∫₁ˣ (1 − cos t)/t² dt sur [1, +∞[. 1. a. F croissante
  (F′(x) = (1 − cos x)/x² ≥ 0) ; b. F majorée par 2 (via |(1 − cos t)/t²| ≤ 2/t² et 2∫₁ˣ dt/t² =
  2 − 2/x ≤ 2) ; c. F admet une limite finie L en +∞. 2. G(x) = ∫₁ˣ (sin t)/t dt : par IPP
  (u(t) = 1/t, v(t) = 1 − cos t), G(x) = F(x) + (1 − cos x)/x + cos 1 − 1 ; G admet une limite finie en
  +∞ (car (1 − cos x)/x → 0).
- **Exercice résolu 2** (p.126–127) : Iₙ = ∫₀² xⁿ/√(x² + 4) dx (n ≥ 1). 1. I₁ = 2√2 − 2. 2. pour
  n ≥ 3, Iₙ = ∫₀² x^{n−2}√(x² + 4) dx − 4Iₙ₋₂. 3. par IPP, nIₙ = 2ⁿ√2 − 4(n − 1)Iₙ₋₂ ; d'où
  I₃ = (16 − 8√2)/3 et I₅ = (224√2 − 256)/15.
- **Problème résolu** (p.127–129) : **intégrales de Wallis** Iₙ = ∫₀^{π/2} cosⁿ(t)dt (I₀ = ∫₀^{π/2} dt).
  1. I₀ = π/2, I₁ = 1, I₂ = π/4. 2. a. Iₙ₊₂ = (n + 1)/(n + 2) · Iₙ (par IPP) ; b. I₃ = 2/3, I₄ = 3π/16,
     I₅ = 8/15, I₆ = 5π/32 ; c. 0 < Iₙ₊₁ ≤ Iₙ. 3. a. 1 ≤ Iₙ/Iₙ₊₂ … ; b. lim Iₙ/Iₙ₊₁ = 1. 4. uₙ =
     (n + 1)IₙIₙ₊₁ constante, uₙ = π/2 ; π/(2(n + 1)) ≤ Iₙ² ≤ π/(2n), d'où √(π/2002) ≤ I₁₀₀₀ ≤ √(π/2000).

### QCM (p.130) — « Cocher la réponse exacte. »

1. D'après la représentation graphique, l'aire limitée par la courbe de f, l'axe des abscisses et
   x = −2, x = 3 est encadrée par (☐ 7 et 13 / ☐ 15 et 20 / ☐ 14 et 21).
2. I = ∫₀¹ t cos²(πt)dt et J = ∫₀¹ t sin²(πt)dt : I + J est égal à (☐ 1 / ☐ 1/2 / ☐ 0).
3. I = |∫*{−1}¹ (−3x⁵ + 5x)/(x⁴ + 1) dx| et J = ∫*{−1}¹ |(−3x⁵ + 5x)/(x⁴ + 1)| dx. Alors
   (☐ I ≤ J / ☐ I = J / ☐ I ≥ J).

### Vrai ou faux (p.130) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. ∫₀^{π/2} sin x dx = ∫_{4π}^{9π/2} sin x dx.
2. ∫_{−1}¹ |x| dx = 1.
3. Si f est dérivable sur [a, b] et sa dérivée est continue sur [a, b] alors ∫ₐᵇ f(x)dx =
   [xf(x)]ₐᵇ − ∫ₐᵇ x f′(x)dx.
4. f continue sur [0, 1]. Si f ≤ 1 alors ∫₀¹ f(x)dx ≤ 1.
5. D'après la représentation graphique, ∫_{−2}² f(x)dx ≥ 0.
6. Si ∫ₐᵇ f(x)dx ≥ 0 alors f ≥ 0 sur [a, b].
7. La fonction x ↦ ∫₀ˣ 1/(1 + t²) dt est définie sur ℝ.

### Exercices et problèmes (p.131–136) — 39 exercices

- **Ex. 1** (p.131) : calculer ∫*{−1}³ (x²/2 − x)dx ; ∫₁² t(t + 1)³ dt ; ∫*{−1}¹ (2x + 1)(x² + x − 5)³ dx ;
  ∫₁² √(2x + 1) dx ; ∫₁² dx/(1 + x)² ; ∫₀⁴ dx/√(2x + 1) ; ∫₀^{π/4} cos⁴t sin t dt ; ∫*{−2}¹ |x(x + 1)| dx ;
  ∫*{−3}³ |x³ + x| dx ; ∫₀³ |2t − 1| dt ; ∫₀^{2π} |sin x| dx.
- **Ex. 2** (p.131) : a > 0 ; parabole y = x² et droite y = a délimitent D₁ et D₂. Pour quelle valeur
  de a les parties D₁ et D₂ ont-elles la même aire ?
- **Ex. 3** (p.131) : f(x) = (2x − 1)/(x − 1)³ sur ℝ\{1}. 1. étudier f et tracer C_f ; 2. f(x) =
  a/(x − 1)² + b/(x − 1)³ ; 3. λ < 1/2, 𝒜(λ) l'aire limitée par C_f, l'axe et x = λ, x = 1/2 :
  a. déterminer 𝒜(λ) ; b. calculer lim_{λ→−∞} 𝒜(λ).
- **Ex. 4** (p.131) : 1. h(x) = x² − 4x + 6 − 3√x sur ]0, +∞[ : a. h″(x) ; b. h′(x) = 0 admet une
  unique solution α ∈ ]2, 3[ ; c. signe de h′, tableau de variation ; d. h(1), h(4) ; 1 et 4 uniques
  solutions de h(x) = 0. 2. a. représenter f(x) = x² − 4x + 6 et g(x) = 3√x ; b. aire entre les deux
  courbes.
- **Ex. 5** (p.131) : f(x) = sin x, g(x) = sin²x sur [0, π/2]. 1. étudier f, g ; 2. position de C_f,
  C_g ; 3. représenter ; 4. aire entre les deux courbes.
- **Ex. 6** (p.131) : f(x) = x + sin x sur [0, π]. 1. variations ; 2. position de C_f vs D : y = x ; 3. représenter C_f et D ; 4. aire entre C_f et D.
- **Ex. 7** (p.131–132) : f(x) = 3x² + 2/x³, g(x) = 3x² sur ]0, +∞[. 1. représenter ; 2. λ > 0, A(λ)
  aire entre C_f, C_g et x = 1, x = λ : a. vérifier A(λ) = |∫₁^λ 2 dx/x³|, calculer ; b. étudier et
  représenter A : λ ↦ A(λ) ; c. selon m, nombre de solutions de A(λ) = m.
- **Ex. 8** (p.132) : f(x) = x + 1 + 4/(x − 2)², g(x) = x + 1 sur ]2, +∞[. λ > 2, A(λ) aire entre C_f,
  C_g et x = 3, x = λ : a. vérifier A(λ) = |∫₃^λ 4 dx/(x − 2)²| ; b. calculer ; c. étudier / représenter
  A ; d. selon m, nombre de solutions de A(λ) = m.
- **Ex. 9** (p.132) : A = ∫₀¹ x/(1 + x²)³ dx, B = ∫₀¹ x³/(1 + x²)³ dx. 1. calculer A ; 2. calculer
  A + B ; 3. en déduire B.
- **Ex. 10** (p.132) : 1. ∫₀^{π/2} sin²x dx ; 2. en déduire ∫₀^{π/2} cos²x dx.
- **Ex. 11** (p.132) : 1. par IPP calculer ∫₀^π x cos 2x dx. 2. I = ∫₀^{π/2} x cos²x dx, J =
  ∫₀^{π/2} x sin²x dx : a. calculer I + J et I − J ; b. en déduire I et J.
- **Ex. 12** (p.132) : 1. ∫₀^{π/4} dx/cos²x. 2. f(x) = sin x/cos³x sur [0, π/4] ; montrer f′(x) =
  3/cos⁴x − 2/cos²x. 3. ∫₀^{π/4} dx/cos⁴x.
- **Ex. 13** (p.132) : f(x) = 1/cos x sur [0, π/4]. 1. 1 ≤ f(x) ≤ √2 ; 2. en déduire π/4 ≤
  ∫₀^{π/4} dt/cos t ≤ π√2/4.
- **Ex. 14** (p.132) : I = ∫_{π/2}^π sin x/(1 + x²) dx. 1. a. pour x ∈ [π/2, π], 0 ≤ sin x/(1 + x²) ≤
  1/(1 + (π/2)²) ; b. en déduire un encadrement de I. 2. a. pour x ∈ [π/2, π],
  sin x/(1 + π²) ≤ sin x/(1 + x²) ≤ sin x/(1 + (π/2)²) ; b. en déduire un nouvel encadrement de I.
- **Ex. 15** (p.133) : f(x) = 1/√(1 + x⁴) sur ℝ₊, I = ∫_{100}^{1000} f(t)dt. 1. a. f(x) ≤ 1/x² ;
  b. par l'inégalité des accroissements finis, 1 − x/2 ≤ 1/√(1 + x) ; c. 1/x² − 1/(2x⁶) ≤ f(x) ; 2. encadrement de I.
- **Ex. 16** (p.133) : f(x) = 1/sin x sur ]π/2, π[. 1. f réalise une bijection de ]π/2, π[ sur un
  intervalle I ; 2. f⁻¹ dérivable sur I, (f⁻¹)′(x) = 1/(x√(x² − 1)) ; 3. en déduire ∫_{2/√3}^{√2}
  dt/(t√(t² − 1)) [bornes lues 2/√3 et √2].
- **Ex. 17** (p.133) : f(x) = x²/(1 + x²) sur ℝ. 1. représenter f ; 2. 𝒜 aire limitée par C_f, l'axe
  et x = 1, x = 2 : a. vérifier 1/2 ≤ 𝒜 ≤ 1 ; b. méthode des rectangles, [1, 2] en 5 intervalles
  d'amplitude 0.2, nouvel encadrement de 𝒜.
- **Ex. 18** (p.133) : uₙ = ∫₀¹ xⁿ/(x² + 1)² dx (n ≥ 1). 1. pour n ≥ 1 et 0 ≤ x ≤ 1, 0 ≤
  x^{2n+1}/(x² + 1)² ≤ x^{2n+1} [la définition écrit xⁿ, la question 1 x^{2n+1} — incohérence source
  [sic]] ; 2. en déduire que (uₙ) converge et sa limite.
- **Ex. 19** (p.133) : u₀ = ∫₀^{π/4} cos 2x dx, uₙ = ∫₀^{π/4} xⁿ cos 2x dx (n ≥ 1). 1. (uₙ)
  décroissante ; 2. comparer uₙ et ∫₀^{π/4} xⁿ dx ; 3. (uₙ) convergente et limite ; 4. a. calculer u₀,
  u₁ ; b. uₙ₊₂ en fonction de uₙ ; c. calculer u₂, u₃.
- **Ex. 20** (p.133) : u₀ = ∫₀¹ √(1 − x) dx, uₙ = ∫₀¹ xⁿ √(1 − x) dx (n ≥ 1). 1. 0 ≤ uₙ ≤ 1/(n + 1) ; 2. en déduire lim uₙ ; 3. a. calculer u₀, u₁ ; b. (3 + 2n)uₙ = 2n·uₙ₋₁ ; c. calculer u₂, u₃.
- **Ex. 21** (p.133) : uₙ = ∫₀¹ xⁿ/√(1 + x²) dx (n ≥ 1). 1. calculer u₁ ; 2. 0 ≤ uₙ ≤ 1/(n + 1) ; 3. en déduire lim uₙ.
- **Ex. 22** (p.134) : f(x) = tan³x + tan x sur [0, π/4]. 1. variations de f ; 2. f bijection de
  [0, π/4] sur [0, 2] ; 3. a. représenter f et f⁻¹ (demi-tangentes aux extrémités) ; b. calculer
  ∫₀^{π/4} f(x)dx, en déduire ∫₀² f⁻¹(x)dx.
- **Ex. 23** (p.134) : f par morceaux sur [0, 3] (f(x) = x si x ∈ [0, 1] ; 1/x² si x ∈ ]1, 3]).
  1. vérifier f continue sur [0, 3] ; 2. F(x) = ∫₀ˣ f(t)dt : a. expliciter F(x), x ∈ [0, 3] ;
     b. représenter F.
- **Ex. 24** (p.134) : f(x) = √(1 − x²) sur [0, 1]. 1. a. étudier f ; b. C_f quart de cercle de centre
  O rayon 1 ; c. tracer C_f. 2. F(x) = ∫₀ˣ f(t)dt ; représenter la partie d'aire F(1), en déduire
  F(1). 3. a ∈ [0, 1], θ ∈ [0, π/2] avec cos θ = a : a. montrer F(a) = π/4 − θ/2 + a√(1 − a²)/2 ;
  b. calculer F(1/2), F(√3/2).
- **Ex. 25** (p.134) : Iₙ = ∫₀^{π/4} tan^{n+2}x dx. 1. a. calculer I₀ ; b. 0 ≤ Iₙ₊₁ ≤ Iₙ ;
  c. (Iₙ) convergente. 3. a. Iₙ + Iₙ₊₂ = 1/(n + 3) ; b. lim Iₙ. (Numérotation source : passe de 1 à 3
  [sic].)
- **Ex. 26** (p.134) : f(x) = 1/x² sur ]0, +∞[. 1. a. calculer ∫₁ⁿ f(x)dx ; b. lim_{n→+∞} ∫₁ⁿ f ; 2. calculer ∫ₖ^{k+1} f(x)dx ; 3. la somme 1/(1·2) + 1/(2·3) + … + 1/(n(n + 1)) converge et sa limite.
- **Ex. 27** (p.134–135) : f(x) = 1/x³ sur [1, +∞[, Sₙ = Σ_{k=1}^n f(k). 1. a. f décroissante et
  positive ; b. (Sₙ) croissante. 2. a. calculer ∫₁ⁿ f(t)dt, 0 ≤ ∫₁ⁿ f ≤ 1/2 ; b. lim_{n→+∞} ∫₁ⁿ f. 3. a. pour k ≥ 2, ∫ₖ^{k+1} f ≤ f(k) ≤ ∫_{k−1}^k f ; b. ∫₂^{n+1} f ≤ Sₙ − f(1) ≤ ∫₁ⁿ f ; c. 1 ≤ Sₙ ≤
  3/2 ; d. la somme 1 + 1/2³ + … + 1/n³ converge, encadrement de sa limite.
- **Ex. 28** (p.135) : valeur moyenne de f sur I : 1. f : x ↦ x⁴ − x³ + 1, I = [−1, 3] ; 2. f : x ↦
  1/x³ − 1, I = [2, 4] ; 3. f : x ↦ sin(2x), I = [0, π].
- **Ex. 29** (p.135) : par l'inégalité de la moyenne, encadrement de ∫₂⁴ dx/(x² − x + 1).
- **Ex. 30** (p.135) : par l'inégalité de la moyenne, encadrement de ∫_{π/6}^{π/3} dx/(3 + tan²x).
- **Ex. 31** (p.135) : C = {M(x, y) : y = x², 0 ≤ x ≤ 2}, S solide par rotation de C autour de (Ox) ;
  calculer le volume de S.
- **Ex. 32** (p.135) : C = {y = 1/x, 1 ≤ x ≤ 3}, rotation autour (Ox) ; volume de S.
- **Ex. 33** (p.135) : C = {y = tan x, 0 ≤ x ≤ π/4}, rotation autour (Ox) ; volume de S.
- **Ex. 34** (p.135) : C = {y = sin x + cos x, 0 ≤ x ≤ π/2}, rotation autour (Ox) ; volume de S.
- **Ex. 35** (p.135) : C = {y = sin x} et C′ = {y = x}, 0 ≤ x ≤ π/2 ; S, S′ solides de rotation autour
  (Ox) ; calculer le volume compris entre S et S′.
- **Ex. 36** (p.135–136) : **I.** F(x) = ∫₀^{tan x} dt/(1 + t²) sur [0, π/4]. 1. F dérivable, dérivée ; 2. F(x) = x ; 3. calculer ∫₀¹ dt/(1 + t²). **II.** Iₙ = ∫₀¹ dt/(1 + t²)ⁿ (n ≥ 0). 1. calculer I₀,
  I₁ ; 2. Iₙ₊₁ = 1/(2n)·(1/2ⁿ + (2n − 1)Iₙ) ; 3. calculer I₂, I₃, I₄. **III.** J₀ = ∫₀¹ dt/(1 + t²),
  Jₙ = ∫₀¹ t^{2n}/(1 + t²) dt (n ≥ 1). 1. a. 0 ≤ Jₙ ≤ 1/(1 + 2n) ; b. lim Jₙ. 2. a. Jₙ₊₁ + Jₙ =
  1/(1 + 2n) ; b. J₁…J₅. 3. uₙ = 1 − 1/3 + 1/5 − … + (−1)ⁿ/(1 + 2n) ; a. Jₙ₊₁ = (−1)ⁿ(uₙ − J₀) ;
  b. lim uₙ.
- **Ex. 37** (p.136) : Iₙ = ∫₀¹ xⁿ/(1 + x + x²) dx (n ≥ 1). 1. a. 1/(3(n + 1)) ≤ Iₙ ≤ 1/(n + 1) ;
  b. convergente, limite. 2. a. Iₙ = 1/(3(n + 1)) + 1/(n + 1)·∫₀¹ (1 + 2x)x^{n+1}/(1 + x + x²)² dx ;
  b. 1 + 1/(3(n + 2)) ≤ 3(n + 1)Iₙ ≤ 1 + 3/(n + 2) ; c. lim nIₙ.
- **Ex. 38** (p.136) : F(x) = ∫₀^{sin x} √(1 − t²) dt sur [0, π/2]. 1. F dérivable, dérivée ; 2. F(x) =
  x/2 + sin(2x)/4 ; 3. calculer ∫₀¹ √(1 − t²) dt ; 4. variations de F ; 5. tracer C_F.
- **Ex. 39** (p.136) : f(x) = x + √(4 − x²) sur [−2, 2]. 1. étudier f et tracer C. 2. F(x) =
  ∫₀^{2cos x} √(4 − t²) dt sur [0, π] : a. F dérivable, F′(x) = −4 sin²x ; b. calculer F(π/2) ;
  c. F(x) = −2x + sin(2x) + π. 3. 𝒜 aire limitée par C, l'axe, y = x, x = −2, x = 2 : a. montrer
  𝒜 = F(0) − F(π) ; b. en déduire 𝒜.

### Bornes de scope observées (chapitre 6)

- ✅ INCLUS : intégrale d'une fonction continue et positive comme aire (F(b) − F(a)) ; intégrale d'une
  fonction continue (∫ₐᵇ f = F(b) − F(a)), variable muette, notation [F(x)]ₐᵇ ; propriétés algébriques
  (∫ₐᵃ = 0, ∫ₐᵇ = −∫ᵦᵃ, **relation de Chasles**, **linéarité**) ; intégrales et inégalités
  (**positivité**, corollaire strict, **comparaison** h ≤ f ≤ g, |∫f| ≤ ∫|f|) ; aire d'une fonction de
  signe quelconque (∫|f|) et **aire entre deux courbes** (∫|f − g|) ; calcul au moyen d'une primitive ;
  **intégration par parties** ; calcul approché (méthode des rectangles) ; **valeur moyenne** +
  **inégalité de la moyenne** + corollaire (valeur moyenne atteinte) ; **volume de solides de
  révolution** V = π∫f² ; **fonctions définies par une intégrale** (F(x) = ∫ₐˣ f = primitive s'annulant
  en a, F′ = f ; F(x) = ∫ₐ^{u(x)} f → F′ = f(u)·u′) ; intégrale et **parité / périodicité** ; suites
  définies par une intégrale (Wallis ∫cosⁿ, récurrences par IPP, encadrements, convergence).
- ⛔ NON traité dans ce chapitre : primitives/intégrales des fonctions **ln et exp** (chapitres 7–8) —
  donc pas d'intégrale du type ∫dx/x ni ∫eˣdx ; **équations différentielles** (chapitre 9) ; changement
  de variable **formalisé** (seule l'IPP est un procédé nommé ; les substitutions apparaissent déguisées
  en dérivation de composées F(u(x))) ; **intégrales impropres / généralisées** (les « limites
  d'intégrales » se traitent par encadrement et suites, jamais ∫₀^{+∞}).

## 2.7 Chapitre 7 — Fonction logarithme népérien (manuel 222445, p.137–157)

**Page de garde (p.137)** — Titre : « Fonction logarithme népérien », Chapitre 7. Citation liminaire
sur M. Stifel (1544), qui met en évidence deux suites (une progression arithmétique
… −3, −2, −1, 0, 1, 2, 3, 4, … 8 en regard d'une progression géométrique … 1/8, 1/4, 1/2, 0
[sic — la table imprimée aligne le 0 arithmétique sur un 0 géométrique], 1, 4, 8, 16, … 256) : le
passage de la ligne « in inferiore ordine » à la ligne « in superioreordine » transforme les
produits en sommes (additionner est plus facile que multiplier). Les premières tables logarithmiques
ont été calculées par John Napier (1614, 1619), Henry Briggs (1624) et Jost Burgi (1620). Référence
donnée : « E. Haier [sic] et al, _L'analyse au fil de l'histoire_, 2000 » (même coquille source que
le chapitre 1 pour Ernst Hairer). Le chapitre est structuré en 5 parties (I à V), suivies d'un
QCM / Vrai-Faux, puis d'une rubrique « Exercices et problèmes ».

### Cours — Activités

**I. Introduction** (p.138)

- **Activité 1** (p.138–139) — **A/** repère orthonormé, courbe de f : ]0, +∞[ → ℝ, t ↦ 1/t ; pour
  tout réel a > 0, S(a) est l'aire de la partie limitée par la courbe de f, l'axe des abscisses et
  les droites x = 1 et x = a. 1. Que vaut S(1) ? 2. a. partager [1, 2] en trois intervalles de même
  amplitude, rectangles r₁, r₂, r₃ et R₁, R₂, R₃ ; 𝒜 (resp. 𝒜′) = somme des aires des rᵢ (resp. Rᵢ),
  1 ≤ i ≤ 3 ; montrer que 37/60 ≤ S(2) ≤ 47/60. b. partager [1, 3] en huit intervalles de même
  amplitude, rectangles rᵢ, 1 ≤ i ≤ 8 ; calculer la somme de leurs aires et vérifier que S(3) ≥ 1.
  c. montrer que S(2.5) ≤ 1. 3. a. E = {M(x, y) avec 1/2 ≤ x ≤ 1 et 0 ≤ y ≤ 1/x} et F = {M(x, y) avec
  1 ≤ x ≤ 2 et 0 ≤ y ≤ 1/x} — montrer que E et F ont même aire ; b. en déduire S(1/2) = S(2).
  **B/** pour tout réel x > 0, on pose F(x) = ∫₁ˣ 1/t dt. 1. a. montrer que F(x) > 0 ssi x > 1 ;
  b. en déduire F(x) à l'aide de S(x). 2. justifier la dérivabilité de F sur ]0, +∞[, calculer F′(x),
  en déduire que F est strictement croissante sur ]0, +∞[. 3. montrer qu'il existe un unique réel
  x ∈ ]2, 3[ tel que F(x) = 1.

- **Activité 2** (p.140) : 1. Résoudre dans ℝ : a. ln(x² + x + 1) = 0 ; b. ln(1 − x) = ln(2 + x). 2. Résoudre dans ℝ : a. ln(4x − 1) ≤ 0 ; b. ln(4 − 3x) > 0 ; c. ln(x² + x + 1) ≤ 0 ;
  d. ln(2x − 5) ≤ ln x.

**II. Étude et représentation graphique de la fonction ln** (p.140)

- **Activité 1** (p.140) : étudier ln et construire sa courbe C dans un repère orthonormé (O, i⃗, j⃗).
  1. a. n ≥ 2 entier — montrer ∫*{2^k}^{2^{k+1}} 1/t dt ≥ 1/2 pour 0 ≤ k ≤ n − 1 ; en remarquant que
     ∫₁^{2ⁿ} 1/t dt = Σ*{k=0}^{n−1} ∫*{2^k}^{2^{k+1}} 1/t dt, en déduire ∫₁^{2ⁿ} 1/t dt ≥ n/2. b. en
     déduire que ln n'est pas majorée et déterminer lim*{x→+∞} ln x. 2. a. montrer que x ↦ ln x et
     x ↦ −ln(1/x) (sur ]0, +∞[) ont même dérivée ; b. en déduire ln x = −ln(1/x), x > 0 ; c. calculer
     lim_{x→0⁺} ln x. 3. a. montrer 1/t ≤ 1/√t pour t ≥ 1, en déduire ln x ≤ 2√x − 2 pour x ≥ 1 ;
     b. montrer lim_{x→+∞} (ln x)/x = 0. 4. a. dresser le tableau de variation de ln ; b. écrire une
     équation de la tangente T à C au point d'abscisse 1 ; c. construire C. (« L'activité 1 fournit la
     démonstration du théorème suivant. »)
- **Activité 2** (p.141) : C courbe de ln ; A ∈ C d'abscisse a ; la tangente à C en A coupe l'axe des
  ordonnées en K ; H projeté orthogonal de A sur l'axe des ordonnées ; y_H, y_K ordonnées de H et K.
  1. montrer que y_H − y_K est constant. 2. en déduire une construction de la tangente en un point de C.

**III. Propriétés algébriques** (p.141)

- **Activité 1** (p.141) : f, g sur ]0, +∞[ par f(x) = ln x, g(x) = ln(ax), a > 0. a. comparer f′(x)
  et g′(x). b. en déduire qu'il existe une constante c telle que ln(ax) = ln x + c, x > 0.
  c. montrer alors ln(ax) = ln a + ln x, x > 0. 2. montrer ln(a/b) = ln a − ln b, a > 0 et b > 0.
- **Activité 2** (p.141) : a > 0. 1. a. montrer par récurrence sur p ∈ ℕ que ln(aᵖ) = p ln a ;
  b. montrer que la formule reste vraie pour tout entier négatif p. 2. p ≥ 2 entier — en écrivant
  a = (ᵖ√a)ᵖ, montrer ln(ᵖ√a) = (1/p) ln a.
- **Activité 3** (p.142) : 1. exprimer à l'aide de ln 2 et ln 3 : ln(√3), ln(³√2), ln 108, ln(81/8),
  ln(⁵√(2³)) et ln(√(1/27)). 2. simplifier : ln(√e), ln(1/e), ln(e³), ln(e⁻²), ln(³√e/√e) et
  ln(⁴√e·³√e). 3. a, b > 0 — exprimer à l'aide de ln a et ln b : ln(a³/b²), ln(√a·b²) et ln(³√a/√b).
- **Activité 4** (p.142) : 1. déterminer le plus petit entier naturel n tel que (1/2)ⁿ ≤ 10⁻⁴. 2. déterminer le plus petit entier naturel n tel que (√2)ⁿ ≥ 10⁵.
- **Activité 5** (p.142) : résoudre dans ℝ les équations et inéquations 2 ln x = 1 ;
  (ln x)² + 2 ln x = 3 ; (ln x + 1/2)(ln x − 2) = 0 ; ln(x + 3) + ln(x + 2) = ln(x + 11) ;
  ln x ≥ −2 ; 2 ln x < 1 ; (1 − ln x)(2 − ln x) ≥ 0.
- **Activité 6** (p.142) : déterminer lim_{x→1} ln(³√x)/x ; lim_{x→+∞} ln(³√x)/x ;
  lim_{x→+∞} ln x/(¹⁰√x) ; lim_{x→+∞} ln(2x + 3)/(3x + 4) ; lim_{x→+∞} x − ln x.

**IV. Autres limites** (p.143)

- **Activité 1** (p.143) : m ∈ ℕ*, n entier ≥ 2. 1. a. vérifier (ln x)ⁿ/xᵐ =
  ((n/m) × ln(ⁿ√(xᵐ))/(ⁿ√(xᵐ)))ⁿ, x > 0 ; b. en déduire lim_{x→+∞} (ln x)ⁿ/xᵐ = 0. 2. calculer lim_{x→0⁺} |xᵐ (ln x)ⁿ|.
- **Activité 2** (p.143) : 1. lim_{x→+∞} x² − ln³x ; lim_{x→0⁺} x² + ln³x. 2. lim_{x→0⁺} x⁴(1 − ln⁵x) ;
  lim_{x→+∞} x⁴(1 − ln⁵x) ; lim_{x→−∞} (ln(3 − 2x))²/(4x − 6).
- **Activité 3** (p.143) : f définie par f(x) = x² ln²x (x > 0), f(0) = 0. 1. étudier la dérivabilité
  de f sur son ensemble de définition. 2. étudier les variations de f et tracer sa courbe.
- **Activité 4** (p.143) : a = (2007)²⁰⁰⁸ et b = (2008)²⁰⁰⁷ — comparer a et b (on pourra calculer ln a
  et ln b).

**V. Fonctions x ↦ ln(u(x)) et x ↦ ln(|u(x)|)** (p.143)

- **Activité 1** (p.143) : u : x ↦ x² + x − 2. 1. résoudre dans ℝ l'inéquation u(x) > 0. 2. f : x ↦ ln(x² + x − 2) : a. ensemble de définition ; b. montrer que f est dérivable en tout réel
  de son ensemble de définition et calculer f′(x).
- **Activité 2** (p.144) : u : x ↦ 1 − x⁴. 1. résoudre |u(x)| > 0 ; en déduire l'ensemble de définition
  de f : x ↦ ln(|1 − x⁴|). 2. montrer que f est dérivable en tout réel de son ensemble de définition et
  que f′(x) = u′(x)/u(x). (« Le théorème de dérivation des fonctions composées fournit la démonstration
  des théorèmes ci-dessous. »)
- **Activité 3** (p.144) : f : x ↦ ln|tan(x/2)|. 1. ensemble de définition. 2. montrer que f est
  dérivable en tout réel de son ensemble de définition et calculer f′(x). 3. déterminer la primitive
  sur [π/6, 5π/6] de x ↦ 1/sin x, qui s'annule en π/3.
- **Activité 4** (p.145) : f : x ↦ ln((x − 2)/(x + 1)) + x. 1. dresser le tableau de variation de f. 2. étudier la nature des branches infinies de la courbe de f. 3. tracer la courbe de f.
- **Activité 5** (p.145) : 1. montrer 1/(x + 1) ≤ ln(x + 1) − ln(x) ≤ 1/x, pour tout réel x > 0. 2. (vₙ) définie par vₙ = 1/(n + 1) + 1/(n + 2) + … + 1/(2n), n ≥ 1 : a. montrer
  ln((2n + 1)/(n + 1)) ≤ vₙ ≤ ln 2, pour tout entier non nul n ; b. en déduire que (vₙ) est
  convergente et déterminer sa limite.
- **Activité 6** (p.145) : déterminer une primitive de f sur I dans chacun des cas : 1. f(x) =
  x/(1 − x²), I = ]1, +∞[ ; 2. f(x) = (x + 1)/(3x − 2), I = ]−∞, 2/3[ ; 3. f(x) = 1/(x ln x),
  I = ]1/e, 1[ ; 4. f(x) = sin(2x)/(2 + cos²(x)), I = ℝ ; 5. f(x) = (x² − x + 5)/(x − 1), I = ]−∞, 1[.
- **Activité 7** (p.145) : dériver x ↦ x ln x. En déduire une primitive de la fonction ln.
- **Activité 8** (p.146) : repère (O, i⃗, j⃗) ; f : x ↦ 1 − x + ln x. 1. étudier les variations de f et
  tracer sa courbe C_f. 2. α ∈ ]0, 1[ : a. exprimer à l'aide de α l'aire 𝒜(α) de la partie limitée
  par C_f, l'axe des abscisses et x = α, x = 1 ; b. déterminer lim_{α→0⁺} 𝒜(α).
- **Activité 9** (p.146) : 1. déterminer a et b tels que pour tout t ∈ ℝ*\{−1}, 1/(t(t + 1)) = a/t +
  b/(t + 1). 2. calculer ∫₁² dt/(t(t + 1)). 3. en déduire la valeur de ∫₁² ln(1 + t)/t² dt.
- **Activité 10** (p.146) : 1. (uₙ) définie par uₙ = ∫₀¹ xⁿ ln(x + 2) dx, n ≥ 1 — calculer u₁. 2. a. justifier que pour 0 ≤ x ≤ 1, ln 2 ≤ ln(x + 2) ≤ ln 3 ; b. en déduire que pour n ≥ 1,
  ln 2 ∫₀¹ xⁿ dx ≤ uₙ ≤ ln 3 ∫₀¹ xⁿ dx ; c. calculer lim_{n→+∞} uₙ.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Définition — fonction logarithme népérien** (p.139) — « On appelle fonction logarithme népérien
> et on note ln, la fonction x ↦ ln x = ∫₁ˣ 1/t dt, x > 0. » (Résultats découlant immédiatement : la
> fonction ln est la primitive sur ]0, +∞[ de t ↦ 1/t qui s'annule en 1 ; elle est définie, continue,
> dérivable sur ]0, +∞[ et ln′(x) = 1/x, x > 0 ; elle est strictement croissante sur ]0, +∞[ et
> ln 1 = 0 ; il existe un unique réel x ∈ ]2, 3[ tel que ln(x) = 1.)

> **Encadré** (p.139) — « Soit a et b deux réels strictement positifs. ln a > ln b, si et seulement
> si, a > b. ln a = ln b, si et seulement si, a = b. ln a = 0, si et seulement si, a = 1. ln a > 0, si
> et seulement si, a > 1. ln a < 0, si et seulement si, 0 < a < 1. »

> **Théorème** (p.141) — « lim_{x→+∞} ln x = +∞ ; lim_{x→0⁺} ln x = −∞ ; lim_{x→+∞} (ln x)/x = 0 ;
> lim_{x→1} (ln x)/(x − 1) = 1. » « • La fonction ln réalise une bijection strictement croissante de
> ℝ*₊ sur ℝ. • L'unique solution de l'équation ln x = 1 est le réel noté e. Ainsi, ln e = 1. Les
> calculatrices donnent des valeurs approchées du réel e, e ≈ 2.71828… »

> **Théorème** (p.141) — « Soit a et b deux réels strictement positifs. ln(a.b) = ln a + ln b.
> ln(a/b) = ln a − ln b. ln(1/b) = −ln b. »

> **Théorème** (p.142) — « Soit a un réel strictement positif. • Pour tout entier p, ln(aᵖ) = p ln a
> • Pour tout entier p ≥ 2, ln(ᵖ√a) = (1/p) ln a. »

> **Théorème** (p.143) — « Pour tous entiers naturels non nuls n et m, lim_{x→+∞} lnⁿx/xᵐ = 0 et
> lim_{x→0⁺} xᵐ lnⁿx = 0. »

> **Théorème** (p.144) — « Soit u une fonction dérivable sur un intervalle I et telle que u(x) > 0,
> pour tout réel x dans I. Alors la fonction f : x ↦ ln(u(x)) est dérivable sur I et
> f′(x) = u′(x)/u(x), pour tout x dans I. »

> **Théorème** (p.144) — « Soit u une fonction dérivable sur un intervalle I et telle que u(x) ≠ 0,
> pour tout réel x dans I. Alors la fonction f : x ↦ ln|u(x)| est dérivable sur I et
> f′(x) = u′(x)/u(x), pour tout x dans I. »

> **Corollaire** (p.144) — « Soit u une fonction dérivable sur un intervalle I et telle que u(x) ≠ 0,
> pour tout réel x dans I. Alors la fonction f : x ↦ u′(x)/u(x) admet pour primitive sur I la fonction
> f : x ↦ ln|u(x)| + k, où k est une constante réelle. »

> **Théorème** (p.145) — « La fonction x ↦ x ln x − x est une primitive de la fonction x ↦ ln x sur
> ℝ*₊. »

### Cours — Problème résolu (p.146–147)

**Problème résolu** (énoncé p.146, solution intégrale p.147) : 1. (Sₙ) par Sₙ = Σ_{k=1}^n 1/k, n ≥ 1
— montrer que (Sₙ) est divergente (via, pour t ∈ [k, k + 1], 1/t ≤ 1/k ⇒ Σ 1/k ≥ Σ ∫*k^{k+1} 1/t dt =
ln(n + 1), donc Sₙ ≥ ln(n + 1) → +∞). 2. (Tₙ) par Tₙ = Sₙ − ln(n), n ≥ 2 : a. par le théorème des
accroissements finis sur [x, x + 1] (x > 0), montrer 1/(x + 1) ≤ ln(x + 1) − ln(x) ≤ 1/x ; b. en
déduire T*{n+1} − Tₙ ≤ 0, donc (Tₙ) décroissante. 3. (Rₙ) par Rₙ = S_{n−1} − ln(n), n ≥ 2 :
a. Tₙ − Rₙ = 1/n ≥ 0 et lim(Rₙ − Tₙ) = 0, (Rₙ) croissante ⇒ (Tₙ) et (Rₙ) **adjacentes** ; b. limite
commune α, Rₙ ≤ α ≤ Tₙ ; c. l'égalité Tₙ − Rₙ = 1/n donne un encadrement d'amplitude 10⁻³ dès
n ≥ 1000 ; « en utilisant le tableur Excel on obtient T₁₀₀₀ ≈ 0.57771558 et Rₙ ≈ 0.57671558 »
(constante d'Euler).

### QCM (p.148) — « Cocher la réponse exacte. »

1. Pour tout réel x > 0, ln(x + x²) est égal à (☐ ln x + ln(x + 1) / ☐ ln(x²) + ln x / ☐ 3 ln x).
2. ln(1/√e) est égal à (☐ −2 / ☐ 1/2 / ☐ −1/2).
3. Soit f(x) = ln(−x), x < 0. Alors f′(x) est égal à (☐ −1/x / ☐ 1/x / ☐ −x).
4. Soit f(x) = x ln(x²), x < 0. Alors f′(x) est égale à (☐ 2(1 + ln|x|) / ☐ 2(1 + ln x) /
   ☐ ln(x²) + 1/x).
5. La limite de x ↦ (ln x)/x en 0⁺ est égale à (☐ +∞ / ☐ −∞ / ☐ 0).
6. La limite de x ↦ ln x + 1/x en 0⁺ est égale à (☐ −∞ / ☐ 0 / ☐ +∞).

### Vrai ou faux (p.148) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. La fonction x ↦ x ln x − x + 1 est la primitive de la fonction ln sur ℝ*₊ qui s'annule en 1.
2. La fonction ln est une bijection de ℝ*₊ sur ℝ*₊.
3. Pour tout réel x, ln x = ∫₂ˣ dt/t + ln 2.
4. lim_{x→0⁺} 1/(x ln x − x) = +∞.

### Exercices et problèmes (p.149–157) — 30 exercices

- **Ex. 1** (p.149) : résoudre dans ℝ : 1. ln x + ln(x + 1) = 0 ; 2. ln(ln x) = 0 ; 3. ln(1/x) + ln(x⁴) = 3 ln 2 ; 4. (ln x)² − 3 ln x + 2 = 0 ; 5. ln|x − 1| + ln|x + 2| =
  ln|4x² + 3x − 7|.
- **Ex. 2** (p.149) : résoudre dans ℝ : 1. ln(√(3 + x)) < 4 ; 2. ln(5x) > 2 + ln 3 ; 3. ln(4x + 1) ≤ 0 ; 4. ln((1 + x)/(3x − 5)) ≥ 0 ; 5. (ln x)² − 2 ln x < 0 ; 6. ln|sin x| < 0.
- **Ex. 3** (p.149) : limite de f en +∞ : 1. ln(x + 2)/(x + 3) ; 2. ln(2x + 3)/³√x ; 3. (x² − 2)/(x ln x) ; 4. ln(x² − 3x + 7)/x ; 5. ln(x⁵ − x³)/x ; 6. (1 + ln x)/(1 − ln x) ; 7. ln((1 + x)/(2 + x)) ; 8. x ln((1 + x)/(2 + x)) ; 9. x² − (ln x)⁵.
- **Ex. 4** (p.149) : déterminer les limites : 1. lim_{x→1/2} (ln x + ln 2)/(x − 1/2) ; 2. lim_{x→7} (ln(1/x) + ln 7)/(x − 7) ; 3. lim_{x→0} ln(1 + 2 sin x)/x ; 4. lim_{x→0}
  ln(1 + 3 tan x)/x³ ; 5. lim_{x→1} (x² + 3x − 4)/ln x ; 6. lim_{x→0⁺} √x ln x ; 7. lim_{x→0⁺}
  √x (ln x)¹⁰ ; 8. lim_{x→0} ln(1 + 3x)/sin x.
- **Ex. 5** (p.149) : primitive de f sur I : 1. f(x) = (1 + x + x² + x³)/x⁴, I = ℝ*₊ ; 2. f(x) =
  (3x − 4)/(x + 5), I = ]−5, +∞[ ; 3. f(x) = (sin x − cos x)/(sin x + cos x), I = ]0, π/2[ ; 4. f(x) =
  (2x + 1)/(x(x + 1)), I = ]0, +∞[ ; 5. f(x) = 1/(x ln x), I = ]1, +∞[ ; 6. f(x) = (ln x)³/x,
  I = ]0, +∞[.
- **Ex. 6** (p.149–150) : calculer les intégrales : 1. ∫_e¹ ln²x dx ; 2. ∫₁^e x ln x dx ; 3. ∫_e^{e²} x² ln x dx ; 4. ∫_e¹ (x − 1)/(x + 1) dx ; 5. ∫₁² 5x(ln x)² dx ; 6. ∫₃² dx/(x√(ln x)) ; 7. ∫₂³ ln((x + 1)/(x − 1)) dx ; 8. ∫₄² dx/(x ln x) ; 9. ∫₁² ln x/x dx ; 10. ∫₀¹ (x² + 3x − 1)/(2x + 1) dx.
  (Bornes des intégrales 1, 4, 6, 8 recopiées telles quelles [sic] : borne inférieure supérieure à la
  borne supérieure.)
- **Ex. 7** (p.150) : f sur ]1, +∞[ par f(x) = 1/(x²(x − 1)). 1. déterminer a, b, c tels que pour tout
  x ∈ ]1, +∞[, f(x) = a/x + b/x² + c/(x − 1). 2. calculer ∫₂³ f(x)dx. 3. en déduire la valeur de
  ∫₂³ ln(x − 1)/x³ dx.
- **Ex. 8** (p.150) : étudier et tracer : 1. f : x ↦ (ln x)² ; 2. f : x ↦ 1/ln x ; 3. f : x ↦ ln(ln x) ; 4. f : x ↦ ln|x| + ln(x² − 3).
- **Ex. 9** (p.150) : f sur ]0, +∞[ par f(x) = 2 − x + (ln x)/x. 1. calculer lim_{x→+∞} f(x) et
  lim_{x→0⁺} f(x). 2. g sur ]0, +∞[ par g(x) = 1 − x² − ln x : a. sens de variation ; b. calculer g(1),
  en déduire le signe de g. 3. vérifier que pour tout x ∈ ]0, +∞[, f′(x) = g(x)/x². 4. C courbe de f :
  a. montrer que Δ : y = −x + 2 est asymptote à C ; b. position relative de C et Δ ; c. tracer C et Δ.
- **Ex. 10** (p.150) : f : x ↦ (ln x)² − 3 ln x + 2. 1. dresser le tableau de variation de f. 2. construire dans (O, i⃗, j⃗) la courbe de f et préciser les points d'intersection avec l'axe (O, i⃗). 3. montrer que F : x ↦ x(ln x)² − 5x ln x + 7x est une primitive de f sur ]0, +∞[. 4. calculer l'aire
  du domaine limité par la courbe de f et les droites x = e, x = e² et y = 0.
- **Ex. 11** (p.150) : 1. résoudre dans ℝ l'inéquation ln|x| < 1. 2. f(x) = 2x − x ln|x| si x ≠ 0,
  0 si x = 0 : a. étudier la continuité et la dérivabilité sur son ensemble de définition ; b. étudier
  la parité, dresser le tableau de variation ; c. construire dans (O, i⃗, j⃗) la courbe de f, préciser
  la tangente au point d'abscisse 0 et la nature des branches infinies.
- **Ex. 12** (p.151) : 0 < a < b ; f(x) = ln(ax + 1)/ln(bx + 1). 1. ensemble de définition. 2. montrer
  que f est dérivable sur son ensemble de définition et calculer f′(x). 3. g(x) = a(bx + 1)ln(bx + 1) −
  b(ax + 1)ln(ax + 1) ; calculer g′(x), en déduire que f est strictement croissante sur ]−1/b, 0[ et
  ]0, +∞[. 4. montrer que ln(a/b + 1)·ln(b/a + 1) < (ln 2)².
- **Ex. 13** (p.151) : 1. étudier les variations de u(x) = ln x − (x − 1)/x et v(x) = x − 1 − ln x sur
  ℝ*₊. 2. en déduire (x − 1)/x < ln x < x − 1, pour x > 0. 3. en déduire (1 + 1/n)ⁿ < e < 1/(1 − 1/n)ⁿ,
  n entier, n ≥ 2.
- **Ex. 14** (p.151) : 1. montrer que pour t ≥ 0, 1 − t ≤ 1/(t + 1) ≤ 1 − t + t². 2. en déduire que
  pour x ≥ 0, x − x²/2 ≤ ln(1 + x) ≤ x − x²/2 + x³/3. 3. f(x) = ln(1 + x)/x si x > 0, 1 si x = 0 :
  a. dérivable sur ]0, +∞[ ; b. continue en 0 à droite ; c. dérivable à droite en 0, préciser f′_d(0).
- **Ex. 15** (p.151) : tracer x ↦ ln x. Pour n ≥ 2, Sₙ = ln 1 + ln 2 + … + ln n et
  Tₙ = ln 1 + ln 2 + … + ln(n − 1). 1. montrer Tₙ ≤ ∫₁ⁿ ln x dx ≤ Sₙ. 2. en déduire ln((n − 1)!) ≤
  n ln n − n + 1 ≤ ln(n!) ; puis e(n/e)ⁿ ≤ n! ≤ ne(n/e)ⁿ.
- **Ex. 16** (p.151) : f(x) = (x + 1)ln|x − 3| ; C courbe dans (O, i⃗, j⃗). 1. préciser l'ensemble de
  définition D. 2. a. vérifier que si x ∈ D alors f′(x) = (x + 1)/(x − 3) + ln|x − 3| ; b. calculer
  f″(x), en déduire les variations de f′ ; c. montrer que f′ s'annule sur ]−∞, 3[ pour une valeur α,
  encadrement d'amplitude 0.1, signe de f′(x) sur ]−∞, 3[ ; d. signe de f′(x) sur ]3, +∞[. 3. limites
  de f aux bornes de D_f, asymptotes éventuelles. 4. points d'intersection de C avec l'axe des
  abscisses. 5. tracer C.
- **Ex. 17** (p.152) : f(x) = −x/2 + ln|(x − 1)/x| ; C courbe dans (O, i⃗, j⃗). 1. préciser D_f. 2. dresser le tableau de variation de f. 3. montrer que Δ : y = −x/2 est asymptote à C, position
  relative. 4. montrer que I(1/2, −1/4) est centre de symétrie pour C. 5. construire C. 6. montrer que
  f(x) = 0 admet une solution réelle unique x₀ et que 2/5 < x₀ < 9/20.
- **Ex. 18** (p.152) : **A/** 1. g sur ℝ*₊ par g(x) = (1 − x)ln x — résoudre g(x) = 0, déterminer le
  signe de g(x). 2. h sur ℝ*₊ par h(x) = ln x − x : a. tableau de variation ; b. en déduire le signe de
  h. **B/** f sur ℝ*₊ par f(x) = ln x(ln x − x) ; C_f dans (O, i⃗, j⃗). 1. montrer que f est dérivable
  sur ℝ*₊ et que f′(x) = (g(x) + h(x))/x. 2. tableau de variation de f. 3. nature des branches infinies
  de C_f. 4. a. point d'intersection de C_f avec l'axe des abscisses ; b. équation cartésienne de la
  tangente T à C_f au point d'abscisse 1 ; c. vérifier que A(e, −e + 1) est un point d'intersection de
  C_f avec T. 5. construire C_f et T. 6. α ∈ ]0, 1[, D limité par C_f, l'axe des abscisses et x = α,
  x = 1 : a. aire 𝒜(α) ; b. lim_{α→0⁺} 𝒜(α). 7. a. montrer que f réalise une bijection de ℝ*₊ sur un
  intervalle J à préciser ; b. construire la courbe de f⁻¹.
- **Ex. 19** (p.152–153) : courbe C_f d'une fonction f dérivable sur ]2, +∞[ (figure : asymptote
  x = 2). 1. a. déterminer f(3) et f′(3) par lecture graphique ; b. la tangente au point d'abscisse 4 a
  pour coefficient −1/2, la tracer. 2. a. limites de f aux bornes de son ensemble de définition ;
  b. tableau de variation de f. 3. f de la forme f(x) = ax + b + ln(x + c) — calculer a, b, c ; par la
  suite on utilise cette forme. 4. nature de la branche infinie de C_f au voisinage de +∞. 5. a. tracer
  Δ : y = −x + 4 ; b. position de C_f par rapport à Δ (algébriquement). 6. g restriction de f à ]2, 3] :
  a. bijection de ]2, 3] sur un intervalle J ; b. construire la courbe C′ de g⁻¹ ; c. g⁻¹ est-elle
  dérivable à gauche de 1 ?
- **Ex. 20** (p.153) : f sur ]0, +∞[\{1} par f(x) = 1/x + 1/ln x ; C_f dans (O, i⃗, j⃗). 1. déterminer
  lim_{x→0⁺} f, lim_{x→1⁻} f, lim_{x→1⁺} f, lim_{x→+∞} f — interpréter graphiquement. 2. a. f dérivable
  sur ]0, +∞[\{1} et f′(x) = −1/x² − 1/(x(ln x)²) ; b. tableau de variation de f. 3. h restriction de f
  à ]0, 1[ : a. bijection de ]0, 1[ sur un ensemble J ; b. h(x) = 0 admet une seule solution α dans
  ]0, 1[, 0.5 < α < 0.6 ; c. en déduire que C_f coupe l'axe des abscisses en un seul point. 4. tracer
  C_f. 5. tracer la courbe de h⁻¹, en déduire son tableau de variation. 6. a. montrer h′(α) =
  −(α + 1)/α³ ; b. montrer que h⁻¹ est dérivable en 0 et exprimer (h⁻¹)′(0) en fonction de α.
- **Ex. 21** (p.153–154) : **A/** g sur ]0, +∞[ par g(x) = (x + 1)/(2x + 1) − ln x. 1. sens de
  variation. 2. g(x) = 0 admet une unique solution α dans ]0, +∞[, encadrement d'amplitude 0.1. 3. signe de g(x) sur ]0, +∞[. **B/** f sur ]0, +∞[ par f(x) = 2 ln x/(x² + x) ; C dans un repère
  orthogonal (2 cm sur (Ox), 4 cm sur (Oy)). 1. limites de f en 0 à droite et en +∞. 2. pour x > 0,
  f′(x) = 2(2x + 1)/(x² + x)² × g(x), en déduire le signe de f′(x). 3. tableau de variation de f et
  montrer f(α) = 2/(α(2α + 1)). 4. tracer C, préciser la tangente au point d'abscisse 1. **C/**
  1. a. primitive sur ]0, +∞[ de x ↦ (ln x)/x ; b. montrer que pour x ≥ 1, f(x) ≤ (ln x)/x. 2. F
     primitive de f sur [1, +∞[ qui s'annule en 1 ; sans calculer F(x), montrer que pour x ≥ 1,
     F(x) ≤ (1/2)(ln x)².
- **Ex. 22** (p.154) : f sur [0, +∞[ par f(x) = ln(x + √(x² + 1)) ; C dans (O, i⃗, j⃗). 1. a. déterminer
  la dérivée de f ; b. calculer ∫₀¹ dt/√(t² + 1). 2. étudier f et tracer (C). 3. a. f réalise une
  bijection de [0, +∞[ sur un intervalle J ; b. tracer la courbe de f⁻¹ ; c. calculer par intégration
  par parties ∫₀¹ ln(x + √(1 + x²)) dx ; en déduire ∫₀^{ln(1+√2)} f⁻¹(x) dx.
- **Ex. 23** (p.154) : pour tout entier p ≥ 1, I_p = ∫₁^e x²(ln x)ᵖ dx. a. montrer que (I_p) est
  décroissante. b. montrer la relation de récurrence I_{p+1} + (p + 1)/3·I_p = e³/3. c. calculer I₁ et
  I₂. 2. montrer que pour p ≥ 1, e³/(p + 4) ≤ I_p ≤ e³/(p + 3) ; calculer lim_{p→+∞} I_p et
  lim_{p→+∞} pI_p.
- **Ex. 24** (p.154) : f(x) = ln(ln x). 1. ensemble de définition. 2. étudier la dérivabilité et
  calculer f′(x). 3. Sₙ = Σ_{k=2}^n 1/(k ln k), n ≥ 2 — montrer que pour tout entier k ≥ 2,
  ∫*k^{k+1} 1/(t ln t) dt ≤ 1/(k ln k). 4. calculer ∫₂^{n+1} 1/(t ln t) dt et en déduire
  lim*{n→+∞} Sₙ.
- **Ex. 25** (p.154) : 1. montrer que pour tout x de ℝ₊, x − x²/2 ≤ ln(1 + x) ≤ x. 2. a. montrer
  Σ_{p=1}^n p = n(n + 1)/2 et Σ_{p=1}^n p² = n(n + 1)(2n + 1)/6 ; b. Pₙ = (1 + 1/n²)(1 + 2/n²)…
  (1 + n/n²) — déterminer lim_{n→+∞} Pₙ.
- **Ex. 26** (p.154–155) : pour tout réel a, f_a(x) = ln(x² + a). 1. a. ensemble de définition de f_a
  suivant a ; b. tableaux de variation de f_a selon a ; c. lim_{x→+∞} f_a(x)/x, nature des branches
  infinies (x → +∞ et x → −∞) ; d. (C_a) et (C_{a'}) courbes de f_a et f_{a'} (a ≠ a′), M ∈ (C_a) et
  M′ ∈ (C_{a'}) de même abscisse — montrer MM′ non nul ; que déduire pour C_a et C_{a'} ; montrer que
  MM′ → 0 quand x → +∞. e. tracer C_{−1}, C₀, C₁ (unité 2 cm), points d'intersection avec l'axe des
  abscisses et tangentes en ces points. 2. a = 3/4 : a. g sur ℝ₊ par g(x) = x − ln(x² + 3/4) — sens de
  variation, position de C_{3/4} par rapport à D : y = x ; b. h restriction de f_{3/4} à ℝ₊, bijection
  de ℝ₊ sur un ensemble à préciser ; c. tracer h et h⁻¹.
- **Ex. 27** (p.155) : **A/** n ∈ ℕ*, f_n sur ℝ*₊ par f_n(x) = (x − 1)ⁿ ln x ; C_n dans (O, i⃗, j⃗).
  1. φ_n(x) = n ln x + 1 − 1/x : a. variations ; b. calculer φ_n(1), en déduire le signe de φ_n(x)
     pour x > 0. 2. a. variations de f_n, tableau de variation suivant la parité de n ; b. tracer C₁ et C₂,
     positions relatives. 3. aire de la partie limitée par C₁, C₂ et x = 1, x = 2. **B/** (v_n) par
     v_n = Σ_{k=0}^n (−1)ᵏ/(k + 1), n ≥ 0. 1. (u_n) par u_n = ∫₁² f_n(x)dx. 2. montrer que pour tout
     n ∈ ℕ*, (n + 1)u_n = ln 2 − ∫₁² (x − 1)^{n+1}/x dx. 3. a. 1/(2(n + 2)) ≤ ln 2 − (n + 1)u_n ≤
     1/(n + 2), n ∈ ℕ* ; b. calculer la limite de (n + 1)u_n. 4. S_n(x) = 1 − (x − 1) + (x − 1)² + … +
     (−1)ⁿ(x − 1)ⁿ (x > 0, n ≥ 1) : a. montrer S_n(x) = 1/x − (−1)^{n+1}(x − 1)^{n+1}/x ; b. en déduire
     que pour tout n ∈ ℕ*, ln 2 − v_n = (−1)^{n+1}[ln 2 − (n + 1)u_n]. (Puis) montrer que (v_n) est
     convergente et calculer sa limite.
- **Ex. 28** (p.155–156) : repère (O, i⃗, j⃗). **I/** 1. g sur [1, +∞[ par g(x) = x ln x − x + 1 :
  a. tableau de variation ; b. signe de g(x) pour x ∈ [1, +∞[. 2. f(x) = (x − 1)/ln x si x ∈ ]1, +∞[,
  1 si x = 1 — montrer que f est continue à droite en 1. 3. a. pour tout t ∈ [1, +∞[, t − 1 − (t − 1)² ≤
  1 − 1/t ≤ t − 1 ; b. en déduire que pour tout x ∈ [1, +∞[, (x − 1)²/2 − (x − 1)³/3 ≤ x − 1 − ln x ≤
  (x − 1)²/2 ; c. déterminer lim_{x→1⁺} (x − 1 − ln x)/(x − 1)² ; d. en déduire que f est dérivable à
  droite en 1 et f′_d(1) = 1/2. 4. a. tableau de variation de f ; b. tracer la courbe C (nature de la
  branche infinie précisée). **II/** F sur [1, +∞[ par F(x) = ∫*x^{x²} 1/ln t dt si x ∈ ]1, +∞[, ln 2
  si x = 1 ; C′ courbe de F. 1. a. pour tout x ∈ ]1, +∞[ et tout t ∈ [x, x²], x/(t ln t) ≤ 1/ln t ≤
  x²/(t ln t) ; b. en déduire x ln 2 ≤ F(x) ≤ x² ln 2 ; c. F continue en 1. 3. a. F dérivable sur
  ]1, +∞[ et F′(x) = f(x) ; b. pour x ∈ ]1, +∞[, il existe c ∈ ]1, x[ tel que F(x) − F(1) =
  (x − 1)F′(c) ; c. en déduire que F est dérivable à droite en 1 et F′*d(1) = 1. 4. tableau de variation
  de F, tracer C′. **III/** α ∈ ]1, +∞[, 𝒜(α) aire limitée par C et y = 0, x = 1, x = α. 1. montrer que
  pour tout x ∈ ]1, +∞[, F(x) = ∫₁ˣ f(t)dt + ln 2. 2. en déduire lim*{α→+∞} 𝒜(α)/α et
  lim*{α→+∞} 𝒜(α)/α². (Numérotation source : dans II/ la numérotation saute de 1 à 3, sans « 2 » [sic] ; I/ est bien numérotée 1-2-3-4.)
- **Ex. 29** (p.156) : **I/** 1. h sur ]0, +∞[ par h(x) = x − ln x : a. dresser le tableau de variation
  de f [sic pour h] ; b. en déduire que pour tout x ∈ ]0, +∞[, h(x) ≥ 1. 2. f sur [0, +∞[ par f(x) =
  1/(x − ln x) si x > 0, 0 si x = 0 : a. f continue sur [0, +∞[ ; b. f dérivable à droite en 0 ? **II/**
  F sur [0, +∞[ par F(x) = ∫_x^{2x} f(t)dt. 1. a. F dérivable sur [0, +∞[ ; b. pour x ∈ ]0, +∞[,
  F′(x) = (ln 2 − ln x)/(h(2x)·h(x)) et F′_d(0) = 0. 2. pour x ∈ ]0, +∞[, ∫*x^{2x} dt/t = ln 2. 3. pour
  x ∈ [1, +∞[, 0 ≤ F(x) − ln 2 ≤ ln(2x)/(x − ln x) ; en déduire lim*{x→+∞} F(x). 4. a. montrer
  F(1/2) ≤ ln 2 ; b. en déduire qu'il existe un réel α de [1/2, 1] tel que F(α) = ln 2. 5. a. tableau de
  variation de F ; b. allure de la courbe de F dans (O, i⃗, j⃗) (« On donne F(1) ≈ 0.9 et F(2) ≈ 1.1 »).
- **Ex. 30** (p.156–157) : **III/** [préambule commun p.156–157] n désigne un entier naturel non nul.
  1. (v_n) par v_n = ∫*{1/n}^1 t/(t − ln t) dt, n ≥ 1 : a. pour tout t ∈ ]0, +∞[, t/(t − ln t) ≤ t ;
     b. (v_n) croissante ; c. (v_n) convergente et 0 ≤ lim v_n ≤ 1/2. 2. (w_n) par w_n = ∫₁ⁿ t/(t − ln t) dt,
     n ≥ 1 : a. pour tout t ∈ [1, +∞[, t/(t − ln t) ≤ 1 + ln t ; b. calculer ∫₁ⁿ (1 + ln t)/t dt ; c. en
     déduire lim*{n→+∞} w_n. **[Exercice 30]** **A/** f sur [2, +∞[ par f(x) = ln(x + √(x² − 4)) ; C_f dans
     (O, i⃗, j⃗). 1. a. f dérivable sur ]2, +∞[, calculer f′(x) ; b. montrer lim_{x→2⁺} (f(x) − f(2))/(x − 2)
     = +∞ ; c. tableau de variation de f. 2. a. position de C_f et de D : y = x ; b. construire C_f.
  2. a. f réalise une bijection de [2, +∞[ sur un intervalle J ; b. construire la courbe C′ de f⁻¹.
     **B/** F sur ]0, 1] par F(x) = ∫₂^{2/x} f(t)dt. 1. F dérivable sur ]0, 1], calculer F′(x). 2. a. pour
     tout t ∈ [2, +∞[, f(t) ≥ ln t ; b. calculer ∫₂^{2/x} ln t dt ; c. en déduire que pour x ∈ ]0, 1],
     F(x) ≥ (2/x)(ln(2/x) − 1) ; d. calculer lim_{x→0⁺} F(x). 3. tableau de variation de F, allure de la
     courbe de F. **C/** pour x ∈ ]2, +∞[ et n ∈ ℕ, g_n(x) = ∫*{2√2}^x t^{2n}/√(t² − 4) dt et
     ℓ_n = lim*{x→2⁺} g_n(x). 1. justifier l'existence de g_n(x) pour x ∈ ]2, +∞[. 2. calculer g₀(x), en
     déduire ℓ₀. 3. montrer g₁(x) = (1/2)x√(x² − 4) − 2√2 + 2g₀(x), en déduire ℓ₁. 4. a. pour x ∈ ]2, +∞[
     et n ∈ ℕ, g_{n+1}(x) = x^{2n+1}√(x² − 4) − 2^{3n+2}√2 − (2n + 1)∫*{2√2}^x t^{2n}√(t² − 4) dt ; b. en
     déduire (2n + 2)g*{n+1}(x) = x^{2n+1}√(x² − 4) − 2^{3n+2}√2 + 4(2n + 1)g_n(x) ; c. exprimer ℓ_{n+1} à
     l'aide de ℓ_n. (Les parties III/ p.157 et **A/B/C** appartiennent au dernier problème de la rubrique ;
     la III/ « suites (v_n)/(w_n) » clôt l'exercice 29, et l'exercice 30 est le problème **A/B/C** ci-dessus.)

### Bornes de scope observées (chapitre 7)

- ✅ INCLUS : construction de ln comme **aire sous 1/t** puis comme **primitive de t ↦ 1/x s'annulant
  en 1** (ln x = ∫₁ˣ dt/t) ; ln′(x) = 1/x, stricte croissance, ln 1 = 0, existence et définition de **e**
  (ln e = 1, e ≈ 2.71828), bijection de ℝ*₊ sur ℝ ; **équations et inéquations** avec ln (dont
  ln a > ln b ⟺ a > b) ; **propriétés algébriques** ln(ab) = ln a + ln b, ln(a/b) = ln a − ln b,
  ln(1/b) = −ln b, ln(aᵖ) = p ln a, ln(ᵖ√a) = (1/p)ln a ; **limites** de référence (lim_{+∞} ln x = +∞,
  lim_{0⁺} ln x = −∞, lim_{+∞} (ln x)/x = 0, lim_{1} (ln x)/(x − 1) = 1) et **croissances comparées**
  lnⁿx/xᵐ → 0, xᵐ lnⁿx → 0 ; **tangente** en 1, tableau de variation et tracé de C ; **dérivation des
  composées** x ↦ ln(u(x)) et x ↦ ln|u(x)| (f′ = u′/u) ; **primitive de u′/u** (ln|u| + k) et
  **primitive de ln** (x ln x − x) ; applications : études de fonctions à ln, intégration par parties
  avec ln, **suites définies par une intégrale** faisant intervenir ln, encadrements et convergence
  (dont la constante d'Euler γ via Sₙ − ln n).
- ⛔ NON traité dans ce chapitre : la **fonction exponentielle** et exp comme réciproque de ln, aᵇ à
  exposant réel, ln comme réciproque de exp (chapitre 8) — ici e est défini uniquement par ln e = 1, et
  ln(aᵖ)/ln(ᵖ√a) restent limités aux exposants **entiers/rationnels 1/p** ; le **logarithme décimal
  log** (aucune section ni notation « log » dans ce chapitre — la notation décimale n'y figure pas) ;
  les **équations différentielles** (chapitre 9).

## 2.8 Chapitre 8 — Fonction exponentielle (manuel 222445, p.158–188)

**Page de garde (p.158)** — Titre : « Fonction exponentielle », Chapitre 8. Citation liminaire
tirée d'Euler (1748, _Introductio_ §110) : des questions d'accroissement de population (« Si le
nombre d'habitants d'une province s'accroît tous les ans d'une trentieme… ») et d'intérêts
composés (« Un particulier doit 400.000 florins… l'intérêt à 5 pour cent… »), puis « En appliquant
la formule du binôme, Euler dit sans la moindre hésitation, "Si N est un nombre plus grand qu'aucune
quantité assignable la fraction ((N−1)/N) égalera l'unité". […] si N tend vers l'infini,
(1 + 1/N)^N tend vers le nombre d'Euler e ». Référence donnée : « E. Haier [sic] et al, _L'analyse
au fil de l'histoire_, 2000 » (même coquille source que les chapitres 1 et 7 pour Ernst Hairer). Le
chapitre est structuré en parties numérotées **I, II, III, IV, V, VII, VIII** — la **numérotation
source saute de V à VII** (aucune partie « VI » n'existe dans le chapitre) [sic] —, suivies de deux
exercices résolus, d'un QCM / Vrai-Faux, puis d'une rubrique « Exercices et problèmes ».

### Cours — Activités

**I. Définition et propriétés** (p.159)

- **Activité 1** (p.159) : figure représentant ln. 1. donner graphiquement une valeur approchée de
  l'antécédent de 1/2 et de −√2/2. 2. montrer que ln : x ↦ ln x admet une fonction réciproque notée
  exp, tracer sa courbe. 3. ensemble de définition de exp et ses limites aux bornes. 4. que valent
  exp(0), exp(1), exp(2), exp(−1) ? 5. montrer que exp(n) = e^n pour n entier. 6. a. comparer
  exp(a + b) et exp(a)·exp(b), puis exp(a − b) et exp(a)/exp(b) ; b. montrer que pour tout n ∈ ℕ,
  exp(na) = (exp(a))^n, a ∈ ℝ.
- **Activité 2** (p.160) : utiliser une calculatrice pour une valeur approchée de e^(2/3), e^√3,
  e^(−√2/2).
- **Activité 3** (p.160) : simplifier e^(ln 1), e^(ln 2), e^(−ln 3), ln(e^−2), ln(e^(−2 ln 3)).
- **Activité 4** (p.160) : simplifier ⁶√(e²)·e^(3/2) ; (√(e³)/√(e^−4))·⁴√(e²) ;
  (√(e^30)/√(e^−42))·¹⁰√(e^−20).
- **Activité 5** (p.160) : résoudre dans ℝ : 1. e^x = 3 ; 2. ln x = 3 ; 3. e^(2x+3) = 4 ; 4. e^(2x+3) = e ; 5. (e^x − 1)(e^x − 2) = 0 ; 6. e^(2x) + e^x − 3 = 0.
- **Activité 6** (p.161) : x > 0, u_n = (1 + x/n)^n (n > 0). Calculer lim_{n→+∞} ln u_n et en déduire
  lim_{n→+∞} u_n.

**II. Étude de la fonction exponentielle** (p.161)

- **Activité 1** (p.161) : C courbe de exp dans (O, i⃗, j⃗). 1. lim_{−∞} e^x et lim_{+∞} e^x. 2. X = e^x : a. montrer e^x/x = X/ln X ; b. en déduire lim_{x→+∞} e^x/x, interpréter graphiquement. 3. a. dérivabilité de exp sur ℝ et fonction dérivée ; b. lim_{x→0} (e^x − 1)/x ; c. tableau de
  variation. 4. intersection de C avec les axes. 5. a. tangente T à C au point d'abscisse 0 ;
  b. h(x) = e^x − x − 1, variations, position relative de C et T. 6. tracer C et T.
- **Activité 2** (p.162) : déterminer les fonctions dérivables sur ℝ vérifiant (E) : f′(x) = f(x).
  1. exp vérifie (E). 2. f vérifie (E), h(x) = e^−x f(x) : h dérivable sur ℝ et h′(x) = 0.
  2. en déduire l'ensemble des fonctions vérifiant (E).
- **Activité 3** (p.162) : résoudre dans ℝ 1. e^(3x) ≤ e^(x²) ; 2. e^(3x) ≤ 4 e^x ; 3. e^(x(x−1)) > 1.
- **Activité 4** (p.162) : figure de f : x ↦ e^x avec une tangente T passant par l'origine.
  1. coordonnées du point de contact A entre C_f et T. 2. montrer que la tangente à C_f au point
     d'abscisse (n + 1) passe par le point (n, 0), n entier naturel.

**III. Limites usuelles** (p.162)

- **Activité 1** (p.162) : f(x) = x e^x, C_f dans (O, i⃗, j⃗). 1. nature de la branche infinie en
  +∞. 2. a. lim_{t→+∞} t/e^t ; b. en déduire lim_{x→−∞} x e^x, interpréter. 3. tableau de variation. 4. point d'inflexion I. 5. tracer C_f en précisant la tangente T en I.
- **Activité 2** (p.163) : n ∈ ℕ*, f_n sur ℝ*₊ par f_n(x) = e^x − Σ_{k=0}^n x^k/k!. 1. par
  récurrence sur n, f_n(x) ≥ 0 pour x > 0. 2. a. pour n, m entiers non nuls, lim_{x→+∞} e^(nx)/x^m =
  +∞ ; b. calculer lim_{x→−∞} |x^m e^(nx)|.
- **Activité 2** (p.163) [_deuxième « Activité 2 » — la numérotation source répète le libellé, aucune
  « Activité 3 » ne l'introduit_ [sic]] : calculer lim_{+∞}(x² − e^(2x)) ; lim_{+∞}(x⁴ − x)e^x ;
  lim_{+∞} x(e^(2x) − e^x + 1) ; lim_{−∞} x(e^(2x) − e^x) ; lim_{+∞} √x/e^x ;
  lim_{−∞} x + 1 + 1/(e^x + 1) ; lim_{+∞} e^x/(x³ + 1) ; lim_{+∞} e^x/(x² − x + 1).
- **Activité 3** (p.163) : f(x) = ½x² − e^x, C_f dans (O, i⃗, j⃗). 1. variations. 2. a. C_f coupe
  l'axe des abscisses en un seul point d'abscisse α, −1 < α < 0 ; b. valeur approchée de α à 10⁻¹. 3. a. point d'inflexion I ; b. tangente à C_f en I. 4. tracer C_f. 5. aire limitée par C_f, l'axe
  des abscisses, x = 0 et x = 1.

**IV. La fonction x ↦ e^(u(x))** (p.164)

- **Activité 1** (p.164) : étudier et représenter x ↦ e^(2x).
- **Activité 2** (p.164) : dériver x ↦ √x e^√x ; x ↦ (2x + 1)e^(−3x) ; x ↦ (e^(2x) + 1)/(2e^(2x) + 3) ;
  x ↦ x³ e^(3x).
- **Activité 3** (p.164) : primitives sur ℝ de x ↦ e^(−3x) ; x ↦ x e^(x²) ; x ↦ (2x + 1)e^(x²+x) ;
  x ↦ sin x · e^(cos x).
- **Activité 4** (p.164) : calculer ∫₀¹ e^x/(e^x + 1)² dx ; ∫₀¹ x e^(x²) dx ; ∫₀¹ x e^x dx ;
  ∫₀¹ x e^(−x+1) dx.
- **Activité 5** (p.165) : f : x ↦ e^(−x²), C_f dans un repère orthonormé. 1. étudier f, représenter
  C_f. 2. montrer que pour x ≥ 1/2, x² ≥ ½x. 3. pour α > 1/2, A(α) = aire limitée par C_f, l'axe des
  abscisses, x = α et x = 1/2. a. montrer A(α) ≤ ∫*{1/2}^α e^(−½x) dx ; b. en déduire que α ↦ A(α)
  admet une limite finie L quand α → +∞. 4. pour α ≥ 1, ∫*{1/2}^1 e^−x dx ≤ A(α). 5. encadrement de L.
- **Activité 6** (p.165) : I_n = ∫₀¹ x^n e^−x dx (n ∈ ℕ*). 1. a. 0 ≤ I_n ≤ 1/(n + 1) ; b. lim I_n. 2. pour n ≥ 2, I_n = n I_{n−1} − 1/e. 3. I_n = (n!/e)[e − Σ_{k=0}^n 1/k!]. 4. en déduire
  e = lim_{n→+∞} Σ_{k=0}^n 1/k!.

**V. Exponentielle de base a** (p.165)

- **Activité 1** (p.165) : 1. calculer e^(3 ln 2), e^(4 ln(3/2)), e^(−2 ln(1/3)), e^(−2 ln √2). 2. vérifier que pour a > 0 et tout entier n, a^n = e^(n ln a).
- **Activité 2** (p.166) : p, q entiers avec q ≥ 2, a > 0. Montrer a^(1/q) = q√a ; a^(p/q) = q√(a^p).
- **Activité 3** (p.166) : résoudre dans ℝ 2^x = 1/2 ; 10^(x+1) = 2^(−x+2) ; (√2)^x = 2^(−x+1).
- **Activité 4** (p.166) : f : x ↦ e^(x ln 2) et g : x ↦ e^(−x ln 2), C_f et C_g. 1. étudier et
  représenter f. 2. le symétrique de A(a, f(a)) ∈ C_f par rapport à l'axe des ordonnées est un point
  de C_g. 3. C_f et C_g symétriques par rapport à l'axe des ordonnées.
- **Activité 5** (p.167) : graphique de C₁ et C₂, courbes de f_{b₁} : x ↦ (b₁)^x et
  f_{b₂} : x ↦ (b₂)^x. Déterminer les réels strictement positifs b₁ et b₂.
- **Activité 6** (p.168) : déterminer lim_{+∞} 2^(x²−2x) ; lim_{−∞} 2^(x²−2x) ; lim_{−∞} (1/2)^(3−2x).

**VII. Fonctions puissances** (p.168) [_la numérotation source passe directement de V à VII, sans
« VI »_ [sic]]

- **Activité 1** (p.168) : figure représentant x ↦ x⁴, x ↦ x⁵, x ↦ x^−4, x ↦ x^−5 (x > 0) —
  identifier chacune des fonctions.
- **Activité 2** (p.168) : figure représentant x ↦ ³√x et x ↦ ³√(1/x) — identifier chacune.
- **Activité 3** (p.168) : f sur ℝ*₊ par f(x) = √(x³). 1. montrer que pour x > 0, f(x) = e^((3/2)ln x). 2. étudier et représenter f. 3. bijection strictement croissante de ℝ*₊ sur ℝ*₊. 4. déterminer f⁻¹.
- **Activité 4** (p.169) : f sur ℝ₊ par f(x) = ⁿ√x, n ≥ 2. Montrer que pour x > 0, f(x) = x^(1/n).
- **Activité 5** (p.169) : calculer lim_{+∞} x^(2/3) ; lim_{0⁺} x^(2/3) ; lim_{+∞} x^(−4/3) ;
  lim_{0⁺} x^(−4/3).
- **Activité 6** (p.169–170) : f, g sur ℝ₊ par f(x) = x^(2/3) si x > 0, 0 si x = 0 ; g(x) = x^(10/3)
  si x > 0, 0 si x = 0. 1. a. f, g continues sur ℝ₊ ; b. dérivabilité à droite en 0. 2. étudier et
  représenter f et g. 3. (p.170) aire limitée par C_f, C_g, x = 1 et x = 2. 4. bijections strictement
  croissantes, déterminer leurs réciproques.

**VIII. Croissances comparées** (p.170)

- **Activité 1** (p.170) : f : x ↦ (ln x)², g : x ↦ √x. 1. signe de f′(x) − g′(x). 3. comparer f(x)
  et g(x) [_la numérotation source saute de 1 à 3, sans « 2 »_ [sic]]. 4. h : x ↦ x², t : x ↦ √(e^x) ;
  comparer h(x) et t(x).
- **Activité 2** (p.171) : 1. montrer (1 + x)^(−3/4) ≤ x^(−3/4) pour x > 0. 2. comparer
  (1 + x)^(1/4) et 1 + x^(1/4) pour x > 0.
- **Activité 3** (p.171) : r rationnel > 0, f : x ↦ (1 + x)^r. 1. ensemble de définition. 2. si
  0 < r < 1, comparer (1 + x)^r et 1 + rx. 3. reprendre pour r > 1. 4. représenter f pour r = 1/3
  puis r = 5/3.
- **Activité 4** (p.171) : 1. variations de f : x ↦ (ln x)/x. 2. en déduire les variations de
  g : x ↦ x^(1/x). 3. représenter g.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Définition — fonction exponentielle** (p.159) — « On appelle fonction exponentielle la fonction
> réciproque de la fonction logarithme népérien. L'image d'un réel x par la fonction exponentielle
> est noté [sic] e^x. »

> **Conséquences** (p.159) — « • Pour tout réel x et pour tout réel strictement positif y, y = e^x
> ⟺ x = ln y. • Pour tout réel x, ln(e^x) = x. • Pour tout réel x > 0, e^(ln x) = x. • ln e = 1. »

> **Propriétés** (p.160) — « Soit deux réels a et b. P₁ : e^(a+b) = e^a × e^b, e^(a−b) = e^a/e^b,
> e^−a = 1/e^a. P₂ : Pour tout entier n, e^(na) = (e^a)^n. P₃ : Pour tout entier naturel q ≥ 2,
> e^(a/q) = q√(e^a). P₄ : Pour tout entier naturel q ≥ 2 et tout entier p, e^((p/q)a) = q√(e^(pa)). »

> **Théorème** (p.161) — « • lim_{x→−∞} e^x = 0, lim_{x→+∞} e^x = +∞, lim_{x→+∞} e^x/x = +∞,
> lim_{x→0} (e^x − 1)/x = 1. • La fonction exponentielle est dérivable sur ℝ et sa fonction dérivée
> est la fonction x ↦ e^x. La fonction exponentielle est strictement croissante sur ℝ. • La fonction
> exponentielle est bijective de ℝ sur ℝ*₊ et pour tout réel x, e^x > 0. »

> **Théorème** (p.163) — « Soit m et n deux entiers naturels non nuls, lim_{x→+∞} e^(nx)/x^m = +∞,
> lim_{x→−∞} x^m e^(nx) = 0. »

> **Théorème** (p.164) — « Soit u une fonction dérivable sur un intervalle I. La fonction
> h : x ↦ e^(u(x)) est dérivable sur I et h′(x) = u′(x)e^(u(x)), x ∈ I. »

> **Corollaire** (p.164) — « Soit u une fonction dérivable sur un intervalle I. Les primitives sur I
> de la fonction x ↦ u′(x)e^(u(x)) sont les fonctions x ↦ e^(u(x)) + k, k ∈ ℝ. »

> **Encadré — puissance à exposant réel** (p.166) — « Soit un réel a > 0. Pour tout réel b, on pose
> a^b = e^(b ln a). »

> **Propriétés** (p.166) — « Pour tous nombres réels strictement positifs a et b et tous réels c et
> d, a^(c+d) = a^c × a^d ; (a^c)^d = a^(cd) ; a^(c−d) = a^c/a^d ; a^c × b^c = (ab)^c ;
> a^c/b^c = (a/b)^c. »

> **Définition — exponentielle de base a** (p.166) — « Soit un réel a > 0. On appelle fonction
> exponentielle de base a la fonction x ↦ a^x. »

> **Conséquences** (p.166–167) — « Soit un réel a > 0. La fonction x ↦ a^x est dérivable sur ℝ et sa
> fonction dérivée est la fonction x ↦ (ln a)a^x. La fonction x ↦ a^x est strictement croissante sur
> ℝ si a > 1. La fonction x ↦ a^x est strictement décroissante sur ℝ si 0 < a < 1. La fonction
> x ↦ 1^x est une fonction constante. Si a > 1 alors lim_{x→+∞} a^x = +∞ ; lim_{x→−∞} a^x = 0. Si
> 0 < a < 1 alors lim_{x→+∞} a^x = 0 ; lim_{x→−∞} a^x = +∞. » (Suivi du tableau de variation selon
> a > 1 / 0 < a < 1 et des courbes représentatives pour a = 0.5, 0.2, e, 2, p.167.)

> **Notation** (p.169) — « Pour tout rationnel r et tout x > 0, on note e^(r·ln x) = x^r. »

> **Définition — fonction puissance** (p.169) — « Soit r un rationnel. On appelle fonction puissance
> r la fonction x ↦ e^(r·ln x), x > 0. »

> **Encadré — limites des fonctions puissances** (p.169) — « Si r > 0 alors lim_{x→+∞} x^r = +∞ ;
> lim_{x→0⁺} x^r = 0. Si r < 0 alors lim_{x→+∞} x^r = 0 ; lim_{x→0⁺} x^r = +∞. »

> **Théorème** (p.169) — « Soit r un rationnel. La fonction x ↦ x^r est dérivable sur ℝ*₊ et sa
> dérivée est la fonction x ↦ r x^(r−1). »

> **Corollaire** (p.169) — « Soit r un rationnel différent de −1. Les primitives sur ℝ*₊ de la
> fonction x ↦ x^r sont les fonctions x ↦ (1/(r + 1))x^(r+1) + k, k ∈ ℝ. »

> **Théorème** (p.170) — « Soit r un rationnel strictement positif. lim_{x→+∞} (ln x)/x^r = 0 ;
> lim_{x→0⁺} x^r ln x = 0 ; lim_{x→+∞} e^x/x^r = +∞. »

### Cours — Exercices résolus (p.171–175)

**Exercice résolu 1** (énoncé p.171, solution intégrale p.172–173) : f définie sur ℝ par
f(x) = √|x − 1| · e^(1/x) si x ≠ 0, f(0) = 0 ; C_f dans (O, i⃗, j⃗). Traite : 1. a. dérivabilité de f
en tout réel ≠ 0 et ≠ 1 ; b. continuité en 0 et en 1 (f non continue en 0 — limite à droite +∞) ;
c. non-dérivabilité en 1 ; d. dérivabilité à gauche en 0, f′_g(0) = 0. 2. a. ln(f(x)) =
½ ln|x − 1| + 1/x et f′(x)/f(x) = ½(1/(x − 1)) − 1/x² ; b. signe de f′(x) = celui de 2(x − 1)x². 3. limites de f et de f(x)/x en ±∞ (branches paraboliques de direction (O, i⃗)). 4. tableau de
variation (f décroissante sur ]−∞, 0[ et ]0, 1[, croissante sur ]1, +∞[) et tracé.

**Exercice résolu 2** (énoncé p.173–174, solution intégrale p.174–175) : préliminaires

1. a. e^−t(1 + t) ≤ 1 pour t ≥ 0 ; b. variations de u(t) = (e^−t − 1)/t sur ℝ*₊ (croissante).
2. F sur [0, +∞[ par F(x) = ∫_x^{2x} (e^−t/t) dt si x > 0, F(0) = ln 2 : a. F(x) =
   ∫_x^{2x} (e^−t − 1)/t dt + ln 2 ; b. encadrement e^−x − 1 ≤ ∫ … ≤ (e^−2x − 1)/2 ; c. continuité en 0.
3. e^−2x ln 2 ≤ F(x) ≤ e^−x ln 2, lim_{+∞} F = 0. 4. dérivabilité à droite en 0, F′_d(0) = −1 ;
   dérivabilité sur ℝ*₊ (F(x) = G(2x) − G(x), G primitive de t ↦ e^−t/t), F′(x) = e^−x(e^−x − 1)/x < 0.
4. tableau de variation (F décroissante de ln 2 vers 0), courbe de F : asymptote y = 0 en +∞,
   demi-tangente de coefficient directeur −1 à l'abscisse 0.

### QCM (p.176) — « Cocher la réponse exacte. »

1. Le réel e^(−3 ln(1/2)) est égal à (☐ −1/8 / ☐ 8 / ☐ −6).
2. Le réel 2e^(x+y) est égal à (☐ e^(2x+2y) / ☐ e^(2x)e^(2y) / ☐ 2e^x e^y).
3. L'équation e^x = 1/e est équivalente à (☐ x = −1 / ☐ x = ln e / ☐ x = e).
4. L'inéquation −2 < e^(x²−1) < 1 est équivalente à (☐ e^(x²−1) > 0 / ☐ x² > 1 / ☐ −1 < x < 1).
5. f sur ℝ* par f(x) = 2e^x/x⁴ − 1/x² : (☐ lim_{+∞} f(x) = 0 / ☐ = 2 / ☐ = +∞).
6. Sur ℝ*₊ la dérivée de f : x ↦ e^x/x est (☐ f′(x) = e^x / ☐ f′(x) = (x − 1)/(x²e^−x) /
   ☐ f′(x) = e^x(x + 1)/x²).
7. L'intégrale ∫₀¹ x e^(x²) dx est égale à (☐ e − 1 / ☐ ½e / ☐ ½(e − 1)).

### Vrai ou faux (p.176) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. La fonction exponentielle est dérivable sur ℝ et égale à sa dérivée.
2. Pour tout x ∈ ℝ*₊, ln x < x < e^x.
3. r rationnel différent de 1 : la fonction x ↦ x^(r+1) est une primitive de x ↦ x^r sur ]0, +∞[.
4. La fonction définie sur ℝ par f(x) = (e^x − 1)/(e^x + 1) est paire.
5. L'équation (e^x + e^−x)/2 = 1 est équivalente à e^x = 1.

### Exercices et problèmes (p.177–188) — 43 exercices

- **Ex. 1** (p.177) : 1. simplifier e^(5 ln 3), e^(−3 ln 2). 2. écrire plus simplement e^x·e^−2x,
  e·e^x, (e^−x)², e^x/e^−x, e^(2x)/e^(1−x), (e^x)⁴/e^(2x). 3. vérifier a. e^(2x) + e^(−2x) + 2 =
  (e^x + e^−x)² ; b. (e^x − e^−x)/(e^x + e^−x) = (e^(2x) − 1)/(e^(2x) + 1). 4. a. si 1 ≤ e^x ≤ 2 alors
  ¼ ≤ e^−2x ≤ 1 ; b. si 1 ≤ e^x ≤ 9 alors 2 ≤ 2 e^(x/2) ≤ 6.
- **Ex. 2** (p.177) : résoudre équations et inéquations 1. (x² − 5x + 4)e^x = 0 ; 2. e^(x/4) = 1/e ; 3. e^(3x) − e^−x = 0 ; 4. e^(2x) + e^x − 2 = 0 ; 5. e^x − 5e^−x + 4 = 0 ; 6. ln((x−1)/(x+1)) = 4 ; 7. e^−x ≤ 1 ; 8. e^(−3x) ≥ 0 ; 9. e^(2x) − 1/e^x ≥ 0 ; 10. 2 − e^(1/x) > 0 ; 11. e^x + 2/e^x − 3 ≤ 0.
- **Ex. 3** (p.177) : figure de C₁…C₄ (repère commun) — associer chaque fonction à sa courbe pour
  f : x ↦ −e^x, g : x ↦ e^−x, h : x ↦ 1/e^(2−x), k : x ↦ 1 + e^x.
- **Ex. 4** (p.177) : S_n = Σ_{k=0}^n 1/e^k. Montrer lim_{n→+∞} S_n = e/(e − 1).
- **Ex. 5** (p.177) : déterminer les limites de x² − e^x, e^(3x) − 2e^x, 2e^x − 1/x (en +∞) ;
  2e^x − 1/x, x e^(−(1−x)), (x² − 2x + 3)e^x (en −∞) ; (x² − x)e^x (en −∞), x e^(1/x) (en 0⁺),
  x³ − e^(2x) (en +∞) ; e^x/√(x + 1), (2x − e^x)/(x² + x) (en +∞), e^(−1/x)/x (en 0⁺) ;
  (e^x − 1)/x, x²(e^(2x) − e^x) (en +∞), (e^(2x) − 1)/x (en 0) ; x/(1 − e^−x) (en 0),
  (e^x − 1)/√(2x) (en 0⁺), x(e^(1/x) − 1) (en +∞) ; x(e^(1/x²) − 1) (en −∞),
  x(e^(1/x) − 1)/(e^(1/x) + 1) (en +∞) ; x²(e^(1/x) − e^(1/(x+1))) en +∞ puis en −∞.
- **Ex. 6** (p.178) : dérivée f′ sur I pour f : x ↦ 2x − e^−x (ℝ) ; x² + e^(1/x) (ℝ*₊) ;
  x e^−x (ℝ) ; (x − 1)/e^x (ℝ) ; (e^(2x) − 1)/(x² + 1) (ℝ) ; 2x − 2 ln(1 + e^x) (ℝ) ;
  e^x ln x (ℝ*₊) ; e^−x(e^(2x) + e^x − 1) (ℝ) ; (e^x − e^−x)/(e^x + e^−x) (ℝ).
- **Ex. 7** (p.178) : f(x) = (ax² + bx + c)e^−x, C dans (O, i⃗, j⃗) passant par A(0, 1), tangente
  parallèle à l'axe des abscisses au point d'abscisse 1, f′(0) = −6. Déterminer a, b, c.
- **Ex. 8** (p.178) : f(x) = (x + 1)² e^−x. 1. f′(x), f″(x). 2. montrer f^(n)(x) =
  (−1)^n(x² + a_n x + b_n)e^−x ; exprimer a_{n+1}, b_{n+1} en fonction de a_n, b_n. 3. a_n, b_n en
  fonction de n. 4. en déduire f^(100).
- **Ex. 9** (p.178) : primitive de f sur I pour f : x ↦ e^(2x) (ℝ) ; x e^(x²+1) (ℝ) ;
  e^(tan x)/cos²x (]−π/2, π/2[) ; sin(2x)e^(cos²x) (ℝ) ; (1/(x−1)²)e^(1/(x−1)) (]1, +∞[) ; √(e^x) (ℝ) ;
  e^(2x)/(1 + e^(2x)) (ℝ) ; (e^(2x) − 1)/(1 + e^(2x)) (ℝ) ; x e^(2x²) (ℝ).
- **Ex. 10** (p.178–179) : 1. calculer a. ∫₀¹(1 + e^x)dx ; b. ∫₀¹ x e^(x²) dx ; c. ∫₀¹ e^x/(1 + e^x) dx ;
  d. ∫₁² dx/(1 + e^x) ; e. ∫₀¹ (1/x)e^(ln x) dx ; f. ∫₁² e^−x/(1 + e^−x)² dx ; g. ∫₁² (1/x²)e^(1/x) dx. 2. par parties a. ∫₁² 2x e^−x dx ; b. ∫₀¹ x³/e^(x²) dx ; c. ∫₀^(−ln2) ln(1 + e^x)/e^x dx ;
  d. ∫₁⁰ x² e^x dx ; e. ∫₀^(π/2) e^−x sin x dx.
- **Ex. 11** (p.179) : 1. pour t > 0, t + 1/t ≥ 2. 2. en déduire e^(x/2) + e^(−x/2) ≥ 2 et
  ln(1 + e^x) ≥ x/2 + ln 2.
- **Ex. 12** (p.179) : 1. pour x ≥ 0, 0 ≤ e^x − 1 ≤ x e^x. 2. pour x ≥ 0, 0 ≤ e^x − 1 − x ≤ (x²/2)e^x.
- **Ex. 13** (p.179) : f(x) = (2 + e^x)/(1 + e^x). 1. trouver a, b tels que f(x) = a + b e^x/(1 + e^x). 2. calculer ∫₀¹ (2 + e^x)/(1 + e^x) dx.
- **Ex. 14** (p.179) : f : x ↦ x − 2 + e^(−x/2), C_f dans (O, i⃗, j⃗). 1. variations. 2. a. D : y = x − 2
  asymptote ; b. tracer D et C_f. 3. λ > 0, Δ : x = λ, A(λ) = aire limitée par C_f, D, Δ et l'axe des
  ordonnées ; calculer lim_{λ→+∞} A(λ).
- **Ex. 15** (p.179) : f : x ↦ (e^x − e^−x)/(e^x + e^−x), C_f dans (O, i⃗, j⃗). 1. parité. 2. a. variations ; b. tracer C_f. 3. λ > 1, Δ : x = λ, A(λ) = aire limitée par C_f, Δ, l'axe des
  abscisses et l'axe des ordonnées ; calculer A(λ).
- **Ex. 16** (p.179) : 1. a. e^x > 1 + x pour x non nul ; b. i. e^−x > 1 − x ; ii. e^x < 1/(1 − x)
  pour x ∈ ]0, 1[. 2. suites u_n = (1 + 1/n)^n, v_n = (1 + 1/n)^(n+1), n ≥ 1 : a. u_n < e < v_n ;
  b. sachant 2 < e < 3, v_n − u_n ≤ 3/n ; c. encadrement de e d'amplitude 10⁻⁶.
- **Ex. 17** (p.179–180) : 1. calculer A = ∫₀¹ e^x/(1 + e^x) dx et B = ∫₀¹ e^x/(1 + e^x)² dx. 2. déterminer a, b, c tels que pour t > 0, 1/(1 + t)² = a + bt/(1 + t) + ct/(1 + t)² ; en déduire
  I = ∫₀¹ 1/(1 + e^x)² dx. 3. J = ∫₀¹ x e^x/(1 + e^x)³ dx ; exprimer J en fonction de I, déduire J.
- **Ex. 18** (p.180) : 1. résoudre 2 − e^(1/x) > 0. 2. f : x ↦ ln(2 − e^(1/x)). a. ensemble de
  définition ; b. limites aux bornes ; c. prolongeable par continuité à gauche en 0 (prolongement g). 3. a. dérivabilité de g à gauche en 0 ; b. intervalles où g dérivable, g′(x). 4. variations de g,
  tracer C_g dans (O, i⃗, j⃗).
- **Ex. 19** (p.180) : a > 0, G_a : x ↦ e^(−ax²). 1. dérivable, dérivée. 2. tableau de variation. 3. dérivée seconde, deux points d'inflexion (coordonnées). 4. lieu des points d'inflexion quand a
  varie. 5. tracer G_a pour a = 1/2, 1 et 2.
- **Ex. 20** (p.180) : f(x) = |3x² − 1| e^(1−x²). 1. parité. 2. limite en +∞. 3. continuité. 4. dérivabilité en x = 1/√3. 5. tableau de variation. 6. représentation graphique.
- **Ex. 21** (p.180) : I_n = ∫₀^(π/2) e^(−nx) sin x dx, J_n = ∫₀^(π/2) e^(−nx) cos x dx. 1. I₀, J₀. 2. par parties, système { I_n + n J_n = 1 ; −n I_n + J_n = e^(−nπ/2) }. 3. I_n, J_n en fonction de
  n. 4. lim I_n, lim J_n.
- **Ex. 22** (p.180) : I_n = ∫*{nπ}^{(n+1)π} e^(−nx) sin x dx. 1. par deux parties,
  I_n = (−1)^n e^(−n²π)(1 + e^(−nπ))/(n² + 1). 2. lim*{n→+∞} I_n.
- **Ex. 23** (p.181) : I(n, m) = ∫₀¹ t^n(1 − t)^m dt, I(n, 0) = 1/(n + 1). 1. par parties,
  I(n, m) = (m/(n + 1)) I(n + 1, m − 1). 2. I(n, m) = (n! m!/(n + m)!) I(n + m, 0). Montrer
  I(n, m) = n! m!/(n + m + 1)!.
- **Ex. 24** (p.181) : suite u_0 = 1/2, u_{n+1} = e^(u_n)/(u_n + 2). 1. f(x) = e^x/(x + 2) sur [0, 1] :
  a. variations ; b. |f′(x)| ≤ e/4 ; c. f(x) = x admet une unique solution α dans [0, 1]. 2. 0 ≤ u_n ≤ 1. 3. a. f(x) − f(α) = ∫*α^x f′(v)dv ; b. |u*{n+1} − α| ≤ (e/4)|u_n − α| ; c. |u_n − α| ≤ ½(e/4)^n ;
  convergence vers α, valeur approchée à 10⁻¹.
- **Ex. 25** (p.181) : calculer lim_{+∞} (√3)^x ; lim_{+∞} (1/2)^(1−x) ; lim_{+∞} 2^x/2^(x²+x) ;
  lim_{−∞} (1/4)^x − (1/4)^(x+1) ; lim_{+∞} (3^x + 3^(x+1))/(2^x + 2^(x−1)) ; lim_{+∞} x^(1/3) − x^(2/3) ;
  lim_{+∞} ln(x)/2^x ; lim_{+∞} x^(1/3) e^−x ; lim_{0⁺} (x^(2/3) − x^(4/3)) ln x ; lim_{+∞} 2^x − e^x.
- **Ex. 26** (p.181) : f sur ]0, +∞[ par f(x) = ln(2^x) − ln(x²). 1. f(2), f(4). 2. variations, signe. 3. comparer x² et 2^x.
- **Ex. 27** (p.181) : f sur ℝ par f(x) = (3/5)^x + (4/5)^x − 1. 1. limites en ±∞. 2. sens de
  variation ; en déduire le nombre de solutions de 3^x + 4^x = 5^x.
- **Ex. 28** (p.182) : f sur ℝ* par f(x) = 4^x/(4^(2x) − 1). 1. impaire. 2. variations sur ]0, +∞[. 3. a. résoudre f(x) = 4/15 ; b. en déduire les solutions de f(x) = −4/15.
- **Ex. 29** (p.182) : intégrales 1. ∫₀¹ 3^x dx ; 2. ∫₀^(−1) 3^x/(1 + 3^x) dx ; 3. ∫₀^(1/ln 2) 2^x(1 + 2^x)² dx ; 4. ∫₁² x^(4/3) dx ; 5. ∫*{1/2}¹ 4 x^(−1/5) dx ; 6. ∫₀¹ ⁴√x dx ; 7. ∫*{1/2}¹ (3x − 1)^(3/2) dx.
- **Ex. 30** (p.182) : I = ∫₀^(π/2) 2^x cos²(x) dx, J = ∫₀^(π/2) 2^x sin²(x) dx. 1. I + J =
  (√(2^π) − 1)/ln 2. 2. K = ∫₀^(π/2) 2^x cos(2x) dx ; par deux parties, K = −(ln 2/2)[(√(2^π) + 1)/2 +
  (ln 2/2)K] ; en déduire I − J. 3. valeurs de I et J.
- **Ex. 31** (p.182) : 1. f : x ↦ x^−α sur ]0, +∞[, α rationnel > 1 ; variations. 2. S_n =
  Σ_{k=1}^n 1/k^α, n ≥ 1 ; pour x ∈ [k, k + 1], 1/(k + 1)^α ≤ ∫_k^{k+1} f(x)dx ≤ 1/k^α. 3. a. ∫₁^{n+1} f(x)dx ≤ S_n ≤ S₁ + ∫₁^n f(x)dx ; b. (S_n) croissante et majorée ; c. convergente,
  encadrement de la limite ; d. déterminer α tel que (S_n) converge vers un réel compris entre 2007 et 2008.
- **Ex. 32** (p.182–183) : **A/** f sur ℝ par f(x) = 1 + x − e^(−x/2). 1. a. limites en ±∞ ;
  b. D : y = x + 1 asymptote en +∞ ; c. position C_f/D. 2. a. f′(x), signe ; b. tableau de variation. 3. tracer C_f et D (2 cm). **B/** n > 0, A_n = aire limitée par D, C_f, x = n, x = n + 1.
  1. A_n en fonction de n. 2. (A_n) géométrique (raison q, premier terme A₁). 3. S_n = A₁ + … + A_n
     (interprétation graphique). 4. lim_{n→+∞} S_n.
- **Ex. 33** (p.183) : f sur [0, +∞[ par f(x) = √x e^(1−x), C dans (O, i⃗, j⃗). 1. lim_{+∞} f(x),
  interpréter. 2. a. dérivable sur ]0, +∞[, f′(x) ; b. dérivabilité à droite en 0 (interprétation
  graphique). 3. tableau de variation. 4. tracer C. 5. f(x) = 1 a deux solutions α ∈ ]0, 1/2[ et
  β ∈ ]1/2, +∞[ ; encadrement de α d'amplitude 10⁻².
- **Ex. 34** (p.183) : **A/** g sur ℝ par g(x) = 2e^x − x − 2. 1. limites en ±∞. 2. variations. 3. g(x) = 0 admet exactement deux solutions 0 et α, −1.6 ≤ α ≤ −1.5. 4. signe de g. **B/** f sur ℝ
  par f(x) = e^(2x) − (x + 1)e^x. 1. limites en ±∞. 2. f′(x) de même signe que g(x) ; variations. 3. f(α) = −(α² + 2α)/4, encadrement de f(α). 4. tableau de variation. 5. tracer C dans (O, i⃗, j⃗). 6. m réel négatif : a. ∫_m^0 x e^x dx ; b. ∫*m^0 f(x)dx ; c. lim*{m→−∞} ∫_m^0 f(x)dx.
- **Ex. 35** (p.183–184) : **A/** φ sur ℝ par φ(x) = (x² + x + 1)e^−x − 1. 1. limites en ±∞. 2. variations, tableau. 3. φ(x) = 0 admet deux solutions dans ℝ, dont α ∈ [1, +∞[ (encadrement
  d'amplitude 10⁻²). 4. signe de φ(x). **B/** f, g sur ℝ par f(x) = (2x + 1)e^−x,
  g(x) = (2x + 1)/(x² + x + 1), C_f et C_g. 1. passent par A(0, 1), même tangente en A. 2. a. f(x) − g(x) = (2x + 1)φ(x)/(x² + x + 1) ; b. signe ; c. position relative. 3. a. F(x) =
  −(2x + 3)e^−x, F′(x) = f(x) ; b. primitive sur ℝ de f − g s'annulant en 0.
- **Ex. 36** (p.184) : **A/** f sur ℝ par f(x) = e^−x ln(1 + e^x). 1. g sur [0, +∞[ par
  g(t) = t/(1 + t) − ln(1 + t) ; variations, signe. 2. a. dérivable, f′(x) = e^−x[e^x/(1 + e^x) −
  ln(1 + e^x)] ; b. sens de variation. 3. a. f(x) = x e^−x + e^−x ln(1 + e^−x) ; b. lim en +∞ ;
  c. lim en −∞. **B/** suite u_0 = 0.5, u_{n+1} = f(u_n). 1. a. f(x) = x a une seule solution α,
  0.5 ≤ x ≤ 0.6 ; b. 0.5 ≤ f(x) ≤ 0.6 et −0.25 ≤ f′(x) ≤ 0. 2. a. |u_{n+1} − α| ≤ 0.25|u_n − α| ;
  récurrence |u_n − α| ≤ (0.25)^n × 0.1 ; b. convergence vers α ; c. n₀ tel que |u_n − α| ≤ 5×10⁻⁴.
  **C/** primitive de f : 1. f′(x) + f(x) = e^−x/(1 + e^−x) ; 2. en déduire une primitive F de f.
- **Ex. 37** (p.184–185) : parties A et B indépendantes. **Partie A** : f_n sur [0, +∞[ par
  f_n(x) = (Σ_{k=0}^n x^k/k!)e^−x, n > 0. 1. a. dérivable, f′(x) ; b. lim_{+∞} f_n(x) ; c. sens de
  variation. 2. a. −1/n! ≤ f′_n(x) ≤ 0 pour x ∈ [0, 1] ; b. −1/n! ≤ f_n(x) − 1 ≤ 0. 3. limite de
  Σ_{k=0}^n 1/k! quand n → +∞. **Partie B** : u_n = (1 − 1/n)^n, a_n = ln(u_n), n ≥ 2.
  1. a_n = −ln(1 + (−1/n))/(−1/n). 2. (a_n) convergente. 3. limite de (u_n).
- **Ex. 38** (p.185) : f sur ℝ par f(x) = (3e^x − 1)/(e^x + 1), C dans (O, i⃗, j⃗). **A/** 1. a.
  A(0, 1) centre de symétrie ; b. limites en ±∞, interpréter ; c. f′(x), sens de variation. 2. a. tangente Δ en A ; b. g(x) = f(x) − f(x + 1), g′(x) = −((e^x − 1)/(e^x + 1))² ; sens de
  variation de g (g(0)) ; en déduire la position de C et Δ. 3. tracer C et Δ.
- **Ex. 39** (p.185–186) : **A/** g sur ]0, +∞[ par g(x) = e^x − ln(x) − x e^x + 1. 1. lim en 0. 2. lim en +∞. 3. variations, tableau. 4. g(x) = 0 admet une unique solution α. 5. α ∈ ]1.23, 1.24[
  (_). 6. signe de g(x). **B/** f sur [0, +∞[ par f(x) = x/(e^x − ln(x)) si x > 0, 0 si x = 0 ; C dans
  (O, i⃗, j⃗). 1. continuité en 0. 2. dérivabilité en 0. 3. lim en +∞, interpréter. 4. f′(x) de même
  signe que g(x), variations. 5. f(α) = 1/(e^α − 1/α). **C/** 1. variations de h sur ]0, +∞[ par
  h(x) = 1/(e^x − 1/x). 2. via (_), encadrement de f(α) ; 0.38 valeur approchée de f(α) à 10⁻². 3. tracer C, tangentes aux abscisses 0 et α.
- **Ex. 40** (p.186) : **A/** f sur ℝ par f(x) = ½x + ((1 − x)/2)e^(2x). 1. a. limites en ±∞ ;
  b. Δ : y = ½x asymptote ; c. position Δ/C. 2. f dérivable, f′(x). 3. u(x) = 1 + (1 − 2x)e^(2x) :
  a. sens de variation ; b. u(x) = 0 admet une unique solution α dans [0, 1] ; c. valeur approchée
  décimale par excès à 10⁻² ; d. signe de u(x). 4. tableau de variation, tracer C. **B/** C′ : y = e^x,
  Δ′ : y = x. 1. M_t point de C′ d'abscisse t, tangente T coupe l'axe des ordonnées en N_t ; coordonnées
  de N_t. 2. P_t point de Δ′ d'abscisse t, G_t barycentre de (O, 1), (M_t, 1), (P_t, 1), (N_t, 1) :
  a. placer M_{−2}, P_{−2}, N_{−2}, construire G_{−2} ; b. coordonnées de G_t. 3. ensemble des points
  G_t quand t décrit ℝ. **C/** 1. construire C. 2. aire limitée par C, Δ, x = 0 et y = 0.
- **Ex. 41** (p.186–187) : f sur [0, +∞[ par f(x) = (x + 1)e^(−1/x) si x > 0, 0 si x = 0 ; C dans
  (O, i⃗, j⃗). 1. étude des variations : a. f′(x) = e^(−1/x) Q(x), Q rationnelle ; b. lim (1 + t)e^−t en
  +∞ ; f dérivable à droite en 0, f′_d(0) ; c. sens de variation ; d. lim f(x) en +∞ ; e. f(x) = 2
  admet une unique solution α (encadrement à 10⁻¹). 2. fonction auxiliaire φ(t) = 1 − (1 + t)e^−t :
  a. dérivée ; b. 0 ≤ φ(t) ≤ 1/t². 3. 0 ≤ x − f(x) ≤ 1/(2x) ; asymptote D en +∞, position de C/D. 4. a > 0, T_a tangente à C au point d'abscisse a/(1 + a + a²) : a. équation de T_a ; b. intersection
  avec l'axe des abscisses. 5. construire C et D (points d'abscisses 1/3, 1, 3).
- **Ex. 42** (p.187) : k ≤ 0, f_k sur ]0, +∞[ par f_k(x) = ((kx + 1)/x)e^x. 1. limites en 0 et +∞. 2. f′_k(x) ; nombre de solutions de f′*k(x) = 0. 3. courbes f*{−1}, f_{−0.25}, f_0 — identifier. 4. a > 0, A(a) = ∫_a^{a+1} f_0(x)dx : a. que représente A(a) ? ; b. sens de variation de a ↦ A(a) ;
  c. déterminer a pour que l'aire (limitée par C_0, l'axe des abscisses, x = a et x = a + 1) soit
  minimale.
- **Ex. 43** (p.188) : **A/** 1. (E) : x + ln x = 0 admet une unique solution α dans ]1/3, 2/3[. 2. φ(x) = e^(1/x) : a. φ(x) = x ⟺ 1/x + ln(1/x) = 0 ; b. 1/α est l'unique solution de φ(x) = x dans
  ]0, +∞[ ; c. pour x ∈ [3/2, 3], |φ′(x)| ≤ (4/9)e^(2/3). 3. v_0 = 2, v_{n+1} = φ(v_n) : a. 3/2 ≤ v_n ≤ 2 ;
  b. |v_{n+1} − 1/α| ≤ (4/9)e^(2/3)|v_n − 1/α| ; c. convergence, limite (valeur approchée de α à 10⁻¹).
  **B/ Étude d'une fonction** : f(x) = x/(x + ln x) si x ∈ ℝ*₊\{α}, 0 si x = 0. 1. continuité et
  dérivabilité à droite en 0. 2. variations, tracer C dans (O, i⃗, j⃗) (on prendra α ≈ 0.6).
  **C/ Encadrement d'une aire** : u_n = ∫₁² (ln x/x)^n dx (n ∈ ℕ*). 1. u₁. 2. par deux parties,
  u₂ = 1 − ln 2 − (ln 2)²/2. 3. simplifier 1 − ln x/x + (ln x/x)² + … + (−1)^n(ln x/x)^n. 4. I_n =
  1 − u₁ + u₂ + … + (−1)^n u_n, I = ∫₁² f(x)dx : a. I − I_n = ∫₁² (−1)^(n+1) f(x)(ln x/x)^(n+1) dx ;
  b. ln x/x ≤ 1/e, |I − I_n| ≤ 1/e^(n+1) ; c. lim I_n ; d. vérifier I₂ − 1/e³ ≤ I ≤ I₂.
  **D/ Fonction définie à l'aide d'une intégrale** : F sur ℝ₊ par F(x) = ∫₁^(e^x) f(t)dt.
  1. dérivabilité de F, F′(x). 2. pour t ≥ 1, t/(t + ln t) ≥ 1/2. 3. lim_{+∞} F(x) et lim_{+∞} F(x)/x.
  2. allure de la courbe de F.

### Bornes de scope observées (chapitre 8)

- ✅ INCLUS : définition de **exp comme fonction réciproque de ln** (e^x), équivalence y = e^x ⟺
  x = ln y, ln(e^x) = x, e^(ln x) = x, ln e = 1 ; **propriétés algébriques** e^(a+b) = e^a·e^b,
  e^(a−b) = e^a/e^b, e^−a = 1/e^a, e^(na) = (e^a)^n, e^(a/q) = q√(e^a), e^((p/q)a) = q√(e^(pa)) ;
  **équations et inéquations** avec exp ; **étude de exp** (limites 0/+∞, e^x/x → +∞,
  (e^x − 1)/x → 1, (e^x)′ = e^x, stricte croissance, bijection de ℝ sur ℝ*₊, tangente en 0, position
  vs x + 1) ; l'équation différentielle **f′ = f** (⇒ f = k e^x) traitée comme activité préparatoire ;
  **croissances comparées** e^(nx)/x^m → +∞, x^m e^(nx) → 0, e^x/x^r → +∞, (ln x)/x^r → 0,
  x^r ln x → 0 ; **fonction x ↦ e^(u(x))** (dérivée u′e^u, primitive de u′e^u = e^u + k) ;
  **exponentielle de base a** (a^b = e^(b ln a), dérivée (ln a)a^x, sens de variation et limites selon
  a ≷ 1, règles opératoires a^(c+d) = a^c a^d, etc.) ; **fonctions puissances à exposant rationnel**
  x^r = e^(r ln x) (dérivée r x^(r−1), primitive x^(r+1)/(r+1) + k, limites 0/+∞ selon le signe de r,
  cas ⁿ√x = x^(1/n)) ; applications : études de fonctions à exp, intégration par parties, suites
  définies par une intégrale (dont I_n = ∫₀¹ x^n e^−x dx menant à e = Σ 1/k!), suites récurrentes et
  encadrements.
- ⛔ NON traité dans ce chapitre : la **résolution générale des équations différentielles**
  y′ = ay + b et y″ + ω²y = 0 (chapitre 9 — ici seule l'équation f′ = f sert d'activité introductive) ;
  le **logarithme décimal** log (aucune notation « log » dans le chapitre) ; les **fonctions
  hyperboliques** nommées (ch, sh, th ne sont pas introduites comme telles — seules apparaissent les
  expressions (e^x ± e^−x)/2 dans des exercices) ; l'exposant **irrationnel** pour x ↦ x^α n'est
  développé que via la définition a^b = e^(b ln a), la fonction puissance x^r restant énoncée pour r
  **rationnel**.

## 2.9 Chapitre 9 — Équations différentielles (manuel 222445, p.189–207)

**Page de garde (p.189)** — Titre : « Equations différentielles » [sic, sans accent sur le É dans
tous les bandeaux-titres du chapitre], Chapitre 9. Citation liminaire sur **le pendule isochrone** :
« Le pendule isochrone. Le problème consiste à modifier le pendule standard pour rendre la période
indépendante de l'amplitude. Hygens [sic, pour Huygens] (1673, Horologium Oscillatorium) a l'idée de
modifier le cercle du pendule standard pour que la force accélératrice devienne proportionnelle à la
longueur d'arc s. Le mouvement du pendule serait alors décrit par s″ + Ks = 0, dont les oscillations
sont indépendantes de l'amplitude. » Référence donnée : « (E.Haier [sic] et al, _L'analyse au fil de
l'histoire_, 2000) » (même coquille source que les chapitres 1, 7 et 8 pour Ernst Hairer). Le
chapitre est structuré en trois parties **I. Définition**, **II. Équations du type y′ = ay + b**,
**III. Équations du type y″ + ω²y = 0**, entrecoupées de deux **problèmes résolus**, suivies d'un
QCM / Vrai-Faux, puis d'une rubrique « Exercices et problèmes ».

### Cours — Activités

**I. Définition** (p.190)

- **Activité 1** (p.190) : 1. f : x ↦ e^−x, déterminer une relation entre f′ et f. 2. reprendre pour
  g : x ↦ −2e^−x et h : x ↦ 0,5e^−x. 3. représenter f, g, h dans un même repère. 4. donner d'autres
  fonctions vérifiant la relation trouvée à la question 1.
- **Activité 2** (p.190) : évolution d'une population de bactéries. N₀ nombre à l'instant t = 0, N(t)
  nombre à l'instant t, N′(t) vitesse instantanée d'évolution. 1. N(t) = 9000 e^(−0,4t). a. nombre de
  bactéries aux instants t = 0, t = 10, t = 20 ; b. relation entre N′ et N ; c. vitesse instantanée
  aux instants t = 10 et t = 20 ; d. représenter t ↦ N(t). 2. reprendre les questions si
  N(t) = 3000 e^(0,4t).
- **Activité 3** (p.191) : repère orthogonal ; on a représenté les courbes de quatre fonctions
  f, g, h et t, solutions de l'équation y′ = 0.3y. Donner les expressions des fonctions f, g, h et t.
  (Figure : courbes C_g, C_l, C_f, C_h.)
- **Activité 4** (p.191) : 1. a. résoudre (E) : 2y′ + 3y = 0 ; b. montrer qu'il existe une unique
  solution f de (E) vérifiant f(0) = −3 ; c. représenter graphiquement cette solution. 2. reprendre la
  question précédente pour l'équation (E) : y′ = 0.
- **Activité 5** (p.192) : repère (O, i⃗, j⃗). Représenter graphiquement la fonction f dont la courbe
  C_f passe par le point A(1, 2) et telle que la tangente en tout point M de C_f a un coefficient
  directeur égal au double de l'ordonnée de M.
- **Activité 6** (p.192) : substance radioactive. N(t) nombre de noyaux radioactifs à l'instant t (en
  années), N₀ le nombre à t = 0. La vitesse N′(t) de désintégration est proportionnelle à N(t), avec
  un coefficient égal à −λ (λ > 0 constante radioactive du noyau). 1. donner l'expression de N(t). 2. déterminer, en fonction de λ, le temps T₀.₅ au bout duquel la moitié des noyaux s'est désintégrée
  (durée de demi-vie). 3. substance = carbone 14 : a. déterminer λ sachant que T₀.₅ = 5730 ;
  b. déterminer l'âge d'un fragment d'os qui contient 60 % de la quantité initiale.

**II. Équations différentielles du type y′ = ay + b, où a et b sont deux réels tels que a ≠ 0** (p.192)

- **Activité 1** (p.192) : figure de f : x ↦ e^(−2x) + 3. 1. montrer que f vérifie l'équation (E) :
  y′ = −2y + 6. 2. montrer que g est solution de (E) si et seulement si h : x ↦ g(x) − 3 est solution
  de y′ = −2y. 3. donner toutes les solutions de (E).
- **Activité 2** (p.193) : donner, dans chacun des cas, la solution f de l'équation différentielle et
  la représenter. a. √2 y′ − 2y = 1, f(0) = −1. b. √2 y′ − 2y = 1, f(0) = −1/2.
- **Activité 3** (p.194) : circuit électrique (générateur G tension E, condensateur C, résistance R).
  i(t) intensité du courant à l'instant t (en seconde), q(t) charge à l'instant t. 1. donner une
  relation entre i(t) et q′(t). 2. montrer que R q′(t) + (1/C) q(t) = E. 3. donner l'expression de
  q(t), puis de i(t). 4. représenter t ↦ i(t) si l'on sait que i(0) = 10 mA. (Figure du circuit.)

**III. Équations différentielles du type y″ + ω²y = 0, ω réel** (p.194)

- **Activité 1** (p.194) : 1. f : x ↦ sin x + cos x. a. déterminer les réels r > 0 et φ ∈ ]−π, π] tels
  que f(x) = r cos(x − φ) pour tout réel x ; b. écrire f″ en fonction de f ; c. représenter f. 2. reprendre les questions pour g : x ↦ √3 sin(2x) − cos(2x).
- **Activité 2** (p.194) : figure représentant la courbe d'une fonction de la forme
  f : x ↦ a sin(3x) + b cos(3x). 1. déterminer les réels a et b. 2. montrer que f est deux fois
  dérivable sur ℝ et trouver une relation entre f″ et f. (Figure : courbe sinusoïdale.)
- **Activité 3** (p.195) : (E) : y″ + 9y = 0, inconnue y deux fois dérivable sur ℝ. 1. montrer que
  x ↦ sin(3x) est solution de (E) sur ℝ. 2. montrer que x ↦ cos(3x) est solution. 3. a. montrer que
  pour tous réels a et b, f : x ↦ a sin(3x) + b cos(3x) est solution de (E) sur ℝ ; b. on suppose
  f(0) = √3/2 et f′(0) = 3/2, déterminer a et b ; c. en déduire les réels r > 0 et φ ∈ ]−π, π] tels
  que f(x) = r cos(3x − φ) pour tout réel x ; d. représenter f.
- **Activité 4** (p.195) : ω réel non nul, x₀ et y₀ deux réels. (E) : y″ + ω²y = 0. 1. montrer que
  f : x ↦ (y₀/ω) sin(ωx) + x₀ cos(ωx) est solution de (E). Vérifier f(0) = x₀ et f′(0) = y₀. 2. on suppose qu'il existe une autre solution g vérifiant g(0) = x₀ et g′(0) = y₀ ;
  h(x) = ω²(f(x) − g(x))² + (f′(x) − g′(x))². a. montrer h dérivable sur ℝ et h′(x) =
  2ω²(f′(x) − g′(x))(f(x) − g(x)) + 2(f″(x) − g″(x))(f′(x) − g′(x)) ; b. en déduire h constante sur ℝ ;
  c. calculer h(0) et conclure.
- **Activité 5** (p.196) : 1. a. déterminer la solution f de y″ + 4y = 0 telle que f(π/2) = −1 et
  f′(π/2) = 2 ; b. représenter f ; c. résoudre dans ℝ f(x) = 1 et f(x) = −1. 2. reprendre les
  questions pour la solution g de y″ + π²y = 0 vérifiant g(0) = 0 et g′(0) = 1.
- **Activité 6** (p.196) : ω réel non nul, (E) : y″ + ω²y = 0. A/ 1. montrer que x ↦ cos(ωx) et
  x ↦ sin(ωx) sont solutions de (E). 2. montrer que pour tous réels A et B, x ↦ A sin(ωx) + B cos(ωx)
  est solution de (E). B/ f solution de (E). 1. montrer que pour tous réels A et B,
  g(x) = f(x) − A sin(ωx) − B cos(ωx) est solution de (E). 2. a. déterminer g′(x) ; b. en déduire qu'il
  existe un unique couple (A, B) tel que g(0) = g′(0) = 0. 3. montrer que les solutions de (E) sont les
  fonctions x ↦ A sin(ωx) + B cos(ωx), (A, B) ∈ ℝ².
- **Activité 7** (p.197) : 1. résoudre dans ℝ l'équation y″ + 9y = 0. 2. montrer qu'il existe une seule
  solution de (E) telle que f(π/12) = √2/2 et f(π/3) = −1/2. 3. existe-t-il une solution de (E) telle
  que f(0) = 1/2 et f(2π/3) = 1 ?

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Vocabulaire** (p.190) — « Une équation de la forme y′ = ay, où l'inconnue y est une fonction et a
> est un réel, est appelée équation différentielle linéaire du premier ordre à coefficient constant.
> Résoudre dans ℝ une équation de la forme y′ = ay, c'est trouver toutes les fonctions dérivables sur
> ℝ qui vérifie [sic] y′ = ay. Ces fonctions sont appelées solutions sur ℝ de l'équation y′ = ay. »

> **Théorème** (p.190) — « Soit a un réel. L'ensemble des solutions de l'équation différentielle
> y′ = ay est l'ensemble des fonctions définies sur ℝ par f : x ↦ ke^(ax), où k est un réel
> quelconque. »

> **Théorème** (p.191) — « Soit a un réel non nul. Pour tous réels x₀ et y₀, l'équation y′ = ay admet
> une unique solution qui prend la valeur y₀ en x₀. C'est la fonction définie sur ℝ par
> f : x ↦ y₀ e^(a(x−x₀)). »

> **Théorème** (p.193) — « Soit a et b deux réels tels que a ≠ 0. L'ensemble des solutions de
> l'équation différentielle y′ = ay + b est l'ensemble des fonctions f : x ↦ ke^(ax) − b/a, où k est
> un réel quelconque. De plus pour tous réels x₀, y₀, la fonction f : x ↦ (y₀ + b/a)e^(a(x−x₀)) − b/a
> est l'unique solution de y′ = ay + b, telle que f(x₀) = y₀. »

> **Vocabulaire** (p.194) — « Une équation de la forme y″ + ω²y = 0, où l'inconnue y est une fonction
> et ω est un réel, est appelée équation différentielle linéaire du second ordre à coefficients
> constants. Résoudre une équation de la forme y″ + ω²y = 0, c'est trouver toutes les fonctions deux
> fois dérivable [sic] sur ℝ qui la vérifient. »

> **Théorème** (p.195) — « Soit ω un réel non nul et x₀, y₀ deux réels. L'équation y″ + ω²y = 0 admet
> une unique solution dans ℝ vérifiant f(0) = x₀ et f′(0) = y₀. C'est la fonction définie sur ℝ par
> f(x) = (y₀/ω) sin(ωx) + x₀ cos(ωx). »

> **Conséquence** (p.196) — « Soit ω un réel non nul. La fonction nulle est l'unique solution de
> l'équation différentielle y″ + ω²y = 0 qui vérifie y(0) = y′(0) = 0. »

> **Théorème** (p.196) — « Soit ω un réel non nul. L'ensemble des solutions de l'équation
> différentielle y″ + ω²y = 0 est l'ensemble des fonctions définies sur ℝ par
> f(x) = A sin(ωx) + B cos(ωx), (A, B) ∈ ℝ². »

(Les théorèmes de p.190, p.191 et p.193 sont chacun suivis d'une **Démonstration** ; le théorème de
p.195 est établi via l'**Activité 4**, celui de p.196 via l'**Activité 6**.)

### Cours — Problèmes résolus (p.197–199)

**Problème résolu 1** (énoncé p.197, solution p.197–198) : notion de **« sous tangente »**. Soit C la
courbe d'une fonction f dans un repère orthonormé ; si la tangente T à C en un point M coupe l'axe
des abscisses en N, on appelle « sous tangente en M » le nombre x_N − x_M. 1. cas C : y = e^−x :
a. sous tangente au point d'abscisse 0 (résultat : x_J − x_O = 1) ; b. montrer que la sous tangente en
tout point de la courbe y = e^−x est une constante que l'on précisera (= 1). 2. réel a ≠ 0 fixé ;
déterminer les fonctions f dérivables sur ℝ (f′(x) ≠ 0) dont les courbes admettent en tout point une
sous tangente constante égale à a : a. calculer la sous tangente au point M₀ d'abscisse x₀ et vérifier
f(x₀) = −a f′(x₀) ; b. en déduire que f est solution de y′ = −(1/a)y ; c. résoudre cette équation
(solutions x ↦ k e^(−(1/a)x), k ∈ ℝ). (Figures : courbe y = e^−x avec tangente ; agrandissement.)

**Problème résolu 2** (énoncé p.198, solution p.198–199) : mobile en mouvement uniformément varié sur
un axe (x′x). x(t) position à l'instant t, x′(t) vitesse, x″(t) accélération (t en secondes, x en
mètres). L'accélération x″(t) est proportionnelle à x(t) de coefficient −π²/4. 1. donner l'équation
horaire si x(1) = 2 et x(2) = 0 (résultat : x(t) = 2 sin((π/2)t), t ≥ 0, via x″ + (π²/4)x = 0). 2. déterminer position et vitesse du mobile à t = 0 (x(0) = 0, à l'origine ; x′(0) = π, soit π m/s). 3. représenter t ↦ x(t) (fonction périodique de période 4 ; tableau de variation sur [0, 4] et
courbe sinusoïdale).

### QCM (p.200) — « Cocher la réponse exacte. »

1. La fonction x ↦ 2e^(2x) est solution de l'équation différentielle (☐ y′ = 4y / ☐ y′ = −4y /
   ☐ y′ = 2y).
2. Si f est la solution de l'équation différentielle y′ = 2y telle que f(0) = 1, alors la courbe de f
   admet une tangente (☐ horizontale / ☐ parallèle à y = 2x / ☐ parallèle à y = −x).
3. Si f est la solution de l'équation différentielle y′ = −y + 1 telle que f(0) = 1, alors la fonction
   f est (☐ négative / ☐ positive / ☐ n'a pas un signe constant).
4. La fonction x ↦ 2 cos x − 3 sin x est solution de l'équation différentielle (☐ y″ + 2y = 0 /
   ☐ y″ + y = 0 / ☐ y″ + 3y = 0).

### Vrai ou faux (p.200) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. La fonction f : x ↦ 2^x est solution sur ℝ de l'équation différentielle y′ − ln 2 − y = 0.
2. Si f est solution sur ℝ de l'équation différentielle y′ = −2y alors la fonction f est croissante
   sur ℝ.
3. Si f est la solution sur ℝ de l'équation différentielle y′ = 3y telle que f′(1) = 3 alors f(1) = 1.
4. Si f est la solution sur ℝ de l'équation différentielle y″ + 2y = 0 qui s'annule et change de signe
   en π/4 alors sa courbe dans un repère orthonormé admet un point d'inflexion.

### Exercices et problèmes (p.201–207) — 32 exercices

- **Ex. 1** (p.201) : 1. résoudre dans ℝ a. y′ + 3y = 0 ; b. y′ + √2 y = 0 ; c. −5y′ + y = 0. 2. donner la solution f sur ℝ : a. y′ − y/2 = 0 et y(−1) = e ; b. −3y′ − y = 0 et y(ln 8) = 1 ;
  c. y′ − 2y = 0 et y(0) = 1.
- **Ex. 2** (p.201) : 1. déterminer la fonction f définie et dérivable sur ℝ vérifiant { f′ = af,
  f(0) = 1, f(x + 10) = 2f(x) }. 2. représenter f.
- **Ex. 3** (p.201) : 1. résoudre sur ℝ a. y′ − 2y + 1 = 0 ; b. y′ − πy + 3 = 0 ; c. −2y′ + 5y − 1 = 0. 2. donner la solution f sur ℝ : a. y′ − y − 1 = 0 et y(2) = 0 ; b. 2y′ + y − 3 = 0 et y(0) = 3 ;
  c. y′ + 3y + 3/4 = 0 et y(−1) = 0.
- **Ex. 4** (p.201) : loi de refroidissement de Newton (vitesse instantanée de perte de chaleur
  proportionnelle à la différence de température entre le corps et le milieu). Air ambiant 25 °C ; le
  corps passe de 100 °C à 75 °C en 15 min ; f(t) température à t (minutes). 1. vérifier qu'il existe un
  réel a tel que { f′(t) = a(f(t) − 25), f(0) = 100, f(15) = 75 }. 2. déterminer f. 3. au bout de
  combien de temps (à 1 min près) ce corps aura-t-il une température de 25 °C ?
- **Ex. 5** (p.201) : substance qui se dissout à une vitesse proportionnelle à la quantité non encore
  dissoute. 20 g placés dans l'eau ; les dix premiers grammes se dissolvent en 5 min. 1. donner
  l'expression de la quantité dissoute f(t) (en grammes) en fonction de t (minutes). 2. quantité
  (à 1 mg près) non dissoute au bout de 10 min ? 30 min ? 1 heure ?
- **Ex. 6** (p.201) : C(t) concentration (mg/l) d'un médicament dans le sang, t en heures ;
  concentration initiale 5 mg/l ; C′(t) = −0.25 C(t). 1. déterminer C(t). 2. représenter C. 3. encadrement à 0.1 près de l'instant t₀ à partir duquel C(t) < 1.
- **Ex. 7** (p.201) : charge et décharge d'un condensateur, définies sur [0, 2ln 3[ par f qui vérifie :
  sur [0, 2ln 3[, f est solution de y′ + y = 0 avec f(ln 3) = −2. 1. exprimer f(x) en fonction de x. 2. étudier f et la représenter.
- **Ex. 8** (p.201–202) : 1. vérifier que u : x ↦ 2 vérifie y′ + 2y = y². 1. [sic, numérotation « 1 »
  répétée] soit E l'ensemble des fonctions f dérivables sur ℝ, ne s'annulant pas sur ℝ, telles que
  f′(x) + 2f(x) = (f(x))² pour tout réel x. a. vérifier que E est non vide. b. f fonction de E, montrer
  que g = 1/f est solution d'une équation de la forme y′ = ay + b. c. déterminer alors E.
- **Ex. 9** (p.202) : culture de microbes, nombre à l'instant t (heures) = fonction y ; vitesse de
  prolifération = y′ ; y′(t) = ky(t), k > 0 ; N nombre de microbes à t = 0. 1. déterminer l'unique
  solution de y′ = ky telle que y(0) = N. 2. au bout de deux heures le nombre a quadruplé, calculer en
  fonction de N le nombre au bout de trois heures. 3. valeur de N sachant que la culture contient
  6400 microbes au bout de cinq heures.
- **Ex. 10** (p.202) : f sur ℝ par f(x) = e^−x sin x, C dans un repère orthogonal (2 cm sur l'axe des
  abscisses, 10 cm sur l'axe des ordonnées). 1. a. calculer f′ et vérifier f′(x) = √2 e^−x cos(x + π/4) ;
  b. résoudre sur [0, 2π] l'inéquation cos(x + π/4) > 0, en déduire le signe de f′ sur [0, 2π] ;
  c. tableau de variation de f sur [0, 2π], préciser les tangentes à C aux deux extrémités. 2. C₁ et C₂
  courbes de x ↦ e^−x et x ↦ −e^−x. a. abscisses dans [0, 2π] des points où C rencontre C₁ et C₂ ;
  b. vérifier qu'en chacun de ces points, C et C₁ d'une part, C et C₂ d'autre part, ont même tangente. 3. a. vérifier f″ + 2f′ + 2f = 0 ; b. calculer, en cm², l'aire du domaine limité par C, l'axe des
  abscisses et les droites x = 0 et x = π.
- **Ex. 11** (p.202) : (E) : y′ + 2y = x². 1. déterminer les solutions de (E₀) : y′ + 2y = 0. 2. déterminer un trinôme du second degré qui vérifie (E). 3. montrer qu'une fonction f est solution
  de (E) ssi f − g est solution de (E₀). 4. en déduire les solutions de (E).
- **Ex. 12** (p.202) : (E) : y′ − y = 4 cos x. 1. déterminer les solutions de (E₀) : y′ − y = 0. 2. déterminer les nombres a et b tels que g(x) = a cos x + b sin x vérifie (E). 3. montrer f solution
  de (E) ssi f − g solution de (E₀). 4. en déduire les solutions de (E).
- **Ex. 13** (p.202) : circuit avec générateur de fem E, bobine de résistance r (ohms) et inductance L
  (henrys) ; l'intensité est solution de L y′ + r y = E. On prend E = 10 v, r = 100 Ω, L = 0.2 H ; à
  l'instant 0 l'intensité est nulle. 1. déterminer la fonction i : t ↦ i(t). 2. déterminer la limite de
  i quand t → +∞ et interpréter.
- **Ex. 14** (p.203) : donner la solution f sur ℝ. 1. y″ + 2y = 0, y(0) = 1 et y′(0) = √2. 2. y″ + 16y = 0, y(π) = −1 et y′(π) = −2. 3. y″ + y/4 = 0, y(−π) = 1 et y′(−π) = 0.
- **Ex. 15** (p.203) : (E) : y″ = 2y′. 1. en posant z = y′, résoudre (E) sur ℝ. 2. déterminer la
  solution f de (E) vérifiant f′(0) = 1 et f(0) = 2.
- **Ex. 16** (p.203) : (E) : y″ = −3y′ + 1. 1. en posant z = y′, résoudre (E) sur ℝ. 2. déterminer la
  solution f de (E) vérifiant f′(0) = 0 et f(0) = 0.
- **Ex. 17** (p.203) : 1. résoudre y″ + 16y = 0. 2. trouver la solution f vérifiant f(0) = 1 et
  f′(0) = 4. 3. trouver deux réels positifs a et b tels que pour tout réel t, f(t) = √2 cos(at − b). 4. calculer la valeur moyenne de f sur l'intervalle [0, π/8].
- **Ex. 18** (p.203) : 1. résoudre dans ℝ y″ + y′ = 0. 2. en déduire les solutions de y‴ + y″ = 0.
- **Ex. 19** (p.203) : 1. linéariser cos⁴(x). 2. déterminer les réels a, b et c pour que
  g : x ↦ a cos(4x) + b cos(2x) + c soit solution de (E) : y″ + y′ = cos⁴(x). 3. montrer qu'une
  fonction f est solution de (E) ssi f − g est solution de y″ + y′ = 0.
- **Ex. 20** (p.203) : 4y″ + π²y = 0. 1. résoudre cette équation. 2. repère orthonormé (O, i⃗, j⃗) ;
  déterminer la fonction g solution vérifiant : la courbe de g passe par N de coordonnées
  (1/2, √2/2) ; la tangente à cette courbe en N est parallèle à l'axe des abscisses. 3. vérifier que
  pour tout réel x, g(x) = (√2/2) cos((π/2)x − π/4).
- **Ex. 21** (p.203) : circuit électrique (C capacité du condensateur, R résistance, U tension aux
  bornes). En physique : R q′(t) + (1/C) q(t) = U, q charge du condensateur, q(0) = 0. 1. écrire
  l'équation différentielle vérifiée par q. 2. montrer q(t) = CU − CU e^(−t/RC). 3. sachant que
  l'intensité i(t) = q′(t), déterminer i(t). (Figure du circuit.)
- **Ex. 22** (p.203) : déterminer les fonctions f continues sur ℝ vérifiant (E) : pour tout réel x,
  f(x) = ∫₀ˣ f(t)dt + x. 1. montrer que si une fonction f vérifie (E), alors f est dérivable sur ℝ. 2. montrer que toute solution de (E) est solution de (E′) : y′ = y + 1 ; réciproquement, quelle
  condition doit vérifier une solution de (E′) pour être solution de (E) ? 3. résoudre (E).
- **Ex. 23** (p.204) (**La piqûre intraveineuse**) : à t = 0 (heures), injection d'une dose de 1.8
  unité de médicament, réparti instantanément puis éliminé. Q(t) quantité présente ;
  Q′(t) = −αQ(t). 1. montrer Q(t) = 1.8 e^(−αt) ; au bout d'une heure la quantité a diminué de 30 %,
  en déduire une équation vérifiée par α ; via x ↦ e^−x, montrer qu'il existe un réel α unique tel que
  e^−α = 0.7 ; valeur décimale approchée de α à 10⁻⁴ près. 2. sens de variation de Q pour t ≥ 0, limite
  en +∞ et tracer la courbe C. 3. réinjection d'une dose analogue à t = 1, puis t = 2, t = 3, etc. ;
  Rₙ quantité présente à t = n (nouvelle injection faite). a. montrer R₁ = 1.8 + 0.7 × 1.8 ; b. montrer
  R₂ = 1.8 + 0.7 × R₁ et calculer R₂ ; c. exprimer R_{n+1} en fonction de Rₙ ; d. montrer que pour tout
  entier naturel n, Rₙ = 6(1 − (0.7)^(n+1)) ; e. déterminer la limite de Rₙ.
- **Ex. 24** (p.204) : (I) : y′ = 2y et (II) : y′ = y. 1. résoudre chacune de ces équations. 2. graphique (partie de la courbe C de f et d'une tangente T dans un repère orthonormé) ; f définie
  sur ℝ par f(x) = f₁(x) − f₂(x), f₁ solution de (I), f₂ solution de (II). a. à partir des données lues
  sur le graphique, donner f(0) et f′(0) ; b. déterminer f₁ et f₂ ; en déduire que pour tout réel x,
  f(x) = 2e^(2x) − e^x ; c. limites de f en −∞ et +∞ ; d. abscisse du point d'intersection de C avec
  l'axe des abscisses. 3. réel t < −ln 2. a. exprimer à l'aide de t l'aire 𝒜(t) du domaine limité par
  C, l'axe des abscisses et les droites x = t et x = −ln 2 ; b. montrer lim_{t→−∞} 𝒜(t) =
  ∫_{−ln2}^0 f(t)dt ; interpréter graphiquement. (Figure : courbe C et tangente T.)
- **Ex. 25** (p.204–205) : 1. a. résoudre (E) : 4y′ + 3y = 0 ; b. déterminer la fonction f, solution de
  (E) telle que f′(0) = −6. 2. g sur I = [0, 4] par g(x) = 8 e^(−0.75x). a. étudier les variations de g
  sur I et tracer sa courbe (C) dans un repère orthonormé ; b. A domaine compris entre (C), l'axe des
  abscisses et les droites x = 0 et x = 4 ; calculer le volume V du solide engendré par la rotation de
  A autour de l'axe des abscisses ; valeur exacte de V en cm³ puis valeur approchée arrondie au mm³.
- **Ex. 26** (p.205) : masse de sel (en grammes) dans un mélange d'eau et de sel à l'instant t
  (minutes), notée m(t). m(0) = 300, m solution sur [0, +∞[ de (E) : 5y′ + y = 0. 1. a. résoudre (E) ;
  b. montrer que pour tout t de [0, +∞[, m(t) = 300 e^(−0.2t). 2. déterminer le réel t₀ tel que
  m(t₀) = 150. 3. il est impossible de détecter la présence de sel ssi m(t) ≤ 10⁻² ; à partir de quel
  instant est-il impossible de détecter la présence de sel ?
- **Ex. 27** (p.205) : g sur ℝ par g(x) = cos x − sin x. 1. montrer que pour tout réel x,
  g′(x) = g(π − x). 2. déterminer toutes les fonctions f définies et dérivables sur ℝ vérifiant pour
  tout x réel f′(x) = f(π − x). a. montrer que f est deux fois dérivable et que f est solution de
  y″ + y = 0 ; b. déterminer les fonctions f.
- **Ex. 28** (p.205) : A/ résoudre (E) : y′ − 2y = −2/(1 + e^(−2x)). 1. déterminer la solution de
  y′ − 2y = 0 qui prend la valeur 1 en 0. 2. f dérivable sur ℝ avec f(0) = ln 2, g définie sur ℝ par
  f(x) = e^(2x) g(x). a. calculer g(0) ; b. calculer f′(x) en fonction de g′(x) et g(x) ; c. montrer
  que f est solution de (E) ssi g′(x) = −2e^(−2x)/(1 + e^(−2x)) ; d. en déduire g(x) puis f(x). B/
  étude de f(x) = e^(2x) ln(1 + e^(−2x)). 1. h(x) = ln(1 + e^(−2x)) − 1/(e^(2x) + 1) : a. limite de h en
  +∞ ; b. sens de variation de h ; c. en déduire le signe de h(x). 2. calculer f′(x) et montrer que
  f′(x) est du signe de h(x). 3. limite de f en +∞ ; montrer f(x) = e^(2x)[−2x + ln(1 + e^(2x))] ;
  limite de f en −∞. 4. tableau de variation. 5. représenter f (5 cm pour unité), préciser la tangente
  au point d'abscisse nulle. C/ 1. en remarquant 1/(1 + e^(−2x)) = e^(2x)/(1 + e^(2x)), déterminer une
  primitive de x ↦ 1/(1 + e^(−2x)). 2. calculer, par intégration par parties, l'aire (en cm²) du
  domaine limité par l'axe des abscisses, la courbe de f et les droites x = −1 et x = 0 ; valeur exacte
  et valeur approchée à 10⁻³ près. D/ suite (uₙ) : u₀ = 0, u_{n+1} = f(uₙ). 1. montrer f([0, 1]) ⊂
  [0, 1], en déduire uₙ ∈ [0, 1] pour tout n ≥ 0. 2. montrer par récurrence que (uₙ) est croissante ;
  en déduire qu'elle converge vers un réel α. 3. vérifier f(α) = α et 0 < α < 1. 4. utiliser le
  graphique pour donner une valeur approchée de α à 10⁻¹ près.
- **Ex. 29** (p.206) : corps de température initiale θ₀ = 30 °C placé dans une ambiance de température T
  constante ; θ : t ↦ θ(t). Loi de Newton : θ′(t) = k[T − θ(t)], k coefficient. On prend k = 0.1 et
  θ₀ = 30 °C, temps en minutes, températures en °C. 1. exprimer cette loi par une équation
  différentielle en précisant les conditions initiales. 2. T = 100 °C : a. déterminer θ ; b. limite de
  θ quand t → +∞, interpréter. 3. représenter les courbes d'évolution pour T = 100 °C, T = 30 °C et
  T = −10 °C.
- **Ex. 30** (p.206) : fil conducteur parcouru par un courant d'intensité constante, s'échauffant par
  effet Joule ; température θ (°C) fonction du temps t (secondes) ; à t = 0, θ = 0 °C ; θ vérifie
  θ′(t) + 0.1 θ(t) = 2. 1. déterminer θ(t), t ∈ ℝ₊. 2. a. température au bout de dix secondes, au bout
  d'une minute ? b. limite de θ(t) quand t → +∞, interpréter.
- **Ex. 31** (p.206–207) : A/ f(x) = 3e^(x/5)/(e^(x/5) + 2), C dans un repère orthogonal (1 cm sur
  l'axe des abscisses, 5 cm sur l'axe des ordonnées). 1. étudier les variations de f et préciser les
  asymptotes de C. 2. équation de la tangente T à C au point d'abscisse 0. 3. tracer C, la tangente et
  les asymptotes. 4. a. trouver la primitive de f qui s'annule en 0 ; b. calculer le nombre qui mesure
  (en unités d'aire) l'aire du domaine limité par l'axe des abscisses, l'axe des ordonnées, C et la
  droite x = 5. B/ 1. population de poissons croissant selon g′ = g/5 (I), g quantité (milliers)
  dépendant de t (années). a. résoudre (I) ; b. à t = 0 la population comprend un millier, trouver g. 2. avec un prédateur : g′ = g/5 − g²/15 (II). a. h = g/(3 − g), on suppose g(t) ≠ 3 ; montrer que g
  est solution de (II) ssi h est solution de (I) ; b. trouver les fonctions h solutions de (I), puis
  les fonctions g solutions de (II) ; c. trouver la fonction g solution de (II) telle que g(0) = 1 ;
  montrer que cette fonction coïncide avec la fonction f de la partie A ; d. vers quelle limite tend la
  population ?
- **Ex. 32** (p.207) : circuit fermé (condensateur capacité C en farads, bobine inductance L en
  henrys, interrupteur), t en secondes. À t = 0 le condensateur est chargé ; on ferme l'interrupteur
  et le condensateur se décharge. q(t) (Coulombs) charge à l'instant t, q deux fois dérivable sur
  [0, +∞[. q solution de (E) : y″ + (1/LC) y = 0. On prend C = 1.25 × 10⁻³ et L = 0.5 × 10⁻².
  1. résoudre (E). 2. déterminer la solution q vérifiant q(0) = 6 × 10⁻³ et q′(0) = 0. 3. l'intensité
     i(t) = −q′(t), sur [0, +∞[. a. vérifier i(t) = 2.4 sin(400t) ; b. calculer
     (400/π) ∫₀^(π/400) cos(800t) dt ; puis intensité efficace I_e (positive, ampères) : son carré est
     (I_e)² = (400/π) ∫₀^(π/400) i²(t) dt ; calculer (I_e)², puis une valeur approchée de I_e à 10⁻³ près.

### Bornes de scope observées (chapitre 9)

- ✅ INCLUS : les **trois types d'équations différentielles au programme** — (1) **y′ = ay** (linéaire
  du premier ordre, coefficient constant) : solutions x ↦ k e^(ax), et le problème de Cauchy
  (condition initiale) f(x₀) = y₀ ⇒ f : x ↦ y₀ e^(a(x−x₀)) ; (2) **y′ = ay + b** (a ≠ 0) : solutions
  x ↦ k e^(ax) − b/a, avec condition initiale ; (3) **y″ + ω²y = 0** (linéaire du second ordre,
  coefficients constants) : solutions x ↦ A sin(ωx) + B cos(ωx), unicité sous conditions f(0) = x₀,
  f′(0) = y₀ (avec f(x) = (y₀/ω) sin(ωx) + x₀ cos(ωx)). **Techniques** : résolution homogène + solution
  particulière (trinôme, combinaison a cos + b sin) pour les seconds membres non nuls (exercices 11,
  12, 19), **réduction d'ordre** par z = y′ pour y″ = ay′ + b (exercices 15, 16, 18) ; passage à la
  forme amplitude-phase r cos(ωx − φ) ; **modélisations physiques** : désintégration radioactive
  (demi-vie, carbone 14), refroidissement de Newton, dissolution, pharmacocinétique (piqûre
  intraveineuse, concentration d'un médicament), circuits électriques (charge/décharge d'un
  condensateur R-C, bobine L-r, oscillations L-C, intensité efficace), croissance de populations
  (bactéries, microbes, poissons avec modèle logistique par changement de variable h = g/(3 − g)).
- ⛔ NON traité dans ce chapitre : les équations différentielles **du second ordre du type
  y″ − ω²y = 0** (solutions exponentielles/hyperboliques — seul le cas oscillatoire y″ + ω²y = 0 est
  au programme) ; l'équation **y″ = ay′ + by + c** générale (seuls les cas réductibles par z = y′ sont
  abordés) ; toute **méthode de variation de la constante** formalisée (les solutions particulières
  sont cherchées par forme imposée) ; les systèmes différentiels.

## 2.10 Chapitre 10 — Nombres complexes (manuel 222446, p.5–34)

**Page de garde (p.5)** — Titre : « Nombres complexes », Chapitre 1 (numérotation interne du tome 2 ;
c'est le chapitre 10 dans la numérotation content). Encart historique : « À partir de la deuxième
moitié du XVIIe, les géomètres utilisent de façon de plus en plus courante le symbole √−1 dans les
identités algébriques et les recherches relatives aux résolutions d'équations. En 1740, Euler donne
la formule cos x = ½(e^(x√−1) + e^(−x√−1)), et en 1748, la formule e^(x√−1) = cos x + √−1 sin x, x est
réel. Dontzig [sic, pour Dantzig] dit de cette dernière qu'elle contient "les symboles les plus
importants, union mystérieuse dans laquelle l'arithmétique est représentée par 0 et 1, l'algèbre par
√−1 [sic, imprimé "-1"], la géométrie par π [imprimé "p"] et l'analyse par e". » Référence :
« (Dalmedico et al, Une histoire des mathématiques, 1986) ». Suivi d'une remarque sur Cauchy qui « ne
se ralliera explicitement à la représentation géométrique des nombres complexes qu'en 1874 ». Le
chapitre est structuré en six parties **I. Rappels et compléments**, **II. Écriture exponentielle
d'un nombre complexe non nul**, **III. Équation zⁿ = a (n ≥ 1, a ∈ ℂ\*)**, **IV. Résolution dans ℂ de
l'équation az² + bz + c = 0 (a ≠ 0)**, **V. Exemples d'équations de degré supérieur ou égal à 3**,
**VI. Nombres complexes et trigonométrie**, entrecoupées de sept **exercices résolus**, suivies d'un
QCM / Vrai-Faux, puis d'une rubrique « Exercices et problèmes ».

### Cours — Activités

**I. Rappels et compléments — I.1 Définition et opérations sur les nombres complexes** (p.6)

- **Activité 1** (p.6) : déterminer l'écriture cartésienne de (2 − 2i)(1 + i)², (−√2 − i√3)(√2 + i√3),
  (1 + i)⁴(1 − i)²⁰.
- **Activité 2** (p.6) : z = 1 + 2i et z′ = i. 1. écriture cartésienne de zz′, (zz′)², (zz′)³, (zz′)⁴,
  ainsi que de leurs conjugués. 2. écriture cartésienne de z/z′ et (z/z′)³, ainsi que de leurs
  conjugués. (Encart rappel : conjugué de z = a + ib est z̄ = a − ib.)

**I.2 Affixe d'un point, affixe d'un vecteur** (p.7)

- **Activité 1** (p.7) : repère orthonormé direct (O, u⃗, v⃗). 1. placer A, B, C d'affixes i, 2i,
  1 + 2i. 2. affixes de leurs symétriques par rapport à l'axe des abscisses. 3. par rapport à O. 4. par
  rapport à l'axe des ordonnées. 5. affixes des vecteurs OB⃗ − 2OC⃗ et −AB⃗ + (3/2)AC⃗. 6. affixe du
  centre de gravité du triangle ABC. (Encart : définitions de l'affixe d'un point Aff(M) = z_M et de
  l'affixe d'un vecteur Aff(w⃗) = z_N − z_M, avec la linéarité Aff(αw⃗ + βw₁⃗) = αAff(w⃗) + βAff(w₁⃗).)
- **Activité 2** (p.7) : A d'affixe 2 − 2i et M d'affixe z. 1. CNS sur z pour que M ∈ (OA). 2. en
  déduire l'ensemble des points M d'affixe z = k(2 − 2i), k ∈ ℝ.
- **Activité 3** (p.8) : repère orthonormé direct (O, u⃗, v⃗). f l'application qui à tout point M
  d'affixe z associe le point M′ d'affixe z′ = 2(z + z̄) + iz̄. 1. déterminer et construire l'ensemble
  des M′, images des M d'abscisse nulle. 2. images des M d'ordonnées nulles.
- **Activité 4** (p.8) : A d'affixe 1 + 2i et M d'affixe z. 1. CNS sur z pour que M ∈ la
  perpendiculaire à (OA) en O. 2. en déduire l'ensemble des M d'affixe z = ik(1 + 2i), k ∈ ℝ.
- **Activité 5** (p.9) : déterminer et construire l'ensemble des points M d'affixe z tels que
  (z − i)/(z − 1) soit imaginaire.

**I.3 Module d'un nombre complexe** (p.9)

- **Activité 1** (p.9) : A et B d'affixes z_A = 1 + i√3 et z_B = 1 − i√3. 1. vérifier que le triangle
  OAB est isocèle en O. 2. D tel que OADB soit un losange, déterminer l'affixe de D. (Encart :
  définition |z| = OM = √(a² + b²) et |z_N − z_M| = MN.)
- **Activité 2** (p.9) : z = 2 − i et z′ = −3 + 4i. Calculer les modules de z + z′, zz′, z/z′, z⁴,
  (z̄z′)².
- **Activité 3** (p.10) : repère orthonormé direct. Déterminer l'ensemble des points M d'affixe z tels
  que : 1. |z − 1 + 2i| = 2. 2. |z + 2 − i| = |z̄ − 2 + 2i|. 3. |2z + 2 − i| = √2/2. 4. |iz + 2 + i| = 2.

**I.4 Argument d'un nombre complexe non nul** (p.10)

- **Activité 1** (p.10) : repère orthonormé direct. 1. placer A, B, C, D d'affixes z_A = −i, z_B = 4,
  z_C = 2 + 2i, z_D = −1 + i. 2. A₁, B₁, C₁, D₁ symétriques par rapport à l'axe des abscisses ;
  argument de chacune de leurs affixes. 4. reprendre pour les symétriques par rapport à O. 5. par
  rapport à l'axe des ordonnées. (Encart + figure : arg(z) = mesure de (u⃗, OM⃗).)
- **Activité 2** (p.10) : f qui à M d'affixe z associe M′ d'affixe z′ = 2(z − z̄) + 2iz. 1.a. ensemble
  des M tels que arg(z) ≡ 0 [2π] ; b. ensemble des M′ images. 2. ensemble des M′ images des M tels que
  arg(z) ≡ π [2π]. 3. ensemble des M′ images des M tels que arg(z) ≡ π/2 [2π].
- **Activité 3** (p.11) : M distinct de O tel que (u⃗, OM⃗) ≡ θ [2π] ; M₁, M₂, M₃ symétriques de M par
  rapport à l'axe des abscisses, au point O et à l'axe des ordonnées. Déterminer (u⃗, OM₁⃗), (u⃗, OM₂⃗),
  (u⃗, OM₃⃗) à l'aide de θ. (Propriétés + figures : arg(z̄), arg(−z), arg(kz) selon signe de k.)

**I.5 Écriture trigonométrique** (p.11)

- **Activité 1** (p.11) : repère orthonormé direct. z = −2√3 + 2i. Déterminer l'écriture
  trigonométrique de z et placer son point image. En déduire l'écriture trigonométrique de z̄, −z,
  (1/2)z et −(3/2)z, puis placer leurs points images. (Encart : écriture trigonométrique
  z = |z|(cos θ + i sin θ) avec arg(z) ≡ θ [2π].)
- **Activité 2** (p.12) : z = (√3 − i√2)/2 et z′ = (1 − i√2)/2. Donner une valeur approchée de leurs
  arguments à 10⁻² près. (Encart : cos θ = a/√(a²+b²) et sin θ = b/√(a²+b²).)
- **Activité 3** (p.12) : A, B, C d'affixes z_A = 4, z_B = 1 + i√3, z_C = 1 − i√3. 1. montrer que le
  triangle ABC est équilatéral. 2. écritures trigonométriques de z_A, z_B, z_C. 3. D tel que OABD soit
  un parallélogramme, écriture trigonométrique de z_D. 4. K image de C par le quart de tour direct de
  centre O, écriture trigonométrique de z_K.

**I.6 Propriétés d'un argument d'un nombre complexe non nul** (p.12)

- **Activité 1** (p.12) : z et z′ non nuls, z = |z|(cos θ + i sin θ), z′ = |z′|(cos θ′ + i sin θ′). 1. écritures trigonométriques de zz′, 1/z et z′/z. 2.a. montrer par récurrence que zⁿ = |z|ⁿ(cos nθ +
  i sin nθ) ; b. en déduire z⁻ⁿ = |z|⁻ⁿ(cos(−nθ) + i sin(−nθ)). (Propriétés VERBATIM : arguments +
  formule de Moivre.)
- **Activité 2** (p.13) : donner l'écriture trigonométrique de (1 + i)⁶, (1 − i)⁹ (√3 + i)⁵/(√3 − i)⁸,
  (2√3 − 2i)⁶(1 + i√3)³.

**Exercice résolu 1** (énoncé + solution p.13–14) : repère orthonormé direct. M₁ d'affixe z = 1 − i ;
Mₙ d'affixe zⁿ. 1. écriture trigonométrique de zⁿ (n ≥ 1). 2. construire M₁, M₂, M₃, M₄. 3. entiers n
tels que Mₙ soit sur la droite y = x ; M₂₀₇₁ y appartient-il ? Solution : 1 − i = √2(cos(−π/4) +
i sin(−π/4)), Moivre ⇒ zⁿ = (√2)ⁿ(cos(−nπ/4) + i sin(−nπ/4)) ; Mₙ ∈ D : y = x ssi (n + 1) multiple de
8 ou (n + 5) multiple de 8 ; 2072 divisible par 8 ⇒ M₂₀₇₁ ∈ D. (Figure : points M₁…M₄.)

**I.7 Angles orientés et nombres complexes** (p.14)

- **Activité 1** (p.14) : A, B distincts d'affixes z_A, z_B. 1. avec E tel que AB⃗ = OE⃗, montrer
  (u⃗, AB⃗) ≡ arg(z_B − z_A) [2π]. 2. C, D distincts : a. vérifier (AB⃗, CD⃗) ≡ (u⃗, CD⃗) − (u⃗, AB⃗) [2π] ;
  b. en déduire (AB⃗, CD⃗) ≡ arg((z_D − z_C)/(z_B − z_A)) [2π]. (Théorème VERBATIM + Conséquence
  VERBATIM ; figure.)
- **Activité 2** (p.15) : A d'affixe 1, B d'affixe i. 1. déterminer et construire l'ensemble des M
  d'affixe z tels que arg(z − i) ≡ π/3 [2π]. 2. ensemble des M tels que arg((z − i)/(z − 1)) ≡ π/2 [2π].

**Exercice résolu 2** (énoncé + solution p.15–16) : A d'affixe 2 − i. Déterminer et construire
l'ensemble des M d'affixe z tels que arg((z − 2 + i)³) ≡ π/2 [2π]. Solution : ⇔ arg(z − 2 + i) ≡ π/6,
5π/6 ou 3π/2 [2π] ; ensemble = réunion des trois demi-droites [AB), [AC), [AD) privées de A. (Figure.)

**Exercice résolu 3** (énoncé + solution p.16) : déterminer et construire l'ensemble E des M d'affixe z
tels que arg((z − 1)/(z + i)) ≡ π/3 [2π]. Solution : E est l'arc BA privé de A et B du cercle 𝒞 passant
par A et B et tangent en A à la demi-droite [AT) définie par (AT⃗, AB⃗) ≡ π/3 [2π] (A, B d'affixes 1 et
−i). (Figure.)

**II. Écriture exponentielle d'un nombre complexe non nul** (p.16)

- **Activité 1** (p.16) : repère orthonormé direct. 1. A, B, C d'affixes z_A = i, z_B = ½(√3 + i),
  z_C = (√2/2)(1 − i) : a. écritures trigonométriques ; b. en déduire qu'ils appartiennent au cercle
  trigonométrique. 2. E, F, G du cercle trigonométrique tels que (u⃗, OE⃗) ≡ −3π/2 [2π],
  (u⃗, OF⃗) ≡ 5π/4 [2π] et (u⃗, OG⃗) ≡ −2π/3 [2π] ; écritures trigonométriques de leurs affixes.
  (Notation VERBATIM : e^(iθ) = cos θ + i sin θ ; Conséquences VERBATIM.)
- **Activité 2** (p.17) : z = e^(−iπ/3) et z′ = e^(i3π/2). 1. module et argument de −z, z̄, zz′, 1/z,
  z/z′, zⁿ (n ∈ ℤ). 2. écrire sous la forme e^(iθ) les complexes zz′, z̄, z/z′, zⁿ. (Propriétés VERBATIM
  des exponentielles.)
- **Activité 3** (p.18) : 1. écriture trigonométrique de z₁ = 2i, z₂ = −3i, z₃ = −5/2, z₄ = √3(1 + i),
  z₅ = (−2√3 + 2i)/5. 2. écrire chacun sous la forme re^(iθ), r > 0. (Théorème et définition VERBATIM :
  écriture exponentielle.)
- **Activité 4** (p.18) : z = √3 + i et z′ = −1 + i. Donner l'écriture exponentielle de z, z̄, z′, z̄′,
  zz′, 1/z, z⁵, z/z′, z′².
- **Activité 5** (p.18) : 1. écrire sous forme exponentielle z = √3 − i et z′ = 1 + i. 2. en déduire
  l'écriture cartésienne de (1 + i)¹⁴/(√3 − i)⁸.
- **Activité 6** (p.19) : 1. vérifier que pour tout réel θ, 1 + e^(iθ) = (e^(−iθ/2) + e^(iθ/2))e^(iθ/2). 2. écriture exponentielle de z = 1 + e^(i2π/5) et z′ = 1 + e^(i3π/5).
- **Activité 7** (p.19) : A, B d'affixes 1 et −1 ; M d'affixe z = e^(iα), α ∈ ]0, π[. 1. mesure
  principale de (u⃗, AM⃗) et expression de AM à l'aide de α. 2. (u⃗, BM⃗) et BM. 3. en déduire module et
  argument de Z₁ = 1 + z et Z₂ = 1 − z. (Figure.)

**III. Équation zⁿ = a, n ≥ 1, a ∈ ℂ\*** (p.19)

- **Activité 1** (p.19) : 1. z non nul d'argument 2kπ/3, k ∈ ℤ ; montrer que a. si k = 3n, arg(z) ≡ 0
  [2π] ; b. si k = 3n + 1, arg(z) ≡ 2π/3 [2π] ; c. si k = 3n + 2, arg(z) ≡ 4π/3 [2π]. 2. résoudre dans
  ℂ (E) : z³ = 1 : a. montrer que z solution ssi z = e^(2ikπ/3), k ∈ ℤ ; b. déduire que (E) possède
  exactement trois solutions distinctes. 3. donner les solutions dans ℂ de zⁿ = 1. (Théorème et
  définition VERBATIM : racines nièmes de l'unité ; Conséquence VERBATIM : polygone régulier ; figure
  hexagone racines sixièmes.)
- **Activité 2** (p.20) : j = (−1 + i√3)/2. 1. vérifier que j est une racine cubique de l'unité. 2. vérifier j³ = 1, j² = j̄ et 1 + j + j² = 0. 3. montrer que pour tout entier naturel n, j^(3n) = 1,
  j^(3n+1) = j et j^(3n+2) = j̄.

**Exercice résolu 5** (énoncé + solution p.20–21) : 1. vérifier (z − 1)(z⁴ + z³ + z² + z + 1) = z⁵ − 1. 2. en déduire les solutions z₁, z₂, z₃, z₄ de (E) : z⁴ + z³ + z² + z + 1 = 0. 3.a. écrire z₂, z₃, z₄ à
l'aide de z₁ ; b. en déduire les valeurs de z₁ + z₂ + z₃ + z₄ et 1/z₁ + 1/z₂ + 1/z₃ + 1/z₄. Solution :
solutions = racines cinquièmes de l'unité autres que 1 : z₁ = e^(i2π/5), z₂ = e^(i4π/5), z₃ = e^(i6π/5),
z₄ = e^(i8π/5) ; z₁ + z₂ + z₃ + z₄ = −1 et 1/z₁ + 1/z₂ + 1/z₃ + 1/z₄ = −1.

- **Activité 3** (p.21) : résoudre dans ℂ (z/(1 + i))² = 1. En déduire les solutions dans ℂ de z² = 2i.
- **Activité 4** (p.21) : résoudre dans ℂ (E) : z³ = 8i. 1. montrer que z solution ssi z/(2e^(iπ/6)) est
  une racine cubique de l'unité. 2. en déduire que (E) possède exactement trois solutions ; vérifier
  que zₖ = 2e^(i(π/6 + 2kπ/3)), k ∈ {0, 1, 2}. (Théorème et définition VERBATIM : racines nièmes du
  nombre complexe a, zₖ = r·e^(i(θ/n + 2kπ/n)) avec rⁿ = |a| ; Démonstration ; Conséquence VERBATIM :
  polygone régulier inscrit dans le cercle de rayon r ; figure.)
- **Activité 5** (p.22) : déterminer les racines carrées, puis les racines quatrièmes du nombre complexe
  u = −1 + i√3.
- **Activité 6** (p.22) : ABCDE pentagone régulier inscrit dans le cercle de centre O de rayon 2 et
  A(2, 0). 1. affixes de B, C, D, E. 2. déterminer l'ensemble des M d'affixe z tels que a. arg(z) ≡ 4π/5
  [2π] ; b. arg(z̄) ≡ 2π/5 [2π] ; c. arg(−2z) ≡ 3π/5 [2π]. (Figure.)
- **Activité 7** (p.22) : z = √(2 − √2) + i√(2 + √2). 1. module et argument de z². 2. en déduire
  l'écriture trigonométrique de z.

**IV. Résolution dans ℂ de l'équation az² + bz + c = 0, a ≠ 0** (p.23)

- **Activité 1** (p.23) (**Recherche des racines carrées d'un nombre complexe par une méthode
  algébrique**) : u = 3 − 4i, racines carrées de u ; z = x + iy. 1. montrer que z² = u équivaut au
  système { x² − y² = 3 ; 2xy = −4 ; x² + y² = 5 }. 2. vérifier que les couples (x, y) solutions sont
  (2, −1) et (−2, 1). 3. conclure.
- **Activité 2** (p.23) : déterminer les racines carrées de u = −8 + 6i et u = 1 − 2√2 i.
- **Activité 3** (p.23) : (E) : z² + 2iz − 7/4 − i = 0. 1. montrer que ⇔ (z + i)² = (3 + 4i)/4. 2. vérifier ((2 + i)/2)² = (3 + 4i)/4. 3. en déduire les solutions de (E).
- **Activité 4** (p.23) : a, b, c complexes, a ≠ 0, (E) : az² + bz + c = 0. 1. montrer que ⇔
  (z + b/2a)² = (b² − 4ac)/4a². 2. Δ = b² − 4ac : a. si Δ = 0, (E) admet une unique solution ; b. si
  Δ ≠ 0, Δ admet deux racines carrées opposées δ et −δ, montrer ⇔ (z + (b − δ)/2a)(z + (b + δ)/2a) = 0,
  en déduire les solutions. (Théorème VERBATIM : z₁ = (−b + δ)/2a, z₂ = (−b − δ)/2a ; Conséquences
  VERBATIM : somme −b/a, produit c/a ; Méthode de résolution encadrée.)
- **Activité 5** (p.24) : résoudre dans ℂ a. z² − (1 − i)z + 2 − 2i = 0 ; b. 1 + z + z² = 0 ;
  c. 1 − z + z² = 0.
- **Activité 6** (p.24) : déterminer z₁ et z₂ vérifiant { z₁ + z₂ = 1 + 2i ; z₁z₂ = −1 + i }.

**V. Exemples d'équations de degré supérieur ou égal à 3** (p.25)

- **Activité 1** (p.25) : a₁,…,aₙ complexes, aₙ ≠ 0, n ≥ 2 ; f : z ↦ aₙzⁿ + … + a₁z + a₀ ; (E) : f(z) = 0. 1. montrer que si z₀ est solution, alors pour tout z, f(z) = 0 ⇔ aₙzⁿ + … + a₁z = aₙz₀ⁿ + … + a₁z₀. 2. en déduire que (E) est équivalente à (z − z₀)g(z) = 0, g de la forme aₙz^(n−1) + b_(n−2)z^(n−2) +
  … + b₀. (Théorème VERBATIM : factorisation P(z) = (z − z₀)g(z).)
- **Activité 2** (p.26) : f(z) = z³ + (2 + 2i)z² + (2 + i)z + 3 + i. 1. vérifier f(i) = 0. 2. en déduire
  les solutions dans ℂ de f(z) = 0.

**Exercice résolu 6** (énoncé + solution p.25–26) : (E) : z³ + (1 − 4i)z² − (7 + 3i)z + 6i − 2 = 0. 1. montrer que (E) admet une solution imaginaire et la déterminer (z₀ = 2i). 2. résoudre (E). Solution :
factorisation (z − 2i)(z² + (1 − 2i)z − 3 − i) = 0 ; solutions z₁ = −2 + i, z₂ = 1 + i ; ensemble
S = {2i, −2 + i, 1 + i}.

**VI. Nombres complexes et trigonométrie** (p.26) — (Théorème VERBATIM : formule de Moivre + formules
d'Euler.)

- **Activité 1** (p.26) : k entier ; montrer que pour tout réel x différent de (2k + 1)π/2,
  (1 + i tan x)/(1 − i tan x) = e^(2ix).
- **Activité 2** (p.26) : 1. avec Moivre et le binôme de Newton, montrer cos 3x = cos³x − 3 cos x sin²x
  et sin 3x = 3 cos²x sin x − sin³x. 2. exprimer cos 4x et sin 4x en fonction de puissances de cos x et
  sin x.

**Exercice résolu 7** (énoncé + solution p.27) : linéariser sin⁵x, x ∈ ℝ. Solution : via Euler
sin⁵x = (1/(2i)⁵)(e^(ix) − e^(−ix))⁵, binôme de Newton ⇒ sin⁵x = (1/16)(sin 5x − 5 sin 3x + 10 sin x).
(Encart définition de « linéariser ».)

- **Activité 3** (p.27) : linéariser cos³x, sin³x, sin³x·cos⁴x où x est un réel.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Théorème et définition (rappel)** (p.6) — « Il existe un ensemble appelé ensemble des nombres
> complexes, noté ℂ et vérifiant les propriétés ci-dessous. 1. L'ensemble ℂ contient l'ensemble des
> nombres réels ℝ. 2. Il existe un élément de ℂ, noté i, tel que i² = −1. 3. L'ensemble ℂ est muni
> d'une addition et d'une multiplication qui vérifient les mêmes propriétés que l'addition et la
> multiplication dans ℝ. 4. Tout élément z de ℂ s'écrit de façon unique sous la forme z = a + ib, où a
> et b sont des réels. »

> **Conséquences** (p.6) — « Soit z = a + ib et z′ = a′ + ib′, où a, a′, b et b′ sont des réels. Alors
> z = z′, si et seulement si, a = a′ et b = b′. z = 0, si et seulement si, a = b = 0. z est réel, si et
> seulement si, b = 0. z est imaginaire, si et seulement si, a = 0. »

> **Propriétés** (p.7) — « Pour tous nombres complexes z et z′, z̄+z̄′ = z̄ + z̄′ [sic, imprimé
> "z + z′ = z̄ + z̄′"] ; z̄z′ = z̄ z̄′ ; (zⁿ)‾ = (z̄)ⁿ ; n ∈ ℕ\*. Pour tout nombre complexe z et tout
> nombre complexe non nul z′, (z/z′)‾ = z̄/z̄′ ; (1/z′ⁿ)‾ = 1/(z̄′)ⁿ, n ∈ ℤ. z + z̄ = 2 Re(z) ;
> z − z̄ = 2i Im(z) ; zz̄ = (Re(z))² + (Im(z))². z = z̄, si et seulement si, z est réel. z = −z̄, si et
> seulement si, z est imaginaire. »

> **Propriété** (p.8) — « Soit w⃗ et w₁⃗ deux vecteurs tels que w₁⃗ est non nul. Les vecteurs w⃗ et w₁⃗
> sont colinéaires, si et seulement si, z_w⃗/z_w₁⃗ est réel. »

> **Propriété** (p.8) — « Soit w⃗ et w₁⃗ deux vecteurs tels que w₁⃗ est non nul. Les vecteurs w⃗ et w₁⃗
> sont orthogonaux, si et seulement si, z_w⃗/z_w₁⃗ est imaginaire. »

> **Propriétés** (p.9) — « Soit deux nombres complexes z et z′. |z| = 0, si et seulement si, z = 0 ;
> |z + z′| ≤ |z| + |z′| ; |kz| = |k||z|, k ∈ ℝ. |zz′| = |z||z′| ; |z̄| = |z| ; |z|² = zz̄ ;
> |zⁿ| = |z|ⁿ, n ∈ ℕ\*. |1/z| = 1/|z|, z ≠ 0 ; |z′/z| = |z′|/|z|, z ≠ 0 ; |1/zⁿ| = 1/|z|ⁿ, z ≠ 0 et
> n ∈ ℤ. »

> **Propriétés** (p.11) — « Soit z un nombre complexe non nul et k un réel non nul.
> arg(z̄) ≡ −arg(z) [2π]. arg(−z) ≡ π + arg(z) [2π]. Si k > 0 alors arg(kz) ≡ arg(z) [2π]. Si k < 0
> alors arg(kz) ≡ π + arg(z) [2π]. »

> **Écriture trigonométrique** (encart p.11) — « Soit z un nombre complexe non nul tel que arg(z) ≡ θ
> [2π]. Alors z = |z|(cos θ + i sin θ). L'écriture précédente est appelée écriture trigonométrique de
> z. »

> **Propriétés** (p.12) — « Soit deux nombres complexes non nuls z et z′. arg(zz′) ≡ arg(z) + arg(z′)
> [2π]. arg(1/z) ≡ −arg(z) [2π]. arg(z′/z) ≡ arg(z′) − arg(z) [2π]. arg(zⁿ) ≡ n arg(z) [2π], n ∈ ℤ.
> Pour tout nombre complexe non nul z et tout entier n, zⁿ = |z|ⁿ(cos nθ + i sin nθ). La formule
> précédente est appelée formule de Moivre. »

> **Théorème** (p.14) — « Le plan est muni d'un repère orthonormé direct (O, u⃗, v⃗). Soit A, B, C et D
> des points d'affixes respectives z_A, z_B, z_C et z_D et tels que AB ≠ 0 et CD ≠ 0. Alors
> (u⃗, AB⃗) ≡ arg(z_B − z_A) [2π] et (AB⃗, CD⃗) ≡ arg((z_D − z_C)/(z_B − z_A)) [2π]. »

> **Conséquence** (p.15) — « (z_D − z_C)/(z_B − z_A) = (CD/AB)(cos θ + i sin θ) avec (AB⃗, CD⃗) ≡ θ [2π]. »

> **Notation** (p.17) — « Pour tout réel θ, on note e^(iθ) le nombre complexe cos θ + i sin θ. »
> **Conséquences** (p.17) — « e^(i0) = 1, e^(iπ/2) = i, e^(−iπ/2) = −i, e^(iπ) = −1. Pour tout réel θ
> et tout entier k, e^(iθ) = e^(i(θ+2kπ)). Pour tout réel θ, |e^(iθ)| = 1 et (e^(iθ))‾ = e^(−iθ) et
> −e^(iθ) = e^(i(θ+π)). »

> **Propriétés** (p.17) — « Soit deux réels θ et θ′. e^(iθ)·e^(iθ′) = e^(i(θ+θ′)) ; 1/e^(iθ) = e^(−iθ) ;
> e^(iθ)/e^(iθ′) = e^(i(θ−θ′)) ; (e^(iθ))ⁿ = e^(inθ), n ∈ ℤ. »

> **Théorème et définition** (p.18) — « Tout nombre complexe non nul z, s'écrit sous la forme z = re^(iθ),
> où r = |z| et arg(z) ≡ θ [2π]. L'écriture z = re^(iθ), r > 0 est appelée écriture exponentielle de z. »

> **Théorème et définition** (p.19) — « Pour tout entier naturel non nul n, l'équation zⁿ = 1 admet dans
> ℂ n solutions distinctes définies par zₖ = e^(i·2kπ/n), l'entier k appartenant à {0, 1, …, (n − 1)}.
> Les solutions de l'équation zⁿ = 1 sont appelées racines nièmes de l'unité. »

> **Conséquence** (p.20) — « Le plan est muni d'un repère orthonormé direct (O, u⃗, v⃗). Lorsque n ≥ 3,
> les points images des racines nièmes de l'unité sont les sommets d'un polygone régulier inscrit dans
> le cercle trigonométrique. »

> **Théorème et définition** (p.21) — « Soit a un nombre complexe non nul d'argument θ et n un entier
> naturel non nul. L'équation zⁿ = a admet dans ℂ, n solutions distinctes définies par
> zₖ = r·e^(i(θ/n + 2kπ/n)), k ∈ {0, 1, …, n − 1}, où r est le réel strictement positif tel que rⁿ = |a|.
> Ces solutions sont appelées les racines nièmes du nombre complexe a. »

> **Conséquence** (p.22) — « Le plan complexe est muni d'un repère orthonormé direct (O, u⃗, v⃗). Lorsque
> n ≥ 3, les points images des racines nièmes d'un nombre complexe non nul sont les sommets d'un polygone
> régulier inscrit dans le cercle de centre O et de rayon r tel que rⁿ = |a|. »

> **Théorème** (p.24) — « Soit a, b et c des nombres complexes tels que a ≠ 0. L'équation az² + bz + c = 0,
> admet dans ℂ, deux solutions (éventuellement confondues) définies par z₁ = (−b + δ)/2a et
> z₂ = (−b − δ)/2a, où δ est une racine carrée du discriminant Δ = b² − 4ac. »

> **Conséquences** (p.24) — « Si z₁ et z₂ sont les solutions de az² + bz + c = 0, a ≠ 0, alors
> az² + bz + c = a(z − z₁)(z − z₂), z₁ + z₂ = −b/a et z₁z₂ = c/a. »

> **Théorème** (p.25) — « Soit a₁, a₂, …, aₙ des nombres complexes tels que aₙ ≠ 0, n ≥ 2. Soit
> P(z) = aₙzⁿ + a_(n−1)z^(n−1) + … + a₁z + a₀. Si z₀ est un zéro de P, alors P(z) = (z − z₀)g(z), où g(z)
> est de la forme aₙz^(n−1) + b_(n−2)z^(n−2) + … + b₀, avec b₀, b₁, …, b_(n−2) complexes. »

> **Théorème** (p.26) — « Pour tout réel x et pour tout entier n, (cos x + i sin x)ⁿ = cos(nx) + i sin(nx)
> (Formule de Moivre). Pour tout réel x, cos x = (e^(ix) + e^(−ix))/2 et sin x = (e^(ix) − e^(−ix))/2i
> (Formules d'Euler). »

(Les propriétés « colinéaires » et « orthogonaux » de p.8, le théorème de p.14, le théorème de
p.21 et le théorème de p.24 sont chacun accompagnés d'une **Démonstration**.)

### Cours — Exercices résolus (p.13–27)

Sept exercices résolus jalonnent le cours (déjà décrits ci-dessus, dans leur section respective) :
**ER 1** (écriture trigonométrique de zⁿ, points sur y = x, p.13–14), **ER 2** (ensemble
arg((z−2+i)³) ≡ π/2, réunion de trois demi-droites, p.15–16), **ER 3** (ensemble arg((z−1)/(z+i)) ≡ π/3,
arc de cercle, p.16), **ER 4** (z = 1 + i + e^(iθ), θ ∈ [0, π] ; ensemble E = demi-cercle de diamètre
[IJ], I(2,1), J(0,1), p.17–18), **ER 5** (racines cinquièmes de l'unité et sommes, p.20–21), **ER 6**
(équation de degré 3 à solution imaginaire z₀ = 2i, p.25–26), **ER 7** (linéarisation de sin⁵x, p.27).

### QCM (p.28) — « Cocher la réponse exacte. »

Le plan est muni d'un repère orthonormé direct (O, u⃗, v⃗). Soit les points M(z) et M′(z′).

1. a. La distance MM′ est égale à (☐ |z − z′| / ☐ ||z| − |z′|| / ☐ |z + z′|). b. Si arg(z) ≡ arg(z′)
   [2π] alors (☐ O, M et M′ sont alignés / ☐ z = z′ / ☐ |z| = |z′|).
2. A, B, C d'affixes z_A, z_B, z_C tels que z_B − z_A = 4i(z_C − z_A). Alors (☐ ABC est isocèle /
   ☐ (AB) et (AC) sont perpendiculaires / ☐ (AB) et (AC) sont parallèles).
3. L'équation z² − 2z + 2 = 0 a pour solutions (☐ z₁ = 1 − i et z₂ = 1 + i / ☐ z₁ = 2i et z₂ = −i /
   ☐ z₁ = 1 − i et z₂ = 2 + i).

### Vrai ou faux (p.28) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. Une équation du second degré dans ℂ admet toujours deux racines opposées.
2. Soit z et a deux nombres complexes non nuls. z⁴ = a⁴, si et seulement si, z = a ou z = −a.
3. Soit z₁ et z₂ deux nombres complexes non réels. Le conjugué du nombre complexe Z = z₁ + iz₂ est
   Z̄ = z₁ − iz₂.
4. Deux nombres complexes non nuls ayant même argument et même partie réelle sont égaux.
5. Soit z un nombre complexe. Si z³ est réel alors nécessairement z est réel.
6. Soit z et z′ deux nombres complexes non nuls. Si |z| = |z′| alors nécessairement z = z′ ou z = −z′.

### Exercices et problèmes (p.29–34) — 39 exercices

- **Ex. 1** (p.29) : déterminer z sous forme algébrique. a. (z − i)/(z + i) = 2i. b. (z + i)/2z = 1 − i.
  c. (2z + i)/iz = 2iz/(1 − z).
- **Ex. 2** (p.29) : représenter les points A, B, S, P, I, J d'affixes z_A, z_B, z_A + z_B, z_A z_B,
  1/z_A et 1/z_B. a. |z_A| = 3, arg(z_A) ≡ π/4 [2π], |z_B| = 1 et arg(z_B) ≡ π/2 [2π]. b. |z_A| = 2,
  arg(z_A) ≡ π/4 [2π], |z_B| = 4 et arg(z_B) ≡ π [2π].
- **Ex. 3** (p.29) : z ≠ −i, M d'affixe z, Z = (z − i)/(z + i). 1. ensemble des M tels que Z réel. 2. ensemble tels que Z imaginaire.
- **Ex. 4** (p.29) : z non nul, M d'affixe z, Z = (z + 1)/z. 1. ensemble des M tels que Z réel. 2. Z
  imaginaire.
- **Ex. 5** (p.29) : 1. ensemble E = {M(z) tel que |(z − 1)/(z − i)| = 1}. 2. en déduire
  F = {M(z) tel que |(2z̄ − 2)/(z − i)| = 2}.
- **Ex. 6** (p.29) : déterminer l'ensemble des M d'affixe z tels que arg(z) − arg(z − 1) ≡ π/2 [2π],
  z ∈ ℂ \ {0, 1}.
- **Ex. 7** (p.29) : donner l'écriture algébrique de 2e^(3iπ/2), −e^(3iπ/4) et 3e^(−2iπ/3).
- **Ex. 8** (p.29) : donner l'écriture exponentielle. a. (3e^(−iπ/5))³, 2e^(iπ/5)/3e^(iπ),
  (e^(3iπ/8))⁴(e^(−iπ))³. b. −3 + 3i, 2√3 − 2i, (1 − i)⁵, (1 − i + √2)/(1 + i + √2).
- **Ex. 9** (p.29) : a = (√6 + √2)/2 + i(√6 − √2)/2. 1. écriture exponentielle de a², en déduire celle
  de a. 2. valeurs exactes de cos(π/12) et sin(π/12). 3. repère orthonormé direct : a. construire A et
  B d'affixes a et ia² ; b. ensemble E des M d'affixe z tels que arg((iz + a²)/(z − a)) ≡ −11π/12 + kπ,
  k ∈ ℤ ; vérifier que O ∈ E, tracer E.
- **Ex. 10** (p.30) : z₁ = e^(iπ/6), z₂ = 2e^(−i2π/3), z₃ = √2 e^(−iπ/4). Donner l'écriture
  exponentielle de iz₁, z₂/(1 + i), z₁z₂, z₁/z₂, z₁z₂z₃, z₃⁴, z₂³/z₁⁶ et z̄₂/z₃.
- **Ex. 11** (p.30) : déterminer les racines cubiques de 4√2(i + 1).
- **Ex. 12** (p.30) : déterminer les racines quatrièmes de 8√2(−1 − i).
- **Ex. 13** (p.30) : déterminer les racines cinquièmes de 32i.
- **Ex. 14** (p.30) : déterminer les racines sixièmes de 32(i − √3).
- **Ex. 15** (p.30) : résoudre dans ℂ. a. z² + 18z + 1681 = 0. b. z² − (5 − i)z + 8 − i = 0.
  c. z² + 4(i − 1)z + 2(4 − i) = 0. d. z² + (1 − 3i)z − 2(1 + i) = 0.
- **Ex. 16** (p.30) : résoudre dans ℂ. a. z⁴ + 6z² + 25 = 0. b. z⁴ + 4z² − 77 = 0.
- **Ex. 17** (p.30) : (E) : z³ − 8z² + 24z − 32 = 0. Vérifier que z₀ = 4 est solution. 2. résoudre (E) ;
  z₁ solution à partie imaginaire positive, z₂ à partie imaginaire négative ; forme exponentielle de z₁
  et z₂.
- **Ex. 18** (p.30) : (E) : z³ − (3 + 4i)z² − 4(1 − 3i)z + 12 = 0. 1. montrer que (E) admet une racine
  réelle et la déterminer. 2. résoudre (E).
- **Ex. 19** (p.30) : (E) : z³ = 2 + 11i. 1. vérifier que z₀ = 2 + i est solution. 2. résoudre (E).
- **Ex. 20** (p.30) : repère orthonormé direct. 1. résoudre dans ℂ zz̄ + 3(z − z̄) = 13 + 18i,
  solutions z₁, z₂ avec Re(z₁) < 0. 2. représenter A et B d'affixes z₁ et z₂. 3. affixe du centre de
  gravité G du triangle OAB. 4. affixe de C pour que OABC soit un parallélogramme.
- **Ex. 21** (p.30) : repère orthonormé direct. 1. (E) : z³ − (4 + i)z² + (7 + i)z − 4 = 0 : a. montrer
  que (E) admet une racine réelle et la déterminer ; b. résoudre (E). 2.a. représenter A, B, C d'affixes
  1, 2 + 2i et 1 − i ; b. module et argument de (2 + 2i)/(1 − i), en déduire la nature du triangle OBC ;
  c. que représente la droite (OA) pour le triangle OBC ? d. D tel que CD⃗ = CO⃗ et (CO⃗, CD⃗) ≡ −π/2 [2π] ;
  nature de OCDB ?
- **Ex. 22** (p.31) : 1. déterminer les racines quatrièmes de l'unité. 2. résoudre dans ℂ
  ((z − i)/(z + i))³ + ((z − i)/(z + i))² + (z − i)/(z + i) + 1 = 0.
- **Ex. 23** (p.31) : résoudre dans ℂ 1 + z + z² + … + z⁶ = 0. Calculer cos(2π/7) + cos(4π/7) +
  cos(6π/7).
- **Ex. 24** (p.31) : 1. montrer que pour tout entier n > 0 et tout z, 1 − z^(n+1) = (1 − z)(1 + z + z²
  - … + zⁿ). 2. montrer que pour tout réel θ, 1 − e^(iθ) = −2i sin(θ/2) e^(iθ/2). 3. n ≥ 1, θ ≠ 2kπ ;
    S = 1 + cos θ + cos 2θ + … + cos nθ, S′ = sin θ + sin 2θ + … + sin nθ : a. montrer S + iS′ =
    (1 − e^(iθ(n+1)))/(1 − e^(iθ)) ; b. en déduire S = (sin((n+1)θ/2)/sin(θ/2)) cos(nθ/2) et
    S′ = (sin((n+1)θ/2)/sin(θ/2)) sin(nθ/2).
- **Ex. 25** (p.31) : repère orthonormé direct. f qui à M d'affixe z associe M′ d'affixe z′ = z² − 4z ;
  A, B d'affixes 1 − i et 3 + i. 1.a. affixes de A′ et B′ images de A et B ; b. deux points de même
  image sont confondus ou l'un est l'image de l'autre par une symétrie centrale à préciser. 2. I
  d'affixe −3 : a. montrer que OMIM′ est un parallélogramme ssi z² − 3z + 3 = 0 ; b. résoudre
  z² − 3z + 3 = 0. 3.a. exprimer (z′ + 4) en fonction de (z − 2) ; relation entre |z′ + 4| et |z − 2|,
  puis entre arg(z′ + 4) et arg(z − 2) ; b. J, K d'affixes 2 et −4 ; montrer que l'image de tout M du
  cercle de centre J et de rayon 2 appartient à un même cercle à déterminer ; c. E d'affixe z_E = −4 − 3i ;
  forme trigonométrique de z_E + 4 et montrer qu'il existe deux points d'image E par f, préciser leur
  affixe algébrique.
- **Ex. 26** (p.31) : plan P, repère orthonormé direct. A, B, C d'affixes 2i, −1 et i ; f de P \ {A}
  dans P qui à M d'affixe z associe M′ d'affixe z′ = (z + 1)/(z − 2i). 1.a. C′ image de C ; nature du
  quadrilatère ACBC′ ? b. montrer que C admet un unique antécédent C″ par f, nature du triangle BCC″ ? 2. interprétation géométrique du module et d'un argument de z′. 3.a. ensemble E des M tels que z′
  réel strictement négatif ; b. ensemble F des M tels que z′ imaginaire non nul ; c. ensemble G des M
  tels que M′ ∈ cercle de centre O et de rayon 1.
- **Ex. 27** (p.32) : z = e^(iθ) − i, θ ∈ [0, π/2[. 1. M et M′ images de z et z̄ ; déterminer l'affixe
  de N pour que OMNM′ soit un losange. 2.a. montrer que z = 2 cos(θ/2 + π/4) e^(i(θ/2 − π/4)) ; b. mettre
  z̄/z sous forme exponentielle ; c. valeur de θ pour que OMNM′ soit un carré ; d. construire le carré.
- **Ex. 28** (p.32) : plan P, repère orthonormé direct ; A d'affixe 1 ; f de P \ {A} qui à M d'affixe z
  associe M′ d'affixe z′ = (z̄ + 3)/(z̄ − 1). 1. B d'affixe 1 − i : a. affixe de B′ ; b. placer B et B′. 2. C d'affixe 1 + 2e^(iπ/6) : a. calculer AC ; b. déterminer (u⃗, AC⃗) ; c. construire C ; d. montrer
  f(C) = C. 3.a. calculer (z̄ − 1)(z′ − 1) ; b. en déduire AM·AM′ = 4 ; c. image par f du cercle de
  centre A et de rayon 2.
- **Ex. 29** (p.32) : repère orthonormé direct. a = (√3 + 1)/4 + i(√3 − 1)/4. 2. U = ½[(1 − i) +
  √3(1 + i)] : a. calculer U² ; b. forme trigonométrique de U ; c. en déduire cos(π/12) et sin(π/12). 3. P(Z) = Z³ − 2(√3 + i)Z² + 4(1 + i√3)Z − 8i : a. montrer que P(Z) = 0 admet une solution imaginaire
  pure à déterminer ; b. résoudre P(Z) = 0. 4. A(√3 − i), B(√3 + i), C(2i) : a. représenter A, B, C ;
  b. montrer que OABC est un losange.
- **Ex. 30** (p.32) : plan P, repère orthonormé direct ; f qui à M d'affixe z non nulle associe M′
  d'affixe z′ = 1/z. 1. ensemble des points fixes de f. 2. pour tout M distinct de O, O, M, M′ alignés
  et OM·OM′ = 1. 3.a. A, B, C d'affixes 4, 2 + 2i, 2 − 2i appartiennent au cercle 𝒞 de centre I(2) et
  de rayon 2 ; b. affixes de A′, B′, C′ images par f ; montrer qu'elles appartiennent à une même droite
  à déterminer. 4.a. pour tout z non nul, |z − 2| = 2 ssi |1/2 − z′| = |z′| ; b. en déduire l'image par
  f du cercle 𝒞.
- **Ex. 31** (p.32) : repère orthonormé direct ; A d'affixe z_A = 1, 𝒞 cercle de centre A de rayon 1.
  I. F d'affixe 2, B d'affixe z_B = 1 + e^(iπ/3), E d'affixe (1 + z_B²). 1.a. montrer B ∈ 𝒞 ; b. mesure
  de (AF⃗, AB⃗) ; placer B. 2.a. forme exponentielle de (z_B − z_A) et (z_E − z_A) ; b. en déduire que
  A, B, E sont alignés. 3. placer E.
- **Ex. 32** (p.33) : repère orthonormé direct ; suite (αₙ) définie par α₀ = π/2 et αₙ₊₁ = αₙ + 5π/6 ;
  Mₙ du cercle de centre O et de rayon 1 tel que (u⃗, OMₙ⃗) ≡ αₙ [2π]. 1. placer M₀…M₈. 2. zₙ affixe de
  Mₙ, écrire zₙ sous forme exponentielle. 3. Mₙ et Mₙ₊₆ diamétralement opposés. 4. Mₙ et Mₙ₊₁₂
  confondus. 5. montrer zₙ₊₄ = e^(−2iπ/3) zₙ ; en déduire que MₙMₙ₊₄Mₙ₊₈ est équilatéral.
- **Ex. 33** (p.33) : 1. résoudre dans ℂ Z⁴ = −1. 2. θ ∈ ℝ \ {kπ, k ∈ ℤ} ; montrer que
  (z + i)/(z − i) = e^(iθ) équivaut à z = 1/tan(θ/2). 3. en déduire les solutions de (z + i)⁴ =
  −(z − i)⁴.
- **Ex. 34** (p.33) : plan P, repère orthonormé direct ; A d'affixe −i ; f de P \ {A} qui à M d'affixe
  z associe M′ d'affixe z′ = iz̄/(i − z). 1. ensemble des points invariants par f. 2.a. pour tout
  z ∈ ℂ \ {−i}, (z′ + i)(z̄ − i) = 1 ; b. en déduire AM′·AM = 1 et M′ ∈ [AM). 3.a. θ ∈ ℝ \ {−π/2 + 2kπ,
  k ∈ ℤ} ; montrer que l'affixe de f(M) est égale à e^(iθ) ssi z = −½(tan(θ/2 − π/4) + i) ; b. résoudre
  dans ℂ z³ = 1 ; c. en déduire les solutions de iz³ = (−i − z)³.
- **Ex. 35** (p.33) : repère orthonormé direct ; a réel, (E) : z² + a(1 − i)z − ia² = 0. 1. résoudre
  (E), z₁ solution réelle, z₂ l'autre solution. 2. A, B d'affixes 2 + z₁ et z₂ ; carré de sens direct
  ACBD : a. montrer que C est fixe ; b. déterminer et construire l'ensemble des D lorsque a varie
  dans ℝ.
- **Ex. 36** (p.33) : 1.a. résoudre dans ℂ Z² − 2√3 Z + 4 = 0. b. écrire les solutions sous forme
  exponentielle.
- **Ex. 37** (p.34) : α réel de [0, π/2]. I.1. exprimer à l'aide de α (e^(i2α) + 2e^(iα))² −
  (e^(i2α) − 2e^(iα))². 2. résoudre dans ℂ z² − (e^(i2α) + 2e^(iα))z + 2e^(i3α) = 0. II. repère
  orthonormé direct ; A, B, A′, B′ d'affixes z_A = e^(i2α), z_B = 2e^(iα), z_A′ = iz_A et z_B′ = −iz_B.
  1.a. mettre z_A′ et z_B′ sous forme exponentielle. b. placer A, B, A′, B′ pour α = π/6. 2. I milieu
  de [A′B′] : a. montrer z_I/(z_B − z_A) = −½ i ; b. en déduire que la médiane issue de O du triangle
  OA′B′ est une hauteur issue de O du triangle OAB et que OI = ½ AB.
- **Ex. 38** (p.34) : I.1. résoudre dans ℂ z² − 2e^(iα)z + 2e^(2iα) = 0, α réel de [0, π]. 2. mettre
  les solutions sous forme exponentielle. II. repère orthonormé direct ; A, B d'affixes z₁ = (1 − i)e^(iα)
  et z₂ = (1 + i)e^(iα). 1.a. montrer z₂/z₁ = i ; b. en déduire que OAB est rectangle et isocèle en O.
  2.a. montrer (u⃗, AB⃗) ≡ α + π/2 [2π] ; b. déterminer α pour que (AB) soit parallèle à y = x ;
  c. construire A et B pour cette valeur.
- **Ex. 39** (p.34) : θ réel de [0, π/2[, (E) : iz² + 6 sin θ z − 9i = 0. 1.a. résoudre (E) ; b. écrire
  sous forme exponentielle les solutions de (E). 2. repère orthonormé direct ; A, M₁, M₂ d'affixes 3i,
  z₁ = 3(cos θ + i sin θ), z₂ = 3(−cos θ + i sin θ) : a. vérifier que A, M₁, M₂ sont sur un même cercle
  à préciser ; b. valeur de θ pour que OM₁AM₂ soit un losange. 3. résoudre dans ℂ iz⁴ + 3√3 z² − 9i = 0 ;
  placer les points images des solutions.

### Bornes de scope observées (chapitre 10)

- ✅ INCLUS : **définition axiomatique de ℂ** (i² = −1, forme algébrique a + ib unique, Re/Im,
  conjugué z̄, égalités et caractérisations réel/imaginaire) ; **module** |z| = √(a² + b²) et ses
  propriétés (inégalité triangulaire, |zz′|, |z/z′|, |zⁿ|, |z|² = zz̄) ; **argument** et ses propriétés
  (arg(z̄), arg(−z), arg(kz), arg(zz′), arg(z/z), arg(zⁿ)) ; **affixe** d'un point et d'un vecteur,
  colinéarité (z_w/z_w₁ réel) et orthogonalité (z_w/z_w₁ imaginaire), **angles orientés**
  (u⃗, AB⃗) ≡ arg(z_B − z_A) et (AB⃗, CD⃗) ≡ arg((z_D − z_C)/(z_B − z_A)) ; **écriture trigonométrique**
  r(cos θ + i sin θ) et **formule de Moivre** ; **écriture exponentielle** re^(iθ) et règles de calcul,
  factorisation 1 + e^(iθ) = 2cos(θ/2)e^(iθ/2), 1 − e^(iθ) = −2i sin(θ/2)e^(iθ/2) ; **racines nièmes de
  l'unité** (zₖ = e^(2ikπ/n), polygone régulier, cas j = e^(2iπ/3)) et **racines nièmes d'un complexe a**
  (zₖ = r·e^(i(θ/n + 2kπ/n)), rⁿ = |a|), y compris **racines carrées par méthode algébrique** (système
  x² − y² / 2xy / x² + y²) ; **équation du second degré** az² + bz + c = 0 (discriminant Δ = b² − 4ac,
  racine carrée δ du discriminant, somme −b/a et produit c/a) ; **équations de degré ≥ 3** par recherche
  d'une racine (réelle ou imaginaire pure) puis factorisation P(z) = (z − z₀)g(z) ; **trigonométrie**
  (formules d'Euler, linéarisation de puissances, expression de cos nx / sin nx). **Techniques
  transverses** : lieux géométriques (droites, cercles, arcs, demi-droites) via module/argument d'un
  quotient ; transformations du plan z ↦ z′ (z′ = 1/z, z′ = z² − 4z, homographies (z+1)/(z−2i)) ;
  sommes trigonométriques Σcos kθ / Σsin kθ par exponentielle.
- ⛔ NON traité dans ce chapitre : la **similitude** en tant que transformation z ↦ az + b classifiée
  (elle est l'objet des chapitres 11–13 du tome 2, non de ce chapitre) ; la **notation √z** ou une
  fonction « racine carrée complexe » (on parle DES racines carrées, au pluriel, sans branche
  privilégiée) ; les **fonctions d'une variable complexe** (holomorphie, exponentielle complexe comme
  fonction) — e^(iθ) est ici une **notation** pour cos θ + i sin θ, pas une fonction analytique ; la
  **résolution générale des équations de degré ≥ 3** sans racine évidente (on suppose toujours une
  racine remarquable donnée ou à deviner par sa nature).

## 2.11 Chapitre 11 — Isométries du plan (manuel 222446, p.35–53)

**Page de garde (p.35)** — Titre de couverture : « Isométrie du plan », Chapitre 2 (numérotation
interne du tome 2 ; c'est le chapitre 11 dans la numérotation content ; le bandeau courant écrit
« Isométries du plan »). Encart historique (citation) : « "La théorie des figures isométriques
curvilignes est beaucoup plus difficile et plus profonde que celle des figures isométriques
rectilignes. […]. M. Jacques Bernoulli a été le premier qui l'ait traité avec exactitude ; il propose
le problème qui le résout très promptement ; son mémoire est imprimé parmi ceux de l'académie des
sciences de 1706, mais il manquait quelque chose à la solution […]. M. Euler a aussi sur cette matière
plusieurs morceaux très profonds dans les mémoires de l'académie de Pétersbourg et on a imprimé à
Lafaune, en 1744, un ouvrage fort étendu du même auteur sur ce sujet. Il a pour titre : Methodus
inveniendi lineas curvas, proprietate grandentes." » Référence : « (D'Alembert, Diderot et al,
Encyclopédie méthodique des mathématiques, réédité en 1987). » Mention liminaire (p.36) : « Dans tout
le chapitre, le plan est orienté dans le sens direct. » Le chapitre est structuré en quatre parties
**I. Définition et propriétés**, **II. Composition d'isométries**, **III. Isométries et points fixes**,
**IV. Décomposition d'une isométrie**, ponctuées d'activités et d'un exercice résolu, suivies d'un
QCM / Vrai-Faux, puis d'une rubrique « Exercices et problèmes ».

### Cours — Activités

**I. Définition et propriétés — I.1 Définition** (p.36)

- **Activité 1** (p.36) : dans chacune des trois figures données, déterminer une application f qui fixe
  B et qui envoie A sur C (① triangle équilatéral ABC, ② points A, B, C alignés avec AB = BC, ③ points
  A, B, C alignés). (Encart : « Soit f une application du plan dans lui-même et M₀ un point du plan. On
  dit que f fixe le point M₀ (ou M₀ est invariant par f) si f(M₀) = M₀. »)
- **Activité 2** (p.36) : on se propose de démontrer qu'une symétrie orthogonale conserve les distances.
  Δ une droite, O un point de Δ, i⃗ un vecteur unitaire de Δ ; repère orthonormé (O, i⃗, j⃗) ; S_Δ la
  symétrie orthogonale d'axe Δ. M(x, y) et N(x₁, y₁) d'images M′ et N′ par S_Δ. 1. déterminer les
  coordonnées de M′ et N′. 2. en déduire que M′N′ = MN. (Figure.)
- **Activité 3** (p.37) : plan P rapporté à un repère orthonormé direct (O, i⃗, j⃗) ; g l'application qui
  à tout point M d'affixe z associe M′ d'affixe z′ = ((−1 + i√3)/2)·z. 1. montrer que g est une
  isométrie. 2. montrer que g est une rotation dont on précisera les éléments caractéristiques.

**I.2 Isométries et produit scalaire** (p.37) — voir encadrés VERBATIM ; démonstrations intégrées au
cours (Démonstration du théorème, du corollaire et de leurs conséquences, p.37–38).

**I.3 Isométrie réciproque** (p.38)

- **Activité** (p.38–39) : f une isométrie munie d'un repère orthonormé (A, AB⃗, AC⃗) ; A′, B′, C′ les
  images de A, B, C par f ; deux réels x et y et N le point tel que A′N⃗ = x·A′B′⃗ + y·A′C′⃗. Montrer que
  le point M de coordonnées (x, y) dans (A, AB⃗, AC⃗) est l'unique point vérifiant f(M) = N. Soit g
  l'application qui à tout point N associe son unique antécédent M par f ; vérifier que g(N) = M ssi
  f(M) = N ; en déduire que g est une isométrie.

**I.4 Isométries et configurations** (p.39)

- **Activité 1** (p.39) : f une isométrie munie d'un repère orthonormé (A, AB⃗, AC⃗) ; P, Q, R, S, M, N
  des points d'images respectives P′, Q′, R′, S′, M′, N′. Montrer que si MN⃗ = a·PQ⃗ + b·RS⃗ alors
  M′N′⃗ = a·P′Q′⃗ + b·R′S′⃗ où a et b sont réels.
- **Activité 2** (p.40) : ABC un triangle rectangle en A tel que (AB⃗, AC⃗) ≡ π/2 [2π], H le pied de la
  hauteur issue de A et D l'image de C par la rotation r de centre A et d'angle π/2. On désigne par O le
  pied de la hauteur issue de D dans le triangle DCB et par K le pied de la hauteur issue de A dans le
  triangle DAO. 1. montrer que r transforme (CB) en (DO) et le triangle AHC en le triangle AKD. 2. en
  déduire que AHOK est un carré.

**II. Composition d'isométries** (p.40)

- **Activité 1** (p.40) : f et g deux isométries, M et N deux points ; M′ = f(M), N′ = f(N), M″ = g(M′),
  N″ = g(N′). 1. comparer M′N′ et MN, puis M″N″ et M′N′. 2. en déduire que g∘f est une isométrie. 3. montrer de la même manière que f∘g est une isométrie. (Encart : « Soit f et g deux applications du
  plan dans lui-même. L'application du plan dans lui-même qui à tout point M associe le point g(f(M)) est
  appelée la composée de f par g. On la note g∘f. Si f, g et h sont trois applications du plan dans
  lui-même, (g∘f)∘h = g∘(f∘h) = g∘f∘h. »)
- **Activité 2** (p.40, « Composée de deux symétries orthogonales d'axes sécants ») : D et D′ deux
  droites sécantes en un point I et de vecteurs directeurs respectifs u⃗ et u′⃗ ; S_D et S_D′ les
  symétries orthogonales d'axes respectifs D et D′ ; M un point distinct de I, M′ = S_D(M) et
  M″ = S_D′(M′). 1. montrer que IM″ = IM et que (IM⃗, IM″⃗) ≡ 2(u⃗, u′⃗) [2π]. 2. déduire que S_D′∘S_D
  est une rotation dont on précisera les éléments caractéristiques. 3. identifier S_D∘S_D′. (Figure.)
- **Activité 3** (p.41) : ABCD un rectangle, E le symétrique de B par rapport à A et F le symétrique de B
  par rapport à C. 1. identifier S_(DC)∘S_(DA). 2. une droite Δ passant par B coupe (AD) en E′ et (CD) en
  F′ ; montrer que les droites (EE′) et (FF′) sont parallèles. (Figure.)
- **Activité 4** (p.41, « Composée de deux symétries orthogonales d'axes parallèles ») : D et D′ deux
  droites parallèles, I un point de D et J son projeté orthogonal sur D′ ; S_D et S_D′ les symétries
  orthogonales d'axes respectifs D et D′. 1. montrer que S_D′∘S_D = t_(2IJ⃗). 2. identifier S_D∘S_D′.
  (Figure.)
- **Activité 5** (p.42) : ABCD un parallélogramme, Δ₁ et Δ₂ les médiatrices respectives des segments [AB]
  et [CD] ; P l'image de B par la symétrie orthogonale d'axe Δ₂ et Q l'image de D par la symétrie
  orthogonale d'axe Δ₁. Quelle est la nature du quadrilatère APCQ ? (Figure.)
- **Activité 6** (p.42) : A, B, C trois points non alignés. Donner les réciproques de chacune des
  isométries : 1. S_(AB)∘S_(AC). 2. S_(AC)∘S_(AB). 3. t_(AB⃗)∘S_(AC)∘t_(−BC⃗).

**III. Isométries et points fixes — III.1 Isométries ayant des points fixes** (p.43)

- **Activité 1** (p.43) : f une isométrie différente de l'identité et A un point non fixe de f d'image
  A′. Montrer que si M est un point fixe de f, alors M appartient à la médiatrice du segment [AA′].
- **Activité 2** (p.44) : ABCD un carré direct ; S la symétrie orthogonale d'axe la médiatrice de [BC] et
  T la translation de vecteur BC⃗. 1.a. déterminer les images par S∘T des points A, B et D ; b. identifier
  S∘T. 2.a. déterminer les images par T∘S des points C, D et A ; b. identifier T∘S. 3. en déduire la
  nature de S∘T∘T∘S.
- **Activité 3** (p.45) : plan P rapporté à un repère orthonormé direct (O, i⃗, j⃗) ; f l'application qui
  à tout point M(x, y) associe M′(x′, y′) tel que x′ = (√2/2)x − (√2/2)y et y′ = (√2/2)x + (√2/2)y.
  1. montrer que f est une isométrie de P. 2.a. montrer que f admet un seul point invariant que l'on
     déterminera ; b. en déduire que f est une rotation dont on précisera les éléments caractéristiques.

**III.2 Isométries sans point fixe** (p.45)

- **Activité 1** (p.45) : Δ une droite de vecteur directeur u⃗ ; S_Δ la symétrie orthogonale d'axe Δ et
  f = t_u⃗∘S_Δ. 1.a. construire l'image d'un point A de Δ ; b. déterminer f(Δ). 2. montrer que f n'a pas
  de point fixe.
- **Activité 2** (p.46) : O et O′ deux points distincts, g une rotation de centre O d'angle non nul α ;
  isométrie f = t_(OO′⃗)∘g. N un point tel que (OO′⃗, ON⃗) ≡ π/2 − α/2 [2π], N′ son image par g. L'image de
  la droite (ON) par la translation t_(O′O⃗) coupe (ON′) en un point B. En considérant l'antécédent de B
  par g, montrer que f possède un point fixe. (Figure.)
- **Activité 3** (p.46) : f une isométrie, O un point d'image O′ distincte de O ; on suppose qu'il existe
  une symétrie orthogonale d'axe Δ passant par O telle que f = t_(OO′⃗)∘S_Δ. 1. on suppose OO′⃗ orthogonal
  à Δ et on désigne par M un point de la médiatrice de [OO′] : montrer que f fixe M et ne fixe pas O, puis
  identifier f. 2. montrer que si OO′⃗ est un vecteur directeur de Δ alors f n'admet pas de point fixe. 3. on suppose OO′⃗ ni orthogonal à Δ, ni directeur de Δ ; C et D les points tels que OO′⃗ = OC⃗ + OD⃗,
  OC⃗ directeur de Δ et OD⃗ orthogonal à Δ ; montrer que f = t_(OC⃗)∘S_Δ′ où OC⃗ est directeur de Δ′ ; en
  déduire que f est sans point fixe.

**IV. Décomposition d'une isométrie — IV.1 Décomposition d'une rotation** (p.47)

- **Activité 1** (p.47) : ABC un triangle direct isocèle rectangle en A et Δ la médiatrice du segment
  [BC] ; r la rotation de centre A qui transforme B en C ; S_Δ et S_(AB) les symétries orthogonales d'axes
  respectifs Δ et (AB). Montrer que r = S_Δ∘S_(AB). (Figure.)
- **Activité 2** (p.47) : r une rotation de centre I et d'angle θ, D une droite passant par I et de
  vecteur directeur u⃗ ; D′ la droite passant par I et de vecteur directeur u′⃗ tel que 2(u⃗, u′⃗) ≡ θ [2π].
  Montrer que r = S_D′∘S_D.
- **Activité 3** (p.48) : ABC un triangle équilatéral direct et A′ le milieu du segment [BC] ; r la
  rotation de centre A et d'angle π/3, S_(AB) la symétrie orthogonale d'axe (AB). 1. déterminer la droite
  Δ telle que r = S_Δ∘S_(AB), où S_Δ désigne la symétrie orthogonale d'axe Δ. 2. S_A′ la symétrie centrale
  de centre A′ ; décomposer S_A′ en deux symétries orthogonales. (Figure.)

**IV.2 Décomposition d'une translation** (p.48)

- **Activité 1** (p.48) : t_u⃗ une translation de vecteur non nul u⃗, D une droite de direction orthogonale
  à celle de u⃗ et H un point de D. Montrer que t_u⃗ = S_D′∘S_D, où D′ est la droite parallèle à D et
  passant par le point K tel que HK⃗ = ½ u⃗.
- **Activité 2** (p.49) : soit un rectangle ABCD. Identifier t_(2AB⃗)∘S_(AD).
- **Activité 3** (p.49) : montrer que toute symétrie glissante f se décompose sous la forme
  f = S_D∘S_D′∘S_D″, avec D ∩ D′ = ∅ et D″ perpendiculaire à D.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Définition** (p.36) — « Une application du plan dans lui-même est une isométrie si elle conserve les
> distances. C'est-à-dire, si M′N′ = MN pour tous points M et N du plan d'images respectives M′ et N′. »

> **Conséquences** (p.37) — « • L'identité du plan, les translations, les symétries orthogonales et les
> rotations sont des isométries. • Les images de deux points distincts du plan par une isométrie sont
> deux points distincts. »

> **Théorème** (p.37) — « Une application du plan dans lui-même est une isométrie, si et seulement si,
> elle conserve le produit scalaire. Une application f est une isométrie, si et seulement si,
> AB⃗·AC⃗ = A′B′⃗·A′C′⃗ pour tous points A, B et C d'images respectives A′, B′ et C′. » (Démonstration
> fournie, p.37.)

> **Corollaire** (p.37) — « Soit f une isométrie du plan. Si A, B et C sont trois points deux à deux
> distincts, d'images respectives A′, B′ et C′, alors BAC^ = B′A′C′^. On dit qu'une isométrie conserve
> les mesures des angles géométriques. » (Démonstration p.38.)

> **Conséquence** (p.38) — « Les images par une isométrie de trois points non alignés sont trois points
> non alignés. »

> **Théorème** (p.38) — « Soit f une isométrie, A, B et C trois points non alignés du plan et A′, B′ et
> C′ leurs images respectives. Si le repère (A, AB⃗, AC⃗) est orthonormé alors le repère (A′, A′B′⃗, A′C′⃗)
> est orthonormé. De plus, pour tout point M d'image M′, AM⃗ = x·AB⃗ + y·AC⃗ avec x et y réels, implique
> que A′M′⃗ = x·A′B′⃗ + y·A′C′⃗. » (Démonstration p.38.)

> **Théorème et définition** (p.39) — « Une isométrie f est une bijection du plan dans lui-même.
> L'application du plan dans lui-même qui à tout point N du plan associe son unique antécédent M par f est
> une isométrie appelée réciproque de f et notée f⁻¹. »

> **(Conséquences de la réciproque)** (p.39) — « Pour toute isométrie f et tout point M, f(M) = N, si et
> seulement si, f⁻¹(N) = M. La réciproque d'une symétrie orthogonale est elle-même. La réciproque d'une
> symétrie centrale est elle-même. La réciproque d'une translation de vecteur u⃗ est la translation de
> vecteur −u⃗. La réciproque d'une rotation de centre I et d'angle α est la rotation de centre I et
> d'angle −α. »

> **Théorème** (p.40, composition) — « La composée de deux isométries est une isométrie. »

> **Théorème** (p.39, configurations) — « Soit f une isométrie et A, B, C et D des points d'images
> respectives A′, B′, C′ et D′ par f. Si AB⃗ = α·CD⃗ alors A′B′⃗ = α·C′D′⃗, où α est un réel. »

> **(Résumé de l'action d'une isométrie sur les configurations usuelles)** (p.39) — « • Une isométrie
> conserve le barycentre de deux points. En particulier une isométrie conserve le milieu d'un segment.
> • L'image d'une droite par une isométrie est une droite. • L'image d'un segment par une isométrie est un
> segment qui lui est isométrique. • Les images de deux droites parallèles par une isométrie sont deux
> droites parallèles (on dit qu'une isométrie conserve le parallélisme). • L'image d'un parallélogramme
> par une isométrie est un parallélogramme. • Les images de deux droites perpendiculaires par une
> isométrie sont deux droites perpendiculaires (on dit qu'une isométrie conserve l'orthogonalité).
> • L'image d'un cercle par une isométrie est un cercle qui lui est isométrique. • L'image par une
> isométrie de la tangente en un point M à un cercle est la tangente au cercle image, au point M′ image de
> M (on dit qu'une isométrie conserve le contact). »

> **Théorème** (p.41, axes sécants) — « La composée de deux symétries orthogonales d'axes sécants est une
> rotation. Plus précisément, si D et D′ sont deux droites sécantes en un point I et de vecteurs directeurs
> respectifs u⃗ et u′⃗ et si S_D et S_D′ sont les symétries orthogonales d'axes respectifs D et D′, alors
> S_D′∘S_D est la rotation de centre I et d'angle α où α ≡ 2(u⃗, u′⃗) [2π]. »

> **Conséquence** (p.41, axes perpendiculaires) — « La composée de deux symétries orthogonales d'axes
> perpendiculaires D et D′ en I est la symétrie centrale de centre I, et dans ce cas
> S_D∘S_D′ = S_D′∘S_D. »

> **Théorème** (p.41, axes parallèles) — « La composée de deux symétries orthogonales d'axes parallèles
> est une translation. Plus précisément, si D et D′ sont deux droites parallèles et si S_D et S_D′ sont les
> symétries orthogonales d'axes respectifs D et D′, alors S_D′∘S_D est la translation de vecteur 2IJ⃗, où I
> est un point de D et J est le projeté orthogonal de I sur D′. »

> **Théorème** (p.42) — « Soit f et g deux isométries. g = f⁻¹, si et seulement si, f∘g = Id, où Id désigne
> l'identité du plan. » (Démonstration p.42.)

> **Propriété** (p.42) — « Si f et g sont deux isométries, alors (f∘g)⁻¹ = g⁻¹∘f⁻¹. » (Démonstration p.42.)

> **Propriété** (p.42) — « Soit f, g et h trois isométries. f = g, si et seulement si, h∘f = h∘g. »
> (Démonstration p.42.)

> **Théorème** (p.43, points fixes) — « Soit f une isométrie différente de l'identité, A un point non fixe
> de f et A′ son image. Alors les points fixes de f, s'ils existent, se trouvent sur la médiatrice du
> segment [AA′]. »

> **Théorème** (p.43) — « Une isométrie fixe trois points non alignés, si et seulement si, c'est l'identité
> du plan. » (Démonstration p.43.)

> **Conséquence** (p.44) — « Si deux isométries f et g coïncident sur trois points non alignés, alors elles
> coïncident partout dans le plan. On dit qu'une isométrie est déterminée par la donnée de trois points non
> alignés et leurs images. »

> **Théorème** (p.44) — « Si une isométrie fixe deux points distincts A et B, alors elle fixe tous les
> points de la droite (AB). » (Démonstration p.44.)

> **Théorème** (p.44) — « Si une isométrie f fixe deux points distincts A et B et si elle est différente de
> l'identité, alors f est la symétrie orthogonale d'axe (AB). » (Démonstration p.44.)

> **Théorème** (p.44) — « Si une isométrie f fixe un unique point I alors f est une rotation de centre I et
> d'angle non nul. » (Démonstration p.45, avec figure.)

> **Théorème** (p.45, décomposition unique) — « Soit O un point du plan. Alors toute isométrie f se
> décompose de manière unique en la composée d'une translation et d'une isométrie g qui fixe O. »
> (Démonstration p.45.)

> **Théorème** (p.46, sans point fixe) — « Une isométrie qui n'a aucun point fixe est soit une translation
> de vecteur non nul, soit la composée d'une translation de vecteur non nul u⃗ et d'une symétrie
> orthogonale d'axe Δ tel que u⃗ est directeur de Δ. » (Démonstration p.46.)

> **Définition** (p.47, symétrie glissante) — « La composée d'une translation de vecteur non nul u⃗ et
> d'une symétrie orthogonale d'axe Δ tel que u⃗ est directeur de Δ est appelée symétrie glissante. »

> **Théorème** (p.47, décomposition) — « Toute isométrie se décompose en au plus trois symétries
> orthogonales. » (Démonstration p.47, avec figure.)

> **Théorème** (p.48, rotation = 2 symétries d'axes sécants) — « Toute rotation est la composée de deux
> symétries orthogonales d'axes sécants. Plus précisément, soit r une rotation de centre I et d'angle θ et
> D une droite quelconque passant par I et de vecteur directeur u⃗. Alors r = S_D′∘S_D, où D′ est la droite
> passant par I et de vecteur directeur u′⃗ tel que 2(u⃗, u′⃗) ≡ θ [2π]. »

> **Conséquence** (p.48, symétrie centrale) — « Soit S_I la symétrie centrale de centre I et D une droite
> passant par I. Alors S_I = S_D′∘S_D = S_D∘S_D′, où D′ est la droite perpendiculaire à D en I. »

> **Théorème** (p.49, translation = 2 symétries d'axes parallèles) — « Toute translation est la composée de
> deux symétries orthogonales d'axes parallèles. Plus précisément, soit t_u⃗ la translation de vecteur non
> nul u⃗, D une droite quelconque de direction orthogonale à celle de u⃗ et H un point de D. Alors
> t_u⃗ = S_D′∘S_D, où D′ est la droite parallèle à D et passant par le point K tel que HK⃗ = ½ u⃗. »

> **Tableau de classification** (p.49) — « Le tableau ci-dessous donne une classification des isométries
> suivant leur décomposition en symétries orthogonales et leurs points fixes. » Colonnes : **Nature de
> l'isométrie** | **Décomposition en symétries orthogonales** | **Ensemble des points fixes**. Lignes :
> — Identité du plan | S_D∘S_D | Tout le plan.
> — Symétrie orthogonale d'axe D. | S_D | La droite D.
> — Rotation de centre I et d'angle θ, θ ≠ k2π ; k ∈ ℤ | S_D∘S_D′ (D ∩ D′ = {I}) | {I}.
> — Translation de vecteur non nul. | S_D∘S_D′ (D ∩ D′ = ∅) | L'ensemble vide.
> — Symétrie glissante d'axe D et de vecteur u⃗. | S_D∘S_D′∘S_D″, (D ∩ D′ = ∅) et D perpendiculaire à D″. |
> L'ensemble vide.

### Cours — Exercice résolu (p.43)

**Exercice résolu** (énoncé + solution p.43) : D₁, D₂ et D₃ trois droites distinctes et S₁, S₂, S₃ les
symétries orthogonales d'axes respectifs D₁, D₂, D₃. Montrer que la composée S₁∘S₂∘S₃ est une symétrie
orthogonale, si et seulement si, les droites D₁, D₂, D₃ sont parallèles ou concourantes. **Solution** :
on suppose S₁∘S₂∘S₃ = S_D symétrie orthogonale d'axe D ; l'égalité équivaut à S₁∘S₂ = S_D∘S₃ (_). Si D₁
est parallèle à D₂, S₁∘S₂ est une translation de vecteur u⃗ orthogonal à D₁ et D₂, donc D est parallèle à
D₃ et u⃗ orthogonal à D₃ ⇒ D₁, D₂, D₃ et D parallèles. Si D₁ et D₂ se coupent en I, S₁∘S₂ est une rotation
de centre I ⇒ D₃ et D se coupent en I ⇒ D₁, D₂, D₃ et D concourantes en I. L'équivalence (_) permet de
conclure.

### QCM (p.50) — « Cocher la réponse exacte. »

1. Soit ABCD un carré direct et r la rotation de centre A et d'angle π/2. Alors r est égale à
   (☐ S_(AB)∘S_(AC) / ☐ S_(AB)∘S_(AD) / ☐ S_(AC)∘S_(AB)).
2. Soit (AB) une droite et C un point de (AB). Alors S_(AB)∘S_(AC) est (☐ la symétrie centrale S_A /
   ☐ l'identité / ☐ la symétrie orthogonale S_(BC)).
3. Soit A, B et C trois points non alignés et f une isométrie qui fixe les deux points A et B et ne fixe
   pas le point C. Alors f est (☐ l'identité / ☐ la symétrie orthogonale S_(AB) / ☐ la translation t_(AB⃗)).
4. Soit A et B deux points distincts et O le milieu de [AB]. Soit f une isométrie qui envoie A sur B et B
   sur A. Alors f(O) est (☐ A / ☐ O / ☐ B).
5. Soit ABC un triangle équilatéral et f une isométrie qui envoie A sur B, B sur C et C sur A. Alors f∘f∘f
   est (☐ une symétrie orthogonale S_(AC) / ☐ la translation t_(AB⃗) / ☐ l'identité).

### Vrai ou faux (p.50) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. La seule isométrie fixant trois points distincts est l'identité.
2. Les symétries glissantes sont les seules isométries sans point fixe.
3. Si une isométrie laisse globalement invariante une droite, alors elle est soit une symétrie
   orthogonale, soit une translation.
4. La composée de deux symétries orthogonales distinctes est soit une translation soit une rotation.
5. Soit ABC un triangle isocèle rectangle en A et direct. Soit f une isométrie qui fixe A et envoie B sur
   C. Alors f est soit la rotation de centre A et d'angle π/2, soit la symétrie orthogonale d'axe la
   médiatrice de [BC].

### Exercices et problèmes (p.51–53) — 22 exercices

- **Ex. 1** (p.51) : A et A′ deux points distincts, Δ la médiatrice du segment [AA′]. B un point
  n'appartenant pas à Δ tel que (AB) et Δ ne sont pas parallèles. Construire à la règle seulement le
  symétrique B′ de B par rapport à la droite Δ.
- **Ex. 2** (p.51) : [Ox) et [Oy) deux demi-droites sécantes ; A et B deux points fixes de [Ox) ; M et N
  deux points variables sur [Oy) tels que MN = AB et N ∈ [My). P le milieu de [AM] et Q le milieu de [BN].
  Montrer que Q est l'image de P par une translation qui ne dépend pas des points M et N. (Figure.)
- **Ex. 3** (p.51) : ABC un triangle de centre de gravité G ; A′, B′, C′ les images de A, B, C par une
  isométrie qui fixe G. Montrer que AA′⃗ + BB′⃗ + CC′⃗ = 0⃗.
- **Ex. 4** (p.51) : S₁ et S₂ deux symétries orthogonales d'axes respectifs Δ₁ et Δ₂. 1. discuter, suivant
  la position relative de Δ₁ et Δ₂, la nature de S₁∘S₂. 2. à quelle condition sur Δ₁ et Δ₂ a-t-on
  S₁∘S₂ = S₂∘S₁ ?
- **Ex. 5** (p.51) : deux cercles isométriques 𝒞 et 𝒞′ sécants en deux points A et B. Deux points I et J
  tels que le quadrilatère IAJB est un losange et I est à l'intérieur du cercle 𝒞. On suppose que (IA) et
  (IB) recoupent le cercle 𝒞′ respectivement en P et Q et que les droites (JA) et (JB) recoupent le cercle
  𝒞 respectivement en M et N. Montrer que le quadrilatère MNQP est un rectangle.
- **Ex. 6** (p.51) : ABCD un parallélogramme de centre O ; I, J, K, L les milieux respectifs des segments
  [AB], [BC], [CD], [DA]. 1. déterminer les images de A, I et L par la symétrie centrale S₁ de centre O. 2. construire les points E et F, images respectives de J et K par la symétrie centrale S₂ de centre C. 3. déterminer les images de A, I et L par S₂∘S₁, puis par la translation de vecteur AC⃗ ; conclure.
- **Ex. 7** (p.51) : triangle ABC rectangle en A ; A′ le symétrique de A par rapport à la médiatrice du
  segment [BC] et A″ le symétrique de A′ par rapport à la droite (BC). Montrer que le quadrilatère ACA″B
  est un rectangle.
- **Ex. 8** (p.51) : triangle ABC isocèle en A ; D l'image de B par la symétrie orthogonale d'axe (AC) et
  I le milieu du segment [BC]. Soit f une isométrie laissant A invariant et transformant B et C
  respectivement en C et D ; on pose g = S_(AC)∘f. 1. déterminer g(A), g(B), g(C) et g(I). 2. montrer que
  g est une symétrie orthogonale.
- **Ex. 9** (p.51) : ABC un triangle équilatéral direct ; I le milieu de [AC] et Δ la droite passant par B
  et parallèle à (AC). J un point de [BA] distinct de B. La droite passant par J et parallèle à (AC) coupe
  [BC] en un point K. 1. caractériser S_(AC)∘S_Δ et S_(KJ)∘S_(AC). 2. identifier f = S_(AC)∘S_Δ∘S_(KJ)∘S_(AC). 3. déterminer la position du point J sur [BA] pour que f soit la translation de vecteur BI⃗.
- **Ex. 10** (p.52) : plan P rapporté à un repère orthonormé direct (O, i⃗, j⃗) ; f l'application de P dans
  P qui à tout point M d'affixe z associe le point M′ d'affixe z′ = iz − 1 − i. Montrer que g [sic] est une
  isométrie et la caractériser.
- **Ex. 11** (p.52) : plan P rapporté à un repère orthonormé direct (O, i⃗, j⃗) ; f l'application de P dans
  P qui à tout point M(x, y) associe M′(x′, y′) tel que x′ = 1 − √2 + (1/√2)x + (1/√2)y et
  y′ = 1 + (1/√2)x − (1/√2)y. 1. montrer que f est une isométrie. 2.a. déterminer l'ensemble des points
  fixes de f ; b. en déduire que f est symétrie orthogonale.
- **Ex. 12** (p.52) : plan orienté P ; f l'application de P dans P qui à tout point M d'affixe z associe le
  point M′ d'affixe z′ = i·z̄. 1. montrer que f est une isométrie. 2. déterminer l'ensemble des points
  invariants par f. 3. en déduire la nature de f.
- **Ex. 13** (p.52) : OAB un triangle équilatéral direct. On désigne par Δ la droite perpendiculaire à
  (OA) en O, par D la médiatrice de [AB] et par S₁, S₂, S₃, S₄ les symétries orthogonales d'axes
  respectifs (OA), (OB), Δ et D. On note f = S₃∘S₂∘S₁. 1. montrer que f = S₃∘R où R est une rotation que
  l'on caractérisera. 2. montrer que R = S₃∘S₄. 3. identifier f.
- **Ex. 14** (p.52) : A et B deux points distincts du plan et f une isométrie qui laisse globalement
  invariant le segment [AB]. 1. montrer que f fixe le milieu de [AB]. 2. en déduire toutes les isométries
  qui laissent globalement invariant le segment [AB].
- **Ex. 15** (p.52) : 𝒞 un cercle de centre O. 1. donner la nature des isométries qui laissent 𝒞
  globalement invariant. 2. A et B deux points distincts de 𝒞 ; déterminer les isométries qui laissent
  globalement invariants le cercle 𝒞 et le triangle OAB.
- **Ex. 16** (p.52) : ABC un triangle équilatéral direct et f une isométrie qui envoie A sur B et B sur C.
  1. montrer que si f n'admet pas de points invariants, alors f est une symétrie glissante. 2. on suppose
     que f admet un point invariant : a. montrer que f n'est pas une symétrie orthogonale ; b. identifier
     alors f.
- **Ex. 17** (p.52) : Δ et Δ′ deux droites strictement parallèles, A un point de Δ et B un point de Δ′.
  Déterminer toutes les isométries qui transforment Δ en Δ′ et A en B.
- **Ex. 18** (p.52) : ABCD un carré direct de centre I. On se propose de déterminer les isométries du plan
  qui laissent globalement invariant le carré ABCD. Soit f une isométrie du plan qui laisse globalement
  invariant le carré ABCD. 1.a. montrer que f(I) = I. b. en déduire que f est soit l'identité du plan,
  soit une rotation de centre I et d'angle non nul et soit une symétrie orthogonale d'axe passant par I. 2. on suppose que f n'est pas une symétrie orthogonale ; montrer que : si f(A) = A, alors f est
  l'identité ; si f(A) = B, alors f est la rotation de centre I et d'angle π/2 ; si f(A) = C, alors f est
  la symétrie centrale de centre I ; si f(A) = D, alors f est la rotation de centre I et d'angle −π/2. 3. on suppose que f est une symétrie orthogonale ; montrer que : si f(A) = A, alors f est la symétrie
  orthogonale d'axe (IA). (suite p.53)
- **Ex. 18 (suite)** (p.53) : si f(A) = B, alors f est la symétrie orthogonale d'axe Δ₂ où Δ₂ désigne la
  médiatrice du segment [DC]. Si f(A) = C, alors f est la symétrie orthogonale d'axe (IB). Si f(A) = D,
  alors f est la symétrie orthogonale d'axe Δ₁ où Δ₁ désigne la médiatrice du segment [CB]. 4. conclure.
- **Ex. 19** (p.53) : triangle ABC équilatéral direct de centre G ; r la rotation de centre G et d'angle
  π/3 et A′, B′, C′ les images respectives de A, B, C par r. 1. quel est le centre de gravité du triangle
  A′B′C′ ? 2. f une isométrie transformant {A, B, C} en {A′, B′, C′} : a. montrer que f(G) = G ;
  b. déterminer toutes les isométries transformant {A, B, C} en {A′, B′, C′}.
- **Ex. 20** (p.53) : ABC un triangle équilatéral direct. 1. déterminer toutes les isométries f qui
  laissent globalement invariant le triangle ABC. 2. soit D = S_(AC)(B) ; on se propose de déterminer
  toutes les isométries f qui transforment ABC en ACD. a. on pose g = S_(AC)∘f ; déterminer l'image par g
  du triangle ABC. b. en déduire toutes les isométries f.
- **Ex. 21** (p.53) : ABC un triangle rectangle en A et direct ; H le projeté orthogonal de A sur (BC).
  1. déterminer la droite Δ telle que S_(CA)∘S_(AB) = S_Δ∘S_(AH). 2. donner la nature de
     S_(BC)∘S_(CA)∘S_(AB).
- **Ex. 22** (p.53) : ABC un triangle équilatéral direct et 𝒞 le cercle circonscrit à ABC. La médiatrice
  de [BC] recoupe le cercle 𝒞 en D et la droite (BD) coupe (AC) en E. 1.a. montrer que le triangle BCE est
  isocèle en C ; b. montrer que (DC) est la médiatrice de [AE]. 2. on note f = S_(BD)∘S_(DC) et
  g = S_(AC)∘S_(AB). a. caractériser les isométries f et g. b. déterminer les droites Δ et Δ′ telles que
  f = S_Δ∘S_(AD) et g = S_(AD)∘S_Δ′. c. montrer que Δ et Δ′ sont parallèles puis identifier f∘g.

### Bornes de scope observées (chapitre 11)

- ✅ INCLUS : **définition d'une isométrie** (conservation des distances) et caractérisation par la
  **conservation du produit scalaire** ; conservation des **angles géométriques** (corollaire), du
  **parallélisme**, de l'**orthogonalité**, du **barycentre / milieu**, du **contact** (tangentes),
  images de droites, segments, cercles, parallélogrammes ; **repère orthonormé image** et coordonnées
  invariantes (AM⃗ = xAB⃗ + yAC⃗) ; **bijectivité** et **isométrie réciproque** f⁻¹ (réciproques des
  symétries, translations, rotations) ; **composition** d'isométries (associativité, (f∘g)⁻¹ = g⁻¹∘f⁻¹) ;
  **composée de deux symétries orthogonales** — d'axes sécants = rotation d'angle 2(u⃗, u′⃗), d'axes
  perpendiculaires = symétrie centrale, d'axes parallèles = translation 2IJ⃗ ; **points fixes** (fixe 3
  points non alignés ⇔ identité ; fixe 2 points ⇒ fixe la droite ; fixe 2 points ≠ Id ⇒ symétrie
  orthogonale ; fixe un unique point ⇒ rotation) ; **isométries sans point fixe** (translation ou
  **symétrie glissante**) ; **décomposition** de toute isométrie en **au plus trois symétries
  orthogonales**, décomposition d'une **rotation** (2 symétries d'axes sécants) et d'une **translation**
  (2 symétries d'axes parallèles) ; **classification** des isométries par décomposition et points fixes
  (tableau récapitulatif) ; **expression complexe** d'une isométrie (z′ = az + b, z′ = az̄ + b) et
  caractérisation d'une isométrie donnée par ses équations analytiques ou son écriture complexe.
- ⛔ NON traité dans ce chapitre : la **classification déplacement / antidéplacement** nommée comme telle
  (le manuel raisonne par décomposition en symétries orthogonales et points fixes, sans le vocabulaire
  « déplacement/antidéplacement ») ; les **similitudes** (z ↦ az + b avec |a| ≠ 1) et l'**homothétie**
  (elles relèvent des chapitres suivants du tome 2, pas des isométries) ; la **réduction générale par
  matrices** (les équations analytiques sont traitées cas par cas, sans formalisme matriciel) ; toute
  isométrie de l'**espace** (le chapitre est strictement plan).

## 2.12 Chapitre 12 — Déplacements – Antidéplacements (manuel 222446, p.54–73)

**Page de garde (p.54)** — Titre de couverture : « Déplacement / Antidéplacement », Chapitre 3
(numérotation interne du tome 2 ; c'est le chapitre 12 dans la numérotation content ; le bandeau
courant écrit « Déplacements / Antidéplacements »). Encart historique : rappel que Euclide (312–215
av. J.-C.) utilisait les déplacements pour démontrer les cas d'égalité des triangles, que les
cartographes du XVIᵉ siècle cherchaient des applications conservant les angles, qu'Euler (1707–1784)
a montré en substance qu'un déplacement plan est une rotation, une translation ou une translation
suivie d'une symétrie, que Poncelet (1788–1867) a fait apparaître la transformation comme
correspondance entre figures et que Mobius (1790–1868) a créé la notion d'affinités géométriques
(le déplacement = cas où figures initiale et transformée sont égales). Références : « (A.
Dahan-Dalmedico et al, Histoire des mathématiques - routes et dédales, 1982). » et « (J. Dhombres
et al, Mathématiques au fil des âges, 1987). » Mention liminaire (p.55) : « Dans tout le chapitre le
plan est orienté dans le sens direct. » Le chapitre est structuré en quatre parties **I. Définitions
et propriétés**, **II. Détermination d'un déplacement ou d'un antidéplacement**, **III. Déplacements**
(angle, composition, nombres complexes), **IV. Antidéplacements** (symétrie glissante, forme réduite),
ponctuées d'activités et de trois exercices résolus, suivies d'un QCM / Vrai-Faux, puis d'une rubrique
« Exercices et problèmes » (28 exercices).

### Cours — Activités

**I. Définitions et propriétés** (p.55)

- **Activité 1** (p.55) : A et C deux points distincts, S la symétrie orthogonale d'axe (AC). M et N
  deux points distincts, E le point tel que MN⃗ = AE⃗ ; construire les images M′, N′ et E′ par S.
  1. comparer (AC⃗, AE⃗) et (AC⃗, AE′⃗). 2. montrer que (AC⃗, MN⃗) ≡ −(AC⃗, M′N′⃗) [2π]. 3. P et Q deux
     points distincts d'images P′ et Q′ par S ; comparer (MN⃗, PQ⃗) et (M′N′⃗, P′Q′⃗). (Figure.)
- **Activité 2** (p.55) : g la composée de deux symétries orthogonales ; M, N, P, Q des points tels que
  MN⃗ ≠ 0⃗ et PQ⃗ ≠ 0⃗, d'images M′, N′, P′ et Q′ par g. Montrer que (MN⃗, PQ⃗) ≡ (M′N′⃗, P′Q′⃗) [2π].
- **Activité 3** (p.55) : f la composée de n symétries orthogonales. Donner une condition nécessaire et
  suffisante sur n pour que f change l'orientation ; puis pour que f conserve l'orientation.

**II. Détermination d'un déplacement ou d'un antidéplacement** (p.56)

- **Activité 1** (p.56) : A et B deux points distincts. 1. f et g deux déplacements qui coïncident sur A
  et B : a. déterminer (f⁻¹∘g)(A) et (f⁻¹∘g)(B) ; b. identifier f⁻¹∘g et en déduire que f = g. 2. f₁ et
  g₁ deux antidéplacements qui coïncident sur A et B ; identifier f₁⁻¹∘g₁ et en déduire que f₁ = g₁.
- **Activité 2** (p.57) : A, B, C et D des points tels que AB⃗ = CD⃗ et AB⃗ ≠ 0⃗. 1. montrer qu'il existe
  une symétrie orthogonale S₁ qui envoie A sur C. 2. on pose M = S₁(B) ; montrer qu'il existe une
  symétrie orthogonale S₂ qui fixe C et envoie M sur D. 3. montrer que S₂∘S₁ est un déplacement qui
  envoie A sur C et B sur D. 4. combien existe-t-il de déplacements qui envoient A sur C et B sur D ?
- **Activité 3** (p.57) : A, B, C et D des points tels que AB⃗ = CD⃗ et AB⃗ ≠ 0⃗ ; t la translation qui
  envoie A sur C ; on pose M = t(B). 1. montrer qu'il existe une symétrie orthogonale S qui fixe C et
  envoie M sur D. 2. montrer que f = S∘t est un antidéplacement qui envoie A sur C et B sur D. 3. combien existe-t-il d'antidéplacements qui envoient A sur C et B sur D ?

**III. Déplacements — III.1 Angle d'un déplacement** (p.57)

- **Activité 1** (p.57) : A, B, C et D des points tels que AB⃗ ≠ 0⃗ et CD⃗ ≠ 0⃗ ; f un déplacement,
  A′, B′, C′ et D′ les images respectives de A, B, C et D. Montrer que (AB⃗, A′B′⃗) ≡ (CD⃗, C′D′⃗) [2π].
- **Activité 2** (p.58) : OAB un triangle isocèle de sommet principal O tel que (OA⃗, OB⃗) ≡ 2π/3 [2π] ; P
  un point de [AB] distinct de A et B ; la parallèle menée de P à (OB) coupe (OA) en A′, la parallèle
  menée de P à (OA) coupe (OB) en B′. 1.a. montrer que OA′ = BB′ ; b. en déduire l'existence d'une unique
  rotation r qui transforme O en B et A′ en B′. 2. montrer que r(A) = O et déterminer les éléments
  caractéristiques de r. 3. Ω le centre de r ; montrer que O, A′, B′ et Ω sont sur un même cercle. (Fig.)
- **Activité 3** (p.58) : ABC un triangle rectangle en A tel que (CA⃗, CB⃗) ≡ π/3 [2π] et O le milieu de
  [BC]. 1. montrer qu'il existe un unique déplacement f tel que f(A) = O et f(C) = B. 2. montrer que f est
  une rotation dont on précisera l'angle ; construire son centre.
- **Activité 4** (p.58) : ABCD un carré de sens direct ; I, J, K, L les milieux respectifs de [AB], [BC],
  [CD] et [DA]. Justifier, dans chaque cas, l'existence du déplacement f et l'identifier. 1. f(J) = I et
  f(K) = L. 2. f(I) = K et f(J) = L. 3. f(B) = K et f(L) = A. (Figure.)

**III.2 Composition de déplacements — Composition de deux translations** (p.58)

- **Activité 1** (p.58) : ABCD un parallélogramme, I et J les milieux respectifs de [AB] et [CD] et Δ la
  droite passant par J et parallèle à (AC). Montrer que Δ est globalement invariante par t_(AI⃗)∘t_(AJ⃗).
  (Figure.)

**Composition de deux rotations** (p.59)

- **Activité 2** (p.59) : ABCD un carré direct ; r la rotation de centre A et d'angle π/2, r′ la rotation
  de centre B et d'angle −π/2. 1. montrer que r = S_(AC)∘S_(AB). 2. déterminer la droite Δ telle que
  r′ = S_(AB)∘S_Δ. 3. identifier r∘r′.
- **Activité 3** (p.59) : ABC un triangle équilatéral direct de centre O ; r la rotation de centre O et
  d'angle 2π/3, r′ la rotation de centre A et d'angle π/3. 1. déterminer (r∘r′)(A). 2. identifier r∘r′.
- **Activité 4** (p.59–60) : r et r′ deux rotations d'angles respectifs θ et θ′ et de centres distincts O
  et O′. 1. A et B deux points tels que 2(OO′⃗, OA⃗) ≡ θ [2π] et 2(O′B⃗, O′O⃗) ≡ θ′ [2π] ; montrer que
  r = S_(OA)∘S_(OO′) et r′ = S_(OO′)∘S_(O′B). 2. si θ + θ′ ≠ 2kπ (k ∈ ℤ), justifier que (OA) et (O′B)
  sont sécantes et que r∘r′ est une rotation dont on déterminera le centre. 3. si θ + θ′ = 2kπ (k ∈ ℤ),
  a. justifier que (OA) et (O′B) sont parallèles ; b. montrer que r∘r′ est la translation de vecteur
  2O′H⃗, où H est le projeté orthogonal de O′ sur (OA). (Figure.)

**Composition d'une rotation et d'une translation** (p.60)

- **Activité 5** (p.60) : OAB et OCD deux triangles équilatéraux directs, E le quatrième sommet du
  parallélogramme BOCE. 1. f = r∘t, r la rotation de centre O et d'angle π/3, t la translation de vecteur
  BO⃗ ; a. déterminer f(B) ; b. déterminer la nature de f et ses éléments caractéristiques. 2. déterminer
  f(E) et en déduire la nature du triangle AED. (Figure.)
- **Activité 6** (p.60–61) : ABC un triangle rectangle et isocèle tel que (AB⃗, AC⃗) ≡ π/2 [2π] ; I le
  milieu de [BC], J le milieu de [AC] et K le milieu de [AB]. R la rotation de centre I et d'angle π/2, T
  la translation de vecteur ½BC⃗ ; f = R∘T et g = T∘R. 1. déterminer f(K), f(B), g(J) et g(I). 2. identifier
  f et g. (Figure.)

**III.3 Déplacements et nombres complexes** (p.61)

- **Activité 1** (p.62) : plan rapporté à un repère orthonormé direct (O, i⃗, j⃗). Caractériser, dans
  chaque cas, l'application f du plan dans lui-même. 1. f : M(z) ↦ M′(z′) tel que z′ = z + 1 + i. 2. f : M(z) ↦ M′(z′) tel que z′ = −z + 1. 3. f : M(z) ↦ M′(z′) tel que z′ = e^{iπ/4}·z + i.

**IV. Antidéplacements** (p.62)

- **Activité 1** (p.62) : A et B deux points distincts, S la symétrie orthogonale d'axe (AB) ; C un point
  de (AB) et D n'appartenant pas à (AB) ; A′, B′, C′, D′ les images de A, B, C, D par S. Comparer
  (AB⃗, A′B′⃗) et (CD⃗, C′D′⃗). Que peut-on conclure ?
- **Activité 2** (p.63) : ABCD un carré de centre I tel que (AB⃗, AD⃗) ≡ π/2 [2π] ; S la symétrie
  orthogonale d'axe (AC), R la rotation de centre A et d'angle π/2 ; f = S∘R. 1. montrer que f est un
  antidéplacement. 2. déterminer f(B) et en déduire la nature de f. 3. Δ la parallèle à (AD) passant par
  I ; on pose g = t_(BC⃗)∘S_Δ ; quelle est la nature de g ?
- **Activité 3** (p.63) : D une droite de vecteur directeur u⃗ ; S_D la symétrie orthogonale d'axe D et
  t_u⃗ la translation de vecteur u⃗. 1. montrer que t_u⃗∘S_D∘t_u⃗∘S_D = t_(2u⃗). 2. en déduire que
  t_u⃗∘S_D = S_D∘t_u⃗. 3. D′ une droite de vecteur directeur u′⃗, S_(D′) la symétrie d'axe D′ et t_(u′⃗) la
  translation de vecteur u′⃗ ; montrer que si t_u⃗∘S_D = t_(u′⃗)∘S_(D′) alors D et D′ sont confondues et
  u⃗ = u′⃗.
- **Activité 4** (p.64) : f une symétrie glissante de vecteur u⃗ et d'axe D. 1. montrer que pour tout point
  M d'image M′ par f, le milieu I de [MM′] appartient à D. 2. si M est un point de D d'image M′, alors
  u⃗ = MM′⃗.
- **Activité 5** (p.64) : ABC un triangle isocèle en A ; I et J les milieux respectifs de [AB] et [AC] ; f
  l'antidéplacement qui transforme A en C et B en A. Montrer que f est une symétrie glissante dont on
  précisera l'axe et le vecteur.
- **Activité 6** (p.64) : ABCD un rectangle ; I et J les milieux respectifs de [AD] et [BC]. 1. f =
  t_(AC⃗)∘S_(AB) ; a. déterminer la droite Δ pour que S_Δ∘S_(AB) = t_(AD⃗) ; b. en déduire que f est une
  symétrie glissante dont on déterminera l'axe et le vecteur. 2. g = S_(AB)∘t_(AC⃗) ; a. Δ′ l'image de la
  droite (IJ) par la symétrie d'axe (AB) ; caractériser S_(AB)∘S_(Δ′) ; b. en déduire la nature et les
  éléments caractéristiques de g.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Théorème** (p.55) — « Toute symétrie orthogonale change les mesures des angles orientés en leurs
> opposées. (On dit qu'une symétrie orthogonale change l'orientation). »

> **Théorème** (p.55) — « La composée de deux symétries orthogonales conserve les mesures des angles
> orientés. (On dit que la composée de deux symétries orthogonales conserve l'orientation). »

> **Définition** (p.56) — « On appelle déplacement toute isométrie qui conserve les mesures des angles
> orientés. On appelle antidéplacement toute isométrie qui change les mesures des angles orientés en
> leurs opposées. »

> **Théorème** (p.56) — « Une isométrie est un déplacement, si et seulement si, elle est la composée de
> deux symétries orthogonales. Une isométrie est un antidéplacement, si et seulement si, elle est une
> symétrie orthogonale ou la composée de trois symétries orthogonales. »

> **Tableau de classification** (p.56) — « Le tableau ci-dessous donne la classification des isométries
> en déplacements ou antidéplacements. » — Identité → Déplacement ; Rotation → Déplacement ; Translation
> → Déplacement ; Symétrie orthogonale → Antidéplacement ; Symétrie glissante → Antidéplacement.

> **Théorème** (p.56) — « • La composée de deux déplacements est un déplacement. • La composée de deux
> antidéplacements est un déplacement. • La composée d'un déplacement et d'un antidéplacement est un
> antidéplacement. • La réciproque d'un déplacement est un déplacement. • La réciproque d'un
> antidéplacement est un antidéplacement. »

> **Théorème** (p.56) — « Deux déplacements qui coïncident sur deux points distincts sont égaux. Deux
> antidéplacements qui coïncident sur deux points distincts sont égaux. »

> **Théorème** (p.57) — « Soit A, B, C et D des points du plan tels que AB⃗ = CD⃗ et AB⃗ ≠ 0⃗. Il existe
> un unique déplacement qui envoie A sur C et B sur D. Il existe un unique antidéplacement qui envoie A
> sur C et B sur D. »

> **Théorème et définition** (p.57, angle d'un déplacement) — « Soit f un déplacement et A, B, C et D des
> points du plan tels que AB⃗ ≠ 0⃗ et CD⃗ ≠ 0⃗. Si A′, B′, C′ et D′ sont les images respectives par f des
> points A, B, C et D, alors (AB⃗, A′B′⃗) ≡ (CD⃗, C′D′⃗) [2π]. En désignant par θ une mesure de l'angle
> (AB⃗, A′B′⃗), on dit que f est un déplacement d'angle θ. »

> **Corollaire 1** (p.57) — « Soit f un déplacement d'angle θ. Si θ = 2kπ, k ∈ ℤ alors f est une
> translation. Si θ ≠ 2kπ, k ∈ ℤ alors f est une rotation d'angle θ. »

> **Corollaire 2** (p.58) — « • Si f est un déplacement d'angle θ et g est un déplacement d'angle θ′,
> alors f∘g est un déplacement d'angle θ + θ′. • Si f est un déplacement d'angle θ, alors f⁻¹ est un
> déplacement d'angle −θ. »

> **Théorème (Rappel)** (p.59, composée de deux translations) — « La composée de deux translations t_u⃗ et
> t_v⃗ est la translation t_(u⃗+v⃗) = t_u⃗∘t_v⃗ = t_v⃗∘t_u⃗ = t_(v⃗+u⃗). »

> **Théorème** (p.60, composée de deux rotations) — « La composée de deux rotations r et r′ d'angles θ et
> θ′ et de centres respectifs O et O′ est soit une translation de vecteur non nul, soit une rotation
> d'angle non nul. Si θ + θ′ ≡ 0 [2π], il s'agit d'une translation de vecteur non nul. Si θ + θ′ ≠ 2kπ,
> k ∈ ℤ, il s'agit d'une rotation d'angle θ + θ′. »

> **Théorème** (p.60, rotation et translation) — « La composée d'une translation et d'une rotation
> d'angle non nul θ est une rotation d'angle θ. » (Démonstration p.60 : c'est un déplacement d'angle θ.)

> **Théorème** (p.61, translation en complexes) — « Le plan est rapporté à un repère orthonormé direct
> (O, i⃗, j⃗). Soit f une application du plan dans lui-même qui à tout point M d'affixe z associe le point
> M′ d'affixe z′. L'application f est une translation de vecteur u⃗, si et seulement si, il existe un
> nombre complexe b tel que z′ = z + b où b est l'affixe de u⃗. » (Démonstration p.61.)

> **Théorème** (p.61, rotation en complexes) — « Le plan est rapporté à un repère orthonormé direct
> (O, i⃗, j⃗). Soit f une application du plan dans lui-même qui à tout point M d'affixe z associe le point
> M′ d'affixe z′. L'application f est une rotation d'angle non nul θ et de centre I, si et seulement si,
> il existe deux nombres complexes a et b tels que z′ = az + b, avec a = e^{iθ}, a ≠ 1 et z_I = b/(1−a)
> est l'affixe de I. » (Démonstration p.61.)

> **Théorème** (p.63, antidéplacement) — « Une isométrie est un antidéplacement, si et seulement si,
> c'est la composée d'une symétrie orthogonale et d'une translation. » (Démonstration p.63.)

> **Théorème et définition** (p.63, forme réduite) — « Soit f une symétrie glissante. Il existe un unique
> vecteur non nul u⃗ et une droite D unique tels que f = t_u⃗∘S_D = S_D∘t_u⃗ où u⃗ est un vecteur directeur
> de D. Cette décomposition est appelée forme réduite de f. » (Avec figure.)

> **Vocabulaire** (p.64) — « On dit que D est l'axe de la symétrie glissante et u⃗ son vecteur. L'axe et
> le vecteur d'une symétrie glissante sont ses éléments caractéristiques. »

> **Propriété** (p.64, symétrie glissante) — « Soit f une symétrie glissante de vecteur u⃗ et d'axe D, M
> un point d'image M′ par f. • Le milieu de [MM′] appartient à D. • Si M est un point de D, alors
> u⃗ = MM′⃗. • f∘f est la translation de vecteur 2u⃗. » (Avec figure.)

### Cours — Exercices résolus

**Exercice résolu 1** (énoncé + solution p.62) : repère orthonormé direct (A, u⃗, v⃗) ; ABCD un
parallélogramme, DCF et BEC des triangles isocèles de sommets respectifs D et B tels que
(DC⃗, DF⃗) ≡ π/4 [2π] et (BE⃗, BC⃗) ≡ π/4 [2π]. Montrer que le triangle AEF est isocèle en A. **Solution** :
la rotation r′ de centre B et d'angle −π/4 envoie C sur E, d'où z_E = e^{−iπ/4}(z_C − z_B) + z_B (_) ; la
rotation r de centre D et d'angle π/4 envoie C sur F, d'où z_F = z_D + e^{iπ/4}(z_C − z_D) (\**) ; l'égalité
AD⃗ = BC⃗ donne z_C − z_B = z_D, soit z_C = z_B + z_D ; il résulte de (_) et (**) que z_F = e^{iπ/4}·z_E,
ce qui prouve que AEF est isocèle de sommet principal A. (Figure.)

**Exercice résolu 2** (énoncé + solution p.65) : ABCD un carré direct, I, J, K, L les milieux de [AB],
[BC], [CD] et [DA]. Justifier l'existence de l'antidéplacement g et donner ses éléments caractéristiques
dans chacun des cas. 1. g(J) = I et g(K) = L. 2. g(B) = K et g(K) = A. 3. g(A) = C et g(D) = B.
**Solution** : 1. JK = IL et IL ≠ 0 ⇒ existence de g ; [JI] et [KL] ont la même médiatrice (BD) ⇒ g est la
symétrie orthogonale d'axe (BD). 2. BK = KA et KA ≠ 0 ⇒ existence ; [BK] et [KA] ont des médiatrices
distinctes ⇒ g est une symétrie glissante d'axe (LJ) (passant par les milieux de [BK] et [KA]), et
g∘g(B) = A ⇒ g de vecteur ½BA⃗. 3. AD = CB et CB ≠ 0 ⇒ existence ; le déplacement f tel que f(A) = C et
f(D) = B est la symétrie centrale de centre O ; g = f∘S_(AD) = S_(JL)∘S_(KI)∘S_(AD) = S_(JL)∘t_(AB⃗).

**Exercice résolu 3** (énoncé p.65, solution p.66) : ABC un triangle équilatéral tel que
(AB⃗, AC⃗) ≡ π/3 [2π] ; B′ et C′ les milieux respectifs de [AC] et [AB]. Déterminer toutes les isométries
f telles que f(A) = B et f(B′) = C′. **Solution** : 1. AB′ = BC′ ⇒ existence d'un unique déplacement r
envoyant A sur B et B′ sur C′. 2. r est la rotation de centre G (centre de gravité de ABC) et d'angle
2π/3. 3. AB′ = BC′ ⇒ existence d'un unique antidéplacement g envoyant A sur B et B′ sur C′ ; médiatrices
de [AB] et [B′C′] distinctes ⇒ g est la symétrie glissante d'axe (B′C′) et de vecteur B′C′⃗. Les seules
isométries répondant au problème sont la rotation de centre G et d'angle 2π/3 et la symétrie glissante
d'axe (B′C′) et de vecteur B′C′⃗. (Figure.)

### QCM (p.67) — « Cocher la réponse exacte. »

1. Soit u⃗ un vecteur non nul et A un point quelconque. L'application t_u⃗∘S_A est (☐ une translation /
   ☐ une symétrie centrale / ☐ une symétrie glissante).
2. Un déplacement qui fixe deux points distincts est (☐ une translation de vecteur non nul / ☐ une
   rotation d'angle non nul / ☐ l'identité).
3. La composée de deux symétries glissantes est (☐ une symétrie glissante / ☐ un déplacement / ☐ une
   symétrie orthogonale).
4. Soit D une droite et O un point de D. L'application S_D∘R(O, π/3) est (☐ une symétrie orthogonale /
   ☐ une rotation / ☐ une symétrie glissante).
5. Soit A et B deux points distincts. L'application S_A∘S_B est (☐ la translation t_(2AB⃗) / ☐ l'identité /
   ☐ la translation t_(2BA⃗)).

### Vrai ou faux (p.67) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. La composée de trois symétries orthogonales est soit une symétrie orthogonale, soit une symétrie
   glissante.
2. Un antidéplacement qui fixe un point est une symétrie orthogonale.
3. Soit I et J deux points distincts, f un déplacement qui envoie I sur J et g un antidéplacement qui
   envoie J sur I. Alors g∘f est une symétrie glissante.
4. La réciproque d'une symétrie glissante d'axe Δ et de vecteur u⃗ est la symétrie glissante d'axe Δ et
   de vecteur −u⃗.
5. Soit ABCD un carré direct et f le déplacement qui envoie A sur C et B sur D. Alors f est une
   translation.

### Exercices et problèmes (p.68–73) — 28 exercices

- **Ex. 1** (p.68) : OAB un triangle isocèle en O. Montrer qu'il existe deux isométries qui fixent O et
  qui envoient A en B.
- **Ex. 2** (p.68) : ABCD un parallélogramme de centre O et I le milieu de [CD]. 1. montrer qu'il existe
  quatre isométries qui transforment le segment [AD] en le segment [BC]. 2. existe-t-il une isométrie qui
  transforme le triangle BCO en le triangle ADI ?
- **Ex. 3** (p.68) : ABCD un rectangle ; S₁, S₂ et S₃ les symétries d'axes respectifs (AD), (AB) et (AC).
  1. donner la nature de l'isométrie S₃∘S₂∘S₁. 2. construire le point E, image de B par S₃∘S₂∘S₁.
  2. caractériser alors S₃∘S₂∘S₁.
- **Ex. 4** (p.68) : ABC un triangle isocèle en A tel que (AB⃗, AC⃗) ≡ π/12 [2π] ; r la rotation de centre
  A qui envoie B sur C ; D, E et F les images respectives de C, D et E par r. 1. montrer que F est l'image
  de B par une rotation r′ de centre A, que l'on précisera. 2. G le symétrique de A par rapport à D ;
  a-t-on S_(AC)∘S_(AE) = S_(AD)∘S_(AG) ?
- **Ex. 5** (p.68) : A, B, C et D des points tels que AB⃗ = CD⃗ et AB⃗ ≠ 0⃗. Montrer qu'il existe deux
  déplacements f et g qui envoient le segment [AB] sur le segment [CD]. 2. définir f et g dans chacun des
  cas : a. (CD) parallèle à (AB) ; b. (CD) et (AB) sécantes.
- **Ex. 6** (p.68) : deux cercles isométriques 𝒞 et 𝒞′ de centres O et O′ se coupant en deux points A et
  B. 1. montrer qu'il existe une unique rotation de centre A qui transforme 𝒞 en 𝒞′ ; préciser son angle. 2. M′ l'image par cette rotation d'un point quelconque M de 𝒞 ; montrer que M, B et M′ sont alignés.
- **Ex. 7** (p.68) : triangle ABC tel que (AB⃗, AC⃗) ≡ π/3 [2π] et AB < AC ; 𝒞 le cercle circonscrit, O
  son centre ; E le milieu de [BC] et P le point de [AC] tel que AB = CP ; (OE) coupe 𝒞 en I et J tels que
  J et A soient sur le même arc orienté BC de 𝒞. 1.a. faire une figure ; b. déterminer l'ensemble des
  points M du plan vérifiant (MB⃗, MC⃗) ≡ π/3 [2π] ; c. déterminer l'ensemble des points M vérifiant
  (MB⃗, MC⃗) ≡ π/3 [2π] et MB < MC. 2.a. justifier qu'il existe une rotation R telle que R(A) = P et
  R(B) = C ; déterminer son angle ; b. démontrer que le centre de R est un point de 𝒞 que l'on précisera ;
  c. quelle est la nature du triangle JAP ?
- **Ex. 8** (p.68) : ABCD un carré de sens direct et de centre I tel que (AB⃗, AD⃗) ≡ π/2 [2π] et 𝒞 le
  cercle circonscrit ; R la rotation de centre D et d'angle π/2, T la translation de vecteur DA⃗ ; f = T∘R.
  1. déterminer f(D) et f(A). 2. identifier f.
- **Ex. 9** (p.68) : ABCD un parallélogramme. 1. préciser la nature des transformations : a. f =
  S_(AB)∘S_(CD)∘S_(AD)∘S_(CB) ; b. g = S_(AB)∘S_(AD)∘S_(CB)∘S_(CD) ; c. h = S_(AB)∘S_(AD)∘S_(CD)∘S_(CB). 2. déterminer les éléments caractéristiques de f, g et h lorsque ABCD est un rectangle.
- **Ex. 10** (p.68–69) : ABCD un parallélogramme direct ; IBA rectangle isocèle direct en I ; ACC′ et ADD′
  rectangles isocèles directs en A ; R_A la rotation d'angle π/2 et de centre A, T la translation de
  vecteur BA⃗. 1. f = R_A∘T ; a. déterminer f(B) ; en déduire que f est la rotation d'angle π/2 et de
  centre I ; b. montrer que le triangle ICD′ est rectangle isocèle. 2. J le milieu de [CC′], R_J la
  rotation d'angle π/2 et de centre J ; a. montrer que C = R_J(A) ; b. que vaut (AD′⃗, CB⃗) ? c. montrer
  que le triangle BDD′ est rectangle isocèle. 3. g = R_J∘f ; a. déterminer g(B) ; b. K = R_J(I) ; montrer
  que K est le symétrique de I par rapport au milieu A′ de [BC].
- **Ex. 11** (p.69) : triangles équilatéraux directs OAA′, OBB′ et OCC′ ; I, J, K les milieux respectifs
  de [A′B], [B′C] et [C′A] ; E, F, G les symétriques de O par rapport à I, J, K. 1. r₁ la rotation de
  centre O et d'angle π/3, r₂ la rotation de centre B′ et d'angle −π/3 ; identifier f₁ = r₁∘r₂.
  2.a. évaluer (BE⃗, OA⃗) ; b. en déduire que le triangle EB′A est équilatéral. 3. t₁ = t_(OA⃗), t₂ =
  t_(B′O⃗) ; a. préciser la nature de f₂ = t₁∘r₁∘t₂ ; b. déterminer f₂(B′) puis identifier f₂ ; c.
  déterminer f₂(F) ; nature du triangle EFG ; d. nature du triangle IJK (justifier).
- **Ex. 12** (p.69) : triangle direct OAB rectangle et isocèle en O ; r_A et r_B les rotations de centres A
  et B et de même angle π/2, S_O la symétrie de centre O ; C non situé sur (AB) ; carrés directs BEDC et
  ACFG. 1.a. déterminer S_(AO)∘S_(AB) ; b. montrer que S_O = r_A∘r_B. 2.a. déterminer l'image de E par
  r_A∘r_B ; b. en déduire que O est le milieu de [EG] ; c. r_F et r_D les rotations de centres F et D et
  d'angle π/2 ; déterminer r_F∘S_O∘r_D(C) puis identifier r_F∘S_O∘r_D ; d. H le symétrique de D par rapport
  à O ; démontrer que r_F(H) = [?] (formule source peu lisible) ; en déduire que FOD est rectangle isocèle.
- **Ex. 13** (p.69) : triangle ABC tel que AB = AC et (AB⃗, AC⃗) ≡ π/2 [2π] ; I, J, K les milieux de [BC],
  [AC], [AB] ; R la rotation de centre I et d'angle π/2, T la translation de vecteur ½BC⃗ ; f = R∘T et
  g = T∘R. 1.a. déterminer l'image de K par f et de J par g ; b. préciser la nature et les éléments
  caractéristiques de f et de g. 2.a. déterminer la nature de g∘f⁻¹ ; b. chercher l'image de A par g∘f⁻¹
  et caractériser g∘f⁻¹ ; c. M un point n'appartenant pas à (IJ), M₁ = f(M), M₂ = g(M) ; montrer que
  ACM₂M₁ est un parallélogramme.
- **Ex. 14** (p.70) : ABC rectangle en C tel que (CA⃗, CB⃗) ≡ π/2 [2π] ; r la rotation de centre A et
  d'angle π/2 ; D = r(C), E = r⁻¹(B) ; I le milieu de [CD]. 1.a. montrer qu'il existe un unique déplacement
  f tel que f(A) = D et f(C) = A ; b. préciser la nature et les éléments caractéristiques de f. 2. g = f∘r ;
  a. montrer que g est une translation ; b. F = g(E) ; montrer que f(B) = F et en déduire la nature du
  triangle BIF ; c. montrer que C, A et F sont alignés.
- **Ex. 15** (p.70) : repère orthonormé direct (O, u⃗, v⃗) ; j = e^{2iπ/3} ; A, B, C d'affixes a = 8,
  b = 6j, c = 8j² ; A′ image de B par la rotation de centre C et d'angle π/3, B′ image de C par la rotation
  de centre A et d'angle π/3, C′ image de A par la rotation de centre B et d'angle π/3. 1.a. placer A, B,
  C, A′, B′, C′ ; b. déterminer les affixes a′, b′, c′ ; c. montrer que (AA′), (BB′) et (CC′) sont
  concourantes en O. 2.a. calculer OA + OB + OC ; b. montrer que 1 + j + j² = 0. 3. M d'affixe z ; a.
  montrer que |(a−z) + (b−z)j² + (c−z)j| = |a + bj² + cj| = 22 ; b. montrer que |z + z′ + z″| ≤ |z| + |z′|
  - |z″| ; c. en déduire une condition sur M pour que MA + MB + MC soit minimale.
- **Ex. 16** (p.70) : deux triangles équilatéraux directs ABC et DEF ; G et H tels que EDBG et CDFH soient
  des parallélogrammes. But : démontrer de deux manières (nombres complexes / composées de déplacements)
  que le triangle AGH est équilatéral. I/ repère orthonormé direct ; a, b, c, d, e, f, g, h les affixes de
  A, …, H. 1. montrer que c − a = e^{iπ/3}(b − a) ; exprimer (f − d) à l'aide de (e − d). 2. exprimer g à
  l'aide de b, d, e ; exprimer h en fonction de c, d, f. 3. montrer que h − a = e^{iπ/3}(g − a) ; en
  déduire que AGH est équilatéral. II/ t₁ = t_(BD⃗), t₂ = t_(DC⃗), R la rotation de centre D et d'angle
  π/3 ; f = t₂∘R∘t₁. 1.a. justifier que f est une rotation et préciser son angle ; b. déterminer l'image de
  B par f et en déduire le centre de f. 2. déterminer l'image de G par f et montrer que AGH est équilatéral.
- **Ex. 17** (p.70) : ABCD un carré direct de centre O ; f l'antidéplacement qui transforme A en D et D en
  C. 1. montrer que f est une symétrie glissante et déterminer ses éléments caractéristiques. 2. E = f(C) ;
  a. montrer que DCE est un triangle isocèle, rectangle en C et direct ; b. construire E ; c. déterminer et
  construire l'image F de B par f. 3. déterminer et caractériser l'application f∘S_(AD).
- **Ex. 18** (p.70–71) : rectangle ABCD ; O, I, J, K les milieux respectifs de [AD], [BC], [OB] et [OC].
  1.a. déterminer les images de B et I par t_[?]∘S_[?] (indices source peu lisibles) ; b. déterminer toutes
  les isométries qui transforment B en O et I en D. 2. Δ la médiatrice de [IC] ; a. construire le point E
  image de B par S_Δ ; b. L le milieu de [CD] ; déterminer l'image de D par S_L. c. en déduire la nature de
  S_L∘t_[?]∘S_[?] (indices source peu lisibles).
- **Ex. 19** (p.71) : repère orthonormé direct (O, i⃗, j⃗) ; déterminer les expressions analytiques, la
  nature et les éléments caractéristiques de f. a. A(1, 2), u⃗ = i⃗ − j⃗, f = R(A, π/3)∘t_u⃗. b. D :
  2x − 3y + 1 = 0, u⃗ = i⃗ + j⃗, f = t_u⃗∘S_D. c. D₁ : y − 1 = 0, D₂ : x − y − 1 = 0, f = S_(D₁)∘S_(D₂).
- **Ex. 20** (p.71) : repère orthonormé direct (O, i⃗, j⃗) ; r l'application P → P qui à M(x, y) associe
  M′(x′, y′) tel que x′ = 1 − y et y′ = x. 1. montrer que r est une rotation dont on précisera le centre A
  et une mesure de l'angle. 2. f = r∘S_(O, j⃗) ; montrer que f est une symétrie glissante que l'on
  caractérisera.
- **Ex. 21** (p.71) : (E) : z³ − (2 + 4i)z² − (9 − 10i)z + 18 + 6i = 0. 1.a. vérifier que 3 est racine de
  (E) ; b. en déduire les deux autres solutions z₁ et z₂ (z₁ ayant la partie réelle positive). Le plan
  rapporté à un repère orthonormé direct (O, u⃗, v⃗) ; A, B, C d'affixes respectives 3, z₁, z₂. a. montrer
  que OABC est un parallélogramme ; b. montrer qu'il existe un unique déplacement f et un unique
  antidéplacement g transformant O en B et A en C. 2. identifier f. 3. S la symétrie orthogonale d'axe
  (OA) ; montrer que g = f∘S.
- **Ex. 22** (p.71) : A, B, C et A′ quatre points distincts d'un cercle Γ de centre O. 1. faire une figure
  et placer B′ et C′ tels que (AB′) et (A′B) soient respectivement parallèles à (BC′) et (B′C). 2. Δ₁, Δ₂,
  Δ₃ les médiatrices respectives de [AB′], [CB′], [CA′] ; S₁, S₂, S₃ les symétries d'axes Δ₁, Δ₂, Δ₃ ; a.
  montrer que f = S₃∘S₂∘S₁ est une symétrie orthogonale ; b. identifier f∘f ; c. montrer que S₃(C′) = A et
  en déduire que (AC′) et (A′C) sont parallèles.
- **Ex. 23** (p.71–72) : carré ABCD de centre I tel que (AB⃗, AD⃗) ≡ π/2 [2π]. **A/** J, K les milieux de
  [AD] et [CD] ; C′ le symétrique de C par rapport à D ; R_D et R_B les rotations d'angle π/2 et de centres
  D et B ; S_I et S_K les symétries centrales de centres I et K. 1. f = R_D∘S_I∘R_B ; a. déterminer f(B) ;
  b. montrer que f est une translation que l'on caractérisera. 2. g = f∘S_(IJ) ; a. déterminer g(C) et
  g(D) ; b. en déduire que g est une symétrie glissante et déterminer ses éléments caractéristiques. 3.a.
  montrer que S_(AD)∘S_(CD)∘S_(IK)∘S_[?] = f (indice source peu lisible) ; b. en déduire que S_K∘S_(IJ) =
  S_(AD)∘f ; c. montrer que S_(AD)∘f est une symétrie glissante et déterminer ses éléments caractéristiques.
  **B/** Ω le point d'intersection des bissectrices intérieures du triangle ABD ; r la rotation de centre A
  et d'angle π/2, r′ la rotation de centre D et d'angle π/4. 1. construire A′ image de A par r′. 2.
  identifier r′∘r. 3. montrer que (ΩA′) et (AB) sont parallèles.
- **Ex. 24** (p.72) : ABC un triangle direct, A′ le milieu de [BC] ; P et Q définis par PA = PC,
  (PA⃗, PC⃗) ≡ π/2 [2π] et QB = QA, (QB⃗, QA⃗) ≡ π/2 [2π] ; Ω le milieu de [PQ], I le milieu de [QA′], J le
  milieu de [PA′], P′ le symétrique de P par rapport à A′ ; R_P et R_Q les rotations d'angle π/2 et de
  centres P et Q ; f = R_Q∘S_(A′)∘R_P. 1.a. déterminer f(A) ; caractériser f ; b. montrer que R_Q(P′) = P.
  2.a. montrer qu'il existe un unique déplacement φ tel que φ(A′) = Q et φ(P) = A′ ; b. caractériser φ ; c.
  donner la nature et les éléments caractéristiques de h = φ∘S_(A′Q). 3. ψ l'antidéplacement qui envoie A′
  sur Q et P sur A′ ; a. montrer que ψ(J) = I ; b. montrer que ψ est une symétrie glissante ; c. déterminer
  ses éléments caractéristiques. 4. M un point ; ψ(M) = M₁, φ(M) = M₂ ; montrer que M₁ et M₂ sont
  symétriques par rapport à une droite fixe que l'on déterminera.
- **Ex. 25** (p.72–73) : carré ABCD de centre I tel que (AB⃗, AD⃗) ≡ π/2 [2π] ; E le point tel que DCE est
  un triangle équilatéral direct ; J, K, L les milieux respectifs de [DC], [AD], [DE] ; O le centre du
  cercle circonscrit à DCE. 1. φ = R(D, π/3)∘S_(IJ) ; a. déterminer φ(C) et φ(D) ; b. montrer que φ est une
  symétrie glissante dont on déterminera les éléments caractéristiques. 2.a. caractériser t_(AD⃗)∘S_(AB) ;
  b. en déduire la nature et les éléments caractéristiques de ψ = t_(BD⃗)∘S_(AB). 3. pour tout point N,
  N₁ = R(D, π/3)(N) et N₂ = R(O, −2π/3)(N) ; montrer que le milieu de [N₁N₂] est un point fixe que l'on
  précisera. 4. M₀ un point du plan ; suite (Mₙ) telle que φ(Mₙ) = Mₙ₊₁ pour tout n ∈ ℕ ; a. montrer par
  récurrence que M₀M₂ₙ⃗ = (2n)·[?] (vecteur source peu lisible) ; b. en déduire que M₂ₙ appartient à une
  droite fixe que l'on précisera.
- **Ex. 26** (p.72–73) : rectangle ABCD tel que AB = 2BC et (AB⃗, AD⃗) ≡ π/2 [2π] ; I et J les milieux
  respectifs de [AB] et [CD]. 1.a. montrer qu'il existe un unique déplacement f tel que f(A) = C et
  f(I) = J ; b. caractériser f puis en déduire que f(B) = D. 2. déterminer la droite Δ telle que
  f = S_(IJ)∘S_Δ. 3. r la rotation de centre I et d'angle π/2 ; a. déterminer r(B), r(C) et r(J) ; b. M un
  point de [CJ], la perpendiculaire à (IM) issue de I coupe la perpendiculaire à (BM) issue de J en M′ ;
  quel est l'ensemble des M′ lorsque M décrit [CJ] ? 4. g = r∘f ; a. montrer que g est une rotation dont on
  précisera l'angle ; b. déterminer g(A) ; c. déduire la construction du centre de g. 5.a. montrer qu'il
  existe un unique antidéplacement h tel que h(A) = C et h(I) = J ; b. montrer que h est une symétrie
  glissante ; c. montrer que h(B) = D. 6. déterminer les éléments caractéristiques de h par deux méthodes —
  **Première méthode** : a. déterminer h∘S_(AB)(A) et h∘S_(AB)(B) ; en déduire h∘S_(AB) ; b. déterminer les
  éléments caractéristiques de h. **Deuxième méthode** : a. D′ = h(D) ; montrer que (CD⃗, CD′⃗) ≡ −π/2 [2π]
  et CD′ = AD ; en déduire que D′ est le symétrique de B par rapport à C ; b. en déduire les éléments
  caractéristiques de h ; c. construire le point C′ = h(C). 7. le cercle de diamètre [AB] recoupe [AC] en
  E ; le cercle de diamètre [CD] recoupe [CC′] en E′ ; F le symétrique de E′ par rapport à (IJ) ; montrer
  que (EF) est parallèle à (AD).
- **Ex. 27** (p.73) : AFED un carré de côté 4 cm tel que (AF⃗, AD⃗) ≡ π/2 [2π] et O son centre ; B et O₁ les
  symétriques respectifs de A et O par rapport à (EF). 1.a. r la rotation définie par r(F) = E et r(E) = D ;
  préciser l'angle et le centre de r ; b. f = r∘S_(OO₁) ; montrer que f est la symétrie orthogonale d'axe
  (OE). 2. r′ = t_(OO₁⃗)∘r⁻¹ ; a. montrer que r′ est une rotation dont on précisera l'angle ; b. déterminer
  r′(O) ; en déduire que F est le centre de r′. 3. g l'antidéplacement défini par g(D) = F et g(O) = O₁ ;
  a. montrer que g est une symétrie glissante et déterminer sa forme réduite ; b. M un point du plan ;
  montrer que g(M) = r′(M) ssi f(M) = M ; c. en déduire l'ensemble des points M tels que g(M) = r′(M).
- **Ex. 28** (p.73) : ABC un triangle tel que (AB⃗, AC⃗) ≡ π/3 [2π] ; O le centre du cercle 𝒞 circonscrit ;
  I le point d'intersection des bissectrices intérieures ; P et Q sur les demi-droites [CA) et [BA)
  vérifiant CP = BQ = BC. 1.a. montrer que (CI) est la médiatrice de [PB] et (BI) la médiatrice de [CQ] ;
  b. montrer que (CP⃗, QB⃗) ≡ 2π/3 [2π]. 2. f la rotation qui transforme C en Q et P en B ; a. montrer que f
  a pour centre I et pour angle 2π/3 ; b. montrer que (IB⃗, IC⃗) ≡ 2π/3 [2π] ; c. montrer que I, P et Q sont
  alignés. 3. O₁ = f(O), O₂ = f(O₁) ; a. montrer que O = f(O₂) ; b. en déduire que OO₁O₂ est équilatéral et
  que (OI) est la médiatrice de [O₁O₂]. 4. r la rotation de centre O et d'angle 2π/3 ; g = f∘r∘f ; a.
  montrer que g est une translation ; vérifier que g(O₂) = O₁ ; en déduire le vecteur ; b. montrer que
  r(B) = C ; en déduire que g(P) = Q ; c. montrer que (OI) et (PQ) sont perpendiculaires.

### Bornes de scope observées (chapitre 12)

- ✅ INCLUS : **définition** d'un **déplacement** (isométrie conservant les mesures des angles orientés) et
  d'un **antidéplacement** (isométrie changeant les angles orientés en leurs opposés) ; caractérisation par
  la **composition de symétries orthogonales** (déplacement ⇔ composée de 2 symétries ; antidéplacement ⇔
  1 symétrie ou composée de 3) et **classification** (identité/rotation/translation = déplacements ;
  symétrie orthogonale/symétrie glissante = antidéplacements) ; règles de **composition et de réciproque**
  (dép∘dép = dép, antidép∘antidép = dép, dép∘antidép = antidép ; réciproque conserve la nature) ; unicité
  (deux déplacements — resp. antidéplacements — coïncidant sur 2 points sont égaux) ; **détermination** :
  unique déplacement et unique antidéplacement envoyant A→C, B→D quand AB⃗ = CD⃗ ≠ 0⃗ ; **angle d'un
  déplacement** (θ = 2kπ ⇒ translation, sinon rotation d'angle θ ; angle de la composée = θ + θ′ ; angle de
  la réciproque = −θ) ; **composition de deux translations**, **de deux rotations** (translation si
  θ + θ′ ≡ 0 [2π], sinon rotation d'angle θ + θ′) et **d'une rotation et d'une translation** (rotation de
  même angle) ; **expression complexe** d'un déplacement — translation z′ = z + b, rotation z′ = az + b
  avec a = e^{iθ} (|a| = 1), centre z_I = b/(1−a) ; **antidéplacement** = composée d'une symétrie
  orthogonale et d'une translation ; **symétrie glissante**, **forme réduite** f = t_u⃗∘S_D = S_D∘t_u⃗ (u⃗
  directeur de D), axe et vecteur comme éléments caractéristiques, propriétés (milieu de [MM′] sur l'axe,
  f∘f = t_(2u⃗)).
- ⛔ NON traité dans ce chapitre : l'écriture complexe d'un **antidéplacement** (z′ = az̄ + b, |a| = 1)
  n'est **pas** énoncée comme théorème encadré (le manuel caractérise l'antidéplacement par sa
  décomposition symétrie∘translation, pas par une forme complexe conjuguée) ; les **similitudes** (|a| ≠ 1)
  et l'**homothétie** (chapitres suivants du tome 2) ; la **réduction matricielle** générale (les équations
  analytiques sont traitées cas par cas) ; toute isométrie de l'**espace** (le chapitre est strictement
  plan). Le chapitre suppose acquis le **chapitre 11 (Isométries du plan)** — décomposition en symétries
  orthogonales, points fixes, isométrie réciproque — qu'il prolonge en distinguant orientation directe /
  indirecte.

## 2.13 Chapitre 13 — Similitudes (manuel 222446, p.74–95)

**Page de garde (p.74)** — Titre de couverture : « Similitudes », Chapitre 4 (numérotation interne
du tome 2 ; c'est le chapitre 13 dans la numérotation content ; le bandeau courant écrit
« Similitudes »). Encart historique : rappel que dans son programme d'Erlangen, en 1872, Felix Klein
propose le caractère d'aujourd'hui de la géométrie, en la considérant comme l'étude d'une famille de
transformations ; que certaines familles méritent une étude particulière (celles dont la composée de
deux transformations, l'identité et la transformation inverse appartiennent encore à la famille —
elles forment alors un groupe) ; que parmi ces transformations, les déplacements, les symétries, les
similitudes et leurs composés forment ce que Klein appelle le groupe principal de la géométrie
euclidienne, dont les propriétés métriques sont les propriétés invariantes. Référence : « (J.
Dhombres et al, Mathématiques au fil des âges, 1987). » Mention liminaire (p.75) : « Dans tout le
chapitre, le plan est orienté dans le sens direct. » Le chapitre est structuré en cinq parties
**I. Homothéties et translations**, **II. Similitudes**, **III. Similitudes directes – Similitudes
indirectes**, **IV. Similitudes directes** (angle, centre, forme réduite, nombres complexes),
**V. Similitudes indirectes** (forme réduite, nombres complexes), ponctuées d'activités et de trois
exercices résolus, suivies d'un QCM / Vrai-Faux, puis d'une rubrique « Exercices et problèmes »
(27 exercices).

### Cours — Activités

**I. Homothéties et translations** (p.75)

- **Activité 1** (p.75) : ABCD un trapèze et M un point ; les droites (AD) et (BC) se coupent en O ; h
  l'homothétie de centre O qui transforme A en D. 1. montrer que h transforme B en C. 2. construire
  l'image du point M par h. (Figure.)
- **Activité 2** (p.76) : A et B deux points distincts, h₁ et h₂ deux homothéties de centres respectifs A
  et B et de rapports respectifs 2 et 1/3. Construire le centre de chacune des homothéties h₂∘h₁ et h₁∘h₂.
- **Activité 3** (p.76) : t une translation de vecteur u⃗ et h une homothétie de rapport k ≠ 1. 1.a. A et B
  deux points d'images A′ et B′ par h∘t ; montrer que A′B′⃗ = kAB⃗. b. quelle est la nature de h∘t ? 2. déterminer de même la nature de t∘h.
- **Activité 4** (p.77) : donner, dans chaque cas, la nature et les éléments caractéristiques de
  l'application f : M(z) ↦ M′(z′). a. z′ = −2z + 3. b. z′ = 4z + 1 − i.

**II. Similitudes** (p.77)

- **Activité 1** (p.77) : ABC et A′B′C′ deux triangles tels que A′B′/AB = A′C′/AC = B′C′/BC ; I un point de
  [A′B′] tel que A′I = AB et J un point de [A′C′] tel que A′J = AC. 1. montrer que les droites (IJ) et
  (B′C′) sont parallèles. 2. montrer qu'il existe une isométrie g qui envoie A, B et C respectivement sur
  A′, I et J. 3. h l'homothétie de centre A′ qui envoie I sur B′ et S = h∘g ; déterminer les images de A, B
  et C par S. (Figure.)
- **Activité 2** (p.79) : deux triangles ABC et A′B′C′ sont dits semblables s'il existe une similitude qui
  envoie A, B et C sur A′, B′ et C′. 1. ABC et A′B′C′ deux triangles semblables ; montrer que
  A′B′/AB = A′C′/AC = B′C′/BC. 2. montrer que deux triangles ABC et A′B′C′ sont semblables, si et seulement
  si, Â = Â′, B̂ = B̂′ et Ĉ = Ĉ′.

**III. Similitudes directes – Similitudes indirectes** (p.80)

- **Activité 1** (p.80) : h et h₁ deux homothéties et g et g₁ deux isométries telles que h∘g = h₁∘g₁.
  1. montrer que h₁⁻¹∘h est un déplacement. 2. montrer que g est un déplacement, si et seulement si, g₁ est
     un déplacement.

**IV. Similitudes directes — IV.1 Angle d'une similitude directe** (p.81)

- **Activité 1** (p.81) : f et g deux similitudes directes d'angles respectifs θ et θ′ ; A et B deux points
  distincts, A′ et B′ les images de A et B par g et A″ et B″ les images de A′ et B′ par f. Déterminer
  (AB⃗, A″B″⃗) et (A′B′⃗, AB⃗).

**IV.2 Centre d'une similitude directe** (p.81)

- **Activité 1** (p.81) : A et B deux points distincts et k un réel strictement positif et différent de 1 ;
  E l'ensemble des points M tels que MA = kMB. 1. montrer que M ∈ E, si et seulement si,
  (MA⃗ − kMB⃗)·(MA⃗ + kMB⃗) = 0. 2. G le barycentre de (A, 1) et (B, −k) et G′ le barycentre de (A, 1) et
  (B, k) ; montrer que M ∈ E, si et seulement si, MG⃗·MG′⃗ = 0. 3. en déduire que E est le cercle de diamètre
  [GG′].
- **Activité 2** (p.82) : A et B deux points distincts. Déterminer et construire, dans chaque cas,
  l'ensemble F des points M du plan tels que a. (MA⃗, MB⃗) ≡ π/3 [2π]. b. (MA⃗, MB⃗) ≡ π/2 [2π]. c.
  (MA⃗, MB⃗) ≡ 4π/3 [2π].
- **Activité 3** (p.83) : A et B deux points distincts ; f une similitude directe qui ne fixe aucun des
  points A et B ; A′ et B′ les images de A et B par f, telles que (AA′) et (BB′) soient strictement
  parallèles. 1. montrer que si deux points C et D de (AB) vérifient CA = DA et CB = DB alors C = D. 2. montrer que si (AB) et (A′B′) sont parallèles, alors le rapport de f vaut 1. 3. f de rapport k ≠ 1, I
  l'intersection des droites (AB) et (A′B′) ; a. montrer que l'image I′ de I par f appartient à (A′B′).
  b. montrer que I′A′ = IA′ et I′B′ = IB′. c. en déduire le centre de f.

**IV.3 Forme réduite d'une similitude directe** (p.84)

- **Activité 1** (p.84) : f une similitude directe de centre I, de rapport k et d'angle non nul θ, h
  l'homothétie de centre I et de rapport k et r la rotation de centre I et d'angle θ. 1. donner les éléments
  caractéristiques des similitudes f, h∘r et r∘h. 2. en déduire que f = h∘r = r∘h.
- **Activité 2** (p.84–85) : I un point du plan. Donner la forme réduite de la similitude h∘r dans chacun
  des cas. 1. h l'homothétie de centre I et de rapport −1/2, r l'identité. 2. h l'homothétie de centre I et
  de rapport −1/2, r la rotation de centre I et d'angle 2π/3. 3. h l'homothétie de centre I et de rapport
  −1/2, r la symétrie centrale de centre I.
- **Activité 3** (p.86) : AECD un carré [sic — le texte écrit « AECD » ; contexte : carré] de centre B ; h
  l'homothétie de centre A et de rapport 2, r la rotation de centre B qui envoie C sur D. Donner les
  éléments caractéristiques des similitudes h∘r et r∘h.

**IV.4 Similitudes directes et nombres complexes** (p.85)

- **Activité 1** (p.85) : plan rapporté à un repère orthonormé direct (O, i⃗, j⃗) ; h l'homothétie de centre
  A(0, 1) et de rapport 2, r la rotation de centre O et d'angle π/3 ; M un point d'affixe z, M′ son image
  par r et M″ l'image de M′ par h ; z′ et z″ les affixes de M′ et M″. Exprimer z′ en fonction de z, puis z″
  en fonction de z.
- **Activité 2** (p.86) : plan rapporté à un repère orthonormé direct (O, i⃗, j⃗). Donner la nature de f et
  préciser ses éléments caractéristiques : a. z′ = −2iz + 3. b. z′ = 4z + 1 − i. c. z′ = e^{iθ/6}·z + 1
  [sic — l'exposant imprimé est « iθ/6 », θ non défini dans l'énoncé ; vraisemblablement iπ/6].
- **Activité 3** (p.86) : ABC un triangle isocèle rectangle en A vérifiant (AB⃗, AC⃗) ≡ π/2 [2π] et AB = AC =
  1 ; D le milieu de [BC] et le plan muni du repère (A, AB⃗, AC⃗). Donner l'écriture complexe de la
  similitude directe de centre A qui envoie C sur D.

**V. Similitudes indirectes** (p.86)

- **Activité 1** (p.86) : OBO′A un losange, les droites (CD) et (AB) parallèles ; h l'homothétie de centre O
  qui envoie C sur B, S la symétrie orthogonale d'axe (AB) ; on pose f = h∘S. 1. E et F les symétriques
  respectifs de C et D par rapport à (AB) ; déterminer les images par f des points O′, E et F. 2. I le point
  d'intersection de [AE] et (OO′) et I′ son symétrique par rapport à (AB) ; montrer que I′ appartient à [AC]
  et en déduire que I est le centre de f. (Figure.)

**V.1 Forme réduite d'une similitude indirecte** (p.87)

- **Activité 1** (p.87) : f une similitude indirecte de centre I et de rapport k ≠ 1 ; h l'homothétie de
  centre I et de rapport k. 1. montrer que h⁻¹∘f est une symétrie orthogonale d'axe une droite D passant par
  I. 2. M un point distinct de I et M′ son image par f ; montrer que M appartient à D, si et seulement si,
  IM′⃗ = kIM⃗. 3. montrer que h∘S_D = S_D∘h.
- **Activité 2** (p.87) : ABCD un carré direct de centre O ; I le milieu de [AB]. 1. f la similitude directe
  telle que f(A) = B et f(D) = I ; déterminer le rapport et l'angle de f et construire son centre Ω. 2. g =
  f∘S_(ΩC) ; montrer que g est une similitude indirecte dont on précisera les éléments caractéristiques.
- **Activité 3** (p.87) : f une similitude indirecte de centre I, de rapport k ≠ 1, d'axe D et u⃗ un vecteur
  directeur de D. Montrer que (u⃗, IM′⃗) ≡ −(u⃗, IM⃗) [2π], pour tout point M distinct de I, d'image M′ par f.
  (Figure.)

**V.2 Similitude indirecte et nombres complexes** (p.88)

- **Activité** (p.89) : plan rapporté à un repère orthonormé direct (O, i⃗, j⃗) ; f la similitude indirecte
  qui à tout M d'affixe z associe le point M′ d'affixe z′ tel que z′ = −2iz̄ + 6 (z̄ le conjugué de z).
  1. montrer que f est une similitude indirecte dont on déterminera le rapport et le centre I. 2. déterminer
     l'ensemble des M d'affixe z tels que IM′⃗ = 2IM⃗ ; en déduire une équation de l'axe de f.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Définition (rappel)** (p.75, homothétie) — « Soit I un point et k un réel non nul. On appelle
> homothétie de centre I et de rapport k l'application du plan dans lui-même qui à tout point M associe
> l'unique point M′ tel que IM′⃗ = kIM⃗. »

> **Théorème (propriété caractéristique d'une homothétie)** (p.75) — « Soit k un réel non nul et différent
> de 1. Une application f est une homothétie de rapport k, si et seulement si, pour tous points M et N
> d'images M′ et N′ par f, M′N′⃗ = kMN⃗. »

> **Théorème** (p.75) — « Toute homothétie conserve les mesures des angles orientés. »

> **Théorème** (p.76, composée de deux homothéties) — « La composée de deux homothéties de rapports
> respectifs k₁ et k₂ est une homothétie de rapport k₁k₂ si k₁k₂ ≠ 1, une translation si k₁k₂ = 1. »

> **Théorème** (p.76) — « La composée d'une translation et d'une homothétie de rapport k ≠ 1 est une
> homothétie de rapport k. »

> **Théorème** (p.77, homothétie et nombres complexes) — « Soit f une application du plan dans lui-même qui
> à tout M d'affixe z associe le point M′ d'affixe z′. L'application f est une homothétie de rapport k ≠ 1,
> si et seulement si, il existe un nombre complexe b tel que z′ = kz + b. De plus, l'affixe z_A du centre A
> de l'homothétie f vérifie z_A = b/(1−k). »

> **Définition** (p.77, similitude) — « Soit k un réel strictement positif. On appelle similitude de rapport
> k, toute application du plan dans lui-même telle que pour tous points A et B d'images respectives A′ et
> B′, A′B′ = k·AB. »

> **Exemples** (p.78) — « Les isométries sont des similitudes de rapport 1. Toute homothétie de rapport k
> est une similitude de rapport |k|. »

> **Théorème** (p.78) — « La composée de deux similitudes de rapports respectifs k et k′ est une similitude
> de rapport kk′. »

> **Théorème** (p.78) — « Une application du plan dans lui-même est une similitude, si et seulement si, elle
> est la composée d'une homothétie et d'une isométrie. »

> **Théorème** (p.78) — « Pour tous points A, B, C et D, d'images respectives A′, B′, C′ et D′ par une
> similitude de rapport k, A′B′⃗·C′D′⃗ = k²·AB⃗·CD⃗. »

> **Propriétés** (p.79) — « • Une similitude de rapport k est une bijection et sa réciproque est une
> similitude de rapport 1/k. • Une similitude conserve les angles géométriques. • Une similitude conserve
> l'orthogonalité. • Une similitude conserve l'alignement et le barycentre. • Une similitude transforme un
> segment en un segment. • Une similitude transforme une droite en une droite. • Une similitude conserve le
> parallélisme. • Une similitude transforme un cercle en un cercle et conserve le contact. • Soit A, B, C,
> D, E, F des points du plan et A′, B′, C′, D′, E′, F′ leurs images respectives par une similitude. Si AB⃗ =
> aCD⃗ + bEF⃗ où a ∈ ℝ et b ∈ ℝ, alors A′B′⃗ = aC′D′⃗ + bE′F′⃗. »

> **Théorème** (p.79) — « Deux similitudes qui coïncident sur trois points non alignés coïncident sur tout
> le plan. »

> **Propriétés** (p.79) — « Soit f, g et h trois similitudes. • (f∘g)⁻¹ = g⁻¹∘f⁻¹. • f = g, si et seulement
> si, h∘f = h∘g. »

> **Définition** (p.80, directe / indirecte) — « On dit qu'une similitude est directe si elle est la
> composée d'une homothétie et d'un déplacement. On dit qu'une similitude est indirecte si elle est la
> composée d'une homothétie et d'un antidéplacement. »

> **Conséquence** (p.80) — « Toute similitude directe conserve les mesures des angles orientés. Toute
> similitude indirecte change les mesures des angles orientés en leurs opposées. »

> **Théorème** (p.80) — « • La composée de deux similitudes directes est une similitude directe. • La
> composée de deux similitudes indirectes est une similitude directe. • La composée d'une similitude directe
> et d'une similitude indirecte est une similitude indirecte. • La réciproque d'une similitude directe est
> une similitude directe. • La réciproque d'une similitude indirecte est une similitude indirecte. »

> **Théorème** (p.80) — « Soit A, B, C et D des points du plan tels que A ≠ B et C ≠ D. Il existe une unique
> similitude directe qui envoie A sur C et B sur D. Il existe une unique similitude indirecte qui envoie A
> sur C et B sur D. »

> **Théorème et définition** (p.81, angle d'une similitude directe) — « Soit f une similitude directe et A,
> B, C et D des points tels que AB ≠ 0 et CD ≠ 0. Soit A′, B′, C′ et D′ les images respectives de A, B, C et
> D. Alors (AB⃗, A′B′⃗) ≡ (CD⃗, C′D′⃗) [2π]. En désignant par θ une mesure de l'angle (AB⃗, A′B′⃗), on dit que
> f est une similitude directe d'angle θ. »

> **Théorème** (p.81) — « Soit f et g deux similitudes directes d'angles respectifs θ et θ′. La similitude
> directe f∘g est d'angle θ + θ′. La similitude directe f⁻¹ est d'angle −θ. »

> **Théorème** (p.82, centre) — « Toute similitude directe de rapport différent de 1 admet un unique point
> fixe, appelé centre de la similitude. »

> **Conséquence** (p.82) — « Une similitude directe de rapport différent de 1 est parfaitement déterminée
> par la donnée de son centre, son rapport et son angle. Le centre, le rapport et l'angle d'une similitude
> directe sont appelés éléments caractéristiques de cette similitude. Une application f est une similitude
> directe de rapport k ≠ 1, de centre I et d'angle θ, si et seulement si, pour tout point M distinct de I,
> d'image M′, IM′ = k·IM et (IM⃗, IM′⃗) ≡ θ [2π]. »

> **Théorème** (p.84, forme réduite d'une similitude directe) — « Toute similitude directe de centre I, de
> rapport k ≠ 1 et d'angle θ se décompose sous la forme f = h∘r = r∘h où h est l'homothétie de centre I et
> de rapport k et r est la rotation de centre I et d'angle θ. Cette décomposition s'appelle forme réduite de
> f. »

> **Théorème** (p.85, similitude directe et nombres complexes) — « Le plan est rapporté à un repère
> orthonormé direct (O, i⃗, j⃗). Soit f une application du plan dans lui-même qui à tout point M d'affixe z
> associe le point M′ d'affixe z′. L'application f est une similitude directe de centre I, de rapport k ≠ 1
> et d'angle θ, si et seulement si, il existe deux nombres complexes a et b tels que z′ = az + b, avec a =
> ke^{iθ} et z_I = b/(1−a) est l'affixe de I. »

> **Théorème et définition** (p.86, centre d'une similitude indirecte) — « Une similitude indirecte de
> rapport différent de 1 admet un unique point fixe, appelé centre de la similitude. »

> **Théorème** (p.87, forme réduite d'une similitude indirecte) — « Soit f une similitude indirecte de
> centre I et de rapport k ≠ 1 et h l'homothétie de centre I et de rapport k. Il existe une droite D telle
> que f se décompose de manière unique sous la forme f = h∘S_D = S_D∘h, où S_D est la symétrie orthogonale
> d'axe D. Dans ce cas, la droite D est l'ensemble des points M tels que IM′⃗ = kIM⃗, où M′ = f(M). Cette
> décomposition est appelée forme réduite de f. La droite D est appelée axe de la similitude indirecte f. »

> **Conséquences** (p.87) — « Une similitude indirecte de rapport différent de 1, est parfaitement
> déterminée par son rapport, son centre et son axe, qui sont appelés éléments caractéristiques de cette
> similitude. L'axe D d'une similitude indirecte de centre I et la perpendiculaire à D passant par I sont
> globalement invariants par f. Si f est une similitude indirecte de centre I et de rapport k alors f∘f est
> une homothétie de centre I et de rapport k². »

> **Propriété** (p.88, similitude indirecte) — « Soit f une similitude indirecte de centre I, de rapport
> différent de 1 et d'axe D. Si u⃗ est un vecteur directeur de D, alors (u⃗, IM′⃗) ≡ −(u⃗, IM⃗) [2π], pour
> tout M distinct de I, d'image M′. La droite D porte donc la bissectrice intérieure de MIM′. »

> **Théorème** (p.88, similitude indirecte et nombres complexes) — « Le plan est rapporté à un repère
> orthonormé direct (O, i⃗, j⃗). Soit f une application du plan dans lui-même qui à tout M d'affixe z associe
> le point M′ d'affixe z′. L'application f est une similitude indirecte de centre I et de rapport k ≠ 1, si
> et seulement si, il existe deux nombres complexes a et b tels que z′ = az̄ + b. Dans ce cas k = |a| et
> z_I = (a·b̄ + b)/(1 − |a|²) est l'affixe du point I. »

### Cours — Exercices résolus

**Exercice résolu 1** (énoncé + solution p.83) : A, B, C et D des points distincts tels que BD = (1/3)AC et
(AC⃗, BD⃗) ≡ π/3 [2π]. Construire le centre I de la similitude directe S qui transforme A en B et C en D.
**Solution** : le centre I de S vérifie IA = 3IB et (IA⃗, IB⃗) ≡ π/3 [2π]. En désignant par G et G′ les
barycentres respectifs de (A, 1), (B, 3) et de (A, 1), (B, −3), le point I appartient à l'intersection du
cercle de diamètre [GG′] et de l'arc de cercle ensemble des points M du plan tels que
(MA⃗, MB⃗) ≡ π/3 [2π]. (Figure.)

**Exercice résolu 2** (énoncé p.83, solution p.84) : 𝒞 et 𝒞′ deux cercles de centres respectifs O et O′ se
coupant en A et B. 1.a. montrer qu'il existe une unique similitude directe f de centre A qui transforme 𝒞
en 𝒞′. b. préciser le rapport et l'angle de f. 2. M un point de 𝒞 ; a. construire son image M′ par f. b.
comparer (OA⃗, OM⃗) et (O′A⃗, O′M′⃗). c. en déduire que les points M, B et M′ sont alignés. **Solution** :
1.a. l'unique similitude directe envoyant A sur A et O sur O′ transforme nécessairement 𝒞 en 𝒞′. b. c'est
la similitude de centre A, de rapport OA′/OA (= O′A/OA) et d'angle (AO⃗, AO′⃗). 2. M′ appartient à 𝒞′ et
vérifie (AM⃗, AM′⃗) ≡ (AO⃗, AO′⃗) [2π] (intersection de 𝒞′ avec la demi-droite [AX)) ; f conservant les
angles orientés, (OA⃗, OM⃗) ≡ (O′A⃗, O′M′⃗) [2π] ; via les angles au centre et la relation de Chasles,
(BM⃗, BM′⃗) ≡ kπ, k ∈ ℤ, ce qui prouve l'alignement de M, B et M′. (Figure.)

**Exercice résolu** (énoncé + solution p.88, similitude indirecte) : OABC un rectangle tel que OA = 2OC et
(OA⃗, OC⃗) ≡ π/2 [2π] ; la médiatrice Δ de [OB] coupe la droite (OA) en I et la droite (OC) en I′ ; J et J′
les symétriques respectifs de O par rapport à I et I′. 1. montrer que les triangles OBJ et OBJ′ sont
rectangles en B. 2. en déduire que les points B, J et J′ sont alignés. 3. S la similitude indirecte qui
transforme J en O et O en J′. a. donner le rapport de S et en déduire que S admet un unique point fixe Ω.
b. caractériser S∘S et en déduire que Ω appartient à (JJ′). c. construire Ω et l'axe de S. **Solution** : I
est le milieu de [OJ] et le triangle OBJ est rectangle en B (de même OBJ′) ; le rapport de S est OJ′/OJ =
tan(JÔD [?]) = OA/AB = 2, donc S admet un unique point fixe Ω ; S∘S est l'homothétie de centre Ω et de
rapport 4, et S∘S(J) = S(O) = J′, d'où ΩJ′⃗ = 4ΩJ⃗ et Ω ∈ (JJ′) ; l'axe de S est la droite portant la
bissectrice intérieure de l'angle OΩJ. (Figure.)

### QCM (p.90) — « Cocher la réponse exacte. » Le plan est muni d'un repère orthonormé direct (O, u⃗, v⃗) ; M(z) et M′(z′).

1. Soit I un point quelconque. L'homothétie h(I, −4) est (☐ une similitude indirecte de rapport 4 / ☐ une
   similitude directe de rapport 4 et d'angle nul / ☐ une similitude directe de rapport 4 et d'angle π).
2. Soit I et J deux points distincts. L'application h(I, 2)∘h(J, −1/2) est (☐ une translation / ☐ une
   homothétie / ☐ l'identité).
3. L'image par une similitude de rapport 1/2 d'un triangle d'aire 𝒜 est un triangle dont l'aire est égale à
   (☐ 𝒜 / ☐ 4𝒜 / ☐ 𝒜/4).
4. Soit Ω un point quelconque. L'application r(Ω, π/6)∘h(Ω, −2) est une similitude directe dont la forme
   réduite est (☐ r(Ω, π/6)∘h(Ω, 2) / ☐ r(Ω, −π/6)∘h(Ω, 2) / ☐ r(Ω, −5π/6)∘h(Ω, 2)).
5. Soit f la similitude indirecte de centre I, de rapport 2 et d'axe Δ. L'application f∘f est (☐ la
   similitude indirecte de centre I, de rapport 4 et d'axe Δ / ☐ l'homothétie h(I, 4) / ☐ la similitude
   directe de centre I, de rapport 4 et d'angle π).

### Vrai ou faux (p.90) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. Une similitude directe qui fixe deux points distincts est l'identité.
2. La composée d'une similitude directe de rapport 2 et d'un antidéplacement est une similitude indirecte de
   rapport 2.
3. La composée d'une similitude directe de rapport 4 et d'une similitude indirecte de rapport 1/4 est un
   déplacement.
4. La réciproque d'une similitude directe de centre I, de rapport 3 et d'angle π/2 est la similitude directe
   de centre I, de rapport 3 et d'angle −π/2.
5. Soit A, B, C et D des points tels que A ≠ C et B ≠ D. Soit f la similitude indirecte qui envoie A sur B
   et C sur D. L'application f∘S_(AC) est une similitude directe de même rapport que f qui envoie A sur B et
   C sur D.

### Exercices et problèmes (p.91–95) — 27 exercices

Mention liminaire (p.91) : « Dans tous les exercices le plan est orienté dans le sens direct. »

- **Ex. 1** (p.91) : ABC un triangle équilatéral de centre G tel que (AB⃗, AC⃗) ≡ π/3 [2π]. Déterminer, dans
  chaque cas, le rapport et l'angle de la similitude directe f. a. f fixe B et envoie A sur C. b. f fixe B
  et envoie C sur G. c. f fixe G et envoie B sur C.
- **Ex. 2** (p.91) : 1. S une similitude directe ; donner la nature de S∘f∘S⁻¹ dans chacun des cas :
  a. f une translation de vecteur non nul ; b. f une rotation d'angle non nul ; c. f une homothétie de
  rapport différent de 1 ; d. f une symétrie orthogonale d'axe passant par le centre de S. 2. reprendre la
  question précédente en supposant que S est une similitude indirecte.
- **Ex. 3** (p.91) : ABCD un carré de côté 1, de centre O, tel que (AB⃗, AD⃗) ≡ π/2 [2π] ; I le milieu de
  [AO]. 1.a. montrer qu'il existe une unique similitude directe S qui envoie A sur O et B sur I. b.
  déterminer le rapport et l'angle de S. 2.a. donner l'écriture complexe de S dans le repère orthonormé
  (A, AB⃗, AD⃗). b. déterminer le centre de S.
- **Ex. 4** (p.91) : ABC un triangle non isocèle, rectangle en A et tel que (AB⃗, AC⃗) ≡ π/2 [2π] ; H le
  projeté orthogonal de A sur (BC), f la similitude directe qui envoie B sur A et A sur C. 1. déterminer les
  éléments caractéristiques de f. 2. M un point variable de [AB] ; la perpendiculaire à (MH) menée de H
  coupe [AC] en N ; montrer que le cercle de diamètre [MN] passe par un point fixe.
- **Ex. 5** (p.91) : ABCD un carré de centre O tel que (AB⃗, AD⃗) ≡ π/2 [2π] ; S la similitude directe de
  centre D qui envoie O sur C. 1. déterminer le rapport et l'angle de S. 2. déterminer l'image du point A
  par S. 3. construire l'image du point C par S.
- **Ex. 6** (p.91) : ABC un triangle direct et M un point du plan ; S la similitude directe de centre A qui
  envoie B sur C. Construire l'image de M dans chacun des cas : 1. M n'appartient pas à (AB). 2. M
  appartient à la droite (AB) privée des points A et B.
- **Ex. 7** (p.91) : ABC un triangle isocèle et rectangle en A tel que (AB⃗, AC⃗) ≡ π/2 [2π] ; A′ le
  symétrique de A par rapport à C. 1.a. préciser le rapport et l'angle de la similitude directe S qui envoie
  A′ sur C et C sur B. b. déterminer l'image par S de la droite (AC). 2.a. I le centre de S ; montrer que le
  triangle ICB est rectangle isocèle. b. construire I. c. construire l'image du cercle de centre C et de
  rayon CA.
- **Ex. 8** (p.91) : ABCD un carré direct de centre O. 1.a. préciser l'angle et le rapport de la similitude
  directe S qui envoie A sur O et B sur D. b. construire le centre de f. c. déterminer S(D). 2. existe-t-il
  une similitude directe qui envoie A sur O, B sur D et D sur C ?
- **Ex. 9** (p.91) : A et B deux points ; h l'homothétie de centre A et de rapport −2, r la rotation de
  centre B et d'angle π/2 ; on pose S = r∘h. 1. montrer que S est une similitude directe et déterminer son
  rapport et son angle. 2. O le centre de S et A′ = r(A). a. montrer que (OA⃗, OA′⃗) ≡ −π/2 [2π] et OA′ =
  2OA. b. construire le point O. 3. B′ = h(B) ; construire le centre de la similitude S′ = h∘r et préciser
  son angle et son rapport.
- **Ex. 10** (p.92) : le triangle ABR isocèle et rectangle en B, le triangle BCP isocèle et rectangle en C
  et le triangle CAQ isocèle et rectangle en A ; S_P, S_Q et S_R les similitudes directes de centres
  respectifs P, Q et R, de rapport √2 et d'angle π/4 ; f = S_R∘S_P∘S_Q. 1. déterminer f(A). 2. préciser f et
  donner ses éléments caractéristiques. (Figure.)
- **Ex. 11** (p.92) : O et B deux points distincts et 𝒞 le cercle de diamètre [OB] ; A un point du segment
  [OB] distinct de O et B et I le milieu de [AB] ; la médiatrice de [AB] coupe le cercle 𝒞 en M et M′ tels
  que (MO⃗, MB⃗) ≡ π/2 [2π] ; N le projeté orthogonal de A sur (OM). 1.a. quelle est la nature du
  quadrilatère AMBM′ ? b. en déduire que la droite (AM′) est orthogonale à (OM) et que les points N, A et M′
  sont alignés. 2. S la similitude de centre N qui envoie M sur A. a. déterminer l'angle de S. b. déterminer
  les images par S des droites (MI) et (NA). c. en déduire l'image par S de M′. d. déterminer l'image I′ de
  I par S. e. montrer que la droite (NI) est tangente en N au cercle de diamètre [OA].
- **Ex. 12** (p.92) : un triangle AHH′ isocèle en H et tel que (AH⃗, AH′⃗) ≡ π/2 [source peu lisible pour le
  membre de gauche et le modulo] et M un point de la droite (HH′) et M′ le point tel que le triangle AMM′
  soit isocèle en M avec (MM′⃗, MA⃗) ≡ π/2 [2π]. 1. préciser la similitude directe de centre A qui envoie M
  sur M′. 2. quel est l'ensemble E des points M′ lorsque M décrit (HH′) ? 3. J le milieu de [MM′] ; calculer
  AJ/AM et montrer que (AM⃗, AJ⃗) ne dépend pas du point M. 4. quel est l'ensemble F des points J lorsque M
  décrit (HH′) ? Construire F.
- **Ex. 13** (p.92) : ABC un triangle rectangle en A et H le pied de la hauteur issue de A. 1. montrer que
  le triangle ABH est l'image du triangle CAH par une similitude directe que l'on déterminera. 2. montrer
  que le triangle AHC est l'image du triangle ABC par la composée d'une similitude directe et d'une symétrie
  orthogonale que l'on précisera. 3. par quelle transformation peut-on passer du triangle ABC au triangle
  HA[?] (source peu lisible) ?
- **Ex. 14** (p.92) : AOO′ un triangle rectangle et isocèle en A ; 𝒞 le cercle de centre O passant par A et
  𝒞′ le cercle de centre O′ passant par A ; les cercles 𝒞 et 𝒞′ se recoupent en B ; M un point de 𝒞 et M′
  le point de 𝒞′ tel que (OM⃗, O′M′⃗) ≡ −π/2 [2π]. 1. préciser la similitude directe qui envoie O sur O′ et M
  sur M′. 2. si M est distinct de B et de S_O(B), la droite (MB) recoupe 𝒞′ en un point N′ et la droite
  (BM′) recoupe 𝒞 en N ; montrer que BN = BN′ et que les droites (BN) et (BN′) sont perpendiculaires. 3. les
  carrés MBM′P et NBN′Q ; a. quel est l'ensemble des points P et l'ensemble des points Q lorsque M varie ?
  b. montrer que la droite (PQ) passe par un point fixe. (Figure.)
- **Ex. 15** (p.93) : f la transformation du plan qui, à tout point M d'affixe z, associe le point M′
  d'affixe z′ = 2iz + 3 − i. 1. B le point d'affixe i et C le point d'affixe −1 ; B′ et C′ les images
  respectives de B et C par f ; déterminer (BC⃗, B′C′⃗) et exprimer B′C′ en fonction de BC. 2. identifier f
  et donner ses éléments caractéristiques.
- **Ex. 16** (p.93) : le plan P muni d'un repère orthonormé direct (O, u⃗, v⃗) ; A(3, −1) et B(0, 2) ; h
  l'homothétie de centre A et de rapport −√2, r la rotation de centre B et d'angle 3π/4 et t la translation
  de vecteur BO⃗ ; on pose f = t∘r∘h. 1.a. caractériser t∘r. b. en déduire la nature de f et ses éléments
  caractéristiques. c. donner l'écriture complexe de f. 2. déterminer et construire le point K tel que
  f(K) = O.
- **Ex. 17** (p.93) : le plan complexe muni d'un repère orthonormé direct (O, u⃗, v⃗) ; A, B, C et D les
  points d'affixes respectives z_A = 2 + i, z_B = 1 + 2i, z_C = 6 + 3i et z_D = −1 + 6i. 1. montrer qu'il
  existe une rotation qui transforme A en B et C en D ; préciser ses éléments caractéristiques. 3 [sic — la
  numérotation source passe de 1 à 3]. J le point d'affixe 3 + 5i ; montrer que la rotation de centre J et
  d'angle −π/2 transforme A en D et C en B. 4. I le point d'affixe 1 + i, M et N les milieux respectifs des
  segments [AC] et [BD] ; déterminer la nature du quadrilatère IMJN. 5. les points P et Q tels que les
  quadrilatères IAPB et ICQD soient des carrés ; a. calculer z_P et z_Q, affixes respectives de P et Q. b.
  déterminer IP/IA et IQ/IC ainsi qu'une mesure des angles (IA⃗, IP⃗) et (IC⃗, IQ⃗) ; en déduire les éléments
  caractéristiques de la similitude directe g telle que g(A) = P et g(C) = Q. c. en déduire que J est
  l'image de M par g et que J est le milieu de [PQ].
- **Ex. 18** (p.93) : ABC un triangle quelconque ; AB′B et ACC′ directs, rectangles, isocèles de sommet A
  et K le milieu de [BC]. Le plan étant rapporté à un repère orthonormé direct d'origine A, on note a, b et
  c les affixes des points A, B et C. 1. exprimer les affixes k, b′ et c′ des points K, B′ et C′ en fonction
  de b et c. 2. montrer qu'il existe une unique similitude directe f qui envoie A sur B′ et K sur C′. 3.a.
  donner les éléments caractéristiques de f, son expression complexe ainsi que sa forme réduite. b. en
  déduire que les droites (AK) et (B′C′) sont perpendiculaires. (Figure.)
- **Ex. 19** (p.93) : un rectangle d'or est un rectangle dont le quotient longueur/largeur est égal à
  φ = (1 + √5)/2 ; ABCD un rectangle d'or et ABFE un carré. 1. vérifier que φ = 1 + 1/φ ; en déduire que
  EFCD est un rectangle d'or. 2. f la similitude directe qui envoie A sur D et D sur C ; préciser son
  rapport et son angle. 3. quelle est l'image de C par f ? 4. en déduire que l'intersection O de (AC) et
  (DF) est invariant par f. 5. montrer que les droites (AC) et (DF) sont perpendiculaires et que si G
  désigne l'intersection de (AC) et (EF) alors ED = EG. (Figure.)
- **Ex. 20** (p.94) : ABCD un rectangle tel que AD = 1, AB = 2 et (DC⃗, DA⃗) ≡ π/2 [2π] ; L, K et J les
  milieux respectifs de [AD], [DC] et [BC] ; le plan muni du repère (D, DK⃗, DA⃗). 1. montrer qu'il existe
  une unique similitude indirecte f qui envoie A sur D et C sur B. 2.a. déterminer f(L) et f(J). b. donner
  les éléments caractéristiques de f.
- **Ex. 21** (p.94) : ABC un triangle équilatéral direct ; I et J les milieux respectifs des segments [AB]
  et [AC] et D le symétrique de A par rapport à C. 1. f l'antidéplacement tel que f(C) = A et f(A) = B ;
  identifier f. 2. g la similitude directe telle que g(B) = D et g(I) = C ; montrer que g(A) = A et
  déterminer les éléments caractéristiques de g. 3. K le point défini par KA⃗ + 2KC⃗ = 0⃗ [source peu
  lisible]. a. donner la nature de f∘g. b. déterminer f∘g(I) et f∘g(A). c. vérifier que KB⃗ + 2KC⃗ = 0⃗
  [source peu lisible] ; en déduire que f∘g(K) = K. d. déterminer le rapport de f∘g. e. montrer que l'axe de
  la similitude f∘g est la perpendiculaire en K à la droite (AB).
- **Ex. 22** (p.94) : le plan muni du repère orthonormé direct (O, u⃗, v⃗) ; f la similitude indirecte qui à
  tout point M d'affixe z associe le point M′ d'affixe z′ tel que z′ = (1 + i)z̄ + i. Déterminer le centre
  et l'axe de f.
- **Ex. 23** (p.94) : le plan muni du repère orthonormé direct (O, u⃗, v⃗) ; f la similitude indirecte qui à
  tout point M d'affixe z associe le point M′ d'affixe z′ tel que z′ = −5iz̄ + 1 + i. 1. déterminer le
  centre et l'axe de f. 2. déterminer l'image par f du cercle de centre I d'affixe 3 + i et de rayon √5.
- **Ex. 24** (p.94) : OABC un rectangle tel que OA = 2OC et (OA⃗, OC⃗) ≡ π/2 [2π] ; la médiatrice D de [OB]
  coupe la droite (OA) en H et la droite (OC) en H′ ; J et J′ les symétriques respectifs du point O par
  rapport à H et H′. 1.a. montrer que les triangles OBJ et OBJ′ sont rectangles en B. b. en déduire que les
  points B, J et J′ sont alignés. 2. f la similitude directe qui envoie J sur O et O sur J′. a. déterminer
  l'angle de f. b. déterminer f(B) et en déduire le centre et le rapport de f. 3. g la similitude indirecte
  qui envoie J sur O et O sur J′. a. donner le rapport de g. b. en déduire que g admet un unique point
  invariant que l'on notera I. c. montrer que le point I appartient à (JJ′). d. construire le centre et
  l'axe de g.
- **Ex. 25** (p.94–95) : un triangle équilatéral ABC tel que (AB⃗, AC⃗) ≡ π/3 [2π] ; I le milieu de [AC] et
  K le milieu de [AB]. 1.a. montrer qu'il existe un unique antidéplacement f qui envoie B sur A et A sur C.
  b. montrer que f est une symétrie glissante dont on déterminera l'axe et le vecteur. c. D le symétrique de
  B par rapport à I ; montrer que f(C) = D. d. D′ = f(D) ; montrer que D′ est le symétrique de B par rapport
  à C. 2. S la similitude directe qui envoie A sur B et I sur D. a. déterminer le rapport et l'angle de S.
  b. 𝒞 le cercle de diamètre [AB] et 𝒞′ le cercle de diamètre [BD] ; montrer que 𝒞 et 𝒞′ sont sécants en I
  et en un autre point Ω, et que Ω est le centre de S. 3. g = f∘S ; déterminer la nature de g et ses
  éléments caractéristiques.
- **Ex. 26** (p.95) : un triangle isocèle ABC direct de sommet principal A ; on pose (AB⃗, AC⃗) ≡ 2α [2π] où
  α est un réel de ]0, π/2[ ; O le milieu de [BC] et D le symétrique de A par rapport à O ; I et J les
  projetés orthogonaux respectifs de O et D sur (AC). 1. f la similitude directe qui envoie O sur I et D sur
  J ; déterminer à l'aide de α l'angle et le rapport de f ; montrer que f(A) = A. 2. E le symétrique de O
  par rapport à I ; montrer que f(B) = O et f(C) = E ; déterminer OE/BC. 3. g la similitude indirecte qui
  envoie B sur O et C sur E. a. déterminer le rapport de g et l'image de O par g. b. montrer que
  g = S_(OE)∘f. 4. Ω le centre de g. a. montrer que g∘g(D) = J et en déduire que Ω appartient à la droite
  (DJ). b. montrer que Ω appartient à la droite (BI). c. construire Ω.
- **Ex. 27** (p.95) : ABC un triangle rectangle en C tel que (BC⃗, BA⃗) ≡ π/3 [2π] ; la bissectrice
  intérieure de l'angle ABC coupe [AC] en O ; H le projeté orthogonal de O sur (AB) et H′ le milieu de
  [OA]. 1.a. faire une figure. b. montrer que le triangle OAB est isocèle et que H est le milieu de [AB]. 2. f la similitude directe telle que f(B) = O et f(H) = H′. a. montrer que le rapport de f est 1/√3 et que
  π/6 est une mesure de son angle. b. montrer que H′ est le milieu du segment [Of(A)] ; en déduire que A est
  le centre de f. 3. les cercles (Γ) et (Γ′) de diamètres respectifs [AB] et [AO] se recoupent en D. a.
  montrer que les points B, O et D sont alignés. b. montrer que les triangles BCD et ODH′ sont équilatéraux
  et que f(C) = D. c. montrer que le quadrilatère ADC[?] (source peu lisible) est un losange. 4.
  g = S_(DH′)∘f, où S_(DH′) est la symétrie axiale d'axe (DH′). a. déterminer g(A) et g(C). b. montrer que g
  est une similitude indirecte dont on précisera le rapport. c. Ω le centre de g ; montrer que ΩD⃗ =
  (1/3)ΩD⃗ [sic — relation imprimée telle quelle, membre de droite probablement mal rendu par la source] ;
  construire alors le centre Ω et l'axe Δ de g.

### Bornes de scope observées (chapitre 13)

- ✅ INCLUS : rappels sur les **homothéties** (définition, propriété caractéristique M′N′⃗ = kMN⃗,
  conservation des angles orientés) et les **translations** ; **composée de deux homothéties** (homothétie
  de rapport k₁k₂ si ≠ 1, translation sinon), **composée d'une translation et d'une homothétie** (k ≠ 1 ⇒
  homothétie de rapport k), **écriture complexe de l'homothétie** z′ = kz + b (k réel, centre
  z_A = b/(1−k)) ; **définition de la similitude de rapport k** (k réel strictement positif, A′B′ = k·AB),
  isométries = similitudes de rapport 1, homothétie de rapport k = similitude de rapport |k| ; **composée de
  deux similitudes** (rapport kk′), caractérisation **similitude = composée homothétie∘isométrie**, effet
  sur le **produit scalaire** (A′B′⃗·C′D′⃗ = k²·AB⃗·CD⃗) ; **propriétés** (bijection de réciproque une
  similitude de rapport 1/k ; conservation des angles géométriques, de l'orthogonalité, de l'alignement, du
  barycentre, du parallélisme ; transforme segment→segment, droite→droite, cercle→cercle) ; **triangles
  semblables** (proportionnalité des côtés ⇔ égalité des angles) ; deux similitudes coïncidant sur 3 points
  non alignés sont égales ; **similitudes directes / indirectes** (composée avec un déplacement / un
  antidéplacement ; conservation / inversion des angles orientés ; règles de composition et de réciproque) ;
  **existence-unicité** (unique similitude directe et unique similitude indirecte envoyant A→C, B→D pour
  A ≠ B, C ≠ D) ; **angle d'une similitude directe** (θ, additif par composition, opposé par réciproque) ;
  **centre** (unique point fixe si rapport ≠ 1), éléments caractéristiques (centre, rapport, angle),
  caractérisation IM′ = k·IM et (IM⃗, IM′⃗) ≡ θ [2π] ; **forme réduite** d'une similitude directe
  f = h∘r = r∘h ; **écriture complexe** d'une similitude directe z′ = az + b avec a = ke^{iθ}, centre
  z_I = b/(1−a) ; **similitude indirecte** — centre (unique point fixe), **forme réduite** f = h∘S_D = S_D∘h,
  **axe** D (ensemble des M tels que IM′⃗ = kIM⃗), globalement invariants (axe et perpendiculaire par I),
  f∘f = homothétie de rapport k², bissectrice ((u⃗, IM′⃗) ≡ −(u⃗, IM⃗)) ; **écriture complexe** d'une
  similitude indirecte z′ = az̄ + b, k = |a|, centre z_I = (a·b̄ + b)/(1 − |a|²).
- ⛔ NON traité dans ce chapitre : les similitudes de l'**espace** (le chapitre est strictement plan) ; toute
  **réduction matricielle** générale (les écritures analytiques restent traitées via l'écriture complexe ou
  cas par cas) ; les groupes de transformations au sens abstrait (évoqués seulement dans l'encart historique
  d'Erlangen). Le chapitre suppose acquis les **homothéties et translations** (rappelées en partie I), le
  **chapitre 11 (Isométries du plan)** et le **chapitre 12 (Déplacements – Antidéplacements)** — déplacements
  et antidéplacements, symétrie glissante, écritures complexes z′ = az + b (|a| = 1) — qu'il prolonge au cas
  |a| ≠ 1 (rapport de similitude quelconque).

## 2.14 Chapitre 14 — Coniques (manuel 222446, p.96–120)

**Page de garde (p.96)** — Titre de couverture : « Coniques », Chapitre 5 (numérotation interne du
tome 2 ; c'est le chapitre 14 dans la numérotation content ; le bandeau courant écrit « Coniques »).
Encart historique (citation) : « Dans l'introduction de son livre, Al-Tusi donnait déjà : – L'équation
de la parabole par rapport à deux axes perpendiculaires dont l'un est l'axe de la parabole et l'autre est
la tangente au sommet de la parabole. – L'équation de l'hyperbole par rapport à deux axes perpendiculaires
dont l'un est l'axe de l'hyperbole et l'autre est la tangente au sommet de l'hyperbole. – L'équation d'une
hyperbole équilatère par rapport à ses asymptotes. Pour résoudre l'équation proposée […]. Al-Tusi démontre
que les deux coniques se coupent […]. » Référence : « (R. Rashed, Entre Arithmétique et Algèbre, 1984,
p.177) ». Le chapitre est structuré en quatre parties **I. La parabole**, **II. L'hyperbole**,
**III. L'ellipse**, **IV. Équations non réduites des coniques**, ponctuées d'activités et de six exercices
résolus, suivies d'un QCM / Vrai-Faux, puis d'une rubrique « Exercices et problèmes » (30 exercices).

### Cours — Activités

**I. La parabole** (p.97)

- **Activité 1** (p.97) : plan muni d'un repère orthonormé (O, i⃗, j⃗) ; 𝒫 la courbe représentative de la
  fonction x ↦ x² ; D la droite d'équation y = −1/4 et le point F(0, 1/4) ; M(x, y) et H son projeté
  orthogonal sur D. 1. calculer les distances MF et MH. 2. en déduire que MF = MH, si et seulement si, M
  appartient à 𝒫.
- **Activité 2** (p.97) : D une droite du plan et F un point n'appartenant pas à D. 1. H un point de D ;
  construire le centre M du cercle passant par F et tangent à D en H ; que vaut le rapport MF/MH ? 2. 𝒫
  l'ensemble des centres des cercles passant par F et tangents à D ; pour tout point M du plan, H son projeté
  orthogonal sur D ; a. montrer que 𝒫 = {M tels que MF/MH = 1}. b. construire quelques points de 𝒫. 3. K le
  projeté orthogonal de F sur D et O le milieu du segment [FK] ; montrer que O appartient à 𝒫.
- **Activité 3** (p.98) : 𝒫 une parabole de foyer F et de directrice D ; K le projeté orthogonal de F sur D.
  1. montrer que la parabole 𝒫 coupe la droite (FK) en un unique point S, milieu du segment [FK]. 2. montrer
     que M appartient à 𝒫, si et seulement si, son symétrique par rapport à (FK) appartient à 𝒫.
- **Activité 4** (p.98) : D une droite du plan et A un point n'appartenant pas à D ; 𝒞 le cercle de centre A
  et tangent à la droite D. 1. H le projeté orthogonal de A sur la droite D et F un point de 𝒞 distinct de H ;
  montrer que F est le foyer d'une parabole passant par A et ayant pour directrice la droite D. 2. préciser le
  foyer F₁ de la parabole de sommet A et de directrice D.

**I.1 Équation réduite d'une parabole** (p.98)

- **Activité 1** (p.98) : 𝒫 une parabole de foyer F, de directrice D et de sommet S ; K le projeté orthogonal
  de F sur D ; on pose FK = p, i⃗ = (1/SF)·SF⃗ et j⃗ un vecteur unitaire de sorte que le repère (S, i⃗, j⃗) soit
  orthonormé. 1. donner une équation de la directrice D dans le repère (S, i⃗, j⃗). 2. M un point de
  coordonnées (x, y) ; montrer que M appartient à 𝒫, si et seulement si, y² = 2px.
- **Activité 2** (p.99) : plan rapporté à un repère orthonormé (O, i⃗, j⃗) ; p un réel strictement positif ; on
  pose 𝒫 = {M(x, y) tels que y² = 2px} et 𝒫′ = {M(x, y) tels que y² = −2px}. 1. montrer que 𝒫′ est la
  symétrique de 𝒫 par rapport à l'axe (O, j⃗). 2. en déduire que 𝒫′ est une parabole dont on précisera le
  foyer et la directrice. 3. déterminer 𝒫″ = {M(x, y) tels que x² = 2py}.
- **Activité 3** (p.99) : plan rapporté à un repère orthonormé (O, i⃗, j⃗). Représenter dans le même repère les
  paraboles d'équations respectives y² = 3x, y² = −3x, x² = 3y et x² = −3y.

**I.2 Tangentes à une parabole** (p.99)

- **Activité** (p.99) : plan rapporté à un repère orthonormé (O, i⃗, j⃗) ; 𝒫 la parabole d'équation x² = 2py et
  𝒫′ la parabole d'équation y² = 2px. 1. montrer que la tangente T en un point M₀(x₀, y₀) de 𝒫 a pour équation
  x₀x = p(y + y₀). 2. en déduire une équation de la tangente T′ en un point M₀(x₀, y₀) de 𝒫′.

**II. L'hyperbole** (p.101)

- **Activité 1** (p.101) : plan muni d'un repère orthonormé (O, i⃗, j⃗) ; ℋ la courbe représentative de la
  fonction x ↦ 1/x ; le point F(√2, √2) et la droite D d'équation x/√2 + y/√2 − 1 = 0 ; M(x, y) et H son
  projeté orthogonal sur D. 1. calculer les distances MF et MH. 2. en déduire que MH = (1/√2)·MF, si et
  seulement si, M appartient à ℋ.
- **Activité 2** (p.101) : D une droite du plan, F un point n'appartenant pas à D et K le projeté orthogonal de
  F sur D. 1.a. construire le point S barycentre de (F, 1) et (K, −2) [source peu lisible pour le coefficient].
  b. que vaut le rapport SF/SK ? 2. construire le point S′ barycentre de (F, 1) et (K, 2) [source peu lisible] ;
  que vaut le rapport S′F/S′K ? 3. ℋ = {M tels que MF/MH = 2} où H est le projeté orthogonal de M sur D ; on se
  propose de donner un procédé de construction d'un point de ℋ ; on considère le cercle 𝒞 de centre S et passant
  par F ; B un point de 𝒞 distinct de F et I le point d'intersection de D et de (FB) ; h l'homothétie de centre I
  qui envoie B sur F, M l'image de S par h et H le projeté orthogonal de M sur D ; a. montrer que h envoie K en H.
  b. que vaut le rapport MF/MH ? en déduire que M ∈ ℋ. c. construire quelques points de ℋ.
- **Activité 3** (p.102) : ℋ une hyperbole de foyer F, de directrice D et d'excentricité e ; K le projeté
  orthogonal de F sur D. 1. montrer que l'intersection de ℋ avec la droite (FK) se réduit à deux points. 2.
  montrer que M appartient à ℋ, si et seulement si, son symétrique par rapport à (FK) appartient à ℋ.

**II.1 Équation réduite d'une hyperbole** (p.102)

- **Activité 1** (p.102) : ℋ une hyperbole de foyer F, de directrice D et d'excentricité e ; K le projeté
  orthogonal de F sur D ; S et S′ les sommets de ℋ et O le milieu de [SS′]. 1. montrer que OF⃗ = e·OS⃗ et
  OK⃗ = (1/e)·OS⃗ où S est le barycentre des points pondérés (F, 1) et (K, e) [source peu lisible]. 2. on pose
  i⃗ = (1/OF)·OF⃗ et on considère un vecteur unitaire j⃗ de sorte que le repère (O, i⃗, j⃗) soit orthonormé ; on
  désigne par (c, 0) les coordonnées de F et (a, 0) celles de S. a. montrer que e = c/a et OK = a²/c. b. M un
  point de coordonnées (x, y) ; montrer que M appartient à ℋ, si et seulement si, x²/a² − y²/(c²−a²) = 1.
- **Activité 2** (p.104) : plan muni d'un repère orthonormé (O, i⃗, j⃗) ; ℋ l'ensemble des points M(x, y) tels
  que x²/9 − y²/16 = 1. 1. montrer que ℋ est une hyperbole de foyer F(5, 0), de directrice associée la droite D
  d'équation x = 9/5 et d'excentricité e = 5/3. 2.a. étudier la fonction f : x ↦ 4√(x²/9 − 1) pour x ≥ 3. b.
  représenter les points M(x, y) tels que y = 4√(x²/9 − 1) et x ≥ 3. 3. en déduire une représentation graphique
  de ℋ.

**II.2 Tangentes à une hyperbole et asymptotes à une hyperbole** (p.104)

- **Activité 1** (p.104) : dans le plan muni d'un repère orthonormé (O, i⃗, j⃗), on considère l'hyperbole ℋ
  d'équation x²/a² − y²/b² = 1. 1. montrer que M(x, y) appartient à ℋ, si et seulement si,
  y = (b/a)√(x²−a²) ou y = −(b/a)√(x²−a²). 2. ℋ₁ et ℋ₂ les courbes représentatives des fonctions
  x ↦ (b/a)√(x²−a²) et x ↦ −(b/a)√(x²−a²). a. montrer que ℋ = ℋ₁ ∪ ℋ₂. b. montrer que les droites d'équations
  y = (b/a)x et y = −(b/a)x sont asymptotes à ℋ. c. M₀(x₀, y₀) un point de ℋ ; montrer que la tangente à ℋ en
  M₀ a pour équation x₀x/a² − y₀y/b² = 1.
- **Activité 2** (p.105) : plan muni d'un repère orthonormé (O, i⃗, j⃗) ; ℋ l'hyperbole d'équation x²/4 − y² = 1.
  1. déterminer les coordonnées de ses sommets et de ses foyers. 2. donner les équations des asymptotes. 3.a.
     tracer ℋ. b. en déduire le tracé de l'hyperbole ℋ′ d'équation −x² + y²/4 = 1.
- **Activité 3** (p.105) : plan muni d'un repère orthonormé (O, i⃗, j⃗). Trouver l'équation réduite de
  l'hyperbole de centre O, de sommet S(5, 0) et dont l'une de ses asymptotes est la droite d'équation
  5y + 3x = 0.

**II.3 Équation d'une hyperbole rapportée à ses asymptotes** (p.107)

- **Activité** (p.107) : plan muni d'un repère orthonormé (O, i⃗, j⃗) ; ℋ l'hyperbole de centre O, de foyer
  F(2, 0) et de directrice associée la droite D d'équation x = 1/2. 1.a. donner l'équation réduite de ℋ. b.
  construire ℋ. 2. les vecteurs u⃗ = i⃗ + √3 j⃗ et v⃗ = i⃗ − √3 j⃗ ; écrire une équation de ℋ dans le repère
  (O, u⃗, v⃗).

**III. L'ellipse** (p.107)

- **Activité 1** (p.107–108) : D une droite du plan et F un point n'appartenant pas à D ; K le projeté
  orthogonal de F sur D. 1.a. construire les points S et S′, barycentres respectifs de (F, 1), (K, −1/2) et
  (F, 1), (K, 1/2). b. que valent les rapports SF/SK et S′F/S′K ? 2. ℰ = {M tels que MF/MH = 1/2} où H est le
  projeté orthogonal de M sur D ; on se propose de donner un procédé de construction d'un point de ℰ ; on
  désigne par 𝒞 le cercle de centre S et passant par F ; B un point de 𝒞 distinct de F et I le point
  d'intersection de D et de (FB) ; h l'homothétie de centre I qui envoie B sur F, M l'image de S par h et H le
  projeté orthogonal de M sur D ; a. montrer que h envoie K en H. b. montrer que M ∈ ℰ.
- **Activité 2** (p.108) : ℰ une ellipse de foyer F, de directrice D et d'excentricité e ; K le projeté
  orthogonal de F sur D. 1. montrer que l'intersection de ℰ avec la droite (FK) se réduit à deux points. 2.
  montrer que M appartient à ℰ, si et seulement si, son symétrique par rapport à (FK) appartient à ℰ.

**III.1 Équation réduite d'une ellipse** (p.109)

- **Activité 1** (p.109) : ℰ une ellipse de foyer F, de directrice D et d'excentricité e ; K le projeté
  orthogonal de F sur D ; S et S′ les sommets principaux de ℰ et O le milieu de [SS′]. 1. montrer que
  OF⃗ = e·OS⃗ et OK⃗ = (1/e)·OS⃗ où S est le barycentre de (F, 1) et (K, e). 2. on pose i⃗ = (1/OF)·OF⃗ et on
  considère un vecteur unitaire j⃗ de sorte que (O, i⃗, j⃗) soit un repère orthonormé ; on désigne par (c, 0) les
  coordonnées de F et (a, 0) celles de S ; montrer que e = c/a et OK = a²/c. 3. M un point de coordonnées
  (x, y) ; montrer que M appartient à ℰ, si et seulement si, x²/a² + y²/(a²−c²) = 1.
- **Activité 2** (p.110) : plan muni d'un repère orthonormé (O, i⃗, j⃗) ; ℰ l'ensemble des points M(x, y) tels
  que x²/25 + y²/9 = 1. 1. montrer que ℰ est une ellipse de foyer F(4, 0), de directrice associée la droite D
  d'équation x = 25/4 et d'excentricité e = 4/5. 2.a. étudier la fonction f : x ↦ 3√(1 − x²/25) pour −5 ≤ x ≤ 5.
  b. représenter les points M(x, y) tels que y = 3√(1 − x²/25) et −5 ≤ x ≤ 5. 3. en déduire une représentation
  graphique de ℰ ; tracer alors ℰ.
- **Activité 3** (p.111) : plan muni d'un repère orthonormé (O, i⃗, j⃗). 1. trouver l'équation réduite de
  l'ellipse de centre O tel que S(3, 0) est un sommet et F(√5, 0) est un foyer. 2. trouver l'équation réduite
  d'une ellipse sachant que O est son centre, F(0, −4) est un foyer et 0.2 est son excentricité.

**III.2 Tangentes à une ellipse** (p.111)

- **Activité** (p.111–112) : plan muni d'un repère orthonormé (O, i⃗, j⃗) ; ℰ l'ellipse d'équation
  x²/a² + y²/b² = 1, a > 0, b > 0. 1. montrer que M(x, y) appartient à ℰ, si et seulement si,
  y = (b/a)√(a²−x²) ou y = −(b/a)√(a²−x²). 2. ℰ₁ et ℰ₂ les courbes représentatives des fonctions
  x ↦ (b/a)√(a²−x²) et x ↦ −(b/a)√(a²−x²). a. montrer que ℰ = ℰ₁ ∪ ℰ₂. b. montrer que la tangente en un point
  M₀(x₀, y₀) de ℰ a pour équation x₀x/a² + y₀y/b² = 1.

**IV. Équations non réduites des coniques** (p.113)

- **Activité 1** (p.113–114) : plan rapporté à un repère orthonormé (O, i⃗, j⃗) ; 𝒫 l'ensemble des points
  M(x, y) tels que y² + 2y − 4x + 4 = 0. 1. montrer que M appartient à 𝒫, si et seulement si,
  (y + 1)² = 4(x − 3/4). 2. montrer que 𝒫 est une parabole de foyer F(7/4, −1) et de directrice la droite
  d'équation x = −1/4. 3. montrer que l'ensemble des points M(x, y) tels que x² + 2x − 4y + 4 = 0 est une
  parabole dont on déterminera les coordonnées du foyer et une équation de la directrice.
- **Activité 2** (p.114) : plan muni d'un repère orthonormé (O, i⃗, j⃗). 1. on considère l'ensemble ℋ des
  points M(x, y) tels que x² − 9y² − 8x + 36y − 56 = 0. a. montrer que M appartient à ℋ, si et seulement si,
  (x−4)² − 9(y−2)² − 36 = 0. b. en déduire que M appartient à ℋ, si et seulement si, (x−4)²/36 − (y−2)²/4 = 1.
  c. O′ le point de coordonnées (4, 2) ; montrer que dans le repère (O′, i⃗, j⃗), ℋ est l'ensemble des points
  M(X, Y) tels que X²/36 − Y²/4 = 1. d. en déduire que ℋ est une hyperbole dont on déterminera l'excentricité,
  ainsi que les coordonnées des sommets et des foyers dans le repère (O, i⃗, j⃗). 2. déterminer l'ensemble des
  points M(x, y) tels que x² − 9y² − 8x + 36y − 20 = 0.
- **Activité 3** (p.114–115) : plan muni d'un repère orthonormé (O, i⃗, j⃗). 1. on considère l'ensemble ℰ des
  points M(x, y) tels que x² + 9y² + 4x − 18y − 23 = 0. a. montrer que M appartient à ℰ, si et seulement si,
  (x+2)²/36 + (y−1)²/4 = 1 ; O′ le point de coordonnées (−2, 1). b. montrer que dans le repère (O′, i⃗, j⃗), ℰ
  est l'ensemble des points M(X, Y) tels que X²/36 + Y²/4 = 1. c. en déduire que ℰ est une ellipse dont on
  déterminera l'excentricité, ainsi que les coordonnées des sommets et des foyers dans le repère (O, i⃗, j⃗). 2. déterminer l'ensemble des points M(x, y) tels que x² + 9y² + 4x − 18y + 14 = 0. 3. déterminer l'ensemble
  des points M(x, y) tels que x² + 9y² + 4x − 18y + 13 = 0.
- **Activité 4** (p.115) : plan muni d'un repère orthonormé (O, i⃗, j⃗). Déterminer la nature de chacune des
  courbes suivantes en donnant ses éléments caractéristiques, puis la construire. 1. x² − 2x + y + 1 = 0. 2.
  x² − y² − 2x − 4y − 7 = 0. 3. (3x + y)² − (x − 1)(6y + 4) = 0.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Définition** (p.97, parabole) — « Soit D une droite et F un point n'appartenant pas à D. Pour tout point
> M du plan, on note H son projeté orthogonal sur la droite D. On appelle parabole de foyer F et de directrice
> D, l'ensemble des points M tels que MF = MH »

> **Vocabulaire** (p.97) — « Soit 𝒫 une parabole de foyer F et de directrice D. La perpendiculaire à D
> passant par F est appelée axe focal de la parabole. La distance du foyer à la directrice est appelée
> paramètre de la parabole. »

> **Théorème** (p.98, sommet d'une parabole) — « Toute parabole admet comme axe de symétrie son axe focal.
> Toute parabole rencontre son axe focal en un unique point appelé sommet de la parabole. Le sommet d'une
> parabole de foyer F et de directrice D est le milieu du segment [FK] où K est le projeté orthogonal de F sur
> D. »

> **Théorème** (p.99, équation réduite d'une parabole) — « Soit 𝒫 une parabole de sommet S, de foyer F et de
> paramètre p. On munit le plan du repère orthonormé (S, i⃗, j⃗), où i⃗ = (1/SF)·SF⃗. La parabole 𝒫 a pour
> équation y² = 2px, la directrice D a pour équation x = −p/2 et le foyer F a pour coordonnées (p/2, 0).
> Réciproquement, dans le plan rapporté à un repère orthonormé (O, i⃗, j⃗), l'ensemble des points M(x, y) tels
> que y² = 2px (p > 0) est la parabole de foyer F(p/2, 0), de directrice la droite d'équation x = −p/2, de
> paramètre p et de sommet O. »

> **Vocabulaire** (p.99) — « L'équation y² = 2px est appelée équation réduite de la parabole 𝒫. »

> **Théorème** (p.100, tangentes à une parabole) — « Le plan est rapporté à un repère orthonormé (O, i⃗, j⃗).
> Soit p un réel strictement positif. Si 𝒫 est la parabole d'équation y² = 2px, alors la tangente à 𝒫 en un
> point M₀(x₀, y₀) est la droite d'équation y₀y = p(x + x₀). Si 𝒫 est la parabole d'équation x² = 2py, alors la
> tangente à 𝒫 en un point M₀(x₀, y₀) est la droite d'équation x₀x = p(y + y₀). »

> **Conséquence** (p.100) — « Soit une parabole d'équation y² = 2px, dans le repère orthonormé (S, i⃗, j⃗), où S
> est le sommet de la parabole et i⃗ et j⃗ sont des vecteurs directeurs unitaires respectifs de l'axe focal et
> de la directrice. Alors sa tangente au sommet a pour équation x = 0. »

> **Vocabulaire** (p.100) — « La tangente à une parabole en son sommet est appelée tangente au sommet. »

> **Définition** (p.101, hyperbole) — « Soit D une droite, F un point n'appartenant pas à D et un réel e > 1.
> Pour tout point M du plan, on note H son projeté orthogonal sur la droite D. On appelle hyperbole de foyer F,
> de directrice D et d'excentricité e, l'ensemble des points M tels que MF/MH = e. »

> **Vocabulaire** (p.102) — « Soit ℋ une hyperbole de foyer F et de directrice D. La perpendiculaire à D
> passant par F est appelée axe focal de l'hyperbole. »

> **Théorème** (p.102, sommets d'une hyperbole) — « Soit ℋ une hyperbole de foyer F, de directrice D et
> d'excentricité e. • L'axe focal de ℋ est un axe de symétrie pour ℋ. • ℋ rencontre son axe focal en deux
> points appelés sommets de l'hyperbole et ils sont les barycentres respectifs des points (F, 1), (K, −e) et
> (F, 1), (K, e) où K est le projeté orthogonal de F sur D. » [note : les signes des coefficients e / −e sont
> peu lisibles à la source dans l'encadré ; recopiés dans l'ordre standard.]

> **Théorème** (p.103, équation réduite d'une hyperbole) — « Soit ℋ une hyperbole de foyer F, de directrice D
> et d'excentricité e, de sommet S et S′. On désigne par O le milieu de [SS′], on pose i⃗ = (1/OF)·OF⃗ et on
> considère un vecteur unitaire j⃗, directeur de D. Si S a pour coordonnées (a, 0) et F a pour coordonnées
> (c, 0) dans le repère orthonormé (O, i⃗, j⃗), alors l'hyperbole ℋ a pour équation x²/a² − y²/b² = 1, avec
> b² = c² − a². Réciproquement, dans le plan muni d'un repère orthonormé (O, i⃗, j⃗), l'ensemble des points
> M(x, y) tels que x²/a² − y²/b² = 1 (a > 0, b > 0) est une hyperbole de centre O, de foyer F(√(a²+b²), 0), de
> directrice d'équation x = a²/c, d'excentricité e = c/a avec c = √(a²+b²) et de sommets S(a, 0) et S′(−a, 0).
> Pour des raisons de symétrie par rapport à la droite Δ : y = x, la courbe ℋ d'équation −x²/a² + y²/b² = 1 est
> une hyperbole de centre O, de foyer F(0, √(a²+b²)), de directrice la droite d'équation y = b²/c,
> d'excentricité e = c/b avec c = √(a²+b²) et de sommets S(0, b) et S′(0, −b). »

> **Vocabulaire** (p.103) — « L'équation x²/a² − y²/b² = 1 (a > 0, b > 0) est appelée équation réduite de
> l'hyperbole. »

> **Théorème** (p.103, centre et axes d'une hyperbole) — « • Toute hyperbole admet un centre de symétrie, qui
> est le milieu de ses sommets. Ce centre de symétrie est appelé centre de l'hyperbole. • Toute hyperbole admet
> deux axes de symétrie qui sont l'axe focal et l'axe parallèle à la directrice et passant par le centre de
> symétrie. »

> **Conséquence** (p.104) — « Soit ℋ une hyperbole de foyer F et de directrice D. Le fait que l'hyperbole ℋ
> admette un centre de symétrie implique l'existence d'une autre directrice D′ et d'un autre foyer F′
> symétriques respectifs de D et F. On dit alors que F est le foyer associé à la directrice D et F′ est le foyer
> associé à la directrice D′. »

> **Vocabulaire** (p.105) — « On dit qu'une hyperbole est équilatère si ses asymptotes sont perpendiculaires. »

> **Théorème** (p.105, asymptotes et tangente d'une hyperbole) — « Soit ℋ l'hyperbole d'équation
> x²/a² − y²/b² = 1, dans le plan muni d'un repère orthonormé (O, i⃗, j⃗). Alors ℋ admet deux asymptotes
> d'équations y = (b/a)x et y = −(b/a)x. La tangente à ℋ en un point M₀(x₀, y₀) a pour équation
> x₀x/a² − y₀y/b² = 1. »

> **Conséquence** (p.105) — « La tangente à une hyperbole ℋ en son sommet S(a, 0) a pour équation x = a. »

> **Théorème** (p.107, hyperbole rapportée à ses asymptotes) — « Toute hyperbole rapportée à ses asymptotes a
> une équation de la forme XY = k où k est un réel non nul. »

> **Définition** (p.108, ellipse) — « Soit D une droite, F un point n'appartenant pas à D et un réel
> 0 < e < 1. Pour tout point M du plan, on note H son projeté orthogonal sur la droite D. On appelle ellipse de
> foyer F, de directrice D et d'excentricité e, l'ensemble des points M tels que MF/MH = e. »

> **Vocabulaire** (p.108) — « Soit ℰ une ellipse de foyer F et de directrice D. La perpendiculaire à D passant
> par F est appelée axe focal de cette ellipse. »

> **Théorème** (p.108, sommets principaux d'une ellipse) — « Soit ℰ une ellipse de foyer F, de directrice D et
> d'excentricité e. L'axe focal de ℰ est un axe de symétrie pour ℰ. ℰ rencontre son axe focal en deux points
> appelés sommets principaux de l'ellipse et ils sont les barycentres respectifs des points (F, 1), (K, −e) et
> (F, 1), (K, e) où K est le projeté orthogonal de F sur D. » [note : les signes des coefficients e / −e sont
> peu lisibles à la source dans l'encadré ; recopiés dans l'ordre standard.]

> **Théorème** (p.109, équation réduite d'une ellipse) — « Soit ℰ une ellipse de foyer F, de directrice D et
> d'excentricité e. On désigne par O le milieu des sommets principaux S et S′. On pose i⃗ = (1/OF)·OF⃗ et j⃗ un
> vecteur unitaire de sorte que le repère (O, i⃗, j⃗) soit orthonormé. Si S a pour coordonnées (a, 0) et F a
> pour coordonnées (c, 0) alors l'ellipse ℰ a pour équation x²/a² + y²/b² = 1, avec b² = a² − c². Cette équation
> est appelée équation réduite de ℰ. »

> **Théorème** (p.109, centre et axes d'une ellipse) — « Toute ellipse admet un centre de symétrie, qui est le
> milieu du segment formé par ses sommets principaux. Ce centre de symétrie est appelé centre de l'ellipse.
> Toute ellipse admet deux axes de symétrie qui sont l'axe focal et la droite perpendiculaire à l'axe focal en
> son centre. »

> **Conséquence** (p.110) — « Soit ℰ une ellipse de foyer F et de directrice D. Le fait que l'ellipse ℰ
> admette un centre de symétrie implique l'existence d'une autre directrice D′ et d'un autre foyer F′
> symétriques respectifs de D et F par rapport au centre de l'ellipse. On dit que F est le foyer associé à la
> directrice D et que F′ est le foyer associé à la directrice D′. » (p.110 : « La perpendiculaire à l'axe focal
> d'une ellipse en son centre coupe cette ellipse en deux points appelés sommets secondaires. »)

> **Théorème** (p.111, cas a > b et a < b) — « Le plan est muni d'un repère orthonormé (O, i⃗, j⃗). • Soit
> a > b deux réels strictement positifs. L'ensemble des points M(x, y) tels que x²/a² + y²/b² = 1 est une
> ellipse de centre O, de foyer F(√(a²−b²), 0), de directrice associée la droite d'équation x = a²/c et
> d'excentricité e = c/a, où a² = c² + b². • Soit a < b deux réels strictement positifs. L'ensemble des points
> M(x, y) tels que x²/a² + y²/b² = 1 est une ellipse de centre O, de foyer F(0, √(b²−a²)), de directrice
> associée la droite d'équation y = b²/c et d'excentricité e = c/b, où b² = a² + c². »

> **Théorème** (p.112, tangente à une ellipse) — « Le plan est muni d'un repère orthonormé (O, i⃗, j⃗). Soit ℰ
> l'ellipse d'équation x²/a² + y²/b² = 1, a > 0, b > 0. Alors la tangente à ℰ en un point M₀(x₀, y₀) a pour
> équation x₀x/a² + y₀y/b² = 1. »

> **Conséquence** (p.112) — « La tangente à une ellipse ℰ en son sommet S(a, 0) a pour équation x = a. La
> tangente à une ellipse ℰ en son sommet L(0, b) a pour équation y = b. »

> **Définition générale** (p.113, conique) — « Soit D une droite, F un point n'appartenant pas à D et un réel
> e > 0. Pour tout point M du plan, on note H son projeté orthogonal sur D. On appelle conique 𝒞 d'excentricité
> e, de foyer F et de directrice D l'ensemble des points M tels que MF = eMH. Si e = 1, 𝒞 est une parabole de
> foyer F et de directrice D. Si e > 1, 𝒞 est une hyperbole de foyer F, de directrice D et d'excentricité e. Si
> e < 1, 𝒞 est une ellipse de foyer F, de directrice D et d'excentricité e. »

> **Équation générale du second degré** (p.115) — « Dans le plan muni d'un repère orthonormé (O, i⃗, j⃗),
> l'ensemble des points M(x, y) du plan tels que Ax² + By² + Cx + Dy + E = 0, où A, B, C, D et E sont des réels
> est une courbe dont la nature est donnée par le tableau suivant : AB = 0 ⇒ parabole ou deux droites
> parallèles ou une droite ou le vide ; AB < 0 ⇒ hyperbole ou deux droites sécantes ; AB > 0 ⇒ ellipse ou
> cercle ou un point ou le vide. »

### Cours — Exercices résolus

**Exercice résolu 1** (énoncé + solution p.100) : plan rapporté à un repère orthonormé (O, i⃗, j⃗) ; 𝒫 une
parabole de foyer F, de directrice D et d'équation y² = 2px ; M₀(x₀, y₀) un point de 𝒫 distinct de O et H₀ son
projeté orthogonal sur D. 1. montrer que la tangente T à 𝒫 en M₀ est la médiatrice du segment [FH₀]. 2. la
tangente T coupe D en T₀ ; montrer que l'angle M₀FT₀ est droit. **Solution** : F a pour coordonnées (p/2, 0) et
H₀ pour coordonnées (−p/2, y₀), d'où FH₀⃗(−p, y₀) est orthogonal à la tangente à 𝒫 en M₀ ; l'égalité M₀H₀ = M₀F
permet de conclure que la tangente est la médiatrice de [FH₀] ; le triangle M₀H₀T₀ est rectangle en H₀ et F est
le symétrique de H₀ par rapport à (M₀T₀), le résultat en découle. (Figure.)

**Exercice résolu 2** (énoncé p.105, solution p.106) : ℋ l'hyperbole d'équation x²/a² − y²/b² = 1, dans un
repère orthonormé (O, i⃗, j⃗). 1. montrer que les points d'intersection des asymptotes à ℋ avec la tangente au
sommet S(a, 0) ont pour coordonnées (a, b) et (a, −b). 2. en déduire un procédé de construction des asymptotes
d'une hyperbole, sachant que l'on connaît un de ses foyers F et ses sommets S et S′. **Solution** : la tangente
au sommet S a pour équation x = a ; les asymptotes y = (b/a)x et y = −(b/a)x la coupent en I(a, b) et J(a, −b) ;
les asymptotes passent par le centre O (milieu de [SS′]) ; en posant OS = a et OF = c, on a
OI = OJ = √(a²+b²) = c = OF, donc I et J sont les points d'intersection du cercle de centre O et de rayon OF avec
la tangente au sommet S. (Figure.)

**Exercice résolu 3** (énoncé p.105, solution p.106–107) : un triangle équilatéral ABC de côté L ; ℋ
l'hyperbole de foyer A, de directrice associée (BC) et d'excentricité 2. 1. déterminer les sommets S et S′ de
ℋ, son centre et le second foyer F′. 2. calculer les distances SS′ et AF′ en fonction de L. 3. donner une
équation de ℋ dans le repère orthonormé (O, i⃗, j⃗), O étant le centre de ℋ et i⃗ un vecteur unitaire directeur
de (OA). **Solution** : l'axe focal de ℋ est la médiatrice de [BC] ; K le milieu de [BC], les sommets vérifient
SA⃗ = −2SK⃗ et S′A⃗ = 2S′K⃗, donc S est le centre de gravité du triangle ABC et S′ le symétrique de A par rapport
à K ; le centre O est le milieu de [SS′], donc le symétrique de A par rapport à S ; le second foyer F′ est le
symétrique de A par rapport à O ; AK = L√3/2, d'où SS′ = SK + KS′ = 2L√3/3 et AF′ = 2·OA = 2SS′ = 4L√3/3 ; avec
a = OS = (1/2)SS′ = L√3/3 et b² = OA² − OS² = 12L²/9 − 3L²/9 = L², l'hyperbole a pour équation
3x²/L² − y²/L² = 1.

**Exercice résolu 4** (énoncé + solution p.110) : on connaît le foyer F d'une ellipse ℰ et ses deux sommets S et
S′ ; construire les points de l'ellipse qui se trouvent sur l'axe de symétrie perpendiculaire à l'axe focal.
**Solution** : on construit le centre O de l'ellipse, milieu de [SS′] ; les points cherchés se trouvent sur la
perpendiculaire Δ à (SS′) passant par O ; dans le repère (O, i⃗, j⃗) (i⃗ unitaire de (SS′), j⃗ unitaire de Δ)
l'équation de ℰ est x²/a² + y²/b² = 1 où b² = a² − c² ; Δ : x = 0 coupe ℰ en B et B′ d'ordonnées b et −b, tels
que les triangles OFB et OF′B′ sont rectangles et d'hypoténuse égale à a.

**Exercice résolu 5** (énoncé p.112, solution p.112–113) : D et D′ deux droites perpendiculaires en O, de
vecteurs directeurs unitaires respectifs i⃗ et j⃗ tels que (O, i⃗, j⃗) est un repère orthonormé direct ; 𝒞 et 𝒞′
deux cercles concentriques de centre O, de rayons a et b avec a > b ; P un point du cercle 𝒞 ; la demi-droite
[OP) coupe 𝒞′ en P′ ; la parallèle à D′ passant par P coupe la parallèle à D passant par P′ en M. 1. montrer que
M varie sur une ellipse ℰ lorsque P varie sur 𝒞. 2. la parallèle à D passant par P coupe la parallèle à D′
passant par P′ en N ; démontrer que la tangente en M à ℰ est perpendiculaire à (ON). **Solution** : P a pour
coordonnées (a cos θ, a sin θ), P′ (b cos θ, b sin θ), d'où M(a cos θ, b sin θ) vérifie
x_M²/a² + y_M²/b² = 1 : M décrit l'ellipse ; la tangente T à ℰ en M a pour équation xx_M/a² + yy_M/b² = 1, de
vecteur directeur U⃗(−sin θ/b, cos θ/a) ; N a pour coordonnées (b cos θ, a sin θ) donc ON⃗(b cos θ, a sin θ) et
ON⃗·U⃗ = 0, ce qui répond à la question.

**Exercice résolu 6** (énoncé p.115, solution p.115–116) : plan muni d'un repère orthonormé direct (O, i⃗, j⃗) ;
f la similitude directe de centre A(0, 1), de rapport √2 et d'angle π/4 ; 𝒞 la courbe d'équation
x² + y² − 2xy + x − 3y = 0. 1.a. déterminer une équation de la courbe 𝒞′ image de 𝒞 par f ; en déduire que 𝒞′
est une parabole dont on précisera le sommet, le foyer et la directrice. b. construire 𝒞′. 2. en déduire la
nature de 𝒞 et la construire. **Solution** : l'expression complexe de f est z ↦ (1 + i)z + 1 ; en posant
z = x + iy et z′ = x′ + iy′, f(M) = M′ équivaut à { x′ = x − y + 1 ; y′ = x + y }, d'où
x = (1/2)(x′ + y′ − 1) et y = (1/2)(−x′ + y′ + 1) ; M ∈ 𝒞 équivaut à M′ ∈ 𝒞′, et 𝒞′ a pour équation
y′ + 1 = x′² : c'est une parabole de sommet S′(0, −1), de directrice D′ : y = −5/4 et de foyer F′(0, −3/4). 2.
en appliquant f⁻¹ (les distances sont divisées par √2, les orthogonalités conservées) 𝒞 est la parabole de
foyer F et de directrice D, images réciproques de F′ et D′ ; de l'expression analytique de f on déduit
S(−1, 0), F(−7/8, 1/8) et D : y = −x − 5/4. (Figures p.116.)

### QCM (p.117) — « Cocher la réponse exacte. » Le plan est muni d'un repère orthonormé (O, i⃗, j⃗). (réponses non fournies)

1. La parabole de foyer F(1, 0) et de directrice D : x = −1 a pour équation (☐ y² = 4x / ☐ y² = 2x / ☐ x² = 4y).
2. L'ensemble des points M(x, y) tels que 4(x−1)² + 9(y+1)² − 1 = 0 est une ellipse de centre (☐ I(−1, 1) / ☐
   O(0, 0) / ☐ I(1, −1)).
3. Soit m un réel. L'ensemble d'équation m²x² + |m|y² + 1 = 0 est (☐ une ellipse / ☐ un cercle / ☐ l'ensemble
   vide).
4. La courbe d'équation |x² − y²| = 1 est (☐ une hyperbole / ☐ la réunion de deux hyperboles / ☐ la réunion
   d'une ellipse et d'une hyperbole).
5. L'hyperbole d'équation (x−2)²/16 − (y+2)²/9 = 1 a pour excentricité (☐ 5/4 / ☐ 5/3 / ☐ 4/3).

### Vrai ou faux (p.117) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. La courbe d'équation x = (1/2)y² est une parabole de sommet O, de foyer F(1/4, 0) et de directrice
   D : x = −1/4.
2. La parabole d'équation x² = 4y se déduit de la parabole d'équation y² = 4x par symétrie par rapport à la
   droite Δ : y = x.
3. La courbe d'équation x² − y² = −5 est une hyperbole de centre O et de sommets S(0, √5) et S′(0, −√5).
4. Les asymptotes de l'hyperbole d'équation 4(x+2)² − 9(y−1)² − 36 = 0 sont les droites d'équations respectives
   y = (2/3)x et y = −(2/3)x dans le repère (O, i⃗, j⃗).
5. L'ellipse d'équation 9x² + 4y² = 36 a pour excentricité √5/2.

### Exercices et problèmes (p.118–120) — 30 exercices

Mention liminaire (p.118) : « Dans tous les exercices le plan est muni d'un repère orthonormé (O, i⃗, j⃗). »

- **Ex. 1** (p.118) : 1. déterminer une équation de la parabole 𝒫 de sommet I(2, 0) et de directrice D : x = 1. 2. construire 𝒫.
- **Ex. 2** (p.118) : 1. déterminer une équation de la parabole 𝒫 de foyer F(2, 2) et de directrice D : x = 3. 2. construire 𝒫.
- **Ex. 3** (p.118) : 1. 𝒫 la parabole d'équation y² = 4x ; F son foyer et D sa directrice ; déterminer les
  coordonnées de F et une équation de D. 2. 𝒫′ la parabole d'équation y² = −4x + 8 ; a. montrer que la parabole
  𝒫′ a pour foyer F. b. déterminer une équation de la directrice D′ de 𝒫′. c. montrer que F est compris entre D
  et D′. 3. déterminer les points d'intersection de 𝒫 et 𝒫′. 4. 𝒫″ la parabole d'équation y² = 8x + 8 ; a.
  montrer que 𝒫″ a pour foyer F. b. déterminer une équation de sa directrice D″. c. montrer que F n'est pas
  compris entre D et D″. d. existe-t-il des points communs de 𝒫 et 𝒫″ ?
- **Ex. 4** (p.118) : pour chacune des paraboles suivantes, déterminer son foyer, son sommet et une équation de
  sa directrice, puis la tracer. a. y² = 10x. b. x² = 12y. c. y² = −10x. d. x² = −12y.
- **Ex. 5** (p.118) : 𝒫 une parabole de foyer F, de directrice D et de sommet S ; trouver dans chacun des cas
  l'équation réduite de 𝒫. 1. F a pour coordonnées (−2, 0) et S a pour coordonnées (0, 0). 2. S a pour
  coordonnées (0, 0) et D a pour équation y + 3 = 0.
- **Ex. 6** (p.118) : 𝒫 la parabole d'équation y² = 6x ; on considère une droite variable D passant par le
  foyer F de 𝒫 et de vecteur directeur U⃗(1, m) où m est un réel non nul ; la droite D coupe la parabole 𝒫 en M
  et M′ ; K le milieu de [MM′]. 1. écrire, à l'aide de m, les coordonnées de K. 2. quel est l'ensemble des
  points K lorsque m décrit ℝ* ? 3. Δ et Δ′ les tangentes à la parabole 𝒫 issues des points M et M′ ; montrer
  que Δ et Δ′ se coupent sur la directrice de 𝒫 et qu'elles sont perpendiculaires.
- **Ex. 7** (p.118) : pour chacune des hyperboles suivantes, déterminer ses foyers, sommets et une équation de
  chacune de ses directrices, son excentricité, puis la tracer. a. −9x² + 25y² = 225. b. 9x² − 25y² = 225. c.
  x² − 4y² = 16.
- **Ex. 8** (p.118) : ℋ une hyperbole de foyers F et F′, de directrice D associée à F, de sommets S et S′ et
  d'excentricité e ; trouver l'équation réduite de ℋ. 1. F a pour coordonnées (12, 0) et S a pour coordonnées
  (4, 0). 2. F et F′ ont pour coordonnées (0, 5) et (0, −5) et e = √3. 3. F a pour coordonnées (0, 2), D a pour
  équation y + 3 = 0 et e = √3.
- **Ex. 9** (p.118) : ℋ l'hyperbole d'équation x² − 4y² = 1 ; déterminer les asymptotes de ℋ et construire ℋ.
- **Ex. 10** (p.118) : calculer l'excentricité d'une hyperbole dont les asymptotes sont orthogonales.
- **Ex. 11** (p.119) : ℋ l'hyperbole d'équation xy = 1 ; A, B et C les points de ℋ d'abscisses respectives 1, 2
  et −1/2. 1. montrer que la tangente en A à ℋ est perpendiculaire à (BC). 2. F le point de ℋ d'abscisse 3 ; a.
  donner une équation cartésienne de la hauteur issue de A du triangle ABF. b. démontrer que l'orthocentre de
  ABF est un point de ℋ.
- **Ex. 12** (p.119) : pour chacune des ellipses suivantes, déterminer ses foyers, ses sommets et une équation
  de chacune de ses directrices, son excentricité, puis la tracer. a. 4x² + 9y² = 36. b. 9x² + 4y² = 36. c.
  −25x² − 9y² = −25.
- **Ex. 13** (p.119) : 𝒞 un cercle de centre O et de rayon R > 1 ; à tout point M d'affixe z = Re^{iθ} du
  cercle 𝒞, on associe le point M′ d'affixe 1/z. 1. déterminer la partie réelle et la partie imaginaire du
  milieu I de [MM′]. 2. montrer que I varie sur une ellipse ℰ lorsque M varie sur 𝒞. 3. donner les éléments
  caractéristiques de ℰ.
- **Ex. 14** (p.119) : 1.a. construire la courbe 𝒞 d'équation 3x² + 4y² + 6x − 9 = 0. b. déterminer les foyers
  et les directrices. 2. M un point de 𝒞 d'affixe z = re^{iθ}, r > 0 ; a. exprimer r en fonction de θ. b.
  exprimer à l'aide de θ la distance MM′ où M′ est le symétrique de M par rapport à O. c. déterminer θ pour que
  la distance MM′ soit maximale. d. déterminer θ pour que la distance MM′ soit minimale.
- **Ex. 15** (p.119) : 𝒞 la courbe d'équation 25(x² + y²) = (3x − 16)². 1. déterminer la nature de 𝒞 et son
  excentricité. 2. M un point de 𝒞 ; on pose (i⃗, OM⃗) ≡ a [2π] ; exprimer OM à l'aide de a. 3. la droite (OM)
  coupe la directrice en I et recoupe la conique 𝒞 en M′ ; a. montrer que 1/OM + 1/OM′ est une constante. b.
  montrer que 1/OM + 1/OM′ = 2/OI pour tout M de 𝒞.
- **Ex. 16** (p.119) : ℰ une ellipse d'équation x²/a² + y²/b² = 1, a > b ; M₀(x₀, y₀) un point de ℰ ; T la
  tangente à ℰ en M₀ ; donner l'équation de la perpendiculaire T′ à T en M₀ ; la droite T′ coupe les axes du
  repère en N et P ; montrer que le rapport M₀N/M₀P est constant.
- **Ex. 17** (p.119) : ℰ une ellipse d'équation x²/a² + y²/b² = 1, a > b, dont l'un des foyers est noté F ; une
  droite variable D passant par F coupe l'ellipse en M et N ; montrer que 1/FM + 1/FN est constant.
- **Ex. 18** (p.119) : f l'application du plan dans lui-même qui à tout point M(x, y) associe le point M′ de
  coordonnées { X = √2(x + y) ; Y = √2(x − y) }. 1. montrer que f est la composée d'une symétrie axiale que
  l'on précisera et d'une homothétie de centre O et de rapport 2. 2. une courbe 𝒞 a pour image par f la courbe
  𝒞′ d'équation 5X² + 5Y² + 6XY − 64 = 0 ; a. déterminer une équation de 𝒞, ses foyers et ses directrices. b.
  en déduire que 𝒞 est une conique que l'on caractérisera. c. construire 𝒞 et 𝒞′.
- **Ex. 19** (p.120) : f l'application du plan dans lui-même qui à tout point M(x, y) associe le point M′ de
  coordonnées { X = (1/4)(x + √3 y) ; Y = (1/4)(−√3 x + y) }. 1. montrer que f est une similitude directe de
  centre O, de rapport 0.5 et d'angle −π/3. 2. une courbe 𝒞 a pour équation 15x² + 13y² − 2√3 xy − 768 = 0 ; a.
  déterminer une équation de 𝒞′ image de 𝒞 par f. b. en déduire que 𝒞′ est une ellipse à caractériser.
- **Ex. 20** (p.120) : 1. E = {M(x, y) ∈ P tel que x² + 4y² = 1} ; donner les éléments caractéristiques de E. 2. D et D′ les droites d'équations respectives x = 1 et x = −1 et F(√3/2, 0) ; M₀(cos θ, (1/2)sin θ) un point
  de E avec θ ∈ ℝ \ {kπ, k ∈ ℤ} ; a. vérifier que M₀ appartient à E. b. écrire l'équation de la tangente T à E
  au point M₀. c. T coupe D et D′ respectivement en K et K′ ; montrer que KFK′ est un triangle rectangle en F.
- **Ex. 21** (p.120) : déterminer la nature de chacune des courbes suivantes en donnant ses éléments
  caractéristiques, puis la construire. 1. x² + 4y² + 6y = 0. 2. (3x + 5y)² = (6x − 1)(5y + 2). 3.
  x² − y = 3x − 1.
- **Ex. 22** (p.120) : construire l'ensemble des points M(x, y) tels que (4x² − 9y² + 8x + 54y − 113) = 0 ou
  (16x² + 9y² + 12x − 54y − 47) = 0.
- **Ex. 23** (p.120) : 𝒞 l'ensemble des points M(x, y) tels que y⁴/16 = x⁴ − 2x² + 1 ; montrer que 𝒞 est la
  réunion de deux coniques ; déterminer les éléments caractéristiques de ces coniques puis les tracer dans un
  même repère.
- **Ex. 24** (p.120) : soit m un réel ; discuter suivant les valeurs de m la nature de la courbe 𝒞ₘ d'équation
  mx² + (1 + m²)y² − 2my = 0.
- **Ex. 25** (p.120) : 𝒞 l'ensemble des points M(x, y) tels que 4x|x| + y² − 16x − 20 = 0. 1. montrer que 𝒞 est
  la réunion d'une partie d'une conique 𝒞₁ et d'une partie d'une conique 𝒞₂ que l'on identifiera. 2. déterminer
  pour chacune des coniques les éléments caractéristiques. 3. A un point où chacune des coniques coupe la droite
  (O, j⃗) ; montrer que les coniques 𝒞₁ et 𝒞₂ ont même tangente en A ; tracer 𝒞 en prenant pour unité le
  centimètre.
- **Ex. 26** (p.120) : construire l'ensemble des points M(x, y) tels que y = √|x² − 6x + 5|.
- **Ex. 27** (p.120) : construire l'ensemble des points M(x, y) tels que 16x|x| + 36y|y| = 576.
- **Ex. 28** (p.120) : on considère une ellipse ℰ d'équation x²/a² + y²/b² = 1 (a > b > 0) ; A₁ et A₂ les
  sommets principaux de ℰ et T₁ et T₂ les tangentes à l'ellipse en A₁ et A₂ ; par un point P de ℰ distinct de A₁
  et A₂, on mène une tangente T à ℰ qui coupe T₁ en P₁ et T₂ en P₂ ; montrer que A₁P₁⃗·A₂P₂⃗ est indépendant de P.
- **Ex. 29** (p.120) : 𝒞 la conique d'équation 2x² + y² − 2x + y − 1 = 0 ; déterminer les tangentes issues du
  point I(2, 3) à 𝒞.
- **Ex. 30** (p.120) : soit a un réel strictement positif ; ℰ l'ellipse d'équation x²/a² + 4y²/a² = 1 de sommets
  principaux A et B ; I un point de la droite (AB) tel que IA⃗ = AO⃗ ; on note P et Q les points de contact des
  tangentes à ℰ issues de I ; que vaut l'angle PIQ ?

### Bornes de scope observées (chapitre 14)

- ✅ INCLUS : définition **par foyer-directrice** des trois coniques (**parabole** MF = MH ; **hyperbole**
  MF/MH = e avec e > 1 ; **ellipse** MF/MH = e avec 0 < e < 1) et la définition **unifiée** MF = eMH (parabole
  e = 1, hyperbole e > 1, ellipse e < 1) ; pour la **parabole** : axe focal, paramètre p, sommet (milieu de
  [FK]), axe de symétrie, **équation réduite** y² = 2px (et x² = 2py par symétrie), foyer F(p/2, 0) et directrice
  x = −p/2, **tangente** en M₀ (y₀y = p(x + x₀) et x₀x = p(y + y₀)), tangente au sommet x = 0 ; pour
  l'**hyperbole** : sommets (barycentres), centre et axes de symétrie, second foyer / seconde directrice,
  **équation réduite** x²/a² − y²/b² = 1 (b² = c² − a²), foyers (±√(a²+b²), 0), directrices x = ±a²/c,
  excentricité e = c/a, **asymptotes** y = ±(b/a)x, hyperbole **équilatère** (asymptotes perpendiculaires),
  **tangente** x₀x/a² − y₀y/b² = 1, **équation rapportée aux asymptotes** XY = k ; pour l'**ellipse** : sommets
  principaux et secondaires, centre et axes de symétrie, second foyer / seconde directrice, **équation réduite**
  x²/a² + y²/b² = 1 (b² = a² − c²), cas a > b (foyers sur (Ox)) et a < b (foyers sur (Oy)), directrices,
  excentricité, **tangente** x₀x/a² + y₀y/b² = 1, tangente au sommet (x = a, y = b), génération par cercles
  concentriques (paramétrage a cos θ, b sin θ) ; **équations non réduites** — réduction par translation
  d'origine (complétion du carré) et classification par le signe de AB dans Ax² + By² + Cx + Dy + E = 0 ;
  transformation d'une conique par une **similitude** (exercices résolus 6, ex. 18-19).
- ⛔ NON traité dans ce chapitre : les coniques de l'**espace** (quadriques) ; les coniques **à centre en repère
  quelconque** avec **terme croisé xy** traité de façon générale par diagonalisation matricielle (seuls des cas
  particuliers sont ramenés à une forme réduite via une similitude/rotation connue, ex. résolu 6, ex. 18-19-24) ;
  la **définition bifocale** (par la somme / différence des distances aux deux foyers) n'est **pas** posée comme
  définition ici — le chapitre construit systématiquement les coniques par **foyer-directrice-excentricité**. Le
  chapitre suppose acquis les **fonctions de référence** (x ↦ x², x ↦ 1/x), le **barycentre**, les **homothéties**
  et les **similitudes** (chapitre 13, réutilisées dans les exercices résolus 6 et les exercices 18-19).

## 2.15 Chapitre 15 — Géométrie dans l'espace (manuel 222446, p.121–146)

**Page de garde (p.121)** — Titre de couverture : « Géométrie dans l'espace », Chapitre 6 (numérotation
interne du tome 2 ; c'est le chapitre 15 dans la numérotation content ; le bandeau courant écrit « Géométrie
dans l'espace »). Encart historique : « Le produit scalaire apparaît assez tard dans l'histoire des
mathématiques. On en trouve trace chez Hamilton en 1843 lorsqu'il crée le corps des quaternions. Peano le
définit ensuite associé à un calcul d'aire ou de déterminant. Roberto Marcolongo et Cesare Burali-Forti le
définissent à l'aide du cosinus d'un angle et lui donne le nom de produit intérieur ou produit scalaire. […]
La définition utilisée actuellement du produit vectoriel est apparu [sic] en 1881 dans un manuel d'analyse
vectorielle écrit par Josiah Willard Gibbs pour ses étudiants en physique. Les travaux de Hermann Grassmann et
William Hamilton sont à l'origine du produit vectoriel défini par Gibbs. » Référence : « (M-J. Crowe, A
history of vector analysis, The Evolution of the Idea of a Vectorial System, 1994) ». Mention liminaire
(p.122) : « Dans tout le chapitre, l'espace E est orienté dans le sens direct. » Le chapitre est structuré en
cinq parties **I. Produit scalaire dans l'espace**, **II. Produit vectoriel**, **III. Équations d'une droite,
d'un plan et d'une sphère**, **IV. Translation**, **V. Homothétie de l'espace**, ponctuées d'activités et
d'encadrés (définitions / propriétés / théorèmes), suivies d'un QCM / Vrai-Faux, puis d'une rubrique
« Exercices et problèmes » (40 exercices). **Ce chapitre ne comporte pas de rubrique « exercices résolus »**
(le cours n'est fait que d'activités et d'encadrés à retenir).

### Cours — Activités

**I. Produit scalaire dans l'espace** (p.122)

- **Activité 1** (p.122) : ABCDEFGH un cube d'arête a. Exprimer en fonction de a les produits scalaires
  AF⃗.AB⃗, AF⃗.DC⃗, AF⃗.DG⃗, AF⃗.DH⃗, AF⃗.DE⃗.
- **Activité 2** (p.122) : ABCDEFGH un cube ; I le milieu de [DH], J le milieu de [BF] et O le centre de la
  face ABCD. 1. montrer que E, I, C et J sont coplanaires. 2. montrer que IJ⃗ = DB⃗ ; en déduire que
  OI⃗.IJ⃗ = 0. 3.a. calculer EC⃗.IJ⃗ et EC⃗.OI⃗. b. montrer que la diagonale [EC] est perpendiculaire au plan
  (DBH) [lecture peu lisible pour le troisième point du plan]. 4. en déduire que la droite (OI) est
  perpendiculaire au plan (EIC). (Figure : cube.)
- **Activité 3** (p.122–123) : ABCDEFGH un cube d'arête 1 ; I et J les milieux respectifs de [FB] et [CD] et K
  le pied de la hauteur issue de A dans le triangle ABH ; utiliser un repère orthonormé adéquat. 1. montrer que
  les droites (BE) et (IJ) sont orthogonales. 2.a. calculer AK⃗.AC⃗ [notation exacte peu lisible à la source].
  b. en déduire la mesure en radian de l'angle AK̂C [peu lisible].
- **Activité 4** (p.123) : ABCD un tétraèdre tel que les triangles ABC, ABD et ACD sont rectangles en A ; G le
  centre de gravité de ABCD et I le symétrique de A par rapport à G ; en choisissant un repère convenable,
  montrer que I est le centre de la sphère circonscrite au tétraèdre ABCD. (Figure : tétraèdre.)

**II. Produit vectoriel** (p.123)

- **Activité 1** (p.123) : en utilisant la figure d'une pyramide ABCDE, déterminer une base directe et une base
  indirecte de l'espace. (Figure : pyramide.)
- **Activité 2** (p.123) : ABCDEFGH un cube d'arête 1 ; déterminer AB⃗∧AD⃗, AD⃗∧AB⃗, AB⃗∧FG⃗, EF⃗∧EF⃗, EF⃗∧EH⃗
  et HD⃗∧DC⃗ [certaines paires de vecteurs sont peu lisibles à la source]. (Figure : cube.)
- **Activité 3** (p.123) : A, B et C trois points non alignés de l'espace. 1. déterminer l'ensemble des points M
  de l'espace tels que AB⃗∧CM⃗ = 0⃗. 2. déterminer l'ensemble des points M de l'espace tels que
  (MA⃗ + MC⃗)∧(MA⃗ + MB⃗) = 0⃗.
- **Activité 4** (p.124) : espace muni d'un repère orthonormé direct (O, i⃗, j⃗, k⃗) ; A(1, 0, −1), B(1, −2, 1)
  et C(0, −1, 2). 1. donner les composantes de AB⃗∧AC⃗. 2. en déduire une valeur approchée à 0.1 près de
  l'angle géométrique BAĈ.
- **Activité 5** (p.124) : espace muni d'un repère orthonormé direct (O, i⃗, j⃗, k⃗) ; u⃗, v⃗ et w⃗ trois
  vecteurs ; montrer que (u⃗∧v⃗).w⃗ = (w⃗∧u⃗).v⃗ = (v⃗∧w⃗).u⃗ = det(u⃗, v⃗, w⃗) [expressions intermédiaires peu
  lisibles à la source].
- **Activité 6** (p.124) : ABCDEFGH un cube de centre O tel que AB = 1 ; repère orthonormé direct
  (A, AB⃗, AD⃗, AE⃗) ; I, J, K et L les centres respectifs des faces ABFE, BCGF, CDHG et ADHE. 1. déterminer
  AB⃗∧AD⃗. 2. montrer que IJKL est un parallélogramme de centre O. 3.a. déterminer les coordonnées du vecteur
  IJ⃗∧IL⃗. b. en déduire l'aire du parallélogramme IJKL, puis l'aire du triangle IJK.
- **Activité 7** (p.124) : OABCDEFG un cube d'arête 1 et a un réel strictement positif ; repère orthonormé
  direct (O, OA⃗, OC⃗, OD⃗) ; L, M et K les points définis par OL⃗ = a·OC⃗, OM⃗ = a·OA⃗ et BK⃗ = a·BF⃗
  [dernière relation peu lisible]. 1. déterminer les coordonnées de DL⃗∧DM⃗ à l'aide de a. 2. calculer
  (DL⃗∧DM⃗).DK⃗ à l'aide de a. 3. en déduire le volume du tétraèdre DLMK à l'aide de a.
- **Activité 8** (p.125) : ABCDEFGH un parallélépipède, M le point tel que AB⃗∧AD⃗ = AM⃗ et K le projeté
  orthogonal de E sur la droite (AM) ; 𝒱 le volume du parallélépipède ABCDEFGH. 1. montrer que
  𝒱 = ‖AM⃗‖·‖AK⃗‖. 2. montrer que |AM⃗.AK⃗| = ‖AM⃗‖·‖AK⃗‖. 3. en déduire que 𝒱 = |(AB⃗∧AD⃗).AE⃗|. (Figure.)
- **Activité 9** (p.125) : espace muni d'un repère orthonormé direct (O, i⃗, j⃗, k⃗) ; A(1, 0, 0), B(0, 3, 0),
  C(−1, 3, 0), D(2, 2, 2), E(3, 2, 2), F(2, 5, 2) et G(5, 2, ?) [troisième coordonnée de G illisible à la
  source]. 1. montrer que OABCDEFG est un parallélépipède. 2. calculer le volume du parallélépipède OABCDEFG.

**III. Équations d'une droite, d'un plan et d'une sphère** (p.125)

- **Activité 1** (p.125) : espace muni d'un repère (O, i⃗, j⃗, k⃗) ; A(0, −1, 1), B(2, 1, 3) et la droite
  Δ : { x = α ; y = −2 + 2α ; z = 1 + α }, α ∈ ℝ. 1. déterminer un point et un vecteur directeur de Δ. 2.
  montrer que les droites (AB) et Δ sont sécantes en un point I que l'on précisera. 3. déterminer une
  représentation paramétrique de la droite Δ′ passant par A et parallèle à Δ.
- **Activité 2** (p.126) : espace muni d'un repère (O, i⃗, j⃗, k⃗) ; A(−1, 2, 1), B(1, −6, −1) et C(2, 2, 2).
  1.a. vérifier que les points A, B et C sont non alignés. b. déterminer une équation cartésienne du plan
  (ABC). 2.a. montrer que les plans (ABC) et (O, i⃗, k⃗) sont sécants. b. déterminer une représentation
  paramétrique de leur droite d'intersection.
- **Activité 3** (p.126) : espace muni d'un repère orthonormé direct (O, i⃗, j⃗, k⃗) ; A(2, 0, −1), B(1, −1, 0)
  et C(0, 1, 4). 1. vérifier que A, B et C sont non alignés. 2. calculer AB⃗∧AC⃗. 3. déterminer une équation
  cartésienne du plan (ABC). 4. déterminer une équation d'un plan passant par A et perpendiculaire au plan
  (ABC).
- **Activité 4** (p.126) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗). 1. montrer que l'ensemble S des
  points vérifiant x² + y² + z² − 2x − 4z + 4 = 0 est une sphère. 2.a. les points A(1, 1, 2) et B(1, −1, 4)
  sont-ils des points de la sphère S ? b. déterminer l'intersection de la sphère S et la droite (AB).
- **Activité 5** (p.126–127) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗). 1. S = {M(x, y, z) ;
  x² + y² + z² + 2x − 4y + 2z = 3} ; montrer que S est une sphère, préciser son rayon R et les coordonnées de
  son centre I. 2.a. vérifier que A(−3, 1, 1) est un point de S. b. déterminer une équation cartésienne du plan
  P tangent à S en A. 3. Q = {M(x, y, z) ; MA² − MI² = −3} ; a. montrer que Q est un plan dont on précisera une
  équation cartésienne. b. montrer que Q ∩ S est un cercle dont on précisera le centre I₁ et le rayon r. 4.a.
  vérifier que P et Q sont strictement parallèles. b. déterminer une équation cartésienne de la sphère S′
  tangente à P et Q respectivement en A et H.
- **Activité 6** (p.127) : ABCDEFGH un cube tel que AB = 1 ; repère orthonormé direct (A, AB⃗, AD⃗, AE⃗). 1.
  déterminer une représentation paramétrique de la droite (AG). 2.a. montrer que la droite (AG) est
  perpendiculaire au plan (EBD). b. en déduire une équation cartésienne du plan (EBD). c. déterminer les
  coordonnées du point L intersection du plan (EBD) et de la droite (AG). d. déterminer une équation cartésienne
  de la sphère circonscrite au tétraèdre EDBG. 3. S = {M(x, y, z) ; 3x² + 3y² + 3z² − 4x − 4y − 4z + 3 = 0} ; a.
  montrer que S est la sphère de diamètre [AG]. b. déterminer la position relative de la sphère S et du plan
  (EBD). c. déterminer une équation cartésienne du plan Q tangent à S et parallèle à (EBD).
- **Activité 7 (distance d'un point à une droite)** (p.127) : u⃗ un vecteur non nul, A un point de l'espace, M
  un point de l'espace n'appartenant pas à la droite D(A, u⃗) et H le projeté orthogonal de M sur la droite D.
  1. montrer que MA⃗∧u⃗ = MH⃗∧u⃗. 2. en déduire que MH = ‖MA⃗∧u⃗‖ / ‖u⃗‖.
- **Activité 8** (p.128) : OABCDEFG un cube d'arête 2 ; on pose i⃗ = (1/2)OA⃗, j⃗ = (1/2)OC⃗ et k⃗ = (1/2)OG⃗ ;
  repère orthonormé direct (O, i⃗, j⃗, k⃗) ; I, J et Q les milieux respectifs des segments [AO], [BC] et [EF] ; P
  le centre de la face AODC [lecture des sommets peu lisible]. 1. M(x, y, z) un point de l'espace ; déterminer à
  l'aide de x, y et z les distances d(M, (DG)) et d(M, (IJ)). 2.a. donner une représentation paramétrique de la
  droite (PQ). b. en déduire les points de la droite (PQ) équidistants des droites (DG) et (IJ). (Figure.)

**IV. Translation** (p.128)

- **IV.1 Définition** (p.128).
- **Activité 1** (p.128) : ABCDEFGH un parallélépipède rectangle. 1. montrer que les droites (AG) et (FD) se
  coupent en un point J. 2. déterminer t_{AB⃗}(H), t_{AJ⃗}(J) et t_{FB⃗}(G). 3. déterminer t_{AD⃗+AB⃗}(E) et
  t_{BA⃗−CD⃗}(A) [dernier vecteur peu lisible]. (Figure.)
- **Activité 2** (p.129) : ABCD un tétraèdre et f l'application qui à tout point M associe le point M′ tel que
  MM′⃗ = MA⃗ − 3MB⃗ + MC⃗ + MB⃗ ; montrer que f est une translation.
- **Activité 3** (p.129) : ABCD un tétraèdre ; I et J les milieux respectifs des segments [AB] et [CD]. 1.
  montrer que AC⃗ + BD⃗ = 2IJ⃗. 2. A′ et B′ images respectives de A et B par la translation de vecteur IJ⃗, C′ et
  D′ les antécédents de C et D par la même translation ; montrer que le solide AC′BD′A′CB′D est un
  parallélépipède [ordre des sommets peu lisible à la source].
- **IV.2 Propriété caractéristique** (p.129) — Théorème + Démonstration.
- **Activité** (p.130) : ABCDEFGH un parallélépipède ; I le point vérifiant AI⃗ = (1/2)AB⃗ + (3/4)AD⃗ et J
  l'image de I par la translation de vecteur AE⃗ ; montrer que J appartient au plan (EFG).
- **IV.3 Action d'une translation sur les configurations** (p.130).
- **Activité 1** (p.130) : u⃗ un vecteur de l'espace, A, B et C trois points non alignés ; t la translation de
  vecteur u⃗, A′ l'image de A par t. 1. montrer que l'image de la droite (AB) par t est la droite passant par A′
  et parallèle à (AB). 2. montrer que l'image du plan (ABC) par t est le plan passant par A′ et parallèle à
  (ABC).
- **Activité 2** (p.130) : ABCD un tétraèdre et I le point défini par AI⃗ = (1/3)AB⃗. 1. construire le plan P
  image du plan (BCD) par la translation de vecteur BI⃗. 2. le plan P coupe (AC) en J et coupe (AD) en K ;
  déterminer les images des droites (BC) et (BD) par t_{BI⃗}.
- **Activité 3** (p.130) : ABCDEFGH un parallélépipède ; I et J les centres de gravité respectifs des triangles
  ACF et DEG. 1.a. vérifier que BH⃗ = BA⃗ + BC⃗ + BF⃗. b. en déduire que J est l'image de I par la translation de
  vecteur BH⃗ [vecteur peu lisible]. 2. O le milieu de [FC] et O′ le point tel que OO′⃗ = BH⃗ ; montrer que O′
  appartient au plan (DEG). 3. la parallèle à la droite (BH) menée de A coupe le plan (DEG) en A′ ; montrer que
  les points O′, A′ et J sont alignés.
- **Activité 4** (p.131) : espace muni d'un repère (O, i⃗, j⃗, k⃗) ; A(1, 1, 1), B(0, 2, 1), C(3, 0, 0),
  D(−2, 1, 4) et E(1, 2, 3). 1. vérifier que A, B et C définissent un plan. 2. montrer que le plan (ABC) est
  globalement invariant par la translation de vecteur AD⃗. 3. donner une représentation paramétrique du plan P
  image du plan (ABC) par la translation de vecteur AE⃗.
- **Activité 5** (p.131) : IABCD une pyramide régulière de sommet I ; J l'image de I par la translation de
  vecteur AB⃗ et S la sphère de centre J passant par B ; déterminer S ∩ (ABCD).
- **IV.4 Expression analytique d'une translation** (p.132) — Théorème.
- **Activité 1** (p.132) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; A(1, 4, 1) et B(4, −2, 4). 1.a.
  vérifier que O, A et B ne sont pas alignés. b. P le plan contenant O, A et B ; montrer qu'une équation
  cartésienne de P est x − z = 0. 2. S la sphère de centre A et de rayon √2 ; t la translation de vecteur
  u⃗(−1, 0, 1). a. déterminer l'expression analytique de t. b. déterminer les coordonnées du point A′ image de A
  par t. c. déterminer une équation cartésienne du plan P′ image de P par t. d. en déduire que P′ est tangent à
  S en A′.
- **Activité 2** (p.132–133) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; les droites
  D : { x = 1 − α ; y = 2 + α ; z = −α }, α ∈ ℝ, et Δ : { x = −β ; y = 3 ; z = β }, β ∈ ℝ. 1. montrer que les
  droites D et Δ ne sont pas coplanaires. 2. Δ′ l'image de Δ par la translation de vecteur u⃗(−1, 1, −2). a.
  déterminer une représentation paramétrique de la droite Δ′. b. montrer que D et Δ′ se coupent en un point que
  l'on précisera. c. donner une équation cartésienne du plan Q contenant D et parallèle à Δ.

**V. Homothétie de l'espace** (p.133)

- **V.1 Définition** (p.133).
- **Activité 1** (p.133) : ABCD un tétraèdre ; I, J et K les milieux respectifs des segments [AB], [BD] et [BC].
  1. exprimer le volume du tétraèdre IJKB [sic] à l'aide du volume V du tétraèdre ABCD. 2. f l'application qui à
     tout point M associe le point M′ tel que BM′⃗ = −(2/3)BM⃗. a. construire le tétraèdre A′B′C′D′ image du
     tétraèdre ABCD par f. b. exprimer le volume de A′B′C′D′ à l'aide du volume du tétraèdre ABCD. (Figure.)
- **Activité 2** (p.133) : ABCD un tétraèdre ; h l'homothétie de centre A et de rapport 2 et h′ l'homothétie de
  centre C et de rapport 2 ; on pose B′ = h(B), D′ = h(D), B″ = h′(B) et D″ = h′(D) ; déterminer la nature du
  quadrilatère B′D′D″B″.
- **Activité 3** (p.133) : ABCDEFGH un parallélépipède ; I, J et K les milieux respectifs des segments [AC],
  [AD] et [AH] ; L et L′ les centres de gravité respectifs des triangles CDH et IJK ; montrer que L′ est
  l'image de L par une homothétie de centre A dont on précisera le rapport.
- **V.2 Propriété caractéristique** (p.134) — Théorème + Démonstration.
- **Activité 1 (V.2)** (p.134) : démonstration, en deux parties, de la propriété caractéristique de l'homothétie de rapport k : pour tous points M et N d'images respectives M′ et N′, M′N′⃗ = k·MN⃗.
- **Activité 2 (V.2)** (p.135) : ABCDEFGH un parallélépipède et I un point du segment [BC] distinct de B et C ;
  la parallèle à (FC) passant par I coupe [BF] en J. 1. f l'homothétie qui transforme C en B et E en I ;
  préciser le centre et le rapport de f. 2. montrer que f(D) = J. 3. en déduire que les droites (EB), (EI) et
  (DJ) sont concourantes.
- **V.3 Action d'une homothétie sur les configurations** (p.135).
- **Activité 1** (p.135) : k un réel non nul, A, B et C trois points non alignés ; h une homothétie de rapport
  k, A′ l'image de A par h. 1. montrer que l'image de la droite (AB) par h est la droite passant par A′ et
  parallèle à (AB). 2. montrer que l'image du plan (ABC) par h est le plan passant par A′ et parallèle à (ABC).
- **Activité 2 (V.3)** (p.135) : ABCDEFGH un cube ; I et J appartiennent respectivement aux segments [EF] et
  [FG] tels que EI = GJ, I et J distincts de F ; la droite (BJ) coupe la droite (CG) au point N ; la droite (BI)
  coupe la droite (AE) au point M ; h l'homothétie de centre B qui transforme J en N. 1. montrer que h(I) = M. 2. en déduire que les droites (IJ) et (MN) sont parallèles. (Figure.)
- **Activité 3 (V.3)** (p.135) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; le point I(1, 1, 1) et le
  plan P : x − 3y + z + 1 = 0 ; montrer que le plan P est globalement invariant par toutes les homothéties de
  centre I.
- **Activité 4** (p.136) : a > 0 et ABCDEFGH un parallélépipède droit tels que AE = 2AB = 2AD = 2a ; P le point
  de l'arête [AB] tel que AP⃗ = (1/4)AB⃗ ; M un point à l'intérieur du carré ABCD tel que le triangle AMP est
  équilatéral ; les droites (AE) et (PF) se coupent en Ω ; h l'homothétie de centre Ω qui transforme A en E.
  1.a. déterminer h(P). b. N l'image de M par h ; montrer que le triangle EFN est équilatéral. 2.a. exprimer à
  l'aide de a la distance ΩA. b. en déduire le volume du solide APMEFN. 3. I le centre du carré EFGH ; montrer
  que les droites (ΩI) et (AC) sont sécantes.
- **Activité 5** (p.136) : ABCDEFGH un cube d'arête a ; pour tout point M du plan (EFG), on désigne par N le
  centre de gravité du triangle MAB. 1. déterminer l'ensemble des points N lorsque M varie. 2. P le centre de
  gravité du triangle MBC ; montrer que la distance PN est constante. 3. Q et R les centres de gravité
  respectifs des triangles MCD et MAD ; montrer que NPQR est un carré et déterminer son aire.
- **Activité 6** (p.137) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; S l'ensemble des points M(x, y, z)
  tels que x² + y² + z² − 2x − 4y − 2z + 2 = 0. 1.a. montrer que S est une sphère dont on précisera le centre I
  et le rayon R. b. déterminer l'intersection de la sphère S avec le plan (O, i⃗, j⃗). 2. Ω(1, 1, 0) et h
  l'homothétie de centre Ω et de rapport −3/2. a. déterminer le centre I′ et le rayon R′ de la sphère S′ image
  de S par h. b. déterminer l'intersection de la sphère S′ avec le plan (O, i⃗, j⃗).
- **V.4 Expression analytique d'une homothétie** (p.137) — Théorème.
- **Activité** (p.137) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; le point I(1, −1, 2) et les plans P
  et Q d'équations respectives x − y + z − 4 = 0 et x + y − 1 = 0. 1. montrer que les plans P et Q sont sécants
  et donner une représentation paramétrique de leur droite d'intersection Δ. 2. h l'homothétie de centre I et de
  rapport 3 ; donner l'expression analytique de h. 3. R le plan image de Q par h ; donner une équation
  cartésienne de R. 4.a. vérifier que h(P) = P. b. en déduire un vecteur directeur de la droite Δ′ intersection
  des plans P et R.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Produit scalaire** (p.122, encadré) — « Soit A, B et C des points. Le produit scalaire des vecteurs AB⃗ et
> AC⃗ est le réel défini par • AB⃗ . AC⃗ = 0, si AB⃗ = 0⃗ ou AC⃗ = 0⃗. • AB⃗ . AC⃗ = AB.AC.cos BAĈ, si AB⃗ et
> AC⃗ sont non nuls. * AB⃗ . AB⃗ = AB⃗² = ‖AB⃗‖². »

> **Propriétés (Rappel)** (p.122) — « Pour tous vecteurs u⃗, v⃗ et w⃗ de l'espace et tous réels α et β
> • u⃗.v⃗ = v⃗.u⃗. • u⃗.(v⃗ + w⃗) = u⃗.v⃗ + u⃗.w⃗. • (αu⃗).v⃗ = u⃗.(αv⃗) = α(u⃗.v⃗). • (αu⃗).(βv⃗) = αβ(u⃗.v⃗). »

> **Expression analytique du produit scalaire** (p.122, encadré) — « Soit (O, i⃗, j⃗, k⃗) un repère orthonormé
> de l'espace. Pour tous vecteurs u⃗(x, y, z) et v⃗(x′, y′, z′), u⃗.v⃗ = xx′ + yy′ + zz′ et
> ‖u⃗‖ = √(x² + y² + z²). Pour tous points M(x, y, z) et M′(x′, y′, z′),
> MM′ = √((x − x′)² + (y − y′)² + (z − z′)²). »

> **Produit vectoriel** (p.123, encadré) — « Soit A, B et C des points de l'espace. Le produit vectoriel de AB⃗
> par AC⃗ est le vecteur noté AB⃗∧AC⃗ et défini comme suit * si AB⃗ et AC⃗ colinéaires, alors AB⃗∧AC⃗ = 0⃗, * si
> AB⃗ et AC⃗ ne sont pas colinéaires, alors • AB⃗∧AC⃗ est orthogonal à AB⃗ et à AC⃗, • (AB⃗, AC⃗, AB⃗∧AC⃗) est
> une base directe, • ‖AB⃗∧AC⃗‖ = AB.AC.sin BAĈ. »

> **Propriétés (Rappel)** (p.123) — « Soit u⃗ et v⃗ deux vecteurs et α, β deux réels. • u⃗∧u⃗ = 0⃗. • u⃗∧v⃗ = 0⃗,
> si et seulement si, u⃗ et v⃗ sont colinéaires. • u⃗∧v⃗ = −(v⃗∧u⃗), u⃗∧(v⃗ + w⃗) = u⃗∧v⃗ + u⃗∧w⃗,
> αu⃗∧βv⃗ = αβ(u⃗∧v⃗). »

> **Composantes du produit vectoriel** (p.124, encadré) — « L'espace est muni d'une base orthonormée directe
> (i⃗, j⃗, k⃗). Pour tous vecteurs u⃗(a, b, c) et v⃗(a′, b′, c′),
> u⃗∧v⃗ = (bc′ − cb′)i⃗ + (ca′ − ac′)j⃗ + (ab′ − ba′)k⃗. »

> **Produit mixte / déterminant** (p.124, Propriété) — « L'espace est muni d'un repère orthonormé direct
> (O, i⃗, j⃗, k⃗). Pour tous vecteurs u⃗, v⃗ et w⃗, (u⃗∧v⃗).w⃗ = (w⃗∧u⃗).v⃗ = (v⃗∧w⃗).u⃗ = det(u⃗, v⃗, w⃗). »
> [note : les expressions intermédiaires de la permutation circulaire sont peu lisibles à la source.]

> **Aire du parallélogramme / du triangle** (p.124, encadré) — « L'aire du parallélogramme ABCD est égale à
> ‖AB⃗∧AD⃗‖. L'aire du triangle ABD est égale à (1/2)‖AB⃗∧AD⃗‖. »

> **Volume d'un tétraèdre** (p.124, encadré) — « Le volume d'un tétraèdre ABCD est égal à
> (1/6)|(BC⃗∧BD⃗).BA⃗|. »

> **Théorème** (p.125, volume d'un parallélépipède) — « Le volume d'un parallélépipède ABCDEFGH est égal à
> |(AB⃗∧AD⃗).AE⃗|. »

> **Représentation paramétrique d'une droite** (p.125, encadré) — « Soit A un point, u⃗ un vecteur non nul et D
> la droite passant par A et de vecteur directeur u⃗. Alors D(A, u⃗) = {M ; AM⃗ = αu⃗, où α est un réel}. »

> **Plan par un point et deux vecteurs** (p.126, encadré) — « L'espace est muni d'un repère (O, i⃗, j⃗, k⃗).
> Soit A un point, u⃗ et v⃗ deux vecteurs non colinéaires et P le plan passant par A et de vecteurs directeurs
> u⃗ et v⃗. Alors P(A, u⃗, v⃗) = {M ; det(AM⃗, u⃗, v⃗) = 0}. »

> **Sphère** (p.126, encadré) — « L'espace est muni d'un repère orthonormé (O, i⃗, j⃗, k⃗). Soit A un point, R
> un réel strictement positif et S la sphère de centre A et de rayon R. Alors S = {M ; AM = R}. »

> **Distance d'un point à un plan** (p.126, encadré) — « L'espace est muni d'un repère orthonormé
> (O, i⃗, j⃗, k⃗). Soit un plan P d'équation ax + by + cz + d = 0 et A(x₀, y₀, z₀) un point de l'espace. La
> distance de A à P est le réel, noté d(A, P), égal à |ax₀ + by₀ + cz₀ + d| / √(a² + b² + c²). »

> **Théorème (Rappel)** (p.127, intersection sphère-plan) — « L'espace est muni d'un repère orthonormé
> (O, i⃗, j⃗, k⃗). Soit S une sphère de centre A et de rayon R. Soit P un plan, h la distance de A à P et H le
> projeté orthogonal de A sur P. L'intersection de S et P est • vide si h > R, • réduite au singleton {H} si
> h = R, • le cercle de rayon √(R² − h²) et de centre H si h < R. »

> **Définition** (p.128, distance d'un point à une droite) — « On appelle distance d'un point M à une droite D,
> la distance MH où H est le projeté orthogonal de M sur D. Cette distance est notée d(M, D). »

> **Théorème** (p.128, distance d'un point à une droite) — « Soit D une droite de vecteur directeur u⃗ et A un
> point de D. La distance d'un point M de l'espace à la droite D est le réel d(M, D) = ‖MA⃗∧u⃗‖ / ‖u⃗‖. »

> **Définition** (p.128, translation) — « Soit u⃗ un vecteur de l'espace. L'application qui à tout point M de
> l'espace associe l'unique point M′ tel que MM′⃗ = u⃗ est appelée translation de vecteur u⃗ et notée t_u⃗. Pour
> tous points M et M′ de l'espace, t_u⃗(M) = M′ équivaut à MM′⃗ = u⃗. »

> **Théorème** (p.129, translation bijective) — « Toute translation de l'espace de vecteur u⃗ est bijective. Son
> application réciproque est la translation de vecteur −u⃗. Pour tous points M et N de l'espace, N = t_u⃗(M)
> équivaut à M = t_{−u⃗}(N). »

> **Théorème** (p.129, propriété caractéristique de la translation) — « Une application de l'espace dans
> lui-même est une translation, si et seulement si, pour tous points M et N d'images respectives M′ et N′,
> M′N′⃗ = MN⃗. »

> **Conséquences** (p.130) — « • Toute translation de l'espace conserve la distance. • Toute translation de
> l'espace conserve le produit scalaire. »

> **Théorème** (p.130, image d'une droite / d'un plan par une translation) — « L'image d'une droite par une
> translation est une droite qui lui est parallèle. L'image d'un plan par une translation est un plan qui lui
> est parallèle. »

> **Conséquences** (p.130) — « Toute translation conserve le parallélisme et l'orthogonalité. Toute translation
> conserve le milieu. »

> **Invariance globale** (p.131, encadré) — « Soit Γ une partie de l'espace. On dit que Γ est globalement
> invariante par une application f lorsque f(Γ) = (Γ). »

> **Théorème** (p.131, image d'une sphère par une translation) — « L'image d'une sphère S par une translation
> est une sphère S′ de même rayon et de centre l'image du centre. »

> **Pyramide régulière** (p.131, encadré) — « Une pyramide IABCD de sommet I est dite régulière si, sa base
> ABCD est un carré et le projeté orthogonal de I sur le plan (ABCD) est le centre du carré ABCD. »

> **Théorème** (p.132, expression analytique d'une translation) — « L'espace est muni d'un repère
> (O, i⃗, j⃗, k⃗). • Soit u⃗(a, b, c) un vecteur de l'espace. Si M(x, y, z) est un point de l'espace et
> M′(x′, y′, z′) est son image par la translation de vecteur u⃗ alors { x′ = x + a ; y′ = y + b ; z′ = z + c }.
> • L'application qui à tout point M(x, y, z) associe le point M′(x′, y′, z′) tel que { x′ = x + a ; y′ = y + b ;
> z′ = z + c } est la translation de vecteur u⃗(a, b, c). »

> **Définition** (p.133, homothétie) — « Soit I un point de l'espace et k un réel non nul. L'application qui à
> tout point M de l'espace associe l'unique point M′ tel que IM′⃗ = k IM⃗ est appelée homothétie de centre I et
> de rapport k, elle est notée h_(I,k). Pour tous points M et M′ de l'espace, h_(I,k)(M) = M′ équivaut à
> IM′⃗ = k IM⃗. »

> **Théorème** (p.134, homothétie bijective) — « Toute homothétie de centre I et de rapport non nul k est une
> bijection de l'espace et admet comme application réciproque l'homothétie de centre I et de rapport 1/k. Pour
> tous points M et N de l'espace, N = h_(I,k)(M) équivaut à M = h_(I,1/k)(N). »

> **Théorème** (p.134, propriété caractéristique de l'homothétie) — « Soit f une application de l'espace dans
> lui-même et k un réel non nul et différent de 1. f est une homothétie de rapport k, si et seulement si, pour
> tous points M et N d'images respectives M′ et N′ par f, M′N′⃗ = k MN⃗. »

> **Conséquences** (p.134) — « Soit h une homothétie de l'espace de rapport k. Pour tous points M et N d'images
> respectives M′ et N′ par h, M′N′ = |k| MN. »

> **Théorème** (p.135, image d'une droite / d'un plan par une homothétie) — « L'image d'une droite par une
> homothétie est une droite qui lui est parallèle. L'image d'un plan par une homothétie est un plan qui lui est
> parallèle. »

> **Conséquences** (p.135) — « Toute homothétie conserve le parallélisme et l'orthogonalité. Toute homothétie
> conserve le milieu. »

> **Théorème** (p.136, image d'une sphère par une homothétie) — « L'image d'une sphère S de centre I et de
> rayon R par une homothétie de l'espace de rapport k est une sphère S′ de centre I′ image de I et de rayon
> |k|R. »

> **Propriété** (p.137) — « Toute homothétie de l'espace conserve le contact. »

> **Théorème** (p.137, expression analytique d'une homothétie) — « L'espace est muni d'un repère orthonormé
> (O, i⃗, j⃗, k⃗). • Soit un point I(a, b, c), k un réel non nul et différent de 1 et h l'homothétie de centre I
> et de rapport k. Si M(x, y, z) est un point de l'espace et M′(x′, y′, z′) est son image par h, alors
> { x′ = kx + (1 − k)a ; y′ = ky + (1 − k)b ; z′ = kz + (1 − k)c }. • L'application qui à tout point M(x, y, z)
> associe le point M′(x′, y′, z′) tel que { x′ = kx + α ; y′ = ky + β ; z′ = kz + δ }, k ≠ 1, est l'homothétie
> de centre I(α/(1 − k), β/(1 − k), δ/(1 − k)) et de rapport k. »

### QCM (p.138) — « Cocher la réponse exacte. » (réponses non fournies)

1. Soit A, B et C trois points non alignés. Le vecteur AB⃗∧AC⃗ est (☐ normal au plan ABC / ☐ directeur du plan
   ABC / ☐ directeur à la droite (BC)).
2. Si ABCD est un parallélogramme alors (☐ AB⃗∧AD⃗ = BA⃗∧BC⃗ / ☐ ‖AB⃗∧AD⃗‖ = ‖BA⃗∧BC⃗‖ /
   ☐ ‖AB⃗∧AD⃗‖ = (1/2)‖AB⃗∧AC⃗‖).
3. Dans la figure ci-contre ABCDEFGH est un cube d'arête 1. a. Le vecteur AB⃗∧AC⃗ est égal à
   (☐ AB⃗∧AD⃗ / ☐ AC⃗∧DC⃗ / ☐ √2 AE⃗). b. Le vecteur AC⃗∧EG⃗ est égal à (☐ 0⃗ / ☐ BD⃗ / ☐ BF⃗). c. Le réel
   AC⃗.FH⃗ est égal à (☐ 2 / ☐ 0 / ☐ √2). d. Le volume du tétraèdre FBEG [sic] est égal à
   (☐ 1/6 / ☐ 2/3 / ☐ 1/2). (Figure : cube.)

### Vrai ou faux (p.138) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. Soit u⃗, v⃗ et w⃗ trois vecteurs. a. Si u⃗∧v⃗ = v⃗ alors v⃗ = 0⃗. b. Si u⃗∧v⃗ = u⃗∧w⃗ alors v⃗ = w⃗. c.
   u⃗∧v⃗ = v⃗∧w⃗, si et seulement si, u⃗ et v⃗ sont colinéaires.
2. L'image d'un cube d'arête a par une homothétie de rapport a est un cube de volume a⁶.
3. Si S et S′ sont deux sphères de même rayon alors il existe une seule translation qui transforme S en S′ et
   une seule homothétie qui transforme S en S′.

### Exercices et problèmes (p.139–146) — 40 exercices

Mention liminaire (p.139) : « Dans tous les exercices, l'espace est orienté dans le sens direct. »

- **Ex. 1** (p.139) : ABCD un tétraèdre ; I le milieu de [CD], G le centre de gravité du triangle BCD, K le
  milieu de [AG] et J le point tel que AJ⃗ = (1/4)AB⃗. 1. montrer que 4AK⃗ = 2AK⃗ + 3AK⃗ = … [relation
  vectorielle peu lisible à la source]. 2. en déduire que les points I, J et K sont alignés. (Figure :
  tétraèdre.)
- **Ex. 2** (p.139) : ABCDEFGH un cube. 1. calculer AG⃗.FH⃗ et AG⃗.FC⃗ [notation exacte peu lisible]. 2. en
  déduire que la droite (AG) est perpendiculaire au plan (FHC) [plan peu lisible]. (Figure : cube.)
- **Ex. 3** (p.139) : ABCDEFGH un cube ; I et J les milieux respectifs des arêtes [EH] et [BF] ; P le point
  d'intersection de (EG) et (IF). Q le point d'intersection de (FC) et (GJ) [lecture peu lisible]. 1. montrer
  que 3PQ⃗ = … [relation vectorielle peu lisible]. 2. calculer 3PQ⃗.EG⃗ et 3PQ⃗.FC⃗. 3. en déduire que la droite
  (PQ) est perpendiculaire à (EG) et (FC). (Figure : cube.)
- **Ex. 4** (p.139) : ABCDEFGH un cube d'arête 1 ; I, J, K et L les points définis par AI⃗ = (1/3)AD⃗,
  BJ⃗ = (1/3)BC⃗, HK⃗ = (1/3)HG⃗ [et une quatrième relation, EL⃗ = (1/3)EG⃗ — lecture peu lisible]. 1. montrer
  que ABJIKL [sic] est un parallélépipède. 2. repère (A, AB⃗, AD⃗, AE⃗). a. déterminer les composantes des
  vecteurs AB⃗, AI⃗ et AL⃗. b. en déduire le volume du parallélépipède ABJIKL [sic]. (Figure : cube.)
- **Ex. 5** (p.139) : ABCDEFGH un cube de centre O d'arête a ; I le milieu du segment [AB], J et K les centres
  respectifs des faces ABFE et ABCD. 1. montrer que O, I, J et K sont coplanaires. 2. quelle est la nature du
  quadrilatère OJIK [sic] ? 3. quel est le volume de la pyramide BIOK [sic] ?
- **Ex. 6** (p.140) : ABCD un tétraèdre régulier. 1.a. calculer AB⃗.AD⃗ et AB⃗.AC⃗. b. en déduire AB⃗.CD⃗. c. en
  déduire que deux arêtes opposées sont orthogonales. 2. A′ le centre de gravité du triangle BCD ; montrer que
  la droite (AA′) est perpendiculaire au plan (BCD). 3. O le point tel que OA⃗ + 3OA′⃗ = 0⃗ ; montrer que O est
  le centre de la sphère S circonscrite au tétraèdre ABCD. 4. I le milieu du segment [BC] et on suppose que
  AB = a (a ∈ ℝ₊*). a. exprimer, à l'aide de a, les distances DI, DA′ et AA′. b. V le volume du tétraèdre et R
  le rayon de la sphère S ; exprimer V et R à l'aide de a. c. déterminer cos AÔB et cos AÎD et donner une valeur
  approchée de ces deux angles en degré, à 0.01 près.
- **Ex. 7** (p.140) : u⃗ et v⃗ deux vecteurs vérifiant ‖u⃗‖ = 1, ‖v⃗‖ = 4 et u⃗.v⃗ = 2 ; w⃗ = 2u⃗ + 3v⃗
  [combinaison peu lisible] ; calculer u⃗.w⃗, v⃗.w⃗ et ‖w⃗‖.
- **Ex. 8** (p.140) : espace muni d'un repère orthonormé direct (O, i⃗, j⃗, k⃗) ; u⃗ = 2i⃗ + j⃗ + k⃗ et
  w⃗ = 3i⃗ − 4j⃗ − 2k⃗ [composantes peu lisibles]. 1. montrer que les vecteurs u⃗ et w⃗ sont orthogonaux. 2.
  trouver un vecteur v⃗ vérifiant u⃗∧v⃗ = w⃗ ; trouver tous les vecteurs v⃗ vérifiant u⃗∧v⃗ = w⃗. 3. trouver un
  vecteur v⃗ vérifiant u⃗∧v⃗ = w⃗ et u⃗.v⃗ = 1.
- **Ex. 9** (p.140) : u⃗ et v⃗ deux vecteurs unitaires orthogonaux et w⃗ un vecteur vérifiant
  w⃗ = u⃗ + u⃗∧w⃗ [relation peu lisible]. 1. montrer que w⃗ est orthogonal à v⃗ et que sa norme vaut
  (1/2)√2. 2. montrer que w⃗ = (1/2)u⃗ − (1/2)u⃗∧v⃗ [expression peu lisible].
- **Ex. 10** (p.140) : A, B, C, D quatre points de l'espace et a = AB⃗.CD⃗ + AC⃗.DB⃗ + AD⃗.BC⃗. 1. calculer a en
  remplaçant BC⃗ par AC⃗ − AB⃗. 2. en déduire que si un tétraèdre a deux couples d'arêtes opposées orthogonales,
  il en est de même du troisième couple.
- **Ex. 11** (p.140) : espace muni d'un repère orthonormé direct (O, i⃗, j⃗, k⃗). 1. vérifier que les trois
  points A(1, 1, −1), B(3, 3, 2) et C(3, −1, −2) déterminent un plan (ABC). 2. trouver un vecteur normal au plan
  (ABC). 3. trouver une équation cartésienne de ce plan (ABC). 4. calculer la distance de l'origine O à ce plan.
- **Ex. 12** (p.140) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; quatre plans ont pour équations
  x + y − 2z = 5, 3x − 6y + 3z = 2, 2x + 2y + 2z = −1, x − 2y + z = 7. 1. montrer que deux de ces plans sont
  parallèles et calculer la distance entre ces deux plans. 2. montrer que deux de ces plans sont
  perpendiculaires.
- **Ex. 13** (p.140) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; P le plan d'équation
  x − y + 5z = 2007 ; trouver un vecteur directeur de P, de norme 1 et orthogonal au vecteur v⃗ = i⃗ + 2j⃗ − 3k⃗.
- **Ex. 14** (p.140) : espace muni d'un repère orthonormé direct (O, i⃗, j⃗, k⃗) ; donner une équation du plan
  passant par le point A(2, 0, 0) et de vecteurs directeurs i⃗ + j⃗ et j⃗ + k⃗.
- **Ex. 15** (p.141) : ABCDEFGH un parallélépipède rectangle tel que AB = 2, AD = 1 et AE = 1 ; I le milieu
  [BD] ; R = (A, (1/2)AB⃗, AD⃗, AE⃗) un repère de l'espace. 1. déterminer une représentation paramétrique de la
  droite (FI). 2. déterminer une équation cartésienne du plan (DEG). 3. en déduire que la droite (FI) coupe le
  plan (DEG) au milieu du segment [FI].
- **Ex. 16** (p.141) : OABC un tétraèdre trirectangle tel que (OA), (OB) et (OC) sont deux à deux orthogonales
  et H le projeté orthogonal de O sur le plan (ABC) ; on pose OA = a, OB = b et OC = c avec a, b et c trois
  réels strictement positifs ; repère R = (O, (1/a)OA⃗, (1/b)OB⃗, (1/c)OC⃗). 1.a. déterminer, à l'aide de a, b et
  c, une équation du plan (ABC). b. en déduire que 1/OH² = 1/OA² + 1/OB² + 1/OC². 2.a. exprimer l'aire du
  triangle ABC à l'aide de a, b et c. b. vérifier que le carré de l'aire de la face ABC est égal à la somme des
  carrés des aires des trois autres faces. (« C'est en 1738 que le mathématicien De Gua de Malves qualifia ce
  résultat de "généralisation du théorème de Pythagore à l'espace". »)
- **Ex. 17** (p.141) : ABCDEFGH un cube d'arête 1 ; M et N deux points variables respectivement sur le segment
  [FB] privé de F et B et [EH] privé de H [lecture peu lisible] et C [sic] tels que BM = CN [sic] ; repère
  (A, AB⃗, AD⃗, AE⃗) ; on note BM = α avec α un réel appartenant à ]0, 1[. 1. déterminer les coordonnées des
  points M et N à l'aide de α. 2.a. montrer qu'il existe un vecteur fixe u⃗ tel que MN⃗ = αu⃗ + AD⃗. b. en
  déduire que la droite (MN) reste parallèle à un plan fixe que l'on précisera. 3. montrer que la droite passant
  par les milieux de [BC] et [MN] est perpendiculaire aux droites (BC) et (MN). (Figure.)
- **Ex. 18** (p.141) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; A(0, 4, −1), B(−2, 4, −5),
  C(1, 1, −5) et D(1, 0, −4). 1. déterminer une équation de chacun des plans médiateurs des segments [AB], [BC]
  et [AD]. 2. montrer que ces trois plans ont un point commun I ; en déduire une équation cartésienne de la
  sphère circonscrite au tétraèdre ABCD.
- **Ex. 19** (p.141–142) : A/ u⃗, v⃗ et w⃗ trois vecteurs de l'espace ; on se propose de montrer que
  w⃗∧(u⃗∧v⃗) = (w⃗.u⃗)v⃗ − (w⃗.v⃗)u⃗ [formule du double produit vectoriel]. 1. vérifier l'égalité précédente
  lorsque u⃗ et v⃗ sont colinéaires. 2. dans le cas où u⃗ et v⃗ ne sont pas colinéaires, on pose u⃗ = OA⃗,
  v⃗ = OB⃗ et i⃗ = OA⃗/‖OA⃗‖, j⃗ un vecteur du plan (OAB) tel que (i⃗, j⃗) soit une base orthonormée de ce plan,
  k⃗ un vecteur de l'espace tel que (O, i⃗, j⃗, k⃗) soit un repère orthonormé direct de l'espace. a. justifier
  l'existence de six réels a, b, c, α, β et δ tels que OA⃗ = αi⃗, OB⃗ = βi⃗ + δj⃗ et w⃗ = ai⃗ + bj⃗ + ck⃗. b.
  déterminer à l'aide de a, b, c, α, β et δ les composantes des vecteurs w⃗∧(u⃗∧v⃗) et (w⃗.u⃗)v⃗ − (w⃗.v⃗)u⃗ ;
  conclure. B/ **Application 1** : u⃗ et v⃗ deux vecteurs unitaires et orthogonaux ; on pose w⃗ = u⃗∧v⃗ ;
  montrer que v⃗∧w⃗ = u⃗ et w⃗∧u⃗ = v⃗ [expressions peu lisibles]. **Application 2** : u⃗, v⃗ et w⃗ trois
  vecteurs de l'espace ; montrer que u⃗∧(v⃗∧w⃗) = (u⃗.w⃗)v⃗ − … [lecture peu lisible], si et seulement si, u⃗ et
  w⃗ sont colinéaires. **Application 3** : u⃗ et v⃗ deux vecteurs de l'espace. 1. montrer que
  ‖u⃗∧v⃗‖² = (v⃗∧(u⃗∧v⃗)).u⃗ = ‖u⃗‖²·‖v⃗‖² − (u⃗.v⃗)².
- **Ex. 20** (p.142) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; A(0, 6, 0), B(0, 0, 8) et C(4, 0, 8).
  1.a. les droites (BC) et (BA) sont orthogonales. b. les droites (CO) et (OA) sont orthogonales. c. la droite
  (BC) est orthogonale au plan (OAB). 2. déterminer le volume du tétraèdre OABC. 3. montrer que les quatre
  points O, A, B et C se trouvent sur une sphère dont on déterminera le centre et le rayon. 4. à tout réel α de
  l'intervalle ]0, 8[ on associe le point M(0, 0, α) ; le plan contenant M et orthogonal à la droite (OB)
  rencontre les droites (OC), (AC) et (AB) respectivement en N, P et Q. a. déterminer la nature du quadrilatère
  MNPQ. b. la droite (PM) est-elle orthogonale à la droite (OB) ? pour quelle valeur de α la droite (PM) est-elle
  orthogonale à la droite (AC) ? c. déterminer MP² à l'aide de α ; pour quelle valeur de α la distance PM
  est-elle minimale ? (Figure.)
- **Ex. 21** (p.142) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; S la sphère de centre J(0, 1, 0) et
  de rayon 1 ; α et β deux réels donnés, M et N les points définis par OM⃗ = αk⃗ et AN⃗ = βi⃗ où A(0, 2, 0). 1.
  déterminer une équation cartésienne de la sphère S. 2. déterminer une représentation paramétrique de la droite
  (MN) à l'aide de α et β. 3.a. montrer que la droite (MN) est tangente à la sphère S si et seulement si
  α²·β² = 4. b. dans le cas où la droite (MN) est tangente à S, calculer les coordonnées du point de contact à
  l'aide de α et β. (Figure.)
- **Ex. 22** (p.143) : ABCD un tétraèdre ; G le centre de gravité du triangle BCD ; I et J les milieux
  respectifs des segments [BC] et [CD] ; K le point tel que 5GK⃗ … = 0⃗ [relation peu lisible] ; L le point
  défini par AL⃗ = (1/6)AB⃗ ; repère (A, AB⃗, AC⃗, AD⃗). 1. déterminer les coordonnées des points A, B, C, D, G,
  I, J et L. 2. déterminer une représentation paramétrique de chacune des droites (KL) et (AG). 3. en déduire
  que les droites (KL) et (AG) sont concourantes.
- **Ex. 23** (p.143) : le cube ABCDEFGH d'arête 1 (présenté ci-dessous) ; à chaque réel x on associe le point M
  de la droite (DF) défini par DM⃗ = x·DF⃗. 1.a. montrer que MB = MG = ME [sic]. b. montrer que le triangle BEG
  est équilatéral. 2.a. exprimer MB² en fonction de x et étudier les variations de la fonction ainsi obtenue. b.
  en déduire les coordonnées du centre du cercle circonscrit au triangle BEG. 3. α le réel tel que
  EM̂B = BM̂G = GM̂E = α. a. montrer que cos α = 1 − 1/(3x² − 4x + 2). b. étudier les variations de la fonction f
  définie par f(x) = 1 − 1/(3x² − 4x + 2) et résoudre l'équation f(x) = 0. c. en déduire qu'il existe deux points
  M₁ et M₂ de (DF) tels que les repères (M₁, M₁B⃗, M₁G⃗, M₁E⃗) et (M₂, M₂B⃗, M₂G⃗, M₂E⃗) sont orthonormés [sic].
  d. en quel point du segment [DF] l'angle α est-il minimum ? (Figure : cube.)
- **Ex. 24** (p.143) : (O, OA⃗, OC⃗, OS⃗) un repère orthonormé de l'espace ; B le point de coordonnées (1, 1, 0) ;
  P le plan d'équation x + y = a où a est un réel de l'intervalle ]0, 1[ ; le but du problème est de déterminer
  la section du plan P avec la pyramide SOABC et le maximum de l'aire de cette section. 1. déterminer une
  représentation paramétrique de chacune des droites (SA), (SB), (SC), (OC) et (OA). 2. I, J, K, L et M les
  points d'intersection respectifs du plan P avec les droites (SA), (SB), (SC), (OC) et (OA). a. déterminer les
  coordonnées des points I, J, K, L et M. b. vérifier que le quadrilatère IJKM [sic] est un rectangle. c.
  déterminer l'aire du pentagone IJKLM. 3. f la fonction définie sur ]0, 1[ par f(x) = (x√2/4)(4 − 3x). a.
  étudier les variations de f sur ]0, 1[. b. en déduire la position du plan P qui réalise le maximum de l'aire du
  pentagone IJKLM ; vérifier qu'il s'agit d'un plan qui passe par le centre de gravité du triangle OAC. (Figure.)
- **Ex. 25** (p.144) : ABCDEFGH un parallélépipède. 1. A′ le point tel que FA′⃗ = (1/4)FG⃗. Soit D′ le point tel
  que DD′⃗ = (1/4)DG⃗ [relation peu lisible] ; les droites (AD′) et (DA′) se coupent en O ; déterminer le rapport
  de l'homothétie de centre O qui transforme A en D′ et D en A′. 2. existe-t-il une homothétie qui transforme
  (AD) en (EF) ?
- **Ex. 26** (p.144) : ABCD un tétraèdre ; I et J les milieux respectifs des segments [AB] et [AC] ; E et F
  désignent respectivement les symétriques du point D par rapport à I et J ; montrer que le triangle BCD est
  l'image du triangle EFA par une translation que l'on déterminera.
- **Ex. 27** (p.144) : ABCD un tétraèdre de l'espace et O le centre du cercle circonscrit au triangle ABC ; E
  l'image du point D par la translation de vecteur AB⃗, F l'image de D par la translation de vecteur AC⃗ et O′
  le centre du cercle circonscrit au triangle DEF ; montrer (en utilisant une translation) que les droites
  (OO′), (AD), (BE) et (CF) sont parallèles.
- **Ex. 28** (p.144) : ABCD un tétraèdre ; M l'image de C par la translation de vecteur BA⃗, N l'image de D par
  la translation de vecteur CA⃗ et P l'image de B par la translation de vecteur DA⃗ ; montrer que les points A,
  M, N et P sont coplanaires.
- **Ex. 29** (p.144) : espace muni d'un repère (O, i⃗, j⃗, k⃗) ; les droites D : { x = 1 − α ; y = 2 + α ;
  z = −1 − α }, α ∈ ℝ, et D′ : { x = 1 + 2β ; y = 2 − 2β ; z = −1 + 2β }, β ∈ ℝ ; montrer que D′ est l'image de
  D par la translation de vecteur u⃗ = i⃗ − j⃗ + k⃗.
- **Ex. 30** (p.144) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; S la sphère dont une équation
  cartésienne est x² + y² + z² − 2x + 3y − z = 1/2 ; P le plan dont une équation cartésienne est
  x + 2y + 2z − 1 = 0. 1. montrer que P coupe S suivant un cercle dont on déterminera le centre et le rayon. 2.
  déterminer les translations qui transforment P en un plan tangent à S.
- **Ex. 31** (p.144) : A, B et C des points non alignés de l'espace ; un point M décrit une droite D strictement
  parallèle à la droite (BC) et ne contenant pas A ; déterminer le lieu géométrique du centre de gravité du
  triangle BCM, puis celui du centre de gravité du tétraèdre ABCM.
- **Ex. 32** (p.144) : ABCDEFGH un cube ; I et J les milieux respectifs des segments [EH] et [BF], P le centre
  de gravité du triangle EFH [sic] et Q le centre de gravité du triangle FBG [sic]. 1. montrer que la droite
  (BH) est perpendiculaire au plan (ACF). 2. K le milieu de [FG]. a. quelles sont les images des points I et B
  par l'homothétie de centre K et de rapport 1/3 ? b. montrer alors que la droite (PQ) est orthogonale aux
  droites (EG) et (FC).
- **Ex. 33** (p.145) : ABCDE une pyramide à base carrée de sommet A ; P le plan parallèle au plan (BCD) passant
  par G le centre de gravité de la face ABC. 1. montrer que P passe par les centres de gravité des quatre faces
  triangulaires de la pyramide. 2. un point M décrit les côtés du carré BCDE et N désigne le point d'intersection
  de la droite (AM) avec le plan P. a. déterminer le lieu géométrique Γ du point N lorsque M décrit le carré
  BCDE. b. quel est le périmètre de Γ ? c. quel est le volume de la pyramide de sommet A dont Γ est une base ?
  (Figure : pyramide.)
- **Ex. 34** (p.145) : ABCD un tétraèdre ; I le milieu de [CD] et E un point de la droite (AI) distinct de A et
  de I ; h l'homothétie de centre I qui transforme A en E. 1. le plan P passant par E et parallèle au plan (ABC)
  coupe (CD) en M ; le plan Q passant par E et parallèle au plan (ABD) coupe (CD) en N. a. montrer que h(C) = M.
  b. montrer que I est le milieu de [MN]. 2.a. montrer que les plans P et Q sont sécants suivant une droite Δ.
  b. montrer que les droites Δ et (IB) sont coplanaires.
- **Ex. 35** (p.145) : ABCDEFGH un parallélépipède ; I le centre de gravité du triangle BDE et J le centre de
  gravité du triangle CFH. 1. montrer que les plans (BDE) et (CFH) sont parallèles. 2.a. montrer que
  3AI⃗ = AB⃗ + AD⃗ + AE⃗ = AG⃗. b. montrer que J est l'image de I par une homothétie de centre A dont on précisera
  le rapport. c. en déduire que AI = IJ = JG [sic]. 3. M, N et P les milieux respectifs des segments [BD], [DE]
  et [EB] ; déterminer les images des points M, N et P par h.
- **Ex. 36** (p.145) : IABCD une pyramide de sommet I et à base carrée ; h l'homothétie de centre I et de
  rapport 2/3 et P l'image du plan (ABCD) par h. 1. montrer que P contient les centres de gravité des triangles
  IAB, IBC, ICD et IDA. 2. à tout point M sur les côtés du carré ABCD, on associe le point N intersection du plan
  P avec la droite (IM). a. déterminer l'ensemble Γ des points N lorsque M varie. b. exprimer le volume de la
  pyramide de sommet I dont la base est Γ à l'aide de celle de la pyramide IABCD.
- **Ex. 37** (p.145) : A, B et C trois points alignés de l'espace ; O le milieu de [AB] et O′ le milieu de [AC].
  1. h l'homothétie de centre A qui transforme B en C ; montrer que h transforme la sphère S de diamètre [AB] en
     la sphère S′ de diamètre [AC]. 2. une droite Δ passant par A et distincte de la droite (AB) recoupe S en M et
     recoupe la sphère S′ en N ; montrer que les droites (BM) et (CN) sont parallèles.
- **Ex. 38** (p.145–146) : ABCDEFGH un parallélépipède droit et I le point de l'espace défini par
  3IA⃗ + IB⃗ = 0⃗ ; la droite (IC) coupe la droite (AD) en O ; h l'homothétie de centre O qui transforme A en D.
  1. déterminer le rapport de h. 2. la droite (OE) perce le plan (CDH) [sic] en J ; montrer que les points D, I
     et J sont alignés [lecture peu lisible]. 3. P le plan parallèle au plan (IED) et passant par J ; montrer que la
     droite (AD) perce le plan P en un point K tel que OD² = OA.OK.
- **Ex. 39** (p.146) : ABCDEFGH un cube d'arête a et I le point tel que IB⃗ = 3IA⃗ ; h l'homothétie de centre I
  et de rapport 1/3 ; M et N les images respectives des points E et H par h. 1. déterminer l'image du plan (BCE)
  par h. 2. la droite (IC) perce le plan (AMN) en P ; montrer que IC⃗ = 3IP⃗ et que P appartient à la droite
  (AD). 3. exprimer en fonction de a le volume de la pyramide IAMNP. (Figure : cube.)
- **Ex. 40** (p.146) : espace muni d'un repère orthonormé (O, i⃗, j⃗, k⃗) ; f l'application de l'espace dans
  lui-même qui à tout point M(x, y, z) associe le point M′(x′, y′, z′) tel que { x′ = 3x − 2 ; y′ = 3y − 3 ;
  z′ = 3z − 4 }. 1. montrer que h [sic, f] est une homothétie dont on précisera le centre I et le rapport. 2.
  déterminer les coordonnées du point J image du point O par h. 3. P le plan dont une équation est
  x − y + z = 0 ; déterminer une équation du plan Q image de P par h.

### Bornes de scope observées (chapitre 15)

- ✅ INCLUS : **produit scalaire dans l'espace** (définition par le cosinus / cas nul, carré scalaire, bilinéarité
  et symétrie, expression analytique u⃗.v⃗ = xx′ + yy′ + zz′ en repère orthonormé, norme et distance de deux
  points) ; **produit vectoriel** (définition géométrique — orthogonalité, base directe, norme = AB.AC.sin(BAC) —,
  colinéarité ⇔ produit nul, antisymétrie / bilinéarité, composantes en base orthonormée directe, **produit mixte**
  (u⃗∧v⃗).w⃗ = det(u⃗, v⃗, w⃗) et permutation circulaire, **aire** d'un parallélogramme / triangle, **volume** d'un
  tétraèdre (1/6)|(BC⃗∧BD⃗).BA⃗| et d'un **parallélépipède** |(AB⃗∧AD⃗).AE⃗|) ; **droite** (représentation
  paramétrique, vecteur directeur), **plan** (défini par un point + deux vecteurs directeurs via det(AM⃗, u⃗, v⃗) = 0,
  équation cartésienne, vecteur normal, positions relatives et intersections, **distance point-plan**
  |ax₀ + by₀ + cz₀ + d|/√(a² + b² + c²)), **distance d'un point à une droite** ‖MA⃗∧u⃗‖/‖u⃗‖, **sphère** (équation
  x² + y² + z² + … = 0 ramenée à (x−a)² + (y−b)² + (z−c)² = R², plan tangent, **intersection sphère-plan** selon
  h ⋛ R : vide / point / cercle de rayon √(R²−h²)) ; **translation** de l'espace (définition, bijection réciproque
  −u⃗, propriété caractéristique M′N′⃗ = MN⃗, conservation distance / produit scalaire / parallélisme / orthogonalité /
  milieu, action sur droite / plan / sphère, invariance globale, expression analytique) ; **homothétie** de l'espace
  (définition IM′⃗ = k·IM⃗, bijection réciproque de rapport 1/k, propriété caractéristique M′N′⃗ = k·MN⃗,
  M′N′ = |k|·MN, action sur droite / plan / sphère (rayon |k|R), conservation du contact, expression analytique).
- ⛔ NON traité dans ce chapitre : les **coniques et quadriques** de l'espace (aucune surface du second degré autre
  que la sphère) ; les **isométries autres que la translation** (les rotations, réflexions et vissages de l'espace,
  ainsi que les **similitudes** de l'espace, ne sont **pas** au programme de ce chapitre) ; la **réduction générale**
  par changement de repère orthonormé (diagonalisation / rotation) ; l'**équation générale du second degré** à trois
  variables. Le chapitre suppose **acquis** le produit scalaire et le produit vectoriel **du plan** (encadrés
  « Rappel »), le **barycentre**, la **géométrie affine de l'espace** (droites, plans, coplanarité, parallélisme) et
  les **translations / homothéties du plan** — l'esprit du chapitre est le prolongement systématique à l'espace des
  outils vus dans le plan.

## 2.16 Chapitre 16 — Divisibilité dans ℤ (manuel 222446, p.147–160)

**Page de garde (p.147)** — Titre de couverture : « Divisibilité dans ℤ », Chapitre 7 (numérotation interne du
tome 2 ; c'est le chapitre 16 dans la numérotation content ; le bandeau courant écrit « Divisibilité dans ℤ »).
Encart historique : « Pascal (1654) : "[…] j'exposerai aussi une méthode générale qui permet de reconnaître, à la
simple inspection de ses chiffres, si un nombre donné est divisible par un autre nombre quelconque […]" Cet écrit
de Pascal expose une théorie de la divisibilité par un nombre quelconque A, fondée sur les restes dans les
divisions euclidiennes des puissances successives de 10 par A. Comme exemple de diviseur il choisit 7 et observe
que les restes des puissances dans les divisions euclidiennes des puissances successives de 10 par 7 se
reproduisent périodiquement, avec une période de longueur 6. » Référence : « (J Dhombres et al, Mathématiques au
fil des âges, 1987) ». Mention liminaire (p.148) : « Dans ce chapitre ℕ est l'ensemble des entiers naturels et ℤ
est l'ensemble des entiers. » Le chapitre est structuré en trois parties **I. Diviseurs et multiples d'entiers**,
**II. Division euclidienne dans ℤ**, **III. Congruence modulo n**, ponctuées d'activités, d'encadrés (définitions /
propriétés / théorèmes) et d'exercices résolus, suivies d'un QCM / Vrai-Faux, puis d'une rubrique « Exercices et
problèmes » (50 exercices). **Ce chapitre comporte 7 « exercices résolus »** intégrés au cours.

### Cours — Activités

**I. Diviseurs et multiples d'entiers** (p.148)

- **Activité 1** (p.148) : 1. Soit l'entier a = 599873120. a. déterminer l'entier p tel que a = 4p. b. en déduire
  l'entier p′ tel que −a = 4p′. 2. déterminer l'entier q tel que a = −11q. 3. existe-t-il un entier s tel que
  −a = 6s ?
- **Activité 2** (p.148) : 1. déterminer pour chacun des entiers a, l'ensemble D_a de tous ses diviseurs :
  a = −15, a = 143, a = −143, a = 1, a = −1 et a = 0. 2. soit p un nombre premier ; quels sont tous ses diviseurs ?
- **Activité 3** (p.148) : soit a et b deux entiers non nuls et c un entier. Que peut-on dire de a et b sachant
  que a divise b et b divise a ? Que peut-on dire de a et c sachant que a divise b et b divise c ?
- **Activité 4** (p.149) : 1. l'entier 4200³ + 3521¹⁰ est-il divisible par 7 ? 2. l'entier 260²⁶⁰ + 11 est-il
  divisible par −13 ? 3. l'entier 42424242424241 est-il divisible par −42 ? 4. déterminer l'ensemble des entiers n
  tels que n divise n − 6.

**Exercice résolu 1** (p.149) : « Déterminer l'ensemble des entiers n tels que n − 1 divise n + 10. » Solution
résumée : n − 1 ≠ 0 nécessairement ; l'écriture n + 10 = n − 1 + 11 prouve que n − 1 divise n + 10 ⟺ n − 1 divise
11 ⟺ n − 1 ∈ {−11, −1, 1, 11} ; il en résulte que n − 1 divise n + 10 ⟺ n ∈ {−10, 0, 2, 12}.

**II. Division euclidienne dans ℤ** (p.149)

- **Activité 1** (p.149) : en tapant « 12345 ÷ 57 = », la calculatrice affiche 216.5789474. Donner la partie
  entière de chacun des nombres 12345/57, −12345/57, 12345/−57 et −12345/−57. (Encart : « Pour tout réel x, il
  existe un entier unique n tel que n ≤ x < n + 1. Cet entier n est appelé partie entière du réel x. »)
- **Activité 2** (p.150) : calculer le quotient de a par b dans chacun des cas. 1. a = 98765123 et b = 56352. 2. a = 98765123 et b = −56352. 3. a = −98765123 et b = −56352.
- **Activité 3** (p.150) : en tapant « 12345 − 57 × 216 = », la calculatrice affiche 33. Écrire la division
  euclidienne de 12345 par 57. En utilisant une calculatrice, écrire la division euclidienne de a. 1234587 par 3547. b. 2358794 par 50111.
- **Activité 4** (p.150) : calculer le reste de a par b dans chacun des cas. 1. a = 1238745 et b = 5017. 2. a = 1238745 et b = −5017. 3. a = −1238745 et b = −5017.
- **Activité 5** (p.150) : écrire dans chacun des cas la division euclidienne de a par b. 1. a = 125498, b = 3587. 2. a = −125498, b = 3587. 3. a = 125498, b = −3587. 4. a = −2008, b = −3587.
- **Activité 6** (p.151) : 1. déterminer les restes possibles dans la division euclidienne d'un entier a par 2. 2. soit a un entier ; montrer que a et a² sont de même parité. 3. déterminer le reste de l'entier (n + 1)³ − n³
  dans la division euclidienne par 6. (Encart : « Les entiers pairs sont les entiers dont le reste dans la division
  euclidienne par 2 est égal à 0. Les entiers impairs sont les entiers dont le reste dans la division euclidienne
  par 2 est égal à 1. »)

**Exercice résolu 2** (p.149–150) : « Calculer le quotient de a par b dans chacun des cas. 1. a = 12354878 ;
b = 23458. 2. a = −12354878 ; b = 23458. 3. a = −12354878 ; b = −23458. » Solution résumée : cas 1 et 2, b > 0 :
12354878 ÷ 23458 ≈ 526.6807 ⇒ q = 526 ; −12354878 ÷ 23458 ≈ −526.6807, le plus grand entier inférieur est −527 ⇒
q = −527. Cas 3, b < 0 : −12354878 ÷ −23458 ≈ 526.6807, le plus petit entier supérieur est 527 ⇒ q = 527.

**Exercice résolu 3** (p.151) : « Déterminer l'ensemble E de tous les entiers a tels que |a| < 53 et tels que le
reste dans la division de a par 11 soit égal à 3. » Solution résumée : a ∈ E ⟺ a = 11q + 3 et |11q + 3| < 53 ⟺
a = 11q + 3 et −56 < 11q < 50 ; par suite E = {−52, −41, −30, −19, −8, 3, 14, 25, 36, 47}.

**III. Congruence modulo n** (p.151)

- **Activité 1** (p.151) : 1. soit a et b deux entiers et n un entier naturel non nul ; montrer que a et b ont le
  même reste dans la division euclidienne par n ⟺ a − b est un multiple de n. 2. montrer que pour tout entier
  naturel s, (−2)^s et (−2)^{s+1} ont le même reste dans la division euclidienne par 3.
- **Activité 2** (p.152) : vérifier que les entiers −19, −129, 124 et 13610 ont le même reste modulo 11.
- **Activité 3** (p.152) : répondre par vrai ou faux. a. 31 ≡ 3 (mod 7). b. −31 ≡ 1 (mod 5). c. −2 ≡ 2 (mod 4).
  d. 914 ≡ 21 (mod 19). e. 914 ≡ −21 (mod 47).
- **Activité 4** (p.152) : 1. soit a et b deux entiers dont les restes respectifs modulo 6 sont 2 et 3 ; montrer que
  ab est un multiple de 6. 2. soit a un entier. a. déterminer les restes possibles de a modulo 6. b. déterminer les
  restes possibles de a² modulo 6.
- **Activité 5** (p.153) : vérifier que 566 ≡ 6 (mod 7). En déduire que 566² ≡ 1 (mod 7) puis que 566^{2n} ≡ 1
  (mod 7), pour tout entier naturel n.
- **Activité 6** (p.154) : 1. déterminer le reste modulo 3 de 2008 ; en déduire le reste modulo 3 de 2008²⁰⁰⁷. 2. déterminer le reste modulo 5 de chacun des entiers 2011²⁰⁰⁷, (−2011)²⁰⁰⁷ et 2008²⁰⁰⁷.
- **Activité 7** (p.154) : montrer que pour tous entiers naturels n, p et q, 4ⁿ + 4ᵖ + 4^q ≡ 0 (mod 3).
- **Activité 8** (p.155) : déterminer tous les entiers a et b tels que ab ≡ 0 (mod 4).
- **Activité 9** (p.155) : 1. soit a un entier naturel ; montrer que 7 divise (a³ − 1)(a⁴ + a). 2. déterminer les
  entiers a tels que a^600 ≡ 1 (mod 7). (Encart — Théorème de Fermat : « Pour tout entier naturel a et tout nombre
  premier p ne divisant pas a, a^{p−1} ≡ 1 (mod p). »)

**Exercice résolu 4** (p.153) : « Déterminer les restes modulo 17 de 55348932 et de 1968755. En déduire le reste
modulo 17 de 55348932 × 1968755. » Solution résumée : 55348932 ≡ 9 (mod 17) et 1968755 ≡ 2 (mod 17) ; il en
résulte que 55348932 × 1968755 ≡ 18 (mod 17), et 18 ≡ 1 (mod 17) donne 55348932 × 1968755 ≡ 1 (mod 17).

**Exercice résolu 5** (p.153–154) : « 1.a. Discuter, suivant les valeurs de l'entier naturel k, le reste de 2^k
modulo 7. b. En déduire le reste de 247³⁴⁹ modulo 7. 2. Calculer le reste de 298³⁴⁹ modulo 13. » Solution
résumée : 2^k ≡ 1 (mod 7) si k ≡ 0 (mod 3), ≡ 2 si k ≡ 1 (mod 3), ≡ 4 si k ≡ 2 (mod 3) ; 247 ≡ 2 (mod 7) et
349 ≡ 1 (mod 3) donnent 247³⁴⁹ ≡ 2 (mod 7). 298 = 22 × 13 + 12 ⇒ 298 ≡ 12 ≡ −1 (mod 13), d'où 298³⁴⁹ ≡ −1 ≡ 12
(mod 13).

**Exercice résolu 6** (p.154) : « Déterminer tous les entiers a et b tel que ab ≡ 1 (mod 6). » Solution résumée :
en notant r et r′ les restes de a et b modulo 6, on dresse le tableau des valeurs de rr′ puis de leur reste
modulo 6 ; on conclut que ab ≡ 1 (mod 6) ⟺ (a ≡ 1 (mod 6) et b ≡ 1 (mod 6)) ou (a ≡ 5 (mod 6) et b ≡ 5 (mod 6)).
(Deux tableaux de congruence.)

**Exercice résolu 7** (p.155) : « Déterminer les restes possibles modulo 9 de a⁹ − a. » Solution résumée : les
restes possibles d'un entier a modulo 9 sont 0, 1, ..., 8 ; on écrit a⁹ = (a³)³ et l'on dresse un tableau de
congruence modulo 9 des restes de a, a³, a⁹ puis a⁹ − a. (Tableau de congruence.)

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Définition (diviseur)** (p.148, encadré) — « Soit a un entier et d un entier non nul. On dit que d est un
> diviseur de a ou que a est divisible par d, s'il existe un entier q tel que a = dq. »

> **Vocabulaire (multiple)** (p.148) — « Si un entier a est divisible par un entier d non nul, on dit que a est un
> multiple de d. »

> **Conséquence** (p.148, encadré) — « Soit d un entier non nul et a un entier. • Si d divise a alors −d divise a.
> • Les multiples de d sont les éléments de l'ensemble dℤ = {dq, q ∈ ℤ}. »

> **Propriétés** (p.148, encadré) — « Soit a et b deux entiers non nuls et c un entier. • Si a divise b et b divise
> a, alors a = b ou a = −b. • Si a divise b et b divise c, alors a divise c. • Si a divise b et a divise c, alors a
> divise αb + βc pour tous entiers α et β. »

> **Définition (quotient)** (p.149, encadré) — « Soit a et b deux entiers avec b non nul. On appelle quotient de a
> par b l'entier q défini de la manière suivante • q est le plus grand entier inférieur ou égal à a/b si b > 0,
> • q est le plus petit entier supérieur ou égal à a/b si b < 0. »

> **Définition (reste)** (p.150, encadré) — « Soit a et b deux entiers avec b non nul. On appelle reste de a par b
> l'entier r tel que r = a − bq, où q est le quotient de a par b. »

> **Théorème (division euclidienne)** (p.150, encadré) — « Pour tout entier a et pour tout entier b non nul, il
> existe un couple unique d'entiers (q, r) tel que a = bq + r et 0 ≤ r < |b|. »

> **Vocabulaire** (p.150) — « L'écriture a = bq + r, 0 ≤ r < |b| s'appelle division euclidienne de a par b, q est
> le quotient de a par b et r est le reste de a par b. »

> **Conséquence** (p.150, encadré) — « Le reste de tout entier n dans la division euclidienne par un entier non nul
> b est un élément de l'ensemble {0, 1, 2, ..., |b| − 1}. »

> **Définition et notation (congruence)** (p.151, encadré) — « Soit n un entier naturel non nul et a et b deux
> entiers. On dit que a est congru à b modulo n (ou a et b sont congrus modulo n) si a − b est un multiple de n. On
> note alors a ≡ b (mod n). »

> **Théorème et définition (reste modulo n)** (p.151, encadré) — « Soit n un entier naturel non nul. Pour tout
> entier a, il existe un unique entier r appartenant à {0, ..., n − 1} tel que a ≡ r (mod n). On dit que r est le
> reste modulo n de a. »

> **Conséquence** (p.151, encadré) — « Soit n un entier naturel non nul. Deux entiers sont congrus modulo n, si et
> seulement si, ils ont le même reste modulo n. »

> **Propriétés (réflexivité / symétrie / transitivité)** (p.152, encadré) — « Soit a, b et c trois entiers et n un
> entier naturel non nul. • a ≡ a (mod n). • Si a ≡ b (mod n) alors b ≡ a (mod n). • Si a ≡ b (mod n) et
> b ≡ c (mod n), alors a ≡ c (mod n). »

> **Propriétés (compatibilité avec les opérations)** (p.152, encadré) — « Soit a, b, c et d quatre entiers et n un
> entier naturel non nul. • Si a ≡ b (mod n) et si c ≡ d (mod n), alors a + c ≡ b + d (mod n) et
> a × c ≡ b × d (mod n). • Si a ≡ b (mod n) alors ha ≡ hb (mod n) pour tout entier h et aᵐ ≡ bᵐ (mod n) pour tout
> entier m > 0. »

> **Théorème de Fermat** (p.155, encart) — « Pour tout entier naturel a et tout nombre premier p ne divisant pas a,
> a^{p−1} ≡ 1 (mod p). »

### QCM (p.156) — « Cocher la réponse exacte. » (réponses non fournies)

1. Le quotient de −20 par 7 est (☐ −3 / ☐ −2 / ☐ 2).
2. Pour tout entier n, (☐ n³ − n ≡ 0 (mod 6) / ☐ n³ − n ≡ 0 (mod 12) / ☐ n³ − n ≡ n² (mod 6)).
3. Le nombre 100! est (☐ divisible par 2⁵⁰ / ☐ divisible par 10⁵⁰ / ☐ se termine par exactement cinq zéros).
4. Soit a un entier non nul. Si a ≡ 19 (mod 20) alors (☐ a^402 ≡ 1 (mod 20) / ☐ a^402 ≡ −1 (mod 20) /
   ☐ a^402 ≡ 19 × 402 (mod 20)).

### Vrai ou faux (p.156) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. Soit a un entier et n un entier naturel non nul. a. Si a ≡ 1 (mod n) alors a² ≡ 1 (mod n). b. Si a² ≡ 0 (mod n)
   alors a ≡ 0 (mod n). c. Si 2a ≡ 4 (mod 10) alors a ≡ 2 (mod 10).
2. Pour tout entier a et pour tout entier naturel non nul n, aⁿ ≡ a (mod n).
3. Il existe un entier b non nul tel que 5b ≡ 0 (mod 10).

### Exercices et problèmes (p.157–160) — 50 exercices

- **Ex. 1** (p.157) : déterminer pour chacun des entiers a, l'ensemble D_a de tous ses diviseurs : a = −13 ;
  a = −57 ; a = 205.
- **Ex. 2** (p.157) : le nombre −35763 est-il un multiple de 3 ? de 11 ? de 7 ?
- **Ex. 3** (p.157) : 1. déterminer l'ensemble des diviseurs de 15. 2. déterminer tous les couples d'entiers (a, b)
  tels que a² − b² = 15.
- **Ex. 4** (p.157) : déterminer tous les entiers n tels que n divise n + 5.
- **Ex. 5** (p.157) : déterminer tous les entiers n tels que n − 2 divise n − 9.
- **Ex. 6** (p.157) : soit un entier n ≥ 0. Montrer que 3^{2n} − 2ⁿ est un multiple de 7.
- **Ex. 7** (p.157) : 1. écrire la division euclidienne 3171 par 19. 2. déterminer le reste de la division
  euclidienne de 3171 par −19.
- **Ex. 8** (p.157) : déterminer le reste de la division euclidienne de −307 par −7.
- **Ex. 9** (p.157) : déterminer, dans chacun des cas, le quotient et le reste de la division de a par b.
  1. a = 1345791113 et b = 246812. 2. a = −1345791113 et b = 246812. 3. a = 1345791113 et b = −246812.
  2. a = −1345791113 et b = −246812.
- **Ex. 10** (p.157) : soit le polynôme P(x) = x⁴ − 32x³ + 186x² − 280x + 125. 1. montrer que si n est un entier
  tel que P(n) = 0, alors n divise 125. 2. résoudre dans ℝ l'équation P(x) = 0.
- **Ex. 11** (p.157) : soit deux entiers non nuls a et b. On désigne respectivement par q et r le quotient et le
  reste de la division euclidienne de a par b. Dans chacun des cas, déterminer, si possible a et b. 1. a + b = 44,
  q = 6 et r = 2. 2. a + b = −49, q = −13 et r = 11. 3. a + b = 42, q = −6 et r = 9.
- **Ex. 12** (p.157) : déterminer les restes modulo 9 de −1, 10, −10, −27 et −25.
- **Ex. 13** (p.157) : déterminer les entiers n dans chacun des cas. a. n ≡ −2 (mod 7) et −10 ≤ n ≤ 15.
  b. n ≡ 6 (mod 11) et −6 ≤ n ≤ 20.
- **Ex. 14** (p.157) : 1. soit n un entier supérieur ou égal à 1, non divisible par 3 ; montrer que n + 1 ou n − 1
  est divisible par 3. 2. soit n et p deux entiers naturels ; montrer que l'un des entiers n, p, n − p ou n + p est
  divisible par 3.
- **Ex. 15** (p.157) : soit deux entiers a et b tels que a ≡ 3 (mod 15) et b ≡ 11 (mod 15). Déterminer les restes
  modulo 15 de a + b, a − b, −a, ab, −a²b et ab².
- **Ex. 16** (p.157) : soit trois entiers a, b et c tels que a ≡ 2 (mod 17), b ≡ 4 (mod 17) et c ≡ 5 (mod 17).
  Déterminer les restes modulo 17 de a + bc et a² + b² + c².
- **Ex. 17** (p.158) : soit deux entiers a et b tels que a ≡ 5 (mod 4) et b ≡ 2 (mod 4). Déterminer le reste
  modulo 4 de 3a² + ab − 9.
- **Ex. 18** (p.158) : soit un entier a tel que a ≡ 7 (mod 11). Déterminer le reste modulo 11 de a(a + 1)(a + 2).
- **Ex. 19** (p.158) : 1. montrer que 1² + 2² + ... + n² = n(n + 1)(2n + 1)/6. 2. en déduire le reste modulo 7 de
  1² + 2² + ... + 100².
- **Ex. 20** (p.158) : déterminer le reste modulo 10 de chacun des entiers 30757, 15163 et 12924.
- **Ex. 21** (p.158) : déterminer les restes modulo 17 de 171¹⁷¹, 186¹⁸⁶, 356⁵⁸³.
- **Ex. 22** (p.158) : 1. déterminer le reste modulo 10 de −1. 2. déterminer le chiffre des unités de 9²⁰⁰⁷ et
  9²⁰⁰⁸.
- **Ex. 23** (p.158) : déterminer les restes modulo 16 de chacun des entiers 49³¹⁶, 15²⁰⁰⁸ et (−49)²³⁷.
- **Ex. 24** (p.158) : déterminer le reste modulo 13 de 4³ et de 121³⁵⁷.
- **Ex. 25** (p.158) : 1. déterminer le reste modulo 7 de 50⁹⁹. 2. déterminer le reste modulo 17 de 50⁹⁹.
- **Ex. 26** (p.158) : déterminer le reste modulo 7 de 19⁵² × 23⁴¹.
- **Ex. 27** (p.158) : 1. déterminer le reste modulo 13 de 5⁴. 2. en déduire les restes modulo 13 de chacun des
  entiers 5^{4k}, 5^{4k+1}, 5^{4k+2}, 5^{4k+3} avec k ∈ ℕ. 3. déterminer les restes modulo 13 de chacun des entiers
  5^{202020202041} et 5^{555555555555}. 4. déterminer l'ensemble des entiers naturels n, tels que
  5^{2n} + 5ⁿ ≡ 0 (mod 13).
- **Ex. 28** (p.158) : 1. déterminer les restes modulo 5 de −1 et de −2. 2. en déduire que
  1²⁰⁹⁹ + 2²⁰⁹⁹ + 3²⁰⁹⁹ + 4²⁰⁹⁹ est divisible par 5.
- **Ex. 29** (p.158) : 1. vérifier que 999 ≡ 0 (mod 27). 2.a. montrer que pour tout entier naturel n,
  10^{3n} ≡ 1 (mod 27). b. en déduire le reste modulo 27 de 10¹⁰⁰ + 100¹⁰.
- **Ex. 30** (p.158) : soit n un entier naturel. 1. montrer que 2ⁿ ≡ 1 (mod 5), si et seulement si, n est multiple
  de 4. 2. donner une condition nécessaire et suffisante sur n pour que 2ⁿ ≡ 1 (mod 11).
- **Ex. 31** (p.158) : soit n un entier. Quels sont les restes possibles modulo 5 de n² ? Quels sont les restes
  possibles modulo 7 de n³ ?
- **Ex. 32** (p.158) : résoudre dans ℤ, a. 2x ≡ 4 (mod 10). b. 4x ≡ 8 (mod 10).
- **Ex. 33** (p.158) : résoudre dans ℤ, a. x² ≡ 0 (mod 4). b. x² ≡ 2 (mod 4). c. x² ≡ 3 (mod 4).
- **Ex. 34** (p.159) : résoudre dans ℤ, a. x² ≡ 4 (mod 11). b. x² ≡ −1 (mod 11). c. x² ≡ −2 (mod 11).
- **Ex. 35** (p.159) : déterminer tous les entiers a et b tels que ab ≡ −2 (mod 8).
- **Ex. 36** (p.159) : résoudre dans ℤ, a. x² + 6x + 5 ≡ 0 (mod 7). b. x² − 4x + 3 ≡ 0 (mod 8).
- **Ex. 37** (p.159) : 1. vérifier que 10²⁰ ≡ 1 (mod 11). 2. en déduire le reste modulo 11 de 99999999999999999995.
- **Ex. 38** (p.159) : déterminer le reste modulo 103 de 10¹⁰² + 3 × 10²⁰⁴ + 106 × 10⁶¹².
- **Ex. 39** (p.159) : soit x un entier naturel. 1. vérifier que x(x⁴ − 1) ≡ 0 (mod 5) ; en déduire le reste
  modulo 5 de (x⁴ − x²)(x² + 1). 2. vérifier que x(x⁶ − 1) ≡ 0 (mod 7) ; en déduire le reste modulo 7 de
  (x⁸ − x⁵)(x³ + 1).
- **Ex. 40** (p.159) : soit p un nombre premier et a un entier naturel non divisible par p. Déterminer les restes
  modulo p de a^{p−1}, a^{p−1} − 2 et 2a^{10p−10} − 3.
- **Ex. 41** (p.159) : 1. soit un entier n ≥ 0. a. déterminer le reste modulo 111 de 1000. b. montrer que les
  restes modulo 111 de n et 1000n sont égaux. c. en déduire, sans utiliser la calculatrice, que chacun des nombres
  111111, 100010001 et 100010000001 est divisible par 111. 2. démontrer que 1001001001001 est divisible par 11111.
- **Ex. 42** (p.159) : soit n un entier naturel. Quel est le reste modulo 4 de 1ⁿ + 2ⁿ + 3ⁿ + 4ⁿ ?
- **Ex. 43** (p.159) : soit n un entier naturel. 1. déterminer pour tout entier n de {0, 1, ..., 6} le reste
  modulo 7 de 3ⁿ. 2. montrer que 3^{n+6} − 3ⁿ est divisible par 7. 3.a. calculer le reste modulo 7 de 3¹⁰⁰⁰.
  b. quel est le chiffre des unités de 3¹⁰⁰⁰ ? c. soit c la somme des diviseurs du nombre 3¹⁰⁰⁰ ; quel est le reste
  modulo 7 de c.
- **Ex. 44** (p.159) : soit a et b deux entiers. 1. vérifier que a³ ≡ a (mod 3). 2. montrer les équivalences
  ci-dessous : a³ − b³ ≡ 0 (mod 3) équivaut à a − b ≡ 0 (mod 3) ; a³ + b³ ≡ 0 (mod 3) équivaut à
  a + b ≡ 0 (mod 3) ; a³ + 2b³ ≡ 0 (mod 3) équivaut à a + 2b ≡ 0 (mod 3).
- **Ex. 45** (p.159) : soit a un entier. 1. déterminer les restes modulo 11 de a, a², a³. 2. en déduire que
  a³ − b³ ≡ 0 (mod 11), si et seulement si, a − b ≡ 0 (mod 11).
- **Ex. 46** (p.159) : soit n un entier naturel non nul. Montrer par récurrence que, a. 16ⁿ ≡ 1 − 10n (mod 25),
  b. 7ⁿ ≡ 6n + 1 (mod 36), c. 4ⁿ ≡ 3n + 1 (mod 9), d. 2ⁿ + 3ⁿ ≡ 5ⁿ (mod 6).
- **Ex. 47** (p.160) : soit un entier n ≥ 4. On se propose d'étudier les solutions entières de l'équation
  (E) : x² + 9 = 2ⁿ. On suppose que (E) possède une solution entière notée a. 1. montrer que a ≡ 1 (mod 2). 2. en
  déduire que a² + 9 ≡ 2 (mod 4). 3. montrer que (E) n'admet pas de solution.
- **Ex. 48** (p.160) : soit un entier n impair. On se propose d'étudier les solutions entières de l'équation
  (E) : x² + 9 = 3ⁿ. On suppose que (E) possède une solution entière notée a. 1. montrer que a ≡ 0 (mod 2). 2. en
  déduire que a² + 9 ≡ 1 (mod 4). 3. montrer que 3ⁿ ≡ 3 (mod 4). 4. en déduire que (E) n'admet pas de solution.
- **Ex. 49** (p.160) : les nombres de Fermat sont définis par F_n = 2^{(2ⁿ)} + 1, n ∈ ℕ. Fermat pensait qu'ils
  étaient tous premiers. En fait les cinq premiers F₀ = 3, F₁ = 5, F₂ = 17, F₃ = 257 et F₄ = 65537 sont premiers et
  le sixième F₅ ne l'est pas. On va montrer sans calculer explicitement F₅, que 641 divise F₅. 1. vérifier les
  égalités 641 = 5 × 2⁷ + 1 = 5⁴ + 2⁴. 2. montrer que 5 × 2⁷ ≡ −1 (mod 641), 5⁴ × 2²⁸ ≡ 1 (mod 641) et
  5⁴ ≡ −2⁴ (mod 641). 3. en déduire que 641 divise 2³² + 1 = F₅.
- **Ex. 50** (p.160) : soit n un entier. On désigne par f(n) la somme des chiffres de n. 1. montrer que
  n ≡ f(n) (mod 9). On pose N = 4444⁴⁴⁴⁴. 2.a. montrer que 4444 ≡ 7 (mod 9). b. écrire la division euclidienne de
  4444 par 3. c. en déduire que 4444⁴⁴⁴⁴ ≡ 7 (mod 9). d. montrer que f(f(N)) ≡ 7 (mod 9). 3.a. vérifier que
  N < (10⁴)^{5·10³}, en déduire que N ≤ 10²⁰⁰⁰⁰ puis que f(N) ≤ 180000. b. montrer que f(f(N)) ≤ 54. 4. montrer que
  f(f(f(N))) = 7.

### Bornes de scope observées (chapitre 16)

- ✅ INCLUS : **divisibilité dans ℤ** (définition d divise a ⟺ a = dq, multiples dℤ = {dq, q ∈ ℤ}, ensemble des
  diviseurs D_a, propriétés : a|b et b|a ⟺ a = ±b, transitivité, combinaisons linéaires a|αb + βc) ; **division
  euclidienne dans ℤ** (partie entière, quotient q selon le signe de b, reste r = a − bq, **théorème** d'existence
  et d'unicité du couple (q, r) avec a = bq + r et 0 ≤ r < |b|, restes ∈ {0, ..., |b| − 1}, parité) ; **congruence
  modulo n** (définition a ≡ b (mod n) ⟺ a − b multiple de n, reste modulo n unique dans {0, ..., n − 1}, congruence
  ⟺ même reste, réflexivité / symétrie / transitivité, **compatibilité avec + et ×**, ha ≡ hb et aᵐ ≡ bᵐ, tableaux
  de congruence, résolution de congruences x² ≡ c (mod n) et ax ≡ b (mod n) par balayage des restes, calcul de
  restes de grandes puissances par périodicité, chiffre des unités, critères de divisibilité et somme des chiffres
  n ≡ f(n) (mod 9)) ; **théorème de Fermat** a^{p−1} ≡ 1 (mod p) (p premier ne divisant pas a) cité en encart et
  exploité (ex. 40, act. 9) ; **nombres de Fermat** F_n = 2^{(2ⁿ)} + 1 (ex. 49).
- ⛔ NON traité dans ce chapitre : le **PGCD / PPCM**, l'**algorithme d'Euclide** et l'**identité de Bézout**
  (renvoyés au chapitre 17 « Identité de Bézout ») ; le **théorème de Gauss**, le **lemme d'Euclide** et la
  **décomposition en facteurs premiers** (les nombres premiers ne sont ici qu'évoqués via leurs diviseurs et le
  théorème de Fermat, sans étude systématique) ; les **systèmes de congruences** (théorème des restes chinois) ; la
  **structure de groupe / anneau ℤ/nℤ** (les congruences sont manipulées sans formalisation algébrique) ; les
  **équations diophantiennes** générales ax + by = c (au-delà des congruences linéaires simples résolues par
  balayage). Le chapitre suppose **acquis** les entiers naturels et relatifs, la notion de multiple, le
  raisonnement par **récurrence** (ex. 46) et l'usage de la **calculatrice** pour les divisions euclidiennes de
  grands nombres ; il constitue le socle d'arithmétique préparant directement le chapitre 17 (Bézout).

## 2.17 Chapitre 17 — Identité de Bézout (manuel 222446, p.161–178)

**Page de garde (p.161)** — Titre de couverture : « Identité de Bezout » [sic, sans accent], Chapitre 8 (numérotation
interne du tome 2 ; c'est le chapitre 17 dans la numérotation content ; le bandeau courant écrit « Identité de
Bezout »). Encart historique intitulé « Cryptographie à clé publique (Rivest et al, 1978) » : « Il s'agit d'un
système permettant à tous les membres d'un réseau de coder leurs messages. Seul le chef du réseau qui a fourni la
clé du codage possède la clé du décodage de tous les messages. Le principe est le suivant : - le chef du réseau
choisit deux grands nombres premiers p et q ; - il calcule n = pq et φ(n) = (p−1)(q−1) ; - il choisit un entier
naturel d inférieur à φ(n) et premier à φ(n) ; - il détermine un entier naturel e tel que d.e ≡ 1 (mod n) ; - il
diffuse aux membres du réseau les nombres n et e, tout en gardant secrets les nombres p, q, φ(n) et d. Le codage
s'effectue de la manière suivante : - le message est traduit en nombres N inférieurs à n ; - chacun de ces nombres
N est remplacé par un nombre C défini par C ≡ Nᵉ (mod n), c'est ce nombre codé qui est transmis. Pour procéder au
décodage, c'est à dire obtenir N à partir de C, il suffit de calculer Cᵈ. En effet, d'après le petit théorème de
Fermat Cᵈ ≡ Nᵉᵈ ≡ N^{1+φ(n)} ≡ N (mod n). Ce décodage nécessite la connaissance de d donc de φ(n). Si l'on connaît
φ(n), on procède à la recherche du PGCD de φ(n) et e en utilisant l'algorithme d'Euclide et on écrit les restes
successifs en utilisant φ(n) et e. On aboutit alors à une Identité de Bezout de la forme d.e + kφ(n) = 1, k un
entier. » Référence : « (J-L Chabert et al, Histoire d'algorithmes, 1993) ». Mention liminaire (p.162) : « Dans ce
chapitre on désigne par ℕ l'ensemble des entiers naturels et par ℤ l'ensemble des entiers. » Le chapitre est
structuré en six parties **I. PGCD de deux entiers**, **II. Entiers premiers entre eux**, **III. PPCM de deux
entiers**, **IV. Inverses modulo b**, **V. Identité de Bezout**, **VI. Exemples d'équations de la forme ax + by = c
; a, b et c entiers**, ponctuées d'activités, d'encadrés (définitions / propriétés / théorèmes) et d'exercices
résolus, suivies d'un QCM / Vrai-Faux, puis d'une rubrique « Exercices et problèmes » (31 exercices). **Ce chapitre
comporte 5 « exercices résolus » et 1 « problème résolu »** intégrés au cours. Notation du manuel : a ∧ b désigne le
PGCD, a ∨ b désigne le PPCM.

### Cours — Activités

**I. PGCD de deux entiers** (p.162)

- **Activité 1** (p.162) : déterminer a ∧ b dans chacun des cas suivants. 1. a = 465 ; b = 225. 2. a = 196 ;
  b = 116. 3. a = 144 ; b = 388. (Encart rappel : « On rappelle que si a et b sont deux entiers naturels non nuls
  alors leur plus grand commun diviseur est l'entier naturel a ∧ b, tel que a ∧ b divise a et b et tout diviseur
  commun à a et b divise a ∧ b. »)
- **Activité 2** (p.162) : « Dans cette activité nous nous proposons d'utiliser l'algorithme d'Euclide pour
  déterminer le plus grand diviseur commun de deux entiers naturels a et b. » 1. recherche de 4851 ∧ 616 : les
  divisions successives 4851 = 616 × 7 + 539 ; 616 = 539 × 1 + 77 ; 539 = 77 × 7 + 0 donnent, le dernier reste non
  nul étant 77, 4851 ∧ 616 = 77. 2. utiliser l'algorithme d'Euclide pour déterminer a ∧ b : 1. 19625 ∧ 1155. 2. 17680 ∧ 4960. 3. 30870 ∧ 15750. (Encart : « Le plus grand diviseur commun de deux entiers naturels a et b est
  le dernier reste non nul dans la succession des divisions euclidiennes de l'algorithme d'Euclide de a et b. »)
- **Activité 3** (p.162–163) : déterminer le PGCD de deux entiers en utilisant la calculatrice. 1. recherche de
  2003 ∧ 365 : en tapant « 2003 ab/c 365 = », la calculatrice affiche 5 ⌐ 178 ⌐ 365, soit 2003/365 = 5 + 178/365
  avec 178/365 irréductible, donc 365 ∧ 178 = 1 ; la division euclidienne 2003 = 365 × 5 + 178 donne
  2003 ∧ 365 = 365 ∧ 178 = 1. 2. recherche de 4010 ∧ 365 : la calculatrice affiche 10 ⌐ 72 ⌐ 73, soit
  4010/365 = 10 + 72/73 avec 72 ∧ 73 = 1 ; la division 4010 = 365 × 10 + 360 donne
  4010 ∧ 365 = 365 ∧ 360 = 5(73 ∧ 72) = 5. 3. utiliser la calculatrice pour déterminer a ∧ b : a = 8623 et
  b = 1155 ; a = 19662 et b = 865 ; a = 4830 et b = 3122.
- **Activité 4** (p.163) : soit a et b deux entiers naturels non nuls et d un entier non nul, diviseur commun de
  7a + 9b et 3a + 4b. 1. montrer que d est un diviseur commun de 21a + 27b et 21a + 28b. En déduire que d divise b. 2. montrer que d divise a. 3. montrer que (7a + 9b) ∧ (3a + 4b) = a ∧ b.
- **Activité 5** (p.163) : soit a et b deux entiers non nuls et d un entier. Montrer que d divise a et b, si et
  seulement si, d divise |a| et |b|.
- **Activité 6** (p.163) : en utilisant la calculatrice, déterminer a ∧ b dans chacun des cas ci-dessous.
  1. a = 462 ; b = −1155. 2. a = −196625 ; b = 654.
- **Activité 7** (p.164) : 1. à l'aide de la calculatrice, déterminer le quotient et le reste de −2921 par 18. 2. existe-t-il deux entiers a et b tels que a − b = −2921 et a ∧ b = 18 ?

**II. Entiers premiers entre eux** (p.164)

- **Activité 1** (p.164) : soit n un entier et d un entier naturel non nul. 1. montrer que si d est un diviseur
  commun de n + 1 et n + 9, alors d divise 8. 2. en déduire que si n est pair alors (n + 1) et (n + 9) sont premiers
  entre eux.
- **Activité 2** (p.164) : déterminer dans chaque cas les entiers premiers entre eux a′ et b′ tels que
  a = (a ∧ b).a′ et b = (a ∧ b).b′. 1. a = −60 et b = 84. 2. a = 77 et b = −150. 3. a = −240 et b = −150.
- **Activité 3** (p.165) : pour tout entier n, on pose a = n − 2 et b = 3n + 1. Déterminer a ∧ b, suivant les valeurs
  de n.
- **Activité 4** (p.165) : soit a et b deux entiers non nuls tels que a ∧ b = 1 et soit c un entier non nul.
  1. justifier que ac ∧ bc = |c|. 2. montrer que si a divise bc alors a divise c.
- **Activité 5** (p.165) : on se propose de résoudre dans ℤ × ℤ l'équation (E) : 43x + 71y = 0. 1. montrer que si
  (a, b) est solution de (E) alors 43 divise b et 71 divise a. 2. en déduire l'ensemble des solutions de (E).
- **Activité 6** (p.166) : résoudre dans ℤ × ℤ les équations ci-dessous. a. 13x + 9y = 0. b. 20x = 17y.
  c. 21x + 35y = 0.
- **Activité 7** (p.167) : 1. donner une condition nécessaire et suffisante pour qu'un entier soit divisible par 187. 2. un entier qui est divisible par 2 et par 28 est-il nécessairement divisible par 56 ? 3. soit a et b deux entiers
  naturels non nuls et premiers entre eux. Montrer que si a divise n et b divise n alors ab divise n.
- **Activité 8** (p.167) : déterminer les restes respectifs modulo 13 et modulo 17 de 129286. En déduire le reste
  modulo 221 de 129286.

**III. PPCM de deux entiers** (p.167)

- **Activité 1** (p.167) : soit a et b deux entiers non nuls, d = a ∧ b et a′ et b′ les entiers tels que
  a′ ∧ b′ = 1, a = da′ et b = db′. On pose m = d|a′b′|. 1. vérifier que m est un multiple commun à a et à b et que
  tout multiple commun à a et b est un multiple de m. 2. en déduire que m est le plus petit multiple commun
  strictement positif de a et b.
- **Activité 2** (p.168) : déterminer a ∧ b dans chacun des cas. En déduire a ∨ b. 1. a = 495 et b = 2541. 2. a = −24 et b = −56. 3. a = 123 et b = −82.
- **Activité 3** (p.168) : résoudre dans ℤ × ℤ les systèmes ci-dessous. S : {ab = −1176, a ∨ b = 84}. S′ :
  {ab = 168, a ∨ b = 24}.
- **Activité 4** (p.168) : soit a un entier non nul et aℤ l'ensemble de tous les multiples de a. 1. déterminer 2ℤ. 2. déterminer les ensembles E, F et G définis par E = {n ∈ 6ℤ et |n| < 31}, F = {n ∈ −5ℤ et |n| < 31} et G
  intersection de E et F.
- **Activité 5** (p.168) : 1.a. montrer que si a ≡ 0 (mod 8) et a ≡ 0 (mod 12), alors a ≡ 0 (mod 24). b. la
  réciproque est-elle vraie ? 2. déterminer les entiers a vérifiant {a ≡ 1 (mod 8), a ≡ 1 (mod 12), |a| ≤ 225}.

**IV. Inverses modulo b** (p.168)

- **Activité 1** (p.168) : 1. soit u un entier. a. déterminer à l'aide d'un tableau de congruence les restes
  possibles de 6u modulo 9. b. existe-t-il un entier u tel que 6u ≡ 1 (mod 9) ? 2. déterminer un entier u tel que
  34u ≡ 1 (mod 7).

**V. Identité de Bezout** (p.170)

- **Activité 1** (p.170) : 1.a. déterminer un inverse de 25 modulo 13. b. en déduire deux entiers u et v tels que
  25u + 13v = 1. 2. déterminer deux entiers u et v tels que 27u + 10v = 1. 3. déterminer, dans chacun des cas
  suivants, deux entiers u et v tels que au + bv = 1. a = 9 et b = 14 ; a = 9 et b = 8.
- **Activité 2** (p.171) : 1. vérifier que 11413 et 191 sont premiers entre eux. 2. utiliser le procédé de l'exercice
  précédent pour déterminer deux entiers u et v tels que 11413u + 191v = 1.

**VI. Exemples d'équations de la forme ax + by = c ; a, b et c entiers** (p.171)

- **Activité 1** (p.171) : soit a, b et c trois entiers et d = a ∧ b. On considère dans ℤ × ℤ l'équation
  (E) : ax + by = c. 1. montrer que si d ne divise pas c alors (E) n'admet pas de solution dans ℤ × ℤ. 2. montrer que
  si d divise c alors (E) admet des solutions dans ℤ × ℤ.
- **Activité 2** (p.171–172) : on se propose de résoudre dans ℤ × ℤ l'équation (E) : 2x + 3y = 1. 1. déterminer une
  solution particulière (x₀, y₀) de (E). 2.a. vérifier que (x, y) est solution de (E), si et seulement si,
  2(x − x₀) + 3(y − y₀) = 0. b. en déduire les solutions de (E). 3. soit l'équation (E₁) : 2x + 3y = 5. Montrer que
  (5x₀, 5y₀) est une solution particulière de (E₁). Donner alors les solutions de (E₁).
- **Activité 3** (p.172) : 1. résoudre dans ℤ × ℤ l'équation 7x + 11y = 1. 2. en déduire l'ensemble des solutions de
  chacune des équations suivantes. a. 7x + 11y = 2. b. 7x + 11y = −5. c. 7x − 11y = −5.
- **Activité 4** (p.172) : résoudre dans ℤ × ℤ l'équation 35x − 14y = 7.
- **Activité 5** (p.172) : on considère dans ℤ × ℤ l'équation (E) : 46x + 115y = a où a est un entier non nul.
  1.a. déterminer 46 ∧ 115. b. déterminer une condition nécessaire et suffisante sur a pour que l'équation (E)
  admette au moins une solution. 2. résoudre dans ℤ × ℤ l'équation (E), dans chacun des cas ci-dessous. • a = 23.
  • a = 230. • a = 15.
- **Activité 6** (p.172) : 1. résoudre dans ℤ × ℤ les équations 5x + 3y = 1 et 5x − 3y = 1. 2. en déduire les
  solutions entières de l'équation 25x² − 9y² = 7.

**Exercice résolu 1** (p.165) : « Pour tout entier n, on pose a = 2n + 5 et b = n − 3. 1. Montrer que tout diviseur
commun de a et b est un diviseur de 11. 2. En déduire, suivant les valeurs de n, la valeur de a ∧ b. 3. Application :
Déterminer a ∧ b lorsque a = 2 × 12³¹²⁰ + 5 et b = 12³¹²⁰ − 3. » Solution résumée : 1. tout diviseur d de a et b
divise a − 2b = 11. 2. a ∧ b ∈ {−11, −1, 1, 11}, donc a ∧ b = 11 ou 1 ; n − 3 ≡ 0 (mod 11) ⟺ n ≡ 3 (mod 11), et dans
ce cas 2n + 5 ≡ 0 (mod 11) ; d'où a ∧ b = 11 ⟺ n ≡ 3 (mod 11), et a ∧ b = 1 sinon. 3. a et b sont de la forme 2n + 5
et n − 3 avec n = 12³¹²⁰ ; comme 12 ≡ 1 (mod 11), 12³¹²⁰ ≡ 1 (mod 11), donc n n'est pas ≡ 3 (mod 11) et
(2 × 12³¹²⁰ + 5) ∧ (12³¹²⁰ − 3) = 1.

**Exercice résolu 2** (p.166) : « Soit a et b deux entiers naturels non nuls tels que a ∧ b = 1. 1. Montrer que a + b
et ab sont premiers entre eux. 2. Montrer que a + b et a² − ab + b² sont soit premiers entre eux, soit divisibles
par 3. » Solution résumée : 1. tout diviseur premier p de ab divise a ou b (pas les deux, car a ∧ b = 1) et ne divise
donc pas a + b ; il en résulte (a + b) ∧ ab = 1. 2. (a + b)² − (a² − ab + b²) = 3ab, donc tout diviseur commun d de
a + b et a² − ab + b² divise 3ab ; a + b et ab étant premiers entre eux, le lemme de Gauss donne d divise 3, soit
d = 1 ou d = 3.

**Exercice résolu 3** (p.166–167) : « On se propose de résoudre dans ℤ × ℤ l'équation (E) : 2x ≡ 12y (mod 10).

1. Montrer que si 2x ≡ 12y (mod 10) alors x − y ≡ 0 (mod 5). 2.a. Résoudre dans ℤ × ℤ l'équation x ≡ y (mod 5).
   b. En déduire les solutions de 2x ≡ 12y (mod 10). » Solution résumée : (x, y) solution ⟺ 2(x − 6y) divisible par 10
   ⟺ 5 divise x − 6y ⟺ 5 divise x − y (car x − 6y = x − y − 5y) ; les solutions de x ≡ y (mod 5) sont les couples
   (x, x + 5k), x ∈ ℤ, k ∈ ℤ ; on vérifie que tout couple de cette forme est solution de (E), donc
   2x ≡ 12y (mod 10) ⟺ (x, y) = (x, x + 5k), x ∈ ℤ et k ∈ ℤ.

**Exercice résolu 4** (p.169) : « 1. Déterminer un inverse de 4 modulo 13. 2. Résoudre dans ℤ l'équation
4x ≡ 1 (mod 13). 3. En déduire les solutions dans ℤ de 43x ≡ 1 (mod 13). » Solution résumée : 4 et 13 premiers entre
eux ⇒ il existe u₀ ∈ {0, 1, ..., 12} tel que 4u₀ ≡ 1 (mod 13) ; la division 40 = 3 × 13 + 1 donne u₀ = 10. Les
solutions de 4x ≡ 1 (mod 13) sont x = 10 + 13k, k ∈ ℤ. Comme 43 ≡ 4 (mod 13), 43x ≡ 1 (mod 13) ⟺ 4x ≡ 1 (mod 13),
d'où les solutions x = 10 + 13k, k ∈ ℤ.

**Exercice résolu 5** (p.170–171) : « 1. Montrer que les entiers 22826 et 537 sont premiers entre eux. 2. Trouver
deux entiers u et v tels que 22826u + 537v = 1. » Solution résumée : la calculatrice donne 22826 ∧ 537 = 272 ∧ 537 = 1.
On écrit les divisions euclidiennes successives jusqu'à obtenir un reste nul (tableau des restes r : 22826, 537, 272,
265, 7, 6, 1, 0 et des quotients q : 42, 1, 1, 37, 1, 6), puis on complète un tableau en respectant la loi
(α, β) ↦ (qβ + α) ; les deux dernières colonnes donnent 22826 × 77 − 3273 × 537 = 1 (donc u = 77 et v = −3273).

**Problème résolu** (p.172–173) : « Dans le plan muni d'un repère orthonormé (O, i⃗, j⃗), on considère les points
A(7, 12), B(7, 0) et C(0, 12). 1.a. Déterminer les points de coordonnées entières qui appartiennent à la droite (OA).
b. En déduire les points de coordonnées entières qui appartiennent au segment [OA]. 2.a. Résoudre dans ℤ × ℤ les
équations 12x − 7y = 1 et 12x − 7y = −1. b. Montrer qu'à l'intérieur du rectangle ABOC il existe deux points I et J
de coordonnées entières et tels que la distance de chacun d'entre eux à la droite soit minimale. 3. Vérifier que le
quadrilatère OIAJ est un parallélogramme et calculer son aire. » Solution résumée : (OA) a pour équation
12x − 7y = 0 ; 12 et 7 étant premiers entre eux, les points entiers de (OA) sont les couples (7k, 12k), k ∈ ℤ, et sur
[OA] seuls O(0, 0) et A(7, 12). L'égalité 12 × 3 − 7 × 5 = 1 donne (3, 5) solution particulière de 12x − 7y = 1, dont
les solutions sont (7k + 3, 12k + 5), k ∈ ℤ ; celles de 12x − 7y = −1 sont (7k′ − 3, 12k′ − 5), k′ ∈ ℤ. La distance
d(M, (OA)) = |12x − 7y|/√193 est minimale quand |12x − 7y| = 1 ; les seuls points entiers intérieurs qui répondent
sont I(3, 5) et J(4, 7). Le milieu S de [OA] a pour coordonnées (7/2, 6) et est aussi milieu de [IJ], donc OIAJ est
un parallélogramme ; son aire 𝒜 = 2𝒜′ = OA × d(I, (OA)) = √193 × 1/√193 = 1. **(Figure p.173 : droite (OA), points A,
C, I, J et rectangle ABOC dans un repère.)**

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Théorème et définition (PGCD)** (p.163, encadré) — « Si a et b sont deux entiers non nuls, alors il existe un
> unique entier naturel d qui vérifie les deux conditions suivantes : 1. d divise a et d divise b, 2. Si un entier k
> divise a et b alors il divise d. L'entier d défini plus haut est noté a ∧ b et appelé le plus grand commun diviseur
> de a et b. »

> **Conséquences** (p.163, encadré) — « Pour tous entiers a et b non nuls, a ∧ b > 0. Pour tous entiers a et b non
> nuls, a ∧ b = |a| ∧ |b|. »

> **Propriétés** (p.164, encadré) — « Soit a et b deux entiers non nuls. • Si b divise a alors a ∧ b = |b|. • Si b ne
> divise pas a et si r est le reste modulo b de a alors a ∧ b = b ∧ r. • a ∧ b = b ∧ a. • Pour tout entier non nul k,
> ka ∧ kb = |k|(a ∧ b). • a ∧ (b ∧ c) = (a ∧ b) ∧ c. »

> **Définition (entiers premiers entre eux)** (p.164, encadré) — « Deux entiers non nuls a et b sont dits premiers
> entre eux, si a ∧ b = 1. »

> **Théorème** (p.164, encadré) — « Soit a et b deux entiers non nuls. Alors il existe un unique couple d'entiers
> (a′, b′) tel que a = (a ∧ b)a′, b = (a ∧ b)b′ et a′ ∧ b′ = 1. »

> **Lemme de Gauss** (p.165, encadré) — « Soit a, b et c trois entiers non nuls. Si a ∧ b = 1 et a divise bc alors a
> divise c. »

> **Théorème** (p.167, encadré) — « Soit a et b deux entiers naturels non nuls et n un entier. Si a ∧ b = 1,
> n ≡ 0 (mod a) et n ≡ 0 (mod b) alors n ≡ 0 (mod ab). »

> **Théorème et définition (PPCM)** (p.167, encadré) — « Pour tous entiers a et b non nuls il existe un unique entier
> m strictement positif qui vérifie les deux conditions suivantes. • m est un multiple de a et b, • tout multiple
> commun de a et b est un multiple de m. L'entier m ainsi défini est le plus petit commun multiple de a et b et est
> noté a ∨ b. »

> **Conséquences (PPCM)** (p.167, encadré) — « • Pour tous entiers a et b non nuls, a ∨ b = |a| ∨ |b|. • Pour tous
> entiers a et b non nuls, (a ∨ b) × (a ∧ b) = |ab|. »

> **Propriétés (PPCM)** (p.168, encadré) — « Soit a et b deux entiers non nuls. • Si b divise a alors a ∨ b = |a|.
> • Pour tout entier non nul k, ka ∨ kb = |k|(a ∨ b). • a ∨ b = b ∨ a. • a ∨ (b ∨ c) = (a ∨ b) ∨ c. »

> **Théorème (inverse modulo b)** (p.169, encadré) — « Soit a et b deux entiers naturels non nuls tels que b ≥ 2 et
> a ∧ b = 1. Alors il existe un unique entier non nul u appartenant à {0, 1, ..., b − 1} tel que au ≡ 1 (mod b). On
> dit que u est un inverse de a modulo b. »

> **Théorème (Identité de Bezout)** (p.170, encadré) — « Deux entiers non nuls a et b sont premiers entre eux, si et
> seulement si, il existe deux entiers u et v tels que au + bv = 1. »

> **Corollaire** (p.170, encadré) — « Soit a et b deux entiers non nuls et d = a ∧ b. Alors il existe deux entiers u
> et v tels que au + bv = d. »

> **Théorème (équations ax + by = c)** (p.171, encadré) — « Soit a, b et c trois entiers et d = a ∧ b. L'équation
> ax + by = c admet des solutions dans ℤ × ℤ, si et seulement si, d divise c. »

### QCM (p.174) — « Cocher la réponse exacte. » (réponses non fournies)

1. L'entier 5 est un inverse modulo 6 de (☐ 5 / ☐ −5 / ☐ 1).
2. Soit p un nombre premier. (☐ p ∧ p² = 1 / ☐ p ∧ p² = p / ☐ p ∧ p² = p²).
3. L'ensemble des solutions entières de l'équation 11x − 5y = 1 est (☐ {(1 + 5k, 2 + 11k), k ∈ ℤ} /
   ☐ {(1 + 11k, 2 + 5k), k ∈ ℤ} / ☐ {(2 + 5k, 1 + 11k), k ∈ ℤ}).
4. L'ensemble des solutions entières de l'équation 13x − 17y = 0 est (☐ {(17k, 13k), k ∈ ℤ} /
   ☐ {(13k, 17k), k ∈ ℤ} / ☐ {(17 + 13k, 13 + 17k), k ∈ ℤ}).

### Vrai ou faux (p.174) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. Soit n un entier. n ≡ 0 (mod 143), si et seulement si, n ≡ 0 (mod 13) et n ≡ 0 (mod 11).
2. Pour tous entiers a et b, a. −3a ∧ 3b = 3(a ∧ b). b. Si a ∧ b = a ∨ b alors a = b.
3. L'équation 25x − 80y = 3 admet des solutions entières.
4. Tout entier admet un inverse modulo 14.
5. Pour tout entier n ≥ 2, (n − 1) est son propre inverse modulo n.

### Exercices et problèmes (p.175–178) — 31 exercices

- **Ex. 1** (p.175) : déterminer a ∧ b dans chacun des cas ci-dessous. 1. a = 558 et b = −1235. 2. a = 924 et
  b = 990. 3. a = −999 et b = 888. 4. a = 1890 et b = −5250.
- **Ex. 2** (p.175) : calculer a ∧ b et a ∨ b dans chacun des cas ci-dessous. 1. a = 588 et b = −1235. 2. a = 51 et
  b = −255. 3. a = 2n + 1 et b = n, où n est un entier non nul.
- **Ex. 3** (p.175) : trouver les valeurs possibles de l'entier a sachant que a ∧ 180 = 36 et |a| < 360.
- **Ex. 4** (p.175) : trouver tous les couples (a, b) d'entiers non nuls tels que a ∧ b = 19 et ab = 2166.
- **Ex. 5** (p.175) : montrer qu'il n'existe aucun couple (a, b) d'entiers tels que a ∧ b = 19 et a² − b² = 490.
- **Ex. 6** (p.175) : 1. montrer que 2⁵ ≡ −1 (mod 11) et 2⁵ ≡ 1 (mod 31). 2. en déduire les congruences
  2³⁴⁰ ≡ 1 (mod 11) et 2³⁴⁰ ≡ 1 (mod 31). 3. montrer que 341 divise 2³⁴⁰ − 1.
- **Ex. 7** (p.175) : la décomposition de 561 en facteurs premiers est 561 = 3 × 11 × 17. Soit a un entier premier
  avec 561. 1. vérifier que a est premier avec chacun des entiers 3, 11 et 17. 2. montrer que a. 3 divise a² − 1.
  b. 11 divise a¹⁰ − 1. c. 17 divise a¹⁶ − 1. 3. en déduire les congruences a⁵⁶⁰ ≡ 1 (mod 3), a⁵⁶⁰ ≡ 1 (mod 11) et
  a⁵⁶⁰ ≡ 1 (mod 17). 3. montrer que 561 divise a⁵⁶⁰ − 1. [sic — la dernière question est numérotée « 3 » alors qu'il
  s'agirait de la question 4]
- **Ex. 8** (p.175) : soit a, b et d trois entiers non nuls tels que a ∧ b = d. 1. montrer que si un entier n divise
  4a + 5b et 5a + 2b alors n divise 17a et 17b. 2. en déduire que (4a + 5b) ∧ (5a + 2b) = d ou
  (4a + 5b) ∧ (5a + 2b) = 17d.
- **Ex. 9** (p.175) : soit a, b et n trois entiers non nuls. 1. montrer que si d divise a et b alors d divise a + bn
  et a + b(n − 1). 2. montrer que si d divise a + bn et a + b(n − 1) alors d divise a et b. 3. en déduire que
  a ∧ b = (a + bn) ∧ (a + b(n − 1)).
- **Ex. 10** (p.175) : 1.a. donner une solution particulière de 5x ≡ 1 (mod 17). b. en déduire les solutions dans ℤ
  de 5x ≡ 1 (mod 17). c. donner les solutions dans ℤ de 345x ≡ 1 (mod 17). 2.a. résoudre dans ℤ 5x ≡ 2 (mod 17).
  b. donner les solutions dans ℤ de 430x ≡ 2 (mod 17).
- **Ex. 11** (p.175) : résoudre dans ℤ a. 17x ≡ 1 (mod 33). b. 17x ≡ −9 (mod 33).
- **Ex. 12** (p.175) : déterminer l'ensemble des couples (x, y) tels que 12x ≡ 30y (mod 15).
- **Ex. 13** (p.176) : déterminer l'ensemble des couples (x, y) tels que 11x ≡ 99y (mod 77).
- **Ex. 14** (p.176) : 1. vérifier que 2015 ∧ 2007 = 1. 2. déterminer deux entiers a et b tels que
  2007a + 2015b = 1.
- **Ex. 15** (p.176) : 1. vérifier que 391 ∧ 323 = 17. 2. déterminer deux entiers a et b tels que 391a − 323b = 17. 3. en déduire une solution de 391a − 323b = 204.
- **Ex. 16** (p.176) : 1. résoudre dans ℤ × ℤ l'équation 97x + 11y = 1. 2. soit l'équation (E) : 97x + 77y = 7.
  a. donner une solution particulière de (E). b. résoudre dans ℤ × ℤ l'équation (E).
- **Ex. 17** (p.176) : on pose u = 2 + √3. 1.a. montrer par récurrence que, pour tout entier naturel n ≥ 1,
  uⁿ = aₙ + bₙ√3, où aₙ et bₙ sont des entiers naturels. b. exprimer aₙ₊₁ et bₙ₊₁ à l'aide de aₙ et bₙ. 2.a. montrer
  que aₙ² − 3bₙ² = 1 et aₙbₙ₊₁ − aₙ₊₁bₙ = 1. b. en déduire que aₙ ∧ bₙ = aₙ₊₁ ∧ aₙ = bₙ₊₁ ∧ bₙ = 1.
- **Ex. 18** (p.176) : résoudre dans ℤ × ℤ chacune des équations suivantes. a. 7x − 14y = 5. b. 5x − 10y = 10.
  c. 29x + 58y = 3.
- **Ex. 19** (p.176) : résoudre dans ℤ × ℤ chacune des équations suivantes. a. (4x − 3y − 5)(4x + 3y − 1) = 0.
  b. x² − 9y² = 2.
- **Ex. 20** (p.176–177) : 1. résoudre dans ℤ × ℤ l'équation (E) : 13x − 8y = 1. 2. on considère les triplets
  (x, y, z) de ℤ × ℤ × ℤ vérifiant le système S : {5x + y − 2z = 1, 8x − 9y + 2z = 0}. Montrer que si (x, y, z) est
  solution de S alors (x, y) est solution de (E). Résoudre S dans ℤ × ℤ × ℤ.
- **Ex. 21** (p.176) : 1. déterminer deux entiers u et v tels que 9u − 11v = 1. 2. soit a, b et x trois entiers.
  Montrer que si x ≡ a (mod 9) et x ≡ b (mod 11), alors x ≡ 45b − 44a (mod 99). 3. résoudre dans ℤ le système
  {x ≡ 6 (mod 9), x ≡ 8 (mod 11)}.
- **Ex. 22** (p.176) : pour tout entier n, on considère les nombres a = 2n − 3 et b = 3n − 1. 1. quelles sont les
  valeurs possibles de a ∧ b ? 2.a. vérifier que pour tout n, le couple (a, b) est solution de l'équation
  (E) : 3x − 2y = −7. b. résoudre dans ℤ × ℤ l'équation (E). 3. déterminer l'ensemble des entiers n tels que
  a ∧ b = 7.
- **Ex. 23** (p.176) : soit p, q et u trois nombres premiers. On pose n = pqu et on suppose que p − 1, q − 1 et u − 1
  divisent n − 1. Soit a un entier premier avec n. 1. montrer que a^{p−1} ≡ 1 (mod p), a^{q−1} ≡ 1 (mod q) et
  a^{u−1} ≡ 1 (mod u). En déduire les congruences a^{n−1} ≡ 1 (mod p), a^{n−1} ≡ 1 (mod q) et a^{n−1} ≡ 1 (mod u). 2. montrer que a^{n−1} ≡ 1 (mod n). 3. décomposer 561 en produit de facteurs premiers et montrer que
  224⁵⁶⁰ ≡ 1 (mod 561). 4. montrer que 561¹⁷²⁸ ≡ 1 (mod 1729).
- **Ex. 24** (p.177) : 1. soit a et b des entiers naturels non nuls tels que (a + b) ∧ ab = p, où p est nombre
  premier. a. montrer que p est un diviseur commun de a et b. b. montrer que a ∧ b = p. 2. on désigne par a et b deux
  entiers naturels tels que a ≤ b. a. résoudre le système {a ∧ b = 5, a ∨ b = 170}. b. en déduire les solutions du
  système {(a + b) ∧ ab = 5, a ∨ b = 170}.
- **Ex. 25** (p.177) : on désigne par x et y deux entiers naturels non nuls tels que x < y. Soit S l'ensemble des
  couples (x, y) tels que x ∧ y = y − x. 1. calculer 363 ∧ 484. Le couple (363, 484) appartient-il à S ? 2. soit n un
  entier naturel non nul. Le couple (n, n + 1) appartient-il à S ? 3.a. montrer que (x, y) appartient à S, si et
  seulement si, il existe un entier naturel k non nul tel que x = k(y − x) et y = (k + 1)(y − x). b. en déduire que
  pour tout couple (x, y) de S, x ∨ y = k(k + 1)(y − x). 4.a. déterminer l'ensemble des entiers naturels diviseurs de 228. b. en déduire l'ensemble des couples (x, y) de S tels que x ∨ y = 228.
- **Ex. 26** (p.177) : le plan est rapporté à un repère orthonormé direct (O, u⃗, v⃗). On considère l'application f qui
  au point M d'affixe z associe le point M′ d'affixe z′ tel que z′ = ((3 + 4i)/5)z̄ + (1 − 2i)/5. 1.a. déterminer
  l'ensemble des points invariants par f. b. quelle est la nature de f ? 2.a. déterminer l'ensemble D des points M
  d'affixe z tels que z′ soit réel. b. résoudre dans ℤ × ℤ l'équation 4x − 3y = 2. c. en déduire les points de D dont
  les coordonnées sont entières. 3. on considère les points M d'affixe z = 1 + iy, où y ∈ ℤ. Déterminer les entiers y
  tels que Re(z′) et Im(z′) soient entiers.
- **Ex. 27** (p.177) : soit a et b deux entiers. 1. montrer que si (a² + ab − b²)² = 1 alors a et b sont premiers
  entre eux. On considère l'équation (E) : (x² + xy − y²)² = 1. 2. déterminer les solutions entières de (E) telles que
  x = y. 3. soit (p, q) une solution de (E). a. montrer que (q, p + q) est une solution de (E). b. en déduire que
  (p + q, p + 2q) est une solution de (E). c. donner six solutions de (E).
- **Ex. 28** (p.177) : le but de l'exercice est déterminer l'ensemble E des triplets (x, y, z) de ℕ* × ℕ* × ℕ* tels
  que x² + y² = z². 1. montrer que pour tout couple (a, b) d'entiers naturels non nuls tels que a > b,
  (a² − b², 2ab, a² + b²) est un élément de E. 2. soit (x, y, z) un élément de E tel que x ∧ y = 1. a. montrer que
  x ∧ z = 1 et y ∧ z = 1. b. montrer que x et y ne sont pas tous les deux pairs. c. montrer que l'équation
  a² ≡ 2 (mod 4) ne possède pas de solution entière. d. montrer que si x et y sont tous les deux impairs alors
  x² + y² ≡ 2 (mod 4). En déduire que x et y ne peuvent pas être tous les deux impairs. e. on suppose que x est
  impair et y est pair. Montrer que z est impair et que z + x et z − x sont pairs. En déduire qu'il existe deux
  entiers strictement positifs p et q, premiers entre eux, tels que x = p − q, z = p + q et y² = 4pq et p et q sont
  des carrés parfaits. 3. en déduire l'ensemble des éléments de E. 4. donner tous les triplets de E tels que z ≤ 18.
- **Ex. 29** (p.178) : on considère les dix caractères A, B, C, D, E, F, G, H et J auxquels on associe dans l'ordre
  les entiers de 1 à 10. On note Ω = {1, 2, 3, ..., 10}. On appelle message tout mot ayant un sens ou non formé avec
  ces dix caractères. Soit a un entier compris entre 1 et 10. On désigne par f l'application qui à tout élément i de Ω
  associe le reste de aⁱ modulo 11. 1. on suppose que a = 5. a. coder à l'aide de f le message « BAC » en utilisant la
  grille de chiffrement (tableau : Message B A C / i 2 1 3 / f(i) 3 … / Code C …). b. coder à l'aide de f le message
  « FADE ». Peut-on déchiffrer avec certitude le message codé ? 2. on suppose que a = 2. Donner la grille de
  chiffrement de f. Peut-on déchiffrer avec certitude un message codé ? 3. on se propose de déterminer les valeurs
  possibles de l'entier a pour que l'application f permette de chiffrer et de déchiffrer avec certitude tous les
  messages. a. soit i et i′ deux entiers compris entre 1 et 9 tels que i < i′. Montrer que aⁱ ≡ a^{i′} (mod 11)
  équivaut à a^{i′−i} ≡ 1 (mod 11). b. en déduire que f permet de chiffrer et de déchiffrer avec certitude tous les
  messages, si et seulement si, aⁱ n'est pas congru à 1 modulo 11 pour tout i ∈ {1, 2, 3, ..., 9}. c. on suppose que
  k est le plus petit entier de Ω tel que a^k ≡ 1 (mod 11). Montrer que k est un diviseur de 10. d. conclure.
- **Ex. 30** (p.178) : on considère la suite de Fibonacci (Fₙ)ₙ≥₀ définie par F₀ = 0 ; F₁ = 1 et F_{n+2} = F_{n+1} + Fₙ,
  n ≥ 0. 1. calculer les termes de cette suite jusqu'à F₁₀. 2. montrer que pour tout entier non nul n,
  F_{n+1}F_{n−1} − Fₙ² = (−1)ⁿ. 3. en déduire que pour tout entier non nul n, Fₙ ∧ F_{n+1} = 1. 4. soit n un entier non
  nul. Montrer par récurrence sur l'entier m que F_{n+m} = Fₘ F_{n+1} + F_{m−1} Fₙ. 5. en déduire que
  Fₘ ∧ Fₙ = Fₘ ∧ F_{m+n}.
- **Ex. 31** (p.178) : pour tout entier naturel n, on note φ(n) le nombre d'entiers naturels inférieurs à n et premiers
  avec n. On pose φ(1) = 1. 1. vérifier que φ(7) = 6 et φ(8) = 4. 2. montrer que φ(n) ≤ n − 1. Soit k un entier naturel
  non nul, p et q deux nombres premiers et a un entier non divisible par p et q. 3.a. montrer que φ(p) = p − 1.
  b. montrer que a^{φ(p)} ≡ 1 (mod p). 4.a. montrer que φ(pq) = φ(p)φ(q). b. montrer que a^{φ(pq)} ≡ 1 (mod pq). c. en
  déduire les congruences 10¹⁵³⁶ ≡ 1 (mod 1649) ; 10430¹⁰²⁰⁰ ≡ 1 (mod 10403). 5.a. montrer que φ(pᵏ) = pᵏ − p^{k−1}.
  b. déterminer φ(125), φ(256) et φ(1331). 6.a. montrer que (1 + up)^{p^{k−1}} ≡ 1 (mod pᵏ) (on pourra utiliser que
  tout entier non nul n divise Cₙʲ, j ≠ 0 et j ≠ n). b. montrer que a^{φ(pᵏ)} ≡ 1 (mod pᵏ). En déduire les congruences
  17¹⁰⁰ ≡ 1 (mod 125) ; 17¹²⁸ ≡ 1 (mod 256).

### Bornes de scope observées (chapitre 17)

- ✅ INCLUS : **PGCD de deux entiers** (a ∧ b, algorithme d'Euclide — dernier reste non nul, recherche à la
  calculatrice via l'affichage ab/c, théorème et définition d'existence/unicité de d, a ∧ b = |a| ∧ |b|, propriétés
  b | a ⇒ a ∧ b = |b|, a ∧ b = b ∧ r, commutativité, ka ∧ kb = |k|(a ∧ b), associativité) ; **entiers premiers entre
  eux** (définition a ∧ b = 1, décomposition unique a = (a ∧ b)a′, b = (a ∧ b)b′ avec a′ ∧ b′ = 1, **lemme de
  Gauss**, produit de diviseurs premiers entre eux ab | n, congruence n ≡ 0 (mod ab) sous a ∧ b = 1) ; **PPCM de deux
  entiers** (a ∨ b, théorème/définition, a ∨ b = |a| ∨ |b|, (a ∨ b)(a ∧ b) = |ab|, propriétés, systèmes {ab, a ∨ b},
  ensembles de multiples aℤ) ; **inverses modulo b** (existence/unicité d'un inverse u ∈ {0, ..., b − 1} de a modulo
  b lorsque a ∧ b = 1 et b ≥ 2, résolution de ax ≡ c (mod b)) ; **identité de Bézout** (a ∧ b = 1 ⟺ ∃ u, v :
  au + bv = 1 ; **corollaire** au + bv = d avec d = a ∧ b ; procédé de remontée de l'algorithme d'Euclide par tableau
  (α, β) ↦ qβ + α) ; **équations diophantiennes** ax + by = c (théorème d'existence ⟺ (a ∧ b) | c, solution
  particulière + solution générale par le paramètre k, systèmes de congruences x ≡ a (mod m), x ≡ b (mod n) — cas
  particulier du théorème des restes chinois, résolution d'équations 25x² − 9y² = k par factorisation). Le chapitre
  réinvestit le **petit théorème de Fermat** (chap. 16) et introduit l'**indicatrice d'Euler φ** (ex. 31), les
  **nombres de Carmichael** (561, ex. 7 et 23), la **suite de Fibonacci** (ex. 30) et une application
  **cryptographique** (RSA en page de garde, chiffrement par aⁱ mod 11 en ex. 29).
- ⛔ NON traité / supposé acquis : la **division euclidienne dans ℤ** et la **congruence modulo n** (établies au
  chapitre 16, ici réutilisées) ; le **petit théorème de Fermat** n'est pas redémontré (cité) ; la **structure de
  groupe / anneau ℤ/nℤ** n'est pas formalisée (les inverses et congruences sont manipulés élémentairement) ; le
  **théorème des restes chinois** n'est pas énoncé en général (seuls des systèmes à deux congruences sont résolus via
  Bézout) ; l'**indicatrice d'Euler** n'est définie que dans l'exercice 31 (hors cours). Le chapitre suppose acquis
  le raisonnement par **récurrence** (ex. 17, 30, 31), les **nombres complexes** (ex. 26) et l'usage de la
  **calculatrice** pour les PGCD et divisions euclidiennes de grands nombres ; il clôt le socle d'arithmétique du
  programme (chap. 16 → 17).

## 2.18 Chapitre 18 — Probabilités (manuel 222446, p.179–207)

**Page de garde (p.179)** — Titre de couverture : « Probabilités », Chapitre 9 (numérotation interne du tome 2 ;
c'est le chapitre 18 dans la numérotation content ; le bandeau courant écrit « Probabilités »). Encart historique
(citation) : « Un homme du monde a proposé deux problèmes à Pascal et Roberval, le second fut à l'origine des calculs
de probabilité. C'est le problème "des points" ou "des parties" ou "de division". Le prix d'un tournoi est gagné par
le premier des participants qui obtient un certain nombre de points. Comment partager ce prix si le tournoi est
interrompu ? Toutes les solutions qui en furent ensuite données étaient fausses. Le calcul des probabilités fut
présenté au monde en 1657 par Huyghens. Pour la première fois, les concepts fondamentaux, énoncés et correctement
utilisés, sont dans le domaine public. » Référence : « (Dieudonné, Abrégé d'histoire des mathématiques, 1978). » Le
chapitre est structuré en deux grandes parties **A. Probabilité sur un ensemble fini** (parties **I. Expériences
aléatoires**, **II. Définition d'une probabilité sur un ensemble fini**, **III. Equiprobabilité**, **IV. Probabilité
conditionnelle**, **V. Variables aléatoires ou aléa numériques**, **VI. Espérance et variance d'une variable
aléatoire**, **VII. Fonction de répartition d'une variable aléatoire**, **VIII. Loi binomiale**) et **B/ Exemples de
lois continues** (parties **I. La loi uniforme**, **II. La loi exponentielle**), ponctuées d'activités, d'encadrés
(définitions / propriétés / théorèmes) et d'exercices résolus, suivies d'un QCM / Vrai-Faux, puis d'une rubrique
« Exercices et problèmes » (31 exercices). **Ce chapitre comporte 4 « exercices résolus »** intégrés au cours.
Notation du manuel : C_n^p désigne le nombre de combinaisons (aussi noté (n parmi p)), A_n^p le nombre
d'arrangements, p(A/B) la probabilité conditionnelle de A sachant B, 𝒫(E) l'ensemble des parties (événements) de E.

### Cours — Activités

**A. Probabilité sur un ensemble fini** (p.180). « Dans cette partie l'univers E de l'expérience aléatoire considérée
est un ensemble fini. »

**I. Expériences aléatoires** (p.180)

- **Activité 1** (p.180) : on désigne par E l'ensemble des entiers naturels pairs inférieurs ou égaux à 500. On note
  A l'ensemble des entiers de E multiples de 10, B ceux multiples de 6, C ceux multiples de 15. 1. dénombrer E, A, B
  et C. 2. déterminer et dénombrer chacun des ensembles A̅, B̅, C̅, A ∩ B, A ∩ C, B ∩ C, A ∩ B̅, A̅ ∪ B, A̅ ∩ C̅,
  (A ∩ B) ∪ C.
- **Activité 2** (p.180) : 1. combien y a-t-il d'anagrammes du mot CHOIX ? 2. du mot POSSIBLE ? 3. du mot
  BACCALAUREAT ?
- **Activité 3** (p.180) : une urne contient trois boules numérotées 1, 2 et 3. On effectue p tirages, en tirant les
  boules une à une et en remettant chaque fois la boule tirée dans l'urne. 1. on note A₃ l'ensemble des tirages qui
  n'amènent pas le numéro 3 ; déterminer le cardinal de A₃. 2. on note A₂,₃ l'ensemble des tirages qui n'amènent ni le
  numéro 2 ni le numéro 3 ; déterminer son cardinal. 3. on note B l'ensemble des tirages qui n'amènent pas en même
  temps les numéros 1, 2 et 3 ; déterminer le cardinal de B.
- **Activité 4** (p.180–181) : dans une librairie douze titres de revues différentes sont disponibles ; trois clients
  commandent chacun une revue. 1. combien y a-t-il de commandes possibles ? 2. combien si on suppose qu'aucun titre
  n'est choisi deux fois ? 3. combien si les clients commandent la même revue ? 4. combien si exactement deux clients
  choisissent le même titre ?
- **Activité 5** (p.181) : 1.a. déterminer le nombre de parties d'un ensemble à quatre éléments. b. à cinq éléments. 2. soit E un ensemble à n éléments (n ≥ 1). a. vérifier que Σ_{k=0}^{n} C_n^k = 2ⁿ. b. en déduire le nombre de
  parties de l'ensemble E.
- **Activité 6** (p.181) : soit un entier n ≥ 2 et un entier 2 ≤ p ≤ n. On considère un ensemble E de cardinal n et
  a, b deux éléments de E. 1.a. déterminer le nombre des parties à p éléments contenant a et b. b. contenant a ou bien
  b. c. ne contenant ni a ni b. 2. en déduire que C_n^p = C_{n−2}^{p−2} + 2C_{n−2}^{p−1} + C_{n−2}^p.

**II. Définition d'une probabilité sur un ensemble fini** (p.182)

- **Activité 1** (p.182) : une expérience consiste à lancer une pièce de monnaie trois fois de suite ; on note à
  chaque fois le côté exposé (P pour pile et F pour face). 1. dénombrer les issues de cette expérience. 2. déterminer
  le cardinal de A « la face pile apparaît une seule fois » et de B « obtenir P pour la première fois au deuxième
  lancer ». 3. déterminer le cardinal de A ∩ B et de A ∪ B.
- **Activité 2** (p.182–183) : on lance un dé cubique dont les faces sont numérotées de 1 à 6. 1. on suppose que la
  probabilité d'apparition de 6 est le triple de la probabilité d'apparition de chacun des nombres 1, 2, 3, 4 et 5 ;
  déterminer la probabilité de chaque événement élémentaire. 2. déterminer la probabilité de A « obtenir un nombre
  pair », B « obtenir un nombre impair inférieur ou égal à 3 », C « obtenir un nombre pair strictement supérieur à 3 »,
  D « obtenir un multiple de 3 ou un nombre pair ».

**III. Equiprobabilité** (p.184) — texte liminaire : « Lorsqu'on lance une pièce de monnaie bien équilibrée, on jette
un dé non pipé ou on effectue un tirage au hasard, les issues ont la même probabilité de réalisation, on dit qu'on est
en présence d'une situation d'équiprobabilité. »

- **Activité** (p.185, non numérotée) : un code comporte deux lettres suivies de deux chiffres. 1. dénombrer les codes
  possibles. 2. un enfant compose un code au hasard ; calculer la probabilité d'obtenir a. un code commençant par la
  lettre A. b. un code contenant les lettres A et Z. c. un code contenant le chiffre 0 deux fois. d. un code ne
  contenant pas de chiffre pair.

**IV. Probabilité conditionnelle** (p.185)

- **Activité 1** (p.185) : un enquêteur effectue un sondage auprès de familles ayant deux enfants et s'intéresse à la
  composition des enfants suivant le sexe (F ou G) et leurs âges ; on suppose que les naissances des filles et des
  garçons sont équiprobables. 1. il choisit une famille au hasard. a. déterminer les quatre éléments possibles de
  l'univers. b. probabilité que l'aîné soit une fille ? c. que la famille ait deux filles ? d. deux garçons ?
  e. un garçon et une fille ? 2. il sonne à la porte, une fille vient ouvrir. a. probabilité que l'autre enfant soit
  une fille ? b. soit un garçon ?
- **Activité 2** (p.186) : une urne contient quatre boules rouges numérotées (1, 1, 2, 2) et deux boules vertes
  numérotées (1, 2). Un joueur tire une boule ; R « obtenir une boule rouge », D « obtenir une boule numérotée 2 ».
  1. probabilité de tirer une boule rouge ? 2. le joueur a tiré une boule rouge : a. probabilité qu'elle soit numérotée
     2 ? b. numérotée 1 ? 3. le joueur a tiré une boule verte : a. numérotée 2 ? b. numérotée 1 ? 4.a. probabilité de
     tirer une boule rouge et numérotée 2 ? b. une boule verte et numérotée 1 ? Le manuel introduit ensuite l'**arbre de
     probabilité** (arbre de choix) modélisant une expérience (I) à deux issues contraires B et B̅ suivie d'une expérience
     (II) à deux issues contraires A et A̅ ; les branches portent p(B), p(B̅), p(A/B), p(A̅/B), p(A/B̅), p(A̅/B̅) et
     aboutissent aux nœuds B ∩ A, B ∩ A̅, B̅ ∩ A, B̅ ∩ A̅. **(Figure p.186 : arbre pondéré à deux niveaux.)**

**Evénements indépendants** (p.188)

- **Activité 3** (p.188) : on jette un dé équilibré numéroté de 1 à 6 ; A « obtenir un numéro pair », B « obtenir un
  multiple de 3 », C « obtenir un multiple de 6 ». Calculer la probabilité de A, B, C, A ∩ B et A ∩ C.
- **Activité 4** (p.188) : une urne U₁ contient trois boules noires et six boules vertes ; une urne U₂ contient deux
  boules noires et trois boules vertes. On choisit une urne au hasard et on tire successivement deux boules, en
  remettant chaque fois la boule, dans l'urne choisie ; A « obtenir une boule verte au premier tirage », B « au
  deuxième tirage ». Les événements A et B sont-ils indépendants ?
- **Activité 5** (p.188) : trois personnes A, B et C participent à un jeu télévisé ; l'animateur offre au hasard deux
  cadeaux aux candidats (un candidat pourra recevoir deux cadeaux). A « la personne A ne reçoit aucun cadeau »,
  B « la personne B ne reçoit aucun cadeau ». 1. calculer les probabilités de A, B et A ∩ B. 2. A et B sont-ils
  indépendants ?

**Formule des probabilités totales** (p.189)

- **Activité 6** (p.189) : dans une usine, le tiers de la production provient de la machine A, le quart de la machine
  B et le reste de la machine C ; les trois machines fabriquent des ampoules de types 1 et 2. Sur 1000 ampoules de A,
  2 sont défectueuses ; de B, 10 ; de C, 5. On choisit au hasard une ampoule emballée. Déterminer à l'aide d'un arbre
  la probabilité de a. « l'ampoule est défectueuse ». b. « l'ampoule fonctionne ». c. « l'ampoule provient de A
  sachant qu'elle est défectueuse ». d. « l'ampoule ne provient pas de A sachant qu'elle fonctionne ».
- **Activité 7** (p.191) : le cycle d'un feu tricolore dure une minute : vert 25 s, orange 5 s et rouge 30 s.
  1. probabilité que le feu soit vert ? orange ? rouge ? 2. un automobiliste arrive à 10 mètres d'un feu tricolore
     (aucun véhicule ne le précède) et passe sans s'arrêter : au feu vert avec probabilité 99 %, au feu orange 80 %, au
     feu rouge 1 %. Probabilité qu'il passe sans s'arrêter ?
- **Activité 8** (p.191) : une personne qui fait du sport un jour donné, en fait le lendemain avec la probabilité 0.4 ;
  si elle n'en fait pas ce jour-là, elle en fera le lendemain avec la probabilité 0.8. Elle a fait du sport le lundi.
  Quelle est la probabilité qu'elle en fasse le jeudi ?

**V. Variables aléatoires ou aléa numériques** (p.191)

- **Activité 1** (p.191) : une urne contient deux boules numérotées 4 et trois boules numérotées −2, indiscernables au
  toucher ; on tire simultanément deux boules. 1.a. probabilité de tirer deux boules numérotées 4 ? b. deux numéros
  différents ? c. le même numéro ? 2. on note X l'application qui à tout événement élémentaire associe la somme des
  numéros des deux boules tirées ; quelles sont les valeurs prises par X ?
- **Activité 2** (p.191–192) : on lance une pièce de monnaie bien équilibrée trois fois de suite. 1. déterminer
  l'ensemble des issues possibles. 2. X = nombre de côtés « face » obtenus ; probabilité de (X = 0), (X = 1), (X = 2),
  (X = 3) ?
- **Activité 3** (p.192) : une entreprise organise un concours pour recruter un cadre ; trois candidats se présentent,
  chacun passe un test et le premier qui y satisfait est engagé ; la probabilité qu'un candidat réussisse est p. X = j
  si le jᵉ candidat est engagé et X = 4 si aucun candidat n'est engagé. Déterminer la loi de X.

**VI. Espérance et variance d'une variable aléatoire** (p.192)

- **Activité 1** (p.193) : on lance un dé de six faces numérotées de 1 à 6 ; X = numéro obtenu et Y = 1 si le numéro
  est pair, −1 sinon. Calculer E(X), E(−3X), E(Y) et E(X + Y).
- **Activité 2** (p.193) : un marchand de glaces propose 5 parfums au choix ; trois personnes choisissent au hasard et
  indépendamment un parfum. 1.a. probabilité que les trois choisissent des parfums deux à deux différents ? b. le même
  parfum ? 2. X = nombre de parfums choisis par les trois personnes ; a. déterminer la loi de X. b. calculer
  l'espérance et l'écart-type de X.
- **Activité 3** (p.193–194) : une enveloppe contient les douze figures d'un jeu de cartes (quatre rois, quatre dames,
  quatre valets). 1. on tire simultanément et au hasard cinq cartes ; X = nombre de rois obtenus. a. loi de X.
  b. espérance et écart-type. 2. on tire successivement, au hasard et avec remise, cinq cartes ; Y = nombre de rois
  obtenus. a. loi de Y. b. espérance et écart-type. 3. comparer les résultats de 1.b et 2.b et interpréter.

**VII. Fonction de répartition d'une variable aléatoire** (p.194)

- **Activité 1** (p.194) : on donne la représentation graphique d'une fonction F : ℝ → [0, 1], x ↦ p(X ≤ x), où
  (X ≤ x) désigne l'ensemble {a ∈ E ; X(a) ≤ x}. Déterminer graphiquement 1. les valeurs prises par X. 2. p(X ≤ −1),
  p(X ≤ 1.3), p(X ≤ 11/3), p(X ≤ 1), p(X < 2), p(X = 2), p(1 ≤ X ≤ 6). 3. la loi de probabilité de X. **(Figure p.194 :
  fonction en escalier à sauts 0.1, 0.3, 0.8, 0.9, 1 aux abscisses 1 à 5.)**
- **Activité 2** (p.194) : une pièce de monnaie est truquée de sorte que la probabilité d'obtenir pile est 0.6 ; on
  lance la pièce trois fois et X = nombre de piles obtenus. 1. déterminer la loi de X. 2. F : ℝ → [0, 1],
  x ↦ p(X ≤ x) ; déterminer l'expression de F et la représenter.
- **Activité 3** (p.194–195) : trois urnes contiennent chacune des jetons numérotés de 1 à 6 ; on tire au hasard un
  jeton de chaque urne et X = plus grand des numéros tirés. 1. soit k un entier ≤ 6. a. dans chaque urne, probabilité
  de tirer un numéro ≤ k ? b. en déduire p(X ≤ k). 2. déterminer la fonction de répartition de X et tracer sa courbe. 3. déterminer la loi de X.

**VIII. Loi binomiale** (p.195)

- **Activité 1** (p.195) : la probabilité qu'un joueur de fléchettes atteigne sa cible est 0.9. 1. deux tirs ; X =
  nombre de succès. a. loi de X. b. probabilité « le joueur atteint au moins une fois sa cible ». 2. dix tirs ; Y =
  nombre de succès. a. probabilités « le joueur réalise neuf succès », « au moins un succès ». b. loi de Y.
- **Activité 2** (p.195) : un mobile se déplace sur un axe (O, i⃗) ; à t = 0 il est en O, à chaque seconde son abscisse
  augmente de 1 (probabilité 1/2) ou diminue de 1 (probabilité 1/2). 1. à t = 2 : a. probabilité qu'il soit au point
  d'abscisse 2 ? b. au point O ? 2. à t = n : a. probabilité au point d'abscisse n ? b. au point d'abscisse −n ?
- **Activité 3** (p.196) : on lance n fois (n ≥ 1) un dé ; A « obtenir au moins un 6 ». 1. calculer p(A) pour n = 3. 2. exprimer p(A) en fonction de n. 3. combien de fois au moins faut-il lancer le dé pour que p(A) ≥ 0.9 ?

**B/ Exemples de lois continues** — **I. La loi uniforme** (p.196)

- **Activité 1** (p.196) : 1.a. soit I = [−1, 1] ; quelle est son amplitude ? b. f définie sur I par f(x) = 1/2 ;
  calculer ∫_{−1}^{1} f(x) dx. c. montrer que pour tout intervalle [c, d] de [−1, 1], 0 ≤ ∫_c^d f(x) dx ≤ 1. 2. soit f
  constante sur [a, b]. a. quelle valeur donner à f pour que ∫_a^b f(x) dx = 1 ? b. montrer que dans ce cas
  0 ≤ ∫_c^d f(x) dx ≤ 1, pour tout intervalle [c, d] de [a, b].
- **Activité 2** (p.197) : un joueur lance une fléchette sur une cible circulaire de rayon 30 cm (il n'est pas
  expérimenté, il atteint aléatoirement la cible) ; d = distance entre le centre et le point d'impact. 1. valeurs
  possibles de d ? 2. on partage [0, 30] en 10 intervalles de même amplitude. a. amplitude de ces intervalles ?
  b. d a-t-il plus de chances d'appartenir à un intervalle plutôt qu'à un autre ? c. probabilité que d appartienne à
  [0, 30] ? [4, 5] ? [9, 10] ?
- **Activité 3** (p.197) : un mobile M se déplace sur un cercle de centre O à partir d'un point A et s'arrête d'une
  manière aléatoire ; on mesure l'angle α que fait [OA) avec [OM). P = probabilité uniforme sur [0, 2π]. Calculer
  P(π/4 ≤ X ≤ π), P(π/4 ≤ X ≤ π/2) et P(0 ≤ X ≤ π). **(Figure p.197 : cercle de centre O, points A et M, angle α.)**
- **Activité 4** (p.198) : la durée (en minutes) du trajet séparant un employé de son travail est une variable
  aléatoire X à valeurs dans [30, 50] suivant la loi uniforme P. 1. calculer P(30 ≤ X ≤ 40) et P(30 ≤ X ≤ 43). 2. on
  considère F : ℝ → [0, 1] définie par F(x) = 0 si x < 30, P(30 ≤ X ≤ x) si x ∈ [30, 50], 1 si x > 50 ; déterminer
  l'expression de F et la représenter.

**B/ II. La loi exponentielle** (p.198)

- **Activité 1** (p.198) : 1. soit λ un réel strictement positif et f définie sur [0, +∞[ par f(t) = λe^{−λt}.
  a. calculer ∫*0^x f(t) dt et lim*{x→+∞} ∫_0^x f(t) dt. b. montrer que pour tout intervalle [c, d] de [0, +∞[,
  0 ≤ ∫_c^d f(x) dx ≤ 1.
- **Activité 2** (p.199) : on s'intéresse à la durée de vie t (en semaines) d'un appareil électronique ; on suppose que
  la probabilité que l'appareil soit encore fonctionnel au bout d'un temps t est une loi exponentielle de paramètre
  0.5. Quelle est la probabilité que la durée de vie soit entre 100 et 200 semaines ?
- **Activité 3** (p.199) : une variable aléatoire X suit une loi exponentielle de paramètre λ. 1. déterminer λ sachant
  que P(X ≥ 10) = 0.5. 2. déterminer P(0 ≤ X ≤ 10), P(100 ≤ X ≤ 300) et P(X ≥ 300). 3. F : ℝ → [0, 1] définie par
  F(x) = 0 si x < 0, P(0 ≤ X ≤ x) si x ∈ [0, +∞[. a. déterminer l'expression de F. b. calculer lim_{x→+∞} F(x).
  c. représenter F.
- **Activité 4** (p.200) : X suit une loi exponentielle de paramètre λ ; on donne la représentation de la fonction de
  répartition de X. 1. déterminer une valeur approchée à 10⁻¹ près du paramètre λ. 2. calculer p(X ≥ 2). **(Figure
  p.200 : courbe de la fonction de répartition passant par ≈ (1, 0.85).)**

**Exercice résolu 1** (p.183–184) : « Un appareil, fabriqué en très grande série, peut présenter deux sortes de défauts
désignés par D₁ et D₂. Dans un lot de 1000 appareils, on constate que 60 ont le défaut D₁, 50 ont le défaut D₂ et 20
ont les deux défauts. Un client achète un appareil (au hasard). Déterminer les probabilités de A "les deux défauts",
B "au moins un défaut", C "pas de défaut", D₁′ "défaut D₁ et pas D₂", D₂′ "défaut D₂ et pas D₁", D "un seul défaut". »
Solution résumée : A = D₁ ∩ D₂ donne p(A) = 20/1000 = 0.02 ; B = D₁ ∪ D₂ donne
p(B) = 60/1000 + 50/1000 − 20/1000 = 0.09 ; C = B̅ donne p(C) = 1 − 0.09 = 0.91 ;
p(D₁′) = p(D₁) − p(D₁ ∩ D₂) = 0.04 ; p(D₂′) = 0.03 ; D = D₁′ ∪ D₂′ (incompatibles) donne p(D) = 0.07. **(Figure p.184 :
diagramme de Venn D₁, D₂, D₁ ∩ D₂.)**

**Exercice résolu 2** (p.184) : « On jette deux dés équilibrés de couleurs rouge et verte, faces numérotées de 1 à 6.

1. déterminer l'univers E et son cardinal. 2. probabilité d'obtenir le même chiffre sur les deux dés. 3. probabilité
   d'obtenir deux chiffres distincts. » Solution résumée : les dés sont discernables par leur couleur, donc
   E = {(i, j) ; 1 ≤ i ≤ 6 et 1 ≤ j ≤ 6}, card(E) = 36 ; A = {(i, i), 1 ≤ i ≤ 6}, card A = 6, p(A) = 6/36 = 1/6 ;
   p(A̅) = 1 − p(A) = 5/6.

**Exercice résolu 3** (p.187–188) : « Un centre de santé se propose de dépister une maladie auprès d'une population de
1000 individus. La proportion des personnes malades est de 10 %. Sur 100 personnes malades, 98 ont un test positif.
Sur 100 personnes non malades, une seule a un test positif. On choisit une personne au hasard. M "la personne est
malade", T "a un test positif". 1. p(T/M) et p(T̅/M). 2. p(T/M̅) et p(T̅/M̅). 3. à l'aide d'un arbre, p(M ∩ T),
p(M ∩ T̅), p(M̅ ∩ T), p(M̅ ∩ T̅). 4. p(T) et p(M/T̅). » Solution résumée : p(T/M) = 0.98, p(T̅/M) = 0.02, p(T/M̅) = 0.01,
p(T̅/M̅) = 0.99 ; l'arbre donne p(T ∩ M) = 0.098, p(T̅ ∩ M) = 0.002, p(T ∩ M̅) = 0.009, p(T̅ ∩ M̅) = 0.891 ;
T = (T ∩ M) ∪ (T ∩ M̅) (incompatibles) donne p(T) = 0.107 ; p(M/T̅) = p(T̅ ∩ M)/(1 − p(T)) = 0.002/0.893 ≈ 0.0022.
**(Figure p.187 : arbre pondéré p(M) = 0.1, p(M̅) = 0.9 et branches conditionnelles 0.98/0.02/0.01/0.99.)**

**Exercice résolu 4** (p.189–191) : « Une urne U₁ contient sept boules noires et trois boules vertes ; une urne U₂
contient deux boules noires et huit boules vertes. On effectue une suite de tirages en remettant à chaque fois la
boule tirée dans l'urne, suivant la règle : si au (n−1)ᵉ tirage on a obtenu une boule noire, le nᵉ tirage s'effectue
dans U₁ ; si une boule verte, dans U₂. 1. on choisit une urne au hasard et on fait le premier tirage ; déterminer la
probabilité p₁ d'obtenir une boule noire. 2. pₙ = probabilité de tirer une boule noire au nᵉ tirage. a. calculer p₂.
b. montrer que pₙ = (1/2)p_{n−1} + 1/5, n ≥ 2. 3.a. montrer que la suite (qₙ), qₙ = pₙ − 2/5 (n ≥ 1), est géométrique.
b. déterminer pₙ en fonction de n et en déduire lim pₙ. » Solution résumée : avec p(U₁) = p(U₂) = 0.5, p(E₁/U₁) = 7/10,
p(E₁/U₂) = 2/10 donne p₁ = 9/20 ; puis p₂ = (7/10)p₁ + (2/10)(1 − p₁) = (1/2)p₁ + 1/5 = 17/40 ; la relation générale
pₙ = (1/2)p_{n−1} + 1/5 ; (qₙ) est géométrique de raison 0.5 et de premier terme q₁ = 1/20, d'où
pₙ = 2/5 + (1/20)(0.5)^{n−1} et lim_{n→+∞} pₙ = 2/5.

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Définition (dénombrement)** (p.181, encadré) — « Soit E = {a₁, a₂, ..., aₙ} un ensemble à n éléments et p un entier
> naturel non nul. * Le nombre des p-uplets d'éléments de E est l'entier nᵖ. * Le nombre de n-uplets d'éléments de E
> deux à deux distincts est l'entier n!. * Si 1 ≤ p ≤ n alors • le nombre des p-uplets d'éléments de E deux à deux
> distincts est l'entier A_n^p = n!/(n − p)!, • le nombre de parties à p éléments de E est l'entier
> C_n^p = n!/((n − p)!p!). (L'entier C_n^p est aussi noté (n parmi p) et on convient que C_n^0 = 1). »

> **Définition (expérience aléatoire, univers)** (p.182, encadré) — « Une expérience aléatoire est une expérience dont
> le résultat est soumis au hasard et est donc imprévisible. L'ensemble E des issues d'une expérience aléatoire est
> appelé univers. Les éléments de E sont appelés événements élémentaires. Une partie A de E est appelée événement. »

> **Définition (probabilité)** (p.182, encadré) — « Soit E l'univers d'une expérience aléatoire et 𝒫(E) l'ensemble des
> événements de E. On appelle probabilité sur E, toute application p, de 𝒫(E) dans [0, 1] vérifiant les conditions
> ci-dessous. • L'image p(E) de E est égale à 1. • L'image p(∅) de l'ensemble vide est égale à 0. • L'image p(A) d'un
> événement A, est la somme des images des événements élémentaires de A, c'est-à-dire p(A) = Σ_{aᵢ ∈ A} p(aᵢ). »

Vocabulaire (p.182) : « Le triplet (E, 𝒫(E), p) est appelé espace probabilisé fini. L'événement E est appelé certain.
L'événement vide est appelé événement impossible. L'événement contraire d'un événement A est noté A̅. Deux événements
sont dits incompatibles si leur intersection est vide. »

> **Propriétés** (p.183, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé et A et B deux événements de E.
> • p(A̅) = 1 − p(A). • p(A ∪ B) = p(A) + p(B) − p(A ∩ B). • Si A ∩ B = ∅ alors p(A ∪ B) = p(A) + p(B). • Si
> A₁, A₂, ..., A_k sont des événements deux à deux incompatibles, alors
> p(A₁ ∪ A₂ ∪ ... ∪ A_k) = p(A₁) + p(A₂) + ... + p(A_k). »

> **Définition et théorème (équiprobabilité)** (p.184, encadré) — « Soit E l'univers d'une expérience aléatoire dans
> une situation d'équiprobabilité et 𝒫(E) l'ensemble des parties de E. L'application p définie de 𝒫(E) dans [0, 1] par
> p(a) = 1/card(E), pour tout événement élémentaire a de E est une probabilité sur E, appelée probabilité uniforme. »

> **Propriété (probabilité uniforme)** (p.184, encadré) — « Si (E, 𝒫(E), p) est un espace probabilisé tel que la
> probabilité p est uniforme, alors p(A) = card(A)/card(E), pour tout événement A de E. »

> **Théorème (probabilité conditionnelle)** (p.185, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé et B un
> événement tel que p(B) ≠ 0. L'application p_B de 𝒫(E) dans [0, 1], définie par p_B(A) = p(A ∩ B)/p(B), pour tout
> événement A, est une probabilité sur E. »

> **Définition (probabilité B-conditionnelle)** (p.186, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé et B un
> événement tel que p(B) ≠ 0. L'application p_B ainsi définie s'appelle probabilité B-conditionnelle. Le réel p_B(A)
> est noté p(A/B) (on lit "probabilité de A, sachant B"). »

> **Définition (événements indépendants)** (p.188, encadré) — « On dit que deux événements A et B sont indépendants
> lorsque p(A ∩ B) = p(A) × p(B). Dans le cas où p(B) ≠ 0, la réalisation de B n'influence pas celle de A, c'est-à-dire
> p(A/B) = p(A). »

> **Définition (partition)** (p.189, encadré) — « Soit E un ensemble fini, les parties B₁, B₂, ..., Bₙ forment une
> partition de E lorsqu'ils sont deux à deux disjoints et leur réunion est E. »

> **Théorème (formule des probabilités totales)** (p.189, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé,
> B₁, B₂, ..., Bₙ des événements formant une partition de E tels que pour tout i, p(Bᵢ) ≠ 0. Alors pour tout événement
> A, p(A) = Σ_{i=1}^{n} p(A ∩ Bᵢ) = Σ_{i=1}^{n} p(Bᵢ)·p_{Bᵢ}(A). » **(Figure p.189 : partition B₁, B₂, B₃, B₄ de E
> et événement A.)**

> **Définition (aléa numérique / variable aléatoire)** (p.191, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé.
> On appelle aléa numérique ou variable aléatoire toute application X : E → ℝ. » Notation (p.191) : « L'événement
> {a ∈ E ; X(a) = xᵢ} est noté (X = xᵢ). L'ensemble X(E) désigne l'ensemble des valeurs prises par X. »

> **Définition (loi de probabilité)** (p.192, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé et X une variable
> aléatoire. On appelle loi de probabilité de X ou distribution de X, l'application P_X : X(E) → [0, 1],
> xᵢ ↦ p(X = xᵢ). »

> **Conséquences** (p.192, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé. Si X est une variable aléatoire sur E
> telle que X(E) = {x₁, x₂, ..., xₙ}, alors Σ_{i=1}^{n} p(X = xᵢ) = 1. »

> **Définition (espérance)** (p.192, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé et X une variable aléatoire
> sur E telle que X(E) = {x₁, x₂, ..., xₙ}. On appelle espérance mathématique ou moyenne de X le nombre
> E(X) = Σ_{i=1}^{n} xᵢ pᵢ. »

> **Théorème (linéarité de l'espérance)** (p.193, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé et X, Y deux
> variables aléatoires sur E. Alors • Pour tout réel α, E(αX) = α E(X). • E(X + Y) = E(X) + E(Y). »

> **Définition (variance, écart-type)** (p.193, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé et X une variable
> aléatoire sur E. On appelle variance de X le nombre V(X) = E((X − E(X))²). On appelle écart-type de X le nombre
> σ(X) = √(V(X)). »

> **Propriété (variance)** (p.193, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé. Si X est une variable
> aléatoire sur E alors V(X) = E(X²) − (E(X))². »

> **Définition (fonction de répartition)** (p.194, encadré) — « Soit (E, 𝒫(E), p) un espace probabilisé et X une
> variable aléatoire sur E. On appelle fonction de répartition de X, l'application définie de ℝ dans [0, 1] par
> F : x ↦ p(X ≤ x). »

> **Théorème et définition (loi binomiale)** (p.195, encadré) — « Soit une expérience aléatoire constituée de n
> épreuves identiques, indépendantes et n'ayant que deux issues : succès ou échec. Soit p la probabilité de
> l'événement succès. On considère la variable aléatoire X associant à cette expérience le nombre de succès réalisés
> au cours des n épreuves. Alors la loi de probabilité de X est donnée par p(X = k) = C_n^k pᵏ (1 − p)^{n−k},
> k ∈ {0, 1, ..., n}. On dit que X suit une loi binomiale de paramètre (n, p). » Notation (p.195) : « La loi binomiale
> de paramètre (n, p) est notée B(n, p). Lorsque n = 1, on dit que X suit une loi de Bernoulli. »

> **Espérance et variance (loi binomiale)** (p.196, encadré) — « Soit X une variable aléatoire suivant à une loi
> binomiale B(n, p). On a E(X) = np, V(X) = np(1 − p) et σ(X) = √(np(1 − p)). »

> **Définition (densité de la loi uniforme)** (p.196, encadré) — « Soit un intervalle [a, b] (a < b). La fonction f
> définie sur [a, b] par f(x) = 1/(b − a) est appelée densité de la loi de probabilité uniforme sur [a, b]. On appelle
> probabilité uniforme sur [a, b] l'application qui à tout intervalle [c, d] inclus dans [a, b] associe le réel
> P([c, d]) = ∫_c^d f(x) dx. »

> **Conséquences (loi uniforme)** (p.197, encadré) — « Pour tout réel c de [a, b], P({c}) = ∫_c^c f(x) dx = 0. Si on
> désigne par [c, d]‾ le complémentaire de [c, d] dans [a, b], alors P([c, d]‾) = 1 − P([c, d]). » **(Figure p.197 :
> aire de la densité 1/(b − a) sur [c, d].)**

> **Définition (loi uniforme)** (p.197, encadré) — « On dit qu'une variable aléatoire X à valeurs dans un intervalle
> [a, b] suit la loi de probabilité uniforme P si P(c ≤ X ≤ d) = (d − c)/(b − a). »

> **Définition (fonction de répartition, loi uniforme)** (p.198, encadré) — « Soit X une variable aléatoire qui suit la
> loi de probabilité uniforme P sur l'intervalle [a, b]. On appelle fonction de répartition de X, l'application
> F : ℝ → [0, 1] définie par F(x) = 0 si x < a, P(a ≤ X ≤ x) si x ∈ [a, b], 1 si x > b. » **(Figure p.198 : rampe
> linéaire de 0 à 1 entre a et b.)**

> **Définition (densité de la loi exponentielle)** (p.198, encadré) — « Soit λ un réel strictement positif. La fonction
> f définie sur [0, +∞[ par f(t) = λe^{−λt} est appelée densité de loi exponentielle. On appelle loi de probabilité
> exponentielle de paramètre λ, l'application P qui • à tout intervalle [c, d] inclus dans [0, +∞[ associe le réel
> P([c, d]) = ∫_c^d λe^{−λx} dx. • à tout intervalle [c, +∞[ inclus dans [0, +∞[ associe le réel
> P([c, +∞[) = e^{−λc}. »

> **Conséquences (loi exponentielle)** (p.199, encadré) — « 1. Pour tout réel c > 0, P({c}) = ∫_c^c f(x) dx = 0. 2. Pour tout réel c > 0, P([0, c]) = ∫_0^c f(x) dx = 1 − e^{−λc}. 3. P([c, +∞[) = 1 − P([0, c]). »

> **Définition (loi exponentielle)** (p.199, encadré) — « On dit qu'une variable aléatoire X suit la loi exponentielle
> de paramètre λ, si P(c ≤ X ≤ d) = ∫_c^d λe^{−λx} dx = e^{−λc} − e^{−λd} et P(X ≥ c) = e^{−λc}. »

> **Définition (fonction de répartition, loi exponentielle)** (p.200, encadré) — « Soit X une variable aléatoire qui
> suit la loi de probabilité exponentielle P de paramètre λ. On appelle fonction de répartition de X, l'application
> F : ℝ → [0, 1] définie par F(x) = 0 si x < 0, P(0 ≤ X ≤ x) si x ∈ [0, +∞[. » **(Figure p.200 : courbe concave
> croissant de 0 vers l'asymptote 1.)**

### QCM (p.201) — « Cocher la réponse exacte. » (réponses non fournies)

1. On représente une expérience aléatoire par l'arbre de probabilité ci-contre (branches : A avec p = 0.9 puis B/A avec
   0.1 et B̅/A avec 0.9 ; A̅ avec p = 0.1 puis A̅ ∩ B avec 0.9 et A̅ ∩ B̅ avec 0.1). a. La probabilité de B sachant A
   est égale à (☐ 0.9 / ☐ 0.1 / ☐ 0.09). b. La probabilité de l'événement A̅ ∩ B̅ est égale à (☐ 0.01 / ☐ 0.1 /
   ☐ 0.2). c. La probabilité de l'événement A sachant B est égale à (☐ 0.09 / ☐ 0.5 / ☐ 0.9). **(Figure p.201 : arbre
   de probabilité à deux niveaux.)**
2. Si X est une variable aléatoire qui suit la loi exponentielle de paramètre 0.1 alors l'arrondi au centième de
   p(X > 10) est (☐ 0.63 / ☐ 0.37 / ☐ 0.91).
3. Une variable aléatoire X suit la loi binomiale de paramètre 3 et 1/3. La probabilité de l'événement X > 2 est
   (☐ (1/3)³ / ☐ (2/3)³ / ☐ C₃² (1/3)(2/3)²).

### Vrai ou faux (p.201) — « Répondre par vrai ou faux en justifiant la réponse. » (réponses non fournies)

1. Si deux événements A et B sont indépendants alors p(A ∪ B) = p(A) + p(B).
2. Si A ∪ B est l'événement certain alors pour tout événement C, p(C) = p(A ∩ C) + p(B ∩ C).
3. Dans une expérience aléatoire, la probabilité d'un événement A est égale à 0.2. On répète huit fois cette
   expérience de façon indépendante. La probabilité que l'événement A se réalise au moins une fois est égale à
   1 − (0.8)⁸.
4. Les situations de tirages sans remise obéissent à une loi binomiale.
5. La probabilité de choisir au hasard un réel entre 0 et 0.0000001 est égale à 0.

### Exercices et problèmes (p.202–207) — 31 exercices

- **Ex. 1** (p.202) : dans une urne, une boule est numérotée 1, deux boules numérotées 2, trois numérotées 3, quatre
  numérotées 4, ... et enfin neuf boules numérotées 9. 1. combien de boules dans l'urne ? 2. on tire deux boules
  simultanément et au hasard. a. probabilité que les deux numéros soient pairs ? b. que la somme des deux numéros soit
  ≥ 3 ? c. que la somme soit ≤ 15 ? 3. on tire quatre boules successivement, sans remise, et on les aligne dans l'ordre
  ; la probabilité d'obtenir 1983 est-elle la même que celle d'obtenir 1389 ? 4. même question avec remise.
- **Ex. 2** (p.202) : un élève effectue un sondage dans sa classe (40 élèves) sur les questions « Aimez-vous les
  mathématiques ? », « la philosophie ? », « le sport ? ». La 1ʳᵉ a obtenu 31 « oui », la 2ᵉ un « oui », la 3ᵉ 9 « oui ».
  Enquête complémentaire : 1 élève aime seulement la philosophie, 3 seulement le sport, 25 seulement les mathématiques.
  Probabilité qu'un élève interrogé au hasard : 1. aime les trois matières ? 2. aime les maths et n'aime pas le sport ? 3. n'aime pas la philosophie et les mathématiques ? 4. n'aime aucune matière ? 5. aime au moins une matière ?
- **Ex. 3** (p.202) : le programme d'une épreuve d'examen comporte 100 questions ; un candidat n'en étudie que 80. Lors
  de l'examen, le candidat tire au sort trois questions ; probabilité qu'il ait étudié 1. les trois questions ? 2. deux
  questions seulement ? 3. une seule question ? 4. aucune des trois ? 5. au moins une des trois ?
- **Ex. 4** (p.202) : lors d'un concours, la 1ʳᵉ épreuve est de mathématiques, la 2ᵉ de sciences physiques. Un élève a
  80 % de chance de réussir la 1ʳᵉ ; s'il la réussit il a 75 % de réussir la 2ᵉ ; sinon 40 %. M « réussit la 1ʳᵉ »,
  S « réussit la 2ᵉ ». Déterminer p(M), p(S/M), p(S/M̅) et p(S).
- **Ex. 5** (p.202) : le personnel d'une grande entreprise est réparti en ingénieurs, techniciens et administratifs.
  10 % sont ingénieurs, 80 % techniciens. 80 % des employés sont des femmes, 60 % des ingénieurs sont des hommes, 90 %
  des techniciens sont des femmes. On interroge un employé au hasard. 1.a. probabilité d'interroger une femme ingénieur
  ? b. un homme technicien ? c. une femme administrative ? 2. l'employé interrogé est une femme : a. probabilité
  qu'elle soit technicienne ? b. ingénieur ? 3. l'employé interrogé est un ingénieur : a. probabilité que ce soit une
  femme ? b. un homme ?
- **Ex. 6** (p.202–203) : un magasin vend deux types de téléphones portables (marque A et marque B) et propose deux
  types d'abonnement (I et II) ; enquête sur 2000 clients ayant acheté un seul téléphone et un seul abonnement. Sur
  2000, 1200 ont acheté le modèle A, 960 l'abonnement I. S « avoir acheté le modèle A », C « avoir choisi l'abonnement
  I ». 1. probabilité qu'il ait acheté A ? 2. parmi les clients A, 32 % ont choisi I : a. probabilité modèle A et
  abonnement I ? b. probabilité modèle B et abonnement II ?
- **Ex. 7** (p.203) : une urne contient huit jetons (trois noirs n° 1, trois noirs n° 2, un vert n° 1, un vert n° 2). On
  extrait deux jetons selon le lancer d'une pièce truquée : si pile, deux jetons simultanément ; si face, deux jetons
  successivement sans remise. La probabilité d'obtenir pile est 7/15. P « obtenir pile », F « obtenir face », A « même
  numéro ou même couleur », B « même numéro et même couleur », C « même couleur », D « même numéro ». 1. déterminer
  p(C/P), p(D/P), p(B/P) et p(A/P). 2. déterminer p(A/F) et en déduire p(A).
- **Ex. 8** (p.203) : deux joueurs X et Y s'entraînent au tir à la cible ; X est expérimenté et atteint sa cible 9 fois
  sur 10, Y est débutant et l'atteint 4 fois sur 10. X laisse Y s'entraîner et n'effectue qu'un tir sur trois. Un des
  joueurs tire et la cible est atteinte ; probabilité que ce soit Y ?
- **Ex. 9** (p.203) : un joueur est en présence de deux urnes A et B. Urne A : trois boules blanches et cinq rouges ;
  urne B : sept blanches et cinq rouges. Le joueur lance deux dés non pipés de couleurs différentes une fois ; si le
  total ≤ 7, il choisit A ; si > 7, il choisit B. Il tire alors successivement quatre boules sans remise. 1. probabilité
  d'obtenir 2 blanches et 2 rouges ? 2. probabilité de n'obtenir que des rouges ? 3. il n'obtient que des rouges ;
  probabilité que ce soit l'urne B qui ait été choisie ?
- **Ex. 10** (p.203) : deux amis se rendent indépendamment sur un lieu de vacances ; jours d'arrivée possibles numérotés
  de 1 à 8 ; chacun choisit son jour au hasard, reste trois jours à attendre l'autre puis repart ; séjours au cours des
  journées 1 à 10. 1. probabilité qu'ils arrivent le même jour ? 2. avec un jour d'écart ? 3. qu'ils puissent se
  rencontrer ? 4. ils se sont rencontrés ; probabilité qu'ils aient pu passer ensemble au moins deux jours ?
- **Ex. 11** (p.203–204) : un individu réduisant sa consommation de cigarettes applique : C₁ s'il reste un jour sans
  fumer, la probabilité qu'il fume le lendemain est 0.2 ; C₂ s'il cède et fume un jour, la probabilité qu'il fume le
  lendemain est 0.7. Fₙ « l'individu fume le nᵉ jour », pₙ = probabilité de Fₙ. 1. à l'aide d'un arbre, déterminer
  p(F_{n+1}/Fₙ), p(F_{n+1}‾/Fₙ), p(F_{n+1}/Fₙ‾), p(F_{n+1}‾/Fₙ‾). 2. en déduire que pour tout n ≥ 1,
  p_{n+1} = 0.5 pₙ + 0.2. 3. soit (aₙ), aₙ = pₙ − 0.4, n ≥ 1. a. montrer que (aₙ) est géométrique (raison et limite).
  b. en déduire lim pₙ ; interpréter.
- **Ex. 12** (p.204) : des personnes P₁, P₂, ..., Pₙ, ... se transmettent une information dans cet ordre ; chaque
  personne la transmet fidèlement avec probabilité 0.9 ou la change en son contraire avec probabilité 0.1 ; la 1ʳᵉ
  possède l'information non déformée. Aₙ « la nᵉ personne possède l'information non déformée », pₙ sa probabilité.
  1. calculer p₁ et p₂. 2. calculer p₃ par un arbre. 3. montrer que p_{n+1} = 0.8pₙ + 0.1. 4.a. soit (qₙ),
     qₙ = pₙ − 1/2, n ≥ 1 ; montrer que (qₙ) est géométrique. b. exprimer pₙ en fonction de n. 5. probabilité que la 20ᵉ
     personne possède l'information non déformée ? 6. calculer lim pₙ.
- **Ex. 13** (p.204) : un dé cubique a trois faces portant le n° 1, deux faces le n° 2 et une face le n° 3. On lance le
  dé deux fois ; X = somme des nombres obtenus. 1. déterminer la loi de X. 2. calculer E(X) et V(X). 3. déterminer la
  fonction de répartition F de X et tracer sa courbe.
- **Ex. 14** (p.204) : un sac contient 10 jetons (quatre rouges et six blancs) ; on extrait les jetons un à un sans
  remise ; X = rang d'apparition du premier jeton rouge. Trouver la loi de X, son espérance et sa variance.
- **Ex. 15** (p.204) : on lance deux dés identiques bien équilibrés ; X = plus grand des nombres obtenus, Y = plus petit.
  1. déterminer les lois de X et Y. 2. calculer l'espérance de X et celle de Y, ainsi que leurs variances.
- **Ex. 16** (p.204) : on jette 20 fois une pièce de monnaie. 1. nombre moyen de faces obtenus ? 2. probabilité d'obtenir
  un nombre de faces égal à 10 ? 3. compris entre 9 et 11 ? 4. entre 8 et 12 ? 5. entre 7 et 13 ?
- **Ex. 17** (p.204) : dans une production d'ampoules, la probabilité qu'une ampoule soit défectueuse est 0.1. Dans un
  lot de 400 ampoules, déterminer la moyenne et l'écart-type de la distribution des pièces défectueuses.
- **Ex. 18** (p.204–205) : on dispose de trois tétraèdres parfaitement équilibrés ; chacun a une face peinte en bleu,
  une en jaune et deux en rouge. On lance simultanément les trois tétraèdres. 1. probabilité qu'aucune face rouge ne
  soit visible ? 2. qu'aucune face bleue ne soit visible ? 3. A « les six faces rouges sont visibles » ; calculer p(A). 4. on répète n fois l'expérience ; calculer la probabilité pₙ que A soit réalisé une et une seule fois.
- **Ex. 19** (p.205) : 1. on lance 2 dés non pipés ; A₂ « le total des numéros amenés est pair » ; calculer p(A₂). 2. on
  lance 3 dés non pipés ; A₃ « le total est pair » ; calculer p(A₃). 3. on lance n dés non pipés ; Aₙ « le total est
  pair » ; montrer par récurrence sur n que la suite (p(Aₙ)) est constante.
- **Ex. 20** (p.205) : un gène peut avoir deux états A « allèle dominant » ou a « allèle récessif » ; génotypes « AA »,
  « Aa », « aa » ; un enfant récupère un allèle de chacun de ses deux parents. 1. un parent « AA » et l'autre « Aa » :
  a. probabilité que l'enfant soit « AA » ? b. « Aa » ? 2. les deux parents « Aa » : a. « AA » ? b. « Aa » ? c. « aa » ? 3. pₙ, qₙ, rₙ = probabilités qu'un individu de la nᵉ génération soit « AA », « Aa » ou « aa ». À l'aide d'un arbre,
  montrer a. p_{n+1} = (pₙ + qₙ/2)². b. r_{n+1} = (qₙ/2 + rₙ)². c. q_{n+1} = 1 − (pₙ + qₙ/2)² − (qₙ/2 + rₙ)². 4. soit
  α = p₀ − r₀. a. montrer que pour tout n, pₙ − rₙ = α. b. montrer que 2rₙ + qₙ = 1 − α. 5. en déduire que les suites
  (pₙ), (qₙ) et (rₙ) sont constantes.
- **Ex. 21** (p.205) : une publicité annonce « Un billet sur deux est gagnant, achetez deux billets » ; on suppose
  qu'exactement un billet sur deux est gagnant. 1. cent billets en vente, un promeneur en achète deux ; probabilité
  qu'il ait au moins un billet gagnant ? 2. 2n billets en vente, il en achète deux ; pₙ = probabilité d'au moins un
  gagnant. a. montrer que pₙ = (3n − 1)/(4n − 2). b. calculer p₁ et expliquer. c. montrer que pour tout n non nul,
  3/4 ≤ pₙ ≤ 1. 3. chaque jour 2n billets en vente ; un promeneur revient trois jours acheter deux billets. a. qₙ =
  probabilité qu'il obtienne au cours des 3 jours au moins un billet gagnant ? b. étudier la limite de (qₙ).
- **Ex. 22** (p.205) : dans une loterie, chaque billet a une chance sur 100 d'être gagnant. 1. on achète n billets, A
  « avoir au moins un billet gagnant » ; exprimer p(A) en fonction de n. 2. combien de billets faut-il acheter pour que
  p(A) > 0.5 ?
- **Ex. 23** (p.206) : un sac contient n boules rouges et 2n boules noires indiscernables, chacune ayant la même
  probabilité d'être tirée ; on tire simultanément trois boules. 1. pₙ = probabilité d'une seule rouge ; en déduire que
  (pₙ) possède une limite finie p. 2. qₙ = probabilité d'au moins une rouge ; en déduire que (qₙ) possède une limite
  finie q. 3. on effectue trois tirages successifs d'une seule boule avec remise. a. montrer que la probabilité d'une
  seule boule rouge est p. b. la probabilité d'au moins une boule rouge est q.
- **Ex. 24** (p.206) : un lot de n pièces contient une pièce défectueuse. 1. une machine teste les pièces une par une
  jusqu'à détecter la défectueuse ; elle effectue le nᵉ test dans le cas où il ne reste que la pièce défectueuse ; X =
  nombre de tests effectués. a. probabilité d'un seul test ? b. exactement deux tests ? c. loi de X. d. espérance et
  variance de X. (On rappelle Σ_{k=1}^{n} k² = n(n + 1)(2n + 1)/6.) 2. les tests sont effectués par un homme qui, s'il
  ne reste que deux pièces, fait un test supplémentaire ; Y = nombre de tests. a. un seul test ? b. exactement n − 1
  tests ? c. loi de Y. d. espérance et variance de Y.
- **Ex. 25** (p.206) : un joueur joue à pile ou face : il gagne dès que le nombre de piles dépasse de deux le nombre de
  faces ; il perd dès que le nombre de faces dépasse de deux le nombre de piles. La pièce amène pile avec probabilité
  5/12 et face avec 7/12. 1. montrer que le joueur doit jouer un nombre pair de lancers pour gagner. 2. probabilité de
  gagner au plus au bout de 2 lancers. 3. au plus 4 lancers. 4. au plus n lancers. 5. au plus 20 lancers.
- **Ex. 26** (p.206) : on choisit un nombre x au hasard dans l'intervalle [0, 1]. 1. probabilité que x soit égal à 0.1 ?
  0.0005 ? 0.99999 ? 2. probabilité que x appartienne à [0.5, 1] ? 3. à [0.001, 0.002] ? 4. que x soit plus petit que
  0.99999 ? 5. plus grand que 0.99999 ?
- **Ex. 27** (p.206–207) : dans la journée, un bus passe toutes les 20 minutes à une station ; X = temps d'attente d'une
  personne ; on suppose que X suit une loi uniforme sur [0, 20]. 1. probabilité d'attendre entre 2 et 5 minutes ? 2.
  entre 10 et 13 minutes ? 3. exactement 3 minutes ? 4. moins de 3 minutes ? 5. plus de 3 minutes ?
- **Ex. 28** (p.207) : la durée de vie X, exprimée en années d'une machine, suit une loi exponentielle de paramètre 0.2.
  1.a. calculer p(X = 10). b. p(X ≤ 10). c. p(X ≥ 10). 2. déterminer le réel c tel que P(X ≤ c) = P(X ≥ c).
- **Ex. 29** (p.207) : la durée de vie (en années) d'un robot, jusqu'à ce que survienne la première panne, suit une loi
  exponentielle de paramètre 0.0005. 1. probabilité qu'un robot ait une durée de vie comprise entre 5 et 8 ans ? 2.
  qu'un robot dépasse 5 ans ? 3. qu'un robot dépasse 8 ans ?
- **Ex. 30** (p.207) : une machine fabrique des cylindres ; on mesure l'écart X, en dixièmes de millimètres, entre le
  diamètre des cylindres et la valeur de réglage ; X suit une loi exponentielle de paramètre 1.5. 1. calculer à 10⁻³
  près P(X ≤ 1), P(X ≥ 2) et P(1 ≤ X ≤ 2). Si l'écart < 1, le cylindre est accepté ; entre 1 et 2, une rectification
  permet de l'accepter dans 80 % des cas ; > 2, il est refusé. 2. on prélève au hasard un cylindre. a. probabilité
  qu'il soit accepté ? b. il est accepté ; probabilité qu'il ait subi une rectification ?
- **Ex. 31** (p.207) : la durée de vie d'une machine (en années), jusqu'à la première panne, est une variable aléatoire
  X suivant une loi exponentielle de paramètre λ. 1. déterminer λ à 10⁻¹ près pour que P(X > 6) = 0.3 ; dans la suite on
  prendra λ = 0.2. 2. à quel instant t, à un mois près, la probabilité qu'une machine tombe en panne pour la première
  fois est-elle de 0.5 ? 3. probabilité qu'une machine n'ait pas de panne au cours des deux premières années ? 4. lot
  de cinq machines fonctionnant indépendamment ; probabilité qu'au moins une n'ait pas eu de panne au cours des deux
  premières années ?

### Bornes de scope observées (chapitre 18)

- ✅ INCLUS : **Dénombrement** (p-uplets nᵖ, permutations n!, arrangements A_n^p = n!/(n − p)!, combinaisons
  C_n^p = n!/((n − p)!p!) avec C_n^0 = 1, formule de Pascal C_n^p = C_{n−2}^{p−2} + 2C_{n−2}^{p−1} + C_{n−2}^p, somme
  Σ C_n^k = 2ⁿ) ; **probabilité sur un ensemble fini** (univers, événement, événement élémentaire/certain/impossible,
  événements contraires et incompatibles, axiomes p(E) = 1, p(∅) = 0, additivité ; propriétés p(A̅) = 1 − p(A),
  p(A ∪ B) = p(A) + p(B) − p(A ∩ B)) ; **équiprobabilité** (probabilité uniforme p(A) = card A / card E) ; **probabilité
  conditionnelle** (p_B(A) = p(A ∩ B)/p(B), notation p(A/B), arbre pondéré) ; **événements indépendants**
  (p(A ∩ B) = p(A)p(B), p(A/B) = p(A)) ; **partition et formule des probabilités totales**
  (p(A) = Σ p(Bᵢ)p_{Bᵢ}(A)) — et implicitement les probabilités des causes (Bayes) via les exercices résolus ;
  **variables aléatoires** (aléa numérique X : E → ℝ, événement (X = xᵢ), loi de probabilité, Σ p(X = xᵢ) = 1) ;
  **espérance et variance** (E(X) = Σ xᵢpᵢ, linéarité E(αX) = αE(X), E(X + Y) = E(X) + E(Y), V(X) = E((X − E(X))²) =
  E(X²) − (E(X))², écart-type σ = √V) ; **fonction de répartition** (F : x ↦ p(X ≤ x), en escalier pour une v.a.
  discrète) ; **loi binomiale** B(n, p) (p(X = k) = C_n^k pᵏ(1 − p)^{n−k}, loi de Bernoulli n = 1, E(X) = np,
  V(X) = np(1 − p)) ; **lois continues** — **loi uniforme** sur [a, b] (densité 1/(b − a), P(c ≤ X ≤ d) = (d − c)/(b − a),
  fonction de répartition en rampe) et **loi exponentielle** de paramètre λ (densité λe^{−λt}, P(0 ≤ X ≤ c) = 1 − e^{−λc},
  P(X ≥ c) = e^{−λc}, fonction de répartition). Le chapitre réinvestit le **calcul intégral** (chap. 6) pour les lois
  continues et les **suites** (arithmético-géométriques, récurrence, limites) dans de nombreux exercices de modélisation
  probabiliste (chaînes à deux états : ex. 11, 12, 20).
- ⛔ NON traité / supposé acquis : l'**intégration** et le **calcul de primitives** (établis aux chapitres 5–6, ici
  réutilisés pour les densités continues) ; les **suites géométriques et arithmético-géométriques** et le **raisonnement
  par récurrence** (chap. 2, ici réinvestis) ; la **loi de Poisson**, la **loi normale** et les **théorèmes limites**
  (loi des grands nombres, théorème central limite) ne sont **pas** abordés ; l'**espérance et la variance d'une loi
  continue** (uniforme/exponentielle) ne sont pas définies (seules les probabilités d'intervalles le sont) ; la
  **formule de Bayes** n'est pas énoncée comme théorème (les probabilités des causes sont calculées cas par cas via
  l'arbre et la formule des probabilités totales) ; l'**indépendance mutuelle** de plus de deux événements n'est pas
  formalisée. Le chapitre suppose acquises la **manipulation des ensembles** (réunion, intersection, complémentaire) et
  la **combinatoire** de base ; il clôt le programme de probabilités du bac Math (chap. 18) avant les statistiques
  (chap. 19).

## 2.19 Chapitre 19 — Statistiques (manuel 222446, p.208–230)

**Page de garde (p.208)** — Titre de couverture : « Statistiques », Chapitre 10 (numérotation interne du tome 2 ;
c'est le chapitre 19 dans la numérotation content ; le bandeau courant écrit « Statistiques »). Encart historique
(titre : « Huygens (1669) : Espérance de vie. ») : « "Par les observations faites à Londres avec beaucoup d'exactitude.
De 100 personnes conçues, il en meurt […]. Donc, de 100 personnes, ceux qui atteignent l'âge de 6 ans sont 64, de
16 ans sont 40, de 26 ans sont 25, de 36 ans sont 16, de 46 ans sont 10, de 56 ans sont 6, de 66 ans sont 3, de 76 ans
est 1 et de 86 ans est 0. Qui gagerait qu'un enfant conçu virait jusqu'à 6 ans, peut mettre 64 contre 36 ou 16 contre 9.
Et qui gagerait […]. De 100 enfants conçus, il en meurt 36 avant l'age de 6 ans, lesquels on peut dire ont vécu l'un
portant l'autre 3 ans. Des 64 restants, il en meurt 24 avant l'âge de 16 ans […]." Une correspondance de Huygens sur la
statistique démographique. Huygens aboutit au total 1822 en multipliant 36 par 3, 24 par 11, jusqu'à 1 par 81 et en
ajoutant tous les produits ainsi obtenus puis calcul le quotient de 1822 par 100 et déclare :" Et le quotient qui est
ici 18 ans et environ 2 mois et demi, ce n'est pas à dire qu'il soit apparent qu'il vivra si longtemps, car il est
beaucoup plus apparent qu'il mourra avant ces termes." » Référence : « (J Dhombres et al, Mathématiques au fil des âges,
1987). » Le chapitre porte sur les **séries statistiques doubles** et est structuré en trois grandes parties
**I. Distributions marginales**, **II. Covariance d'une série statistique double** (**II.1 Cas d'un échantillon
simple**, **II.2 Cas d'un échantillon groupé**) et **III. Ajustement d'une série statistique double** (**III.1 Méthode
de Mayer**, **III.2 Méthode d'ajustement par les moindres carrés**, **III.3 Coefficient de corrélation linéaire**,
**III.4 Exemple d'ajustement non affine**), ponctuées d'activités, d'encadrés (définitions / propriétés / théorème),
d'exercices résolus et de rubriques « Utilisation d'une calculatrice », suivies d'une rubrique « Exercices et problèmes ».
**Ce chapitre comporte 3 « exercices résolus »** intégrés au cours (p.213–215, p.222–223 et un « Activité » terminal
p.224). Texte liminaire (p.209) : « Il arrive que l'on soit amené à effectuer deux séries de mesure X et Y sur un même
échantillon composé de n individus et que l'on s'interroge sur les relations possibles entre ces mesures. On dit alors
que l'on a une série statistique double (X, Y). » Notation du manuel : X̄, Ȳ pour les moyennes marginales, σ_X, σ_Y pour
les écart-types, V(X) pour la variance, cov(X, Y) pour la covariance, ρ_XY pour le coefficient de corrélation linéaire.

### Cours — Activités

**I. Distributions marginales** (p.209)

- **Activité 1** (p.209) : on a relevé dans un tableau à double entrée l'intensité de travail X (en kilojoules par
  minute ; valeurs 9.6, 12.8, 18.4, 31.2, 36.8, 47.2, 49.6, 56.8) et la fréquence cardiaque Y (valeurs 70, 86, 90, 104)
  de 100 personnes ; effectifs marginaux Total X = (9, 13, 30, 21, 13, 6, 4, 4) et Total Y = (6, 21, 28, 45) ; le nombre
  12 est encadré dans le tableau à la case (Y = 104, X = 18.4). 1.a. quelle est la signification du nombre 12 encadré
  dans le tableau ? b. nombre d'individus dont la fréquence cardiaque est supérieure à 100 ? c. nombre d'individus qui
  ont fourni un travail d'intensité supérieure à 49 ? d. nombre d'individus ayant un travail d'intensité supérieure à 49
  et une fréquence cardiaque supérieure à 100 ? 2. déterminer la distribution marginale de X, puis calculer la moyenne X̄
  et l'écart-type σ_X. 3. déterminer la distribution marginale de Y, puis calculer la moyenne Ȳ et l'écart-type σ_Y.
  **(Tableau p.209 : série double à double entrée X × Y, 8 × 4 cases + totaux.)**
- **Activité 2** (p.210) : on a recueilli dans un tableau la distance parcourue X (en mille km) avant la première grande
  panne et la puissance Y (en chevaux) de 20 voitures (couples (42, 4), (55, 5), (57, 6), (81, 6), (64, 4), (70, 7),
  (75, 6), (58, 5), (61, 4), (65, 5), (48, 4), (58, 4), (65, 4), (72, 6), (75, 4), (80, 7), (65, 7), (73, 5), (43, 6),
  (61, 5)). 1.a. quelles sont les valeurs prises par Y ? b. calculer la moyenne Ȳ et l'écart-type σ_Y. 2. compléter le
  tableau donnant la répartition des 20 voitures suivant la distance parcourue (classes : « Moins de 50 », [50, 60[,
  [60, 70[, « 70 et plus »). 3. déterminer le pourcentage des voitures ayant parcouru une distance inférieure à 60 000 km
  et qui ont une puissance supérieure ou égale à 6 chevaux. **(Deux tableaux p.210.)**
- **Activité 3** (p.211) : on a reproduit dans un tableau à double entrée les effectifs d'individus d'un échantillon
  selon leur poids X (en kg ; classes [40, 45[, [45, 50[, [50, 55[, [55, 60[) et leur taille Y (en cm ; classes
  [120, 155[, [155, 160[, [160, 165[, [165, 170[), avec effectifs et fréquences marginaux (effectifs selon la taille :
  30, 25, 23, 22 ; fréquences 0.30, 0.25, 0.23, 0.22 ; effectifs selon le poids : 22, 33, 24, 21 ; fréquences 0.22, 0.23,
  0.24, 0.21 ; total 100). 1. déterminer la distribution marginale de X et celle de Y. 2. calculer la moyenne X̄ et
  l'écart-type σ_X de la variable X. 3. calculer la moyenne Ȳ et l'écart-type σ_Y de la variable Y. **(Tableau p.211 :
  série double 4 × 4 + marges effectifs/fréquences.)**

**II. Covariance d'une série statistique double** — **II.1 Cas d'un échantillon simple** (p.211)

- **Activité 1** (p.211–212) : on a relevé dans un tableau les exportations X (en million de dinars) et les importations
  Y (en million de dinars) mensuelles de la Tunisie pour l'année 2006 (Janvier (1081.1 ; 1312.1), Février (1225.6 ;
  1367.6), Mars (1378.6 ; 1641.6), Avril (1193.7 ; 1613.1), Mai (1205.8 ; 1827.3), Juin (1374.6 ; 1705.8), Juillet
  (1283.8 ; 1713.4), Août (1157.8 ; 1494.1), Septembre (1349.4 ; 1859.8), Octobre (1230.1 ; 1668.1), Novembre (1488.5 ;
  1902.6), Décembre (1347.3 ; 1660.6)). 1. déterminer la taille de l'échantillon étudié. 2.a. calculer la moyenne X̄ et
  l'écart-type σ_X de X. b. calculer la moyenne Ȳ et l'écart-type σ_Y de Y. 3. calculer (1/12)Σ_{i=1}^{12} xᵢyᵢ − X̄·Ȳ.
  **(Tableau p.211 : 12 mois × (X, Y).)**
- **Activité 2** (p.212) : on a relevé le nombre de logements X (en milliers) et le nombre de logements modernes (villa,
  appartement) Y durant quelques années (1984 (1313.1 ; 265.2), 1989 (1512.3 ; 343.3), 1994 (1870.1 ; 630.2), 1999
  (2204.3 ; 848.7), 2004 (2501.0 ; 1128.0)). 1. représenter le nuage de points de la série (X, Y). 2.a. calculer X̄ et Ȳ.
  b. calculer cov(X, Y) ; interpréter le résultat. **(Tableau p.212.)**
- **Activité 3** (p.213) : dans un graphique on a représenté les points M(X, Y), où X désigne le nombre de logements (en
  milliers) et Y le pourcentage des logements traditionnels pour la même année (abscisses 1313, 1512.3, 1870.1, 2204.3,
  2501.0 ; ordonnées ≈ 71, 72.4, 63.6, 60.3, 54.1). Quel est le signe de cov(X, Y) ? **(Figure p.213 : nuage de 5 points
  décroissant.)**

**II.2 Cas d'un échantillon groupé** (p.213)

- **Exercice résolu** (p.213–215) : un tableau à double entrée donne le poids Y (en kg ; classes ]1.5, 2.5], ]2.5, 3.5],
  ]3.5, 4.5]) de 63 nouveaux-nés ainsi que le poids maternel X (classes ]40, 50], ]50, 60], ]60, 70], ]70, 80]) ;
  effectifs (ligne ]1.5, 2.5] : 1, 0, 1, 0 ; ligne ]2.5, 3.5] : 11, 17, 13, 2 ; ligne ]3.5, 4.5] : 4, 4, 8, 2 ; totaux
  colonnes 16, 21, 22, 4 ; total 63). 1. calculer X̄ et σ_X, ainsi que Ȳ et σ_Y. 2. déterminer la covariance de X et Y ;
  interpréter. **Solution résumée** (p.214–215) : centres des classes de X : (45, 55, 65, 75) d'effectifs (16, 21, 22, 4),
  Σnᵢxᵢ = 3605, Σnᵢxᵢ² = 211375, X̄ ≈ 57.2222, V(X) ≈ 80.776, σ_X ≈ 8.9875 ; centres de Y : (2, 3, 4) d'effectifs
  (2, 43, 18), Σnⱼyⱼ = 205, Σnⱼyⱼ² = 683, Ȳ ≈ 3.2539, V(Y) ≈ 0.2529, σ_Y ≈ 0.5029 ; couples distincts (xᵢ, yⱼ) et leurs
  effectifs nᵢⱼ (10 couples, ΣΣnᵢⱼxᵢyⱼ = 11775) donnent cov(X, Y) = (1/63)×11775 − X̄·Ȳ ≈ 0.7. **Interprétation** : la
  covariance est positive donc X et Y ont tendance à varier dans le même sens. **(Tableaux de calcul p.214–215.)**
- **Utilisation d'une calculatrice** (p.215) : mode d'emploi d'une calculatrice pour retrouver les résultats précédents
  (MODE 1 puis 1 pour le sous-mode statistique à deux variables ; saisie xᵢ STO yⱼ STO nᵢⱼ M+ ; par exemple pour le
  couple (55, 3) : 55 STO 3 STO 17 M+ ; RCL n → 63 ; RCL Σx → 3605 ; RCL Σx² → 211375 ; RCL X̄ → 57.22222222 ;
  RCL σ_X → 8.987547725 ; RCL σ_X x² → 80.77601411 (valeur de V(X)) ; RCL Σxy → 11775 ; RCL Σxy ÷ 63 − RCL X̄ × RCL Ȳ →
  0.705467372 (valeur de cov(X, Y))).
- **Activité 1** (p.216) : dans une population de 100 ménages, on a considéré le nombre d'enfants X (valeurs 0, 1, 2, 3,
  4, 5) et le revenu du chef de famille Y (en DT ; classes « Moins de 200 », [200, 400[, [400, 600[, [600, 800[), rangés
  dans un tableau à double entrée (ligne « Moins de 200 » : 6, 4, 1, 0, 0, 0, total 11 ; ligne [200, 400[ : 3, 11, 10, 5,
  1, 0, total 30 ; ligne [400, 600[ : 1, 3, 16, 13, 4, 1, total 38 ; ligne [600, 800[ : 0, 1, 3, 5, 8, 4, total 21 ;
  totaux colonnes 10, 19, 30, 23, 13, 5). 1.a. déterminer le nombre de ménages qui ont 4 enfants et dont le revenu est
  supérieur à 600 dinars. b. nombre de ménages sans enfants ayant un revenu inférieur à 200 dinars. c. nombre de ménages
  qui ont moins de 4 enfants et dont le revenu est compris entre 400 et 600 dinars. 2.a. calculer X̄ et σ_X. b. calculer
  Ȳ et σ_Y. 3.a. peut-on prévoir le signe de la covariance de X et Y ? b. calculer la covariance de X et Y. **(Tableau
  p.216.)**

**III. Ajustement d'une série statistique double** (p.216) — texte liminaire : « Lorsqu'un statisticien étudie une série
statistique double. L'une des questions qu'il se pose est : peut-on prévoir la valeur de Y lorsqu'on connaît la variable
X ? Pour répondre à une telle question, le statisticien essaiera de trouver une fonction f qui modélise le phénomène
étudié, grâce à la relation Y = f(X). Dans ce cas, on dit que X est la variable explicative et Y est la variable
expliquée. […] Par conséquent faire un ajustement affine consiste à déterminer deux réels a et b tels que Y = aX + b soit
un modèle acceptable du phénomène étudié. La droite d'équation y = ax + b sera appelée droite d'ajustement affine de Y
en X. »

**III.1 Méthode de Mayer** (p.217)

- **Activité 1** (p.217) : on a relevé le montant total (en million de dinars) du commerce extérieur en Tunisie
  (importations X et exportations Y) de 1990 à 2004 (15 années : 1990 (4826.4 ; 3087.4), 1991 (4788.9 ; 3417.1),
  1992 (5688.8 ; 3549.7), 1993 (6172.1 ; 3760), 1994 (6647.3 ; 4696.6), 1995 (7464.3 ; 5172.5), 1996 (7498.8 ; 5372),
  1997 (8793.5 ; 6147.9), 1998 (9489.5 ; 6518.3), 1999 (10070.5 ; 6966.9), 2000 (11738 ; 8004.8), 2001 (13697.3 ;
  9536.2), 2002 (13510.9 ; 9748.6), 2003 (14038.9 ; 10342.6), 2004 (15960.3 ; 12054.9)). 1.a. calculer X̄ et σ_X. b.
  calculer Ȳ et σ_Y. 2. on a représenté le nuage de points de la série double (X, Y) ; placer le point G(X̄, Ȳ). 3. on
  scinde l'ensemble des 15 points du nuage en deux parties : la partie (I) correspond aux valeurs observées entre 1990 et
  1997 et la partie (II) entre 1998 et 2004 ; G₁ et G₂ sont les points moyens respectifs de (I) et (II). a. déterminer
  les coordonnées de G₁ et G₂ ; vérifier que G, G₁ et G₂ sont alignés et tracer la droite (G₁G₂). b. comment semblent se
  répartir les points du nuage autour de la droite (G₁G₂) ? c. donner alors un ajustement affine de la série double
  (X, Y). d. donner une estimation du montant des exportations si le montant de l'importation est égal à 17000 millions
  de dinars. **(Tableau p.217 + figure p.217 : nuage de 15 points croissant.)**
- **Activité 2** (p.218) : le mur d'une habitation est constitué par une couche de béton et une couche de polystyrène
  d'épaisseur variable X (en cm) ; on a mesuré la résistance thermique R (en m²·°C/W) de ce mur pour divers valeurs de X
  (couples (2 ; 0.83), (4 ; 1.34), (6 ; 1.63), (8 ; 2.3), (10 ; 2.44), (12 ; 2.93), (14 ; 3.44), (16 ; 3.85),
  (18 ; 4.28)). 1. tracer le nuage de la série (X, R). 2. déterminer un ajustement affine de R en X par la méthode de
  Mayer. 3. quelle résistance thermique peut-on espérer obtenir avec une épaisseur de polystyrène de 25 cm ? **(Tableau
  p.218.)**

**III.2 Méthode d'ajustement par les moindres carrés** (p.218) — texte liminaire (p.218) : « Nous avons représenté […] le
nuage de points Mᵢ(xᵢ, yᵢ), 1 ≤ i ≤ n, d'une série statistique double, ainsi qu'une droite D d'équation y = ax + b. Pour
tout entier 1 ≤ i ≤ n, on note Hᵢ(xᵢ, zᵢ) le point de la droite D de même abscisse que Mᵢ. » Puis (p.219) : « Le principe
de la méthode d'ajustement par la méthode des moindres carrés consiste à déterminer les réels a et b tels que la somme
Σ_{i=1}^{n} MᵢHᵢ² soit minimale. Dans ce cas, le statisticien pourra faire des prévisions en remplaçant la valeur
observée yᵢ par la valeur théorique zᵢ = axᵢ + b. » **(Figure p.218 : droite D = ax + b et points Mᵢ, Hᵢ projetés
verticalement.)**

- **Activité 1** (p.219) : le tableau donne le chiffre d'affaire annuel en mille DT d'une société pendant huit années
  consécutives (rang de l'année X = 1..8 ; chiffre d'affaires (13.6, 15, 15.8, 17, 18, 20, 19, 20)). 1.a. représenter le
  nuage de points de la série (X, Y). b. un ajustement affine de cette série est-il justifié ? 2. déterminer les
  coordonnées du point moyen G de ce nuage. 3.a. tracer dans le même repère la droite D d'équation y = 1.6x + 10.1.
  b. calculer la somme S_D = Σ_{i=1}^{8} [yᵢ − (1.6xᵢ + 10.1)]². 4. on considère une droite Δ d'ajustement de Y par
  rapport à X obtenue par la méthode de Mayer. a. déterminer l'équation de Δ sous la forme y = ax + b (a et b à 10⁻¹
  près). b. calculer la somme S_Δ = Σ_{i=1}^{8} [yᵢ − (axᵢ + b)]². 5. comparer S_D et S_Δ. 6. estimer le chiffre
  d'affaires de cette société à sa dixième année. **(Tableau p.219.)**
- **Activité 2** (p.220–221) : dans le tableau on a relevé le poids (en kg) et la surface corporelle (en m²) de 15 sujets
  (couples (15 ; 0.58), (20 ; 0.7), (25 ; 0.8), (29 ; 0.9), (34 ; 1), (39 ; 1.1), (44 ; 1.2), (50 ; 1.3), (55 ; 1.4),
  (60 ; 1.5), (65 ; 1.56), (70 ; 1.64), (74 ; 1.74), (80 ; 1.8), (85 ; 1.9)). 1.a. calculer X̄ et σ_X. b. calculer Ȳ et
  σ_Y. 2. déterminer la covariance de la série (X, Y). 3. on a représenté le nuage de la série (X, Y). a. placer le point
  G(X̄, Ȳ). b. comment semblent se répartir les points du nuage ? c. donner alors un ajustement affine par les moindres
  carrés de la série double (X, Y). 4. donner une estimation de la surface corporelle d'un sujet qui pèse 62 kg.
  **(Tableau p.220 + figure p.221 : nuage de 15 points croissant.)**

**III.3 Coefficient de corrélation linéaire** (p.221) — texte liminaire : « On peut toujours au vu des formules
précédentes construire une droite de régression. Mais parfois cette dernière n'est d'aucune efficacité, dans la mesure
où les prédictions que l'on fait à partir de cette droite ne sont pas raisonnables. Pour savoir s'il est pertinent
d'ajuster un nuage de point par les moindres carrés, on calcule un réel appelé coefficient de corrélation linéaire. »

- **Activité 1** (p.222) : le tableau donne l'effectif de la population scolaire de la 3ᵉ année de l'enseignement
  secondaire du mois d'octobre 1997 au mois d'octobre 2002 (année X = 1997..2002 ; population Y = (67755, 74581, 79266,
  76138, 80123, 90087)). 1. calculer le coefficient de corrélation linéaire. 2. déterminer un ajustement par les moindres
  carrés de la série double (X, Y) puis donner une estimation de la population scolaire en 3ᵉ année secondaire au mois
  d'octobre 2010. **(Tableau p.222.)**
- **Activité 2** (p.222) : on donne la série double (à double entrée) relative aux voitures selon leur puissance Y (20,
  25, 30) et la durée des pneumatiques X (2, 3, 4, en millier de kilomètres) ; effectifs (ligne Y = 20 : 0, 8, 30,
  total 38 ; ligne Y = 25 : 5, 20, 7, total 32 ; ligne Y = 30 : 25, 3, 2, total 30 ; totaux colonnes 30, 31, 39 ;
  total 100). 1. calculer le coefficient de corrélation linéaire. 2. un ajustement par les moindres carrés est-il
  justifié ? **(Tableau p.222 : série double 3 × 3 + marges.)**

**III.4 Exemple d'ajustement non affine** (p.222)

- **Exercice résolu** (p.222–223) : le tableau indique l'évolution du personnel paramédical tunisien dans le secteur
  public (techniciens supérieurs, infirmiers, auxiliaires de santé) de 1990 à 2005 (Paramédicaux : 1990 → 23743, 1991 →
  24555, 1992 → 25070, 1993 → 25291, 1994 → 25466, 1995 → 25874, 1996 → 26130, 1997 → 26369, 1998 [imprimé « 19989 »
  [sic]] → 26676, 1999 → 27050, 2000 → 27392, 2001 → 30292, 2002 → 28629, 2003 → 29976, 2004 → 29584, 2005 → 29607).
  1. en numérotant les années de 0 à 15, déterminer les valeurs de la série double (X, ln Y), où X est le rang de l'année
     et Y le nombre de paramédicaux. 2. on pose Z = ln Y. a. calculer le coefficient de corrélation et justifier que l'on
     peut procéder à un ajustement affine par les moindres carrés de la série (X, Z). b. donner la droite de régression de Z
     en X. 3. quel sera le nombre de paramédicaux en 2010 ? **Solution résumée** (p.223) : tableau des xᵢ, yᵢ, zᵢ = ln(yᵢ),
     xᵢ², zᵢ², xᵢzᵢ ; X̄ = 7.5, σ_X ≈ 4.6, Z̄ ≈ 10.199, σ_Z ≈ 0.074, Cov(X, Z) ≈ 0.326, ρ_XZ ≈ 0.960 (« Le coefficient de
     corrélation est très proche de 1 ; l'ajustement est donc justifié ») ; droite de régression z = [0.326/(4.61)²](x − 7.5)
  - 10.199, soit z = 0.015(x − 7.5) + 10.199 ; le nombre de paramédicaux en 2010 sera de e^{0.015(20−7.5)+10.199} ≈ 32419.
    **(Tableaux de calcul p.222–223.)**
- **Utilisation d'une calculatrice** (p.223) : dans cet exercice la série est à données simples ; saisie xᵢ STO yᵢ M+ ;
  RCL r pour le coefficient de corrélation ; RCL b pour la pente de la droite de régression de Y en X ; RCL a pour
  l'ordonnée à l'origine de la droite de régression de Y en X.
- **Activité** (p.224) : la résistance à l'avancement d'un poids lourd est une fonction de la vitesse ; on cherche la
  meilleure expression possible de cette fonction dans un intervalle de vitesse compris entre 10 km/h et 100 km/h ; cette
  résistance est mesurée en kW (couples V (km/h) → R (kW) : 10 → 2.6, 20 → 5.8, 30 → 9.9, 40 → 15.4, 50 → 23.6, 60 → 34.5,
  70 → 49, 80 → 67.2, 90 → 89.1). 1. dresser le tableau des valeurs de la série (X, Y) où X = V² et Y = R/V. 2. donner le
  coefficient de corrélation linéaire entre X et Y et une équation de la droite de régression de Y en X. 3. en déduire une
  relation entre R et V. 4. donner une évaluation de la valeur de R pour une vitesse de 100 km/h. **(Tableau p.224.)**

### Cours — Résultats / définitions / théorèmes à retenir (VERBATIM)

> **Définitions (série double, distributions marginales)** (p.210, encadré) — « Soit (X, Y) une série statistique double
> sur un échantillon de taille n et soit (xᵢ, yᵢ)_{1≤i≤n} les valeurs numériques prises respectivement par les variables
> X et Y. La distribution marginale de la variable X est la distribution des valeurs (xᵢ)_{1≤i≤n} prises par la variable
> X. La distribution marginale de la variable Y est la distribution des valeurs (yᵢ)_{1≤i≤n} prises par la variable Y. »

> **Définition (moyenne, variance, écart-type d'une série simple)** (p.210, encadré) — « Soit X une série statistique sur
> un échantillon de taille n. Si X̄, V(X) et σ_X désignent respectivement la moyenne, la variance et l'écart-type de la
> série, alors X̄ = (1/n)Σ_{i=1}^{p} nᵢxᵢ, V(X) = (1/n)Σ_{i=1}^{p} nᵢ(xᵢ − X̄)², σ_X = √(V(X)), où les valeurs x₁, x₂,
> ..., x_p désignent les valeurs distinctes prise par la variable X si elle est discrète, ou les centres des classes si la
> variable X est continue. L'entier nᵢ désigne l'effectif de la valeur xᵢ. »

> **Définition (covariance, échantillon simple)** (p.212, encadré) — « Soit (X, Y) une série statistique double sur un
> échantillon de taille n. On appelle covariance de (X, Y) le réel, noté cov(X, Y) défini par
> cov(X, Y) = (1/n)Σ_{i=1}^{n} xᵢyᵢ − X̄·Ȳ, où (xᵢ, yᵢ) est la valeur observée pour l'individu i si X et Y sont discrètes,
> ou le centre de la classe si l'une des variables est continue. » Remarque (p.212) : « Il découle de la définition que
> cov(X, Y) = cov(Y, X). »

Interprétation de la covariance (p.212) : « La covariance mesure la tendance qu'ont les variables X et Y à varier
ensemble. La covariance est positive si X et Y ont tendance à varier dans le même sens. La covariance est négative si X
et Y ont tendance à varier en sens contraire. »

> **Définition (covariance, échantillon groupé)** (p.213, encadré) — « Soit (X, Y) une série statistique double de taille
> n. Soit nᵢⱼ le nombre de fois qu'apparaît le couple (xᵢ, yⱼ). Alors
> cov(X, Y) = (1/n)Σ_{j=1}^{q}Σ_{i=1}^{p} nᵢⱼxᵢyⱼ − X̄·Ȳ. »

> **Définition (nuage de points, point moyen)** (p.218, encadré) — « Soit (X, Y) une série statistique double de valeurs
> (xᵢ, yᵢ)_{1≤i≤n}. L'ensemble des points Mᵢ de coordonnées (xᵢ, yᵢ) dans un repère orthogonal est appelé nuage de points
> représentant la série statistique. Le point moyen du nuage est le point dont les coordonnées sont les moyennes X̄ et
> Ȳ. »

> **Principe de la méthode de Mayer** (p.218, encadré) — « Soit un nuage de points représentant une série statistique
> double (X, Y) et G son point moyen. On scinde le nuage de points de (X, Y) en deux parties contenant à peu prés le même
> nombre de points. On considère alors les points moyens G₁ et G₂ des deux nuages obtenus. La droite (G₁G₂) définit un
> ajustement affine du nuage de points représentant la série statistique double (X, Y). La droite (G₁G₂) est appelée
> droite de Mayer et passe par le point moyen G du nuage global. »

> **Théorème (admis)** (p.219, encadré) — « Soit (X, Y) une série statistique double sur un échantillon de taille n et
> telle que σ_X ≠ 0. Soit (xᵢ, yᵢ)_{1≤i≤n} les valeurs observées de la série. Alors la somme Σ_{i=1}^{n} (axᵢ + b − yᵢ)²
> est minimale pour le couple (a₀, b₀) tel que a₀ = cov(X, Y)/σ_X² et b₀ = (Ȳ − (cov(X, Y)/σ_X²)·X̄). »

> **Définition (droites de régression / moindres carrés)** (p.220, encadré) — « Soit (X, Y) une série statistique double
> sur un échantillon de taille n. La droite d'équation y = (cov(X, Y)/σ_X²)(x − X̄) + Ȳ est appelée droite des moindres
> carrés de Y en X, ou droite de régression de Y en X. La droite d'équation x = (cov(X, Y)/σ_Y²)(y − Ȳ) + X̄ est appelée
> droite des moindres carrés de X en Y, ou droite de régression de X en Y. »

> **Conséquence** (p.220, encadré) — « Les droites des moindres carrés de Y en X et de X en Y passent par le point moyen G
> du nuage associé à la série (X, Y). »

> **Définition (coefficient de corrélation linéaire)** (p.221, encadré) — « Soit (X, Y) une série statistique double. On
> appelle coefficient de corrélation linéaire le réel noté ρ_XY défini par ρ_XY = cov(X, Y)/(σ_X σ_Y). »

> **Propriétés (coefficient de corrélation)** (p.221, encadré) — « Soit (X, Y) une série statistique double. Alors
> −1 ≤ ρ_XY ≤ 1. Le coefficient de corrélation linéaire est invariant par changement d'unité ou d'origine. »

Interprétation du coefficient de corrélation linéaire (p.221, encadré) : « Les statisticiens conviennent que lorsque
|ρ_XY| > √3/2, l'ajustement affine est justifié et les prédictions faites au moyen de cet ajustement sont raisonnables. »

### Exercices et problèmes (p.225–230)

> **Note de transcription** : la numérotation imprimée des exercices passe de l'**exercice 12** (p.229) à l'**exercice
> 15** (p.230) ; les **exercices 13 et 14 n'apparaissent pas** dans les pages rendues (p.225–230, contiguës) — les pages
> du chapitre transcrites vont de la 208 à la 230.

- **Ex. 1** (p.225) : pour chacun de quatre graphiques (nuages de points), indiquer si le nuage justifie la recherche
  d'un ajustement affine. **(Figure p.225 : 4 nuages de points — 1. en « V », 2. décroissant, 3. croissant incurvé, 4. décroissant hyperbolique.)**
- **Ex. 2** (p.225) : on a relevé les poids (en kg) respectif de 12 pères (X) et de leurs fils aînés (Y) : (65, 63),
  (63, 61), (67, 66), (64, 62), (68, 67), (62, 60), (70, 69), (66, 65), (68, 67), (67, 67), (69, 66), (71, 70).
  1. tracer le nuage de la série (X, Y). 2. déterminer un ajustement affine par la méthode de Mayer. 3. quel poids devrait
     avoir le fils aîné d'un homme qui pèse 77 kg ? **(Tableau p.225.)**
- **Ex. 3** (p.225–226) : le tableau indique l'évolution du nombre de médecins en Tunisie de 1990 à 2003 (rang de l'année
  X = 1..14 ; nombre de médecins Y = 4425, 4500, 5099, 5257, 5344, 5965, 6177, 6464, 6819, 7149, 7444, 7767, 7964, 8189).
  1. tracer le nuage de la série (X, Y). 2. déterminer le point moyen G(X̄, Ȳ). 3. déterminer un ajustement affine par la
     méthode de Mayer. 4. donner une estimation du nombre de médecin en Tunisie dans l'année 2010 ? **(Tableau p.225.)**
- **Ex. 4** (p.226) : le tableau (à double entrée) donne la répartition d'une population de 100 ménages selon les deux
  caractères X (nombre de pièces habitées, valeurs 1, 2, 3, 4) et Y (nombre d'enfants, valeurs 0, 1, 2, 3, 4) ;
  effectifs (ligne X = 1 : 6, 2, 1, 0, 0, total 9 ; ligne X = 2 : 5, 12, 8, 1, 1, total 27 ; ligne X = 3 : 2, 7, 15, 11,
  3, total 38 ; ligne X = 4 : 0, 1, 8, 14, 3, total 26 ; totaux colonnes 13, 22, 32, 26, 7). 1.a. calculer X̄ et σ_X de X.
  b. calculer Ȳ et σ_Y de Y. 2.a. calculer le coefficient de corrélation entre X et Y. b. un ajustement affine de la série
  (X, Y) est-il justifié ? **(Tableau p.226 : série double 4 × 5 + marges.)**
- **Ex. 5** (p.226) : le tableau donne la charge maximale Y, en tonnes, qu'une grue peut lever pour une longueur X, en
  mètres, de la flèche (couples (9 ; 1.4), (10 ; 1.25), (12 ; 1), (14 ; 0.84), (16 ; 0.7), (18 ; 0.62), (20 ; 0.55),
  (22 ; 0.5)). 1. les réponses numériques à cette question seront données à 10⁻² près. a. représenter le nuage de points
  dans un repère orthogonal. b. déterminer le coefficient de corrélation linéaire entre X et Y. c. déterminer une équation
  de la droite de régression de Y en X ; construire cette droite sur le graphique précédent. d. utiliser cette équation
  pour déterminer la charge maximale que peut lever la grue avec une flèche de 23 mètres. **(Tableau p.226.)**
- **Ex. 6** (p.226–227) : le tableau recense par clinique le nombre de postes du personnel non médical (Y) en fonction du
  nombre de lits (X) de la clinique (C₁ (122 ; 185), C₂ (177 ; 221), C₃ (77 ; 114), C₄ (135 ; 164), C₅ (109 ; 125),
  C₆ (88 ; 118), C₇ (185 ; 193), C₈ (128 ; 160), C₉ (120 ; 151), C₁₀ (146 ; 172), C₁₁ (100 ; 150)). 1. représenter le
  nuage de points associé à la série (X, Y) dans un repère orthogonal. 2. déterminer le coefficient de corrélation
  linéaire entre X et Y. 3. donner une équation de la droite de régression de Y en X (coefficients arrondis à 10⁻¹ près) ;
  tracer cette droite. 4. une clinique possède 35 lits : combien devrait-elle embaucher de personnel occupant un poste non
  médical ? **(Tableau p.226.)**
- **Ex. 7** (p.227) : A/ un club sportif a été créé en 1999, à l'origine le nombre d'adhérents était égal à 600 ; le
  tableau donne le nombre d'adhérents Y de 1999 à 2005 (rang X = 0..6 ; Y = 600, 690, 794, 913, 1045, 1207, 1380). On pose
  Z = ln Y. 1.a. vérifier qu'on peut réaliser un ajustement affine par la méthode des moindres carrés de la série (X, Z).
  b. déterminer une prévision du nombre d'adhérents en 2006. 2. justifier que Y ≈ 602 × (1.15)^X. B/ en fait le club a
  compté 2400 adhérents lors de l'année 2006 ; soit f la fonction définie sur ℝ₊ par f(x) = 3600/(1 + 0.5e^{−x}) ; on
  suppose que le nombre d'adhérents en (2006 + n) est égal à f(n) où n est un entier naturel. 1. déterminer la limite de
  f(n) lorsque n tend vers +∞ et interpréter le résultat. 2.a. reproduire et compléter le tableau (Année 2007..2011,
  n = 1..5, f(n) ; f(1) = 3040). b. calculer la moyenne M du nombre prévisionnel d'adhérents entre 2007 et 2011. 3. calculer la valeur moyenne f̄ de f sur l'intervalle [0.5, 5.5]. **(Tableaux p.227.)**
- **Ex. 8** (p.227) : on a relevé la taille (X, en cm) et le poids (Y, en kg) de 16 jeunes filles (couples (160, 46),
  (165, 48), (167, 48), (160, 46), (168, 49), (170, 51), (160, 45), (162, 45), (165, 48), (170, 49), (170, 51),
  (168, 50), (172, 50), (165, 48), (165, 47), (170, 50)). 1.a. construire, dans un repère orthogonal, le nuage de points
  de la série (X, Y). b. un ajustement affine est-il justifié ? 2.a. déterminer le coefficient de corrélation entre X et Y.
  b. écrire une droite de régression de Y en X. c. donner une estimation de la masse d'une jeune fille mesurant 180 cm. 3. un journal de santé publie la loi de Lorentz qui donne une relation entre le poids M et la taille T pour une jeune
  fille, M = (T − 100) − (T − 130)/2 ; utiliser cette relation pour estimer la masse d'une jeune fille mesurant 180 cm.
  **(Tableau p.227.)**
- **Ex. 9** (p.228) : onze élèves de 7ᵉ année de base travaillent sur la proportionnalité ; ils mesurent le rayon d'un
  disque (série X, en cm) puis évaluent l'aire de ce disque (série Y, en cm²) — couples (2 ; 12), (2.5 ; 20), (3 ; 28),
  (3.5 ; 38), (4 ; 50), (4.5 ; 64), (5 ; 78), (5.5 ; 95), (6 ; 113), (6.5 ; 133), (7 ; 154). 1. les deux séries sont-elles
  proportionnelles ? 2. on pose Z = √Y. a. construire, dans un repère orthogonal, le nuage de points de la série (X, Z)
  (valeurs de Z arrondies à 10⁻¹ près). b. calculer le coefficient de corrélation ρ_XZ ; interpréter le résultat.
  c. déterminer une équation de la droite de régression de Z en X (coefficients arrondis à 10⁻¹ près). d. en déduire une
  valeur approchée de π. **(Tableau p.228.)**
- **Ex. 10** (p.228–229) : une entreprise envisage la fabrication d'un nouveau produit ; une étude a permis d'établir un
  tableau où, pour différentes observations, X désigne la quantité de produit que la clientèle est disposée à acheter et Y
  le prix de vente (en DT) d'une unité (couples (350 ; 140), (400 ; 120), (450 ; 100), (500 ; 95), (550 ; 85), (600 ; 70)).
  1. calculer le coefficient de corrélation ρ_XY. 2. déterminer une équation de la droite de régression de Y en X
     (coefficients arrondis à 10⁻¹ près). 3. soit r(x) la recette correspondant à la vente de x articles au prix unitaire y.
     a. montrer que r(x) = (226.5 − 0.3x)x. b. étudier les variations de la fonction f définie sur ℝ₊ par
     f(x) = −0.3x² + 226.5. c. en déduire le prix de vente pour lequel la recette est maximale ; calculer cette recette
     maximale. **(Tableau p.228.)**
- **Ex. 11** (p.228–229) : le tableau donne la population d'une ville entre les années 1975 et 2005 (Année, rang X, P (en
  milliers d'habitants) : 1975 (0 ; 18), 1980 (5 ; 21), 1985 (10 ; 25), 1990 (15 ; 30), 1995 (20 ; 36), 2000 (25 ; 42),
  2005 (30 ; 50)) ; le nuage de points associé est représenté graphiquement. **A/** 1. calculer le coefficient de
  corrélation entre X et Y. 2.a. déterminer une équation de la droite de régression de Y en X. b. tracer cette droite sur
  le graphique. c. en déduire une estimation de la population en 2008 à un millier prés. **B/** 1. l'allure du nuage
  suggère à chercher un ajustement par une fonction f définie sur [0, +∞[ par f(x) = ae^{bx} où a et b sont des réels ;
  déterminer a et b tels que f(0) = 18 et f(30) = 50 (valeur arrondie de b au millième). 2. déduire de cet ajustement une
  estimation de la population en 2008 à un millier prés. 3. tracer la courbe de f sur le même graphique. 4. la population
  en 2008 était de 55 milliers ; lequel des deux ajustement vous semble le plus pertinent ? justifier. **C/** on considère
  maintenant que la population est donnée en fonction du rang x par f(x) = 18e^{0.034x}. 1. calculer la valeur moyenne f̄
  de la fonction f sur [0, 30] (résultat arrondi au dixième). 2. à l'aide d'une lecture graphique, déterminer l'année au
  cours de laquelle la population atteint cette valeur moyenne. **(Tableau + figure p.228 : nuage de 7 points croissant.)**
- **Ex. 12** (p.229) : le tableau donne l'évolution de la population d'un pays de 1965 à 2000 ; T désigne le rang de
  l'année et P la population en millions d'habitants (1965 (0 ; 8), 1970 (5 ; 8.9), 1975 (10 ; 9.9), 1980 (15 ; 11),
  1985 (20 ; 12), 1990 (25 ; 13.5), 1995 (30 ; 15), 2000 (35 ; 16.6)). **A/** 1. représenter le nuage de points associé à
  la série (T, P) dans un repère orthogonal (2 cm pour 5 unités sur l'axe des abscisses ; 8 à l'origine puis 2 cm pour une
  unité — 1 million d'habitants — sur l'axe des ordonnées). 2. on cherche à modéliser l'évolution par une fonction f dont
  la courbe est voisine du nuage ; on pose Y = ln P. a. donner une valeur approchée à 10⁻³ près par défaut du coefficient
  de corrélation linéaire de la série (T, Y). b. déterminer une équation de la droite de régression de Y en T
  (coefficients arrondis à 10⁻³ près). c. en déduire l'expression de la population P en fonction du rang T de l'année.
  **B/** on admet que la fonction f définie sur [0, 35] par f(t) = 8·e^{0.02t} est une modélisation satisfaisante de
  l'évolution de la population (en millions d'habitants) de 1965 à 2000. 1. étudier le sens de variation de f sur [0, 35]
  et dresser son tableau de variation. 2. construire la courbe représentative de f, notée (C), dans le repère de la partie
  A. 3. on pose I = ∫_0^{35} f(t) dt. a. donner une valeur approchée de I arrondie à 10⁻² près. b. en déduire la population
  moyenne m du pays durant ces 35 années et la représenter sur le graphique. 4. calculer le rapport (f(t + 1) − f(t))/f(t)
  et en donner une interprétation en terme de pourcentage. 5. si le modèle exponentiel étudié dans la partie B restait
  valable après 2000, en quelle année la population aurait-elle dépassé les 19 millions d'habitants ? **(Tableau p.229.)**
- **Ex. 15** (p.230) : on étudie la croissance d'une plante à partir d'un instant considéré comme initial ; le tableau
  indique le diamètre D de la tige (en centimètres) après T semaines (Temps T → Diamètre D : 0 → 0.4, 2 → 1.2, 6 → 5.4,
  8 → 5.8, 10 → 6.4, 12 → 6.9). 1. représenter le nuage de points associé à cette série statistique. 2. on pose
  U = ln(8/D − 1). a. calculer le coefficient de corrélation linéaire de la série (T, U). b. déterminer par les moindres
  carrés une équation de la droite d'ajustement de U en T. c. vérifier que pour cette plante, le diamètre de sa tige
  principale est donné par une relation de la forme D(t) = 8/(1 + ce^{−at}) où a et c sont deux réels que l'on précisera.
  3.a. pour les valeurs de a et c trouvées, tracer dans le repère précédent la fonction f : t ↦ D(t) pour t ≥ 0. b. le
  diamètre de la plante dépassera-t-il 8 cm ? **(Tableau p.230.)**

### Bornes de scope observées (chapitre 19)

- ✅ INCLUS : **séries statistiques doubles** (X, Y) et **distributions marginales** (distribution des xᵢ, des yⱼ,
  moyennes marginales X̄, Ȳ, écart-types σ_X, σ_Y — rappel du cours de série simple : moyenne, variance
  V(X) = (1/n)Σnᵢ(xᵢ − X̄)², écart-type) ; **covariance** cov(X, Y) = (1/n)Σxᵢyᵢ − X̄·Ȳ dans le cas d'un échantillon
  simple et cov(X, Y) = (1/n)ΣΣnᵢⱼxᵢyⱼ − X̄·Ȳ dans le cas groupé, symétrie cov(X, Y) = cov(Y, X), interprétation du signe
  (variation dans le même sens / en sens contraire) ; **nuage de points** et **point moyen** G(X̄, Ȳ) ; **ajustement
  affine** — **méthode de Mayer** (scinder le nuage en deux, droite (G₁G₂) passant par G) et **méthode des moindres
  carrés** (minimisation de Σ MᵢHᵢ², théorème admis a₀ = cov(X, Y)/σ_X², b₀ = Ȳ − a₀X̄) ; **droites de régression** de Y
  en X (y = (cov/σ_X²)(x − X̄) + Ȳ) et de X en Y (x = (cov/σ_Y²)(y − Ȳ) + X̄), toutes deux passant par G ; **coefficient
  de corrélation linéaire** ρ_XY = cov(X, Y)/(σ_X σ_Y), propriétés −1 ≤ ρ_XY ≤ 1 et invariance par changement d'unité ou
  d'origine, seuil d'ajustement |ρ_XY| > √3/2 ; **ajustements non affines par changement de variable** (Z = ln Y,
  Z = √Y, U = ln(8/D − 1), X = V², Y = R/V) ramenés à un ajustement affine puis réinvestis via les fonctions exponentielle
  et logarithme et le **calcul intégral** (valeur moyenne, intégrale I) dans les exercices de modélisation. Le manuel
  décrit aussi l'**usage d'une calculatrice** en mode statistique à deux variables (Σx, Σx², Σxy, X̄, σ_X, r, a, b).
- ⛔ NON traité / supposé acquis : la **moyenne, variance et écart-type d'une série simple** (rappelés en encadré mais
  établis en amont) et la manipulation des **classes / centres de classe / effectifs et fréquences** ; les **fonctions
  exponentielle et logarithme** (chap. 3–4) et le **calcul intégral / valeur moyenne** (chap. 5–6), ici réinvestis pour
  les ajustements non affines ; la **variance et la covariance ne sont pas démontrées** comme formes développées (les
  formules V(X) = E(X²) − (E(X))² et la covariance sont admises / posées) ; aucune **inférence statistique** (estimation,
  intervalle de confiance, test d'hypothèse), aucune **régression multiple**, ni justification théorique du seuil √3/2
  (« les statisticiens conviennent que… ») ne sont abordées ; le lien covariance ↔ probabilités (v.a. couplées) n'est pas
  fait — le chapitre est purement descriptif et **clôt le manuel** (dernier chapitre du tome 2, après les probabilités —
  chap. 18).

## 3. Notes pédagogiques / méthode

Rigueur d'énoncé type bac : hypothèses explicites (continuité, monotonie), justification exigée
(citer le théorème utilisé), notation standard LTR, valeurs « qui tombent juste » (le calcul ne doit
jamais masquer le raisonnement — pas de calculatrice supposée). Pièges récurrents du niveau (ch.1) :
appliquer le TVI sans continuité ou sans encadrement de k, confondre « f(a)·f(b) < 0 » avec
l'unicité (oubli de la stricte monotonie), lever une forme indéterminée par une opération illégale,
composée dans le mauvais sens, asymptote verticale confondue avec horizontale. (Taxonomie complète
par chapitre : skill `prof-math-lycee`.)

## 4. Chapitrage retenu (→ content `math-bac-math`, manifest `bac-math.json`)

Slugs = identité (UUIDv5) : choisis une seule fois, jamais rencommés. Page PDF = page imprimée.

| #   | slug                               | notion                          | manuel (code · pages) |
| --- | ---------------------------------- | ------------------------------- | --------------------- |
| 1   | `01-continuite-limites`            | Continuité et limites           | 222445 · p.5–27       |
| 2   | `02-suites-reelles`                | Suites réelles                  | 222445 · p.28–52      |
| 3   | `03-derivabilite`                  | Dérivabilité                    | 222445 · p.53–76      |
| 4   | `04-fonctions-reciproques`         | Fonctions réciproques           | 222445 · p.77–95      |
| 5   | `05-primitives`                    | Primitives                      | 222445 · p.96–108     |
| 6   | `06-integrales`                    | Intégrales                      | 222445 · p.109–136    |
| 7   | `07-fonction-logarithme-neperien`  | Fonction logarithme népérien    | 222445 · p.137–157    |
| 8   | `08-fonction-exponentielle`        | Fonction exponentielle          | 222445 · p.158–188    |
| 9   | `09-equations-differentielles`     | Équations différentielles       | 222445 · p.189–207    |
| 10  | `10-nombres-complexes`             | Nombres complexes               | 222446 · p.5–34       |
| 11  | `11-isometries-du-plan`            | Isométries du plan              | 222446 · p.35–53      |
| 12  | `12-deplacements-antideplacements` | Déplacements – Antidéplacements | 222446 · p.54–73      |
| 13  | `13-similitudes`                   | Similitudes                     | 222446 · p.74–95      |
| 14  | `14-coniques`                      | Coniques                        | 222446 · p.96–120     |
| 15  | `15-geometrie-dans-l-espace`       | Géométrie dans l'espace         | 222446 · p.121–146    |
| 16  | `16-divisibilite-dans-z`           | Divisibilité dans ℤ             | 222446 · p.147–160    |
| 17  | `17-identite-de-bezout`            | Identité de Bézout              | 222446 · p.161–178    |
| 18  | `18-probabilites`                  | Probabilités                    | 222446 · p.179–207    |
| 19  | `19-statistiques`                  | Statistiques                    | 222446 · p.208–230    |

## 5. Sources croisées

Manuels élèves officiels CNP 4ème Math (section Mathématiques) : tome 1 « Analyse » (222445P00,
207 p.) et tome 2 « Algèbre · Géométrie · Probabilités » (222446P00, 230 p.), rattachés au corpus
sous `cnp-officiel/manuels/secondaire/c4/eleve/`. Aucun guide enseignant au corpus pour ce couple ⇒
le manuel fait référence (profil ecole-secondaire). Confronter au programme officiel ministériel du
Bac Math s'il est publié (R-3). Annales du bac math (sessions principales) comme référence de
calibration d'épreuve pour le tier d4 `NN-annales-bac` (LOT B).
