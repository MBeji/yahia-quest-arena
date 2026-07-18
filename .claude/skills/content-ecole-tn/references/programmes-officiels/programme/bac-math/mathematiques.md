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
| 2   | Suites réelles               | 28–52                   | `bloc`       |
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
