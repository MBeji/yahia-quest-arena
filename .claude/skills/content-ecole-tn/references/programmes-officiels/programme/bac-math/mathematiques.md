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

| #   | Chapitre                        | pages (PDF = imprimées) | profondeur |
| --- | ------------------------------- | ----------------------- | ---------- |
| 10  | Nombres complexes               | 5–34                    | `bloc`     |
| 11  | Isométries du plan              | 35–53                   | `bloc`     |
| 12  | Déplacements – Antidéplacements | 54–73                   | `bloc`     |
| 13  | Similitudes                     | 74–95                   | `bloc`     |
| 14  | Coniques                        | 96–120                  | `bloc`     |
| 15  | Géométrie dans l'espace         | 121–146                 | `bloc`     |
| 16  | Divisibilité dans ℤ             | 147–160                 | `bloc`     |
| 17  | Identité de Bézout              | 161–178                 | `bloc`     |
| 18  | Probabilités                    | 179–207                 | `bloc`     |
| 19  | Statistiques                    | 208–230                 | `bloc`     |

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
