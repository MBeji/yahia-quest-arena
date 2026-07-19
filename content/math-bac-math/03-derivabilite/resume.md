# 📜 Résumé : Dérivabilité

- **Nombre dérivé et tangente** : f dérivable en a si lim x→a (f(x) − f(a))/(x − a) = f′(a) ; tangente en a : y = f′(a)(x − a) + f(a) ; approximation affine f(a + h) ≈ f(a) + f′(a)h.
- **Dérivabilité à gauche/à droite** : f dérivable en a ⟺ f′_g(a) = f′_d(a) ; sinon point anguleux ; dérivable ⟹ continue, jamais l'inverse (|x| en 0).
- **Dérivable sur un intervalle** : dérivable en tout point de l'ouvert ; sur [a, b] = sur ]a, b[ + à droite en a + à gauche en b ; √x dérivable sur ]0, +∞[ (tangente verticale en 0).
- **Dérivées usuelles** : (xⁿ)′ = nxⁿ⁻¹ ; (1/xⁿ)′ = −n/xⁿ⁺¹ ; (sin(ax + b))′ = a cos(ax + b) ; (cos(ax + b))′ = −a sin(ax + b) ; (tan(ax + b))′ = a(1 + tan²(ax + b)).
- **Opérations** : (f + g)′ = f′ + g′ ; (fg)′ = f′g + g′f ; (1/f)′ = −f′/f² ; (f/g)′ = (f′g − g′f)/g² ; (fⁿ)′ = nf′fⁿ⁻¹.
- **Composée** : (g∘f)′(x) = f′(x) × g′(f(x)) ; cas clés (uⁿ)′ = nu′uⁿ⁻¹ et (√u)′ = u′/(2√u).
- **Dérivées successives** : f″, puis f⁽ⁿ⁾ par itération ; racine double α ⟺ P(α) = P′(α) = 0 et P″(α) ≠ 0.
- **Théorème de Rolle** : f continue sur [a, b], dérivable sur ]a, b[, f(a) = f(b) ⟹ il existe c ∈ ]a, b[ avec f′(c) = 0 (tangente horizontale).
- **Accroissements finis (TAF)** : f continue sur [a, b], dérivable sur ]a, b[ ⟹ il existe c ∈ ]a, b[ avec f(b) − f(a) = f′(c)(b − a) (tangente parallèle à la corde).
- **Inégalité des accroissements finis** : m ≤ f′ ≤ M sur ]a, b[ ⟹ m(b − a) ≤ f(b) − f(a) ≤ M(b − a) ; corollaire |f′| ≤ M ⟹ |f(b) − f(a)| ≤ M|b − a|.
- **Sens de variation** : f′ > 0 ⟹ strictement croissante ; f′ < 0 ⟹ strictement décroissante ; f′ ≥ 0 s'annulant sur aucun intervalle ⟹ strictement croissante (prolongement aux bornes par continuité).
- **Extrema locaux** : extremum local en a ⟹ f′(a) = 0 (nécessaire, non suffisant : x³ en 0) ; f′ change de signe en a ⟹ extremum en a.
- **Point d'inflexion et centre de symétrie** : f″ s'annule en a en changeant de signe ⟹ inflexion en I(a, f(a)) (la courbe traverse sa tangente) ; O′(a, b) centre de symétrie ⟺ f(2a − x) = 2b − f(x).
