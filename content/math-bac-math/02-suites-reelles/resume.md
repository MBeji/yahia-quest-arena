# 📜 Résumé : Suites réelles

- **Récurrence** : pour prouver P(n) pour tout n ≥ n₀, vérifier l'initialisation P(n₀), puis l'hérédité P(n) ⟹ P(n + 1) ; sans initialisation, l'hérédité ne prouve rien.
- **Rappels arith./géo.** : arithmétique Uₙ = U₀ + nr ; géométrique Uₙ = U₀ × qⁿ ; somme géométrique 1 + q + … + qⁿ = (1 − q^(n+1))/(1 − q) pour q ≠ 1 ; notation Σ (k = 1 → n) aₖ = a₁ + … + aₙ.
- **Majorée / minorée / bornée / monotone** : bornée = majorée et minorée ⟺ |Uₙ| ≤ K ; monotonie par le signe de Uₙ₊₁ − Uₙ (ou le quotient Uₙ₊₁/Uₙ comparé à 1 si termes positifs).
- **Limite et sous-suites** : lim Uₙ = a ⟺ lim U₂ₙ = a et lim U₂ₙ₊₁ = a ; toute suite convergente est bornée ; passage à la limite : m ≤ Uₙ ≤ M ⟹ m ≤ a ≤ M (les inégalités strictes deviennent larges).
- **Opérations sur les limites** : somme, produit, quotient comme pour les fonctions ; formes indéterminées ∞ − ∞, 0 × ∞, ∞/∞, 0/0 → transformer (terme dominant, factorisation, conjugué).
- **Suites géométriques qⁿ** : q > 1 → +∞ ; |q| < 1 → 0 ; q ≤ −1 → pas de limite ; q = 1 → constante. Attention : |q| < 1, pas q < 1.
- **Vₙ = f(Uₙ)** : f continue et Uₙ → a ⟹ f(Uₙ) → f(a) ; plus généralement Uₙ → ℓ et f(x) → L en ℓ ⟹ f(Uₙ) → L.
- **Comparaison, gendarmes, valeur absolue** : Vₙ ≤ Uₙ ≤ Wₙ avec lim Vₙ = lim Wₙ = a ⟹ lim Uₙ = a ; 0 ≤ |Uₙ| ≤ Vₙ → 0 ⟹ Uₙ → 0 ; minoration/majoration pour les limites ±∞.
- **Suites monotones (admis)** : croissante + majorée ⟹ converge (limite ≠ majorant en général) ; décroissante + minorée ⟹ converge ; croissante non majorée → +∞ ; décroissante non minorée → −∞.
- **Récurrentes Uₙ₊₁ = f(Uₙ)** : prouver d'abord la convergence (encadrement + monotonie), puis la limite parmi les points fixes f(x) = x (si f continue en la limite) ; le point fixe seul ne prouve jamais la convergence.
- **Suites adjacentes** : Uₙ ≤ Vₙ, (Uₙ) croissante, (Vₙ) décroissante, Vₙ − Uₙ → 0 ⟹ même limite (approximation de e, de √a…).
