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
| 6   | Intégrales                   | 109–136                 | `bloc`       |
| 7   | Fonction logarithme népérien | 137–157                 | `bloc`       |
| 8   | Fonction exponentielle       | 158–188                 | `bloc`       |
| 9   | Équations différentielles    | 189–207                 | `bloc`       |

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
