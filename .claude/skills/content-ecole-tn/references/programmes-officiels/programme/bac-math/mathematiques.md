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
| 3   | Dérivabilité                 | 53–76                   | `bloc`       |
| 4   | Fonctions réciproques        | 77–95                   | `bloc`       |
| 5   | Primitives                   | 96–108                  | `bloc`       |
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
