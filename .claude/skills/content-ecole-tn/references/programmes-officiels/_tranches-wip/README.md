# `_tranches-wip/` — transcriptions brutes par tranches (temporaire, à consommer puis supprimer)

> **Ce dossier n'est pas une couche du pipeline.** C'est un **sas de sauvegarde** : il conserve le
> travail de lecture brut produit par des agents parallèles, tant que la fiche correspondante
> (`programme/<niveau>/<matière>.md`) ne l'a pas **entièrement** absorbé. Rien ici ne fait autorité :
> **la fiche fait foi**, toujours. Ces fichiers sont un filet, pas une source.

## Pourquoi ils sont là

La campagne CNP lit un manuel en **tranches disjointes, par des agents à contexte vierge**, puis un
agent d'assemblage en fait une fiche unique. Quand l'assemblage **synthétise** au lieu de tout
recopier — ou quand la campagne est interrompue avant d'aller au bout — la tranche brute garde du
**verbatim que la fiche ne porte pas** (chaque question de l'appareil pédagogique, chaque encadré de
règle). Le perdre coûterait une relecture-vision complète des mêmes pages : c'est le travail le plus
cher de la chaîne.

Versé au dépôt le **2026-07-17**, après que le workflow `vague-a-1ere-sec` a été interrompu par une
limite de session : les tranches ne vivaient que dans un répertoire `Temp`.

## Contenu

| dossier              | source                                             | état                                                                                                                                                                                                                    |
| -------------------- | -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `1ere-sec-arabe/`    | `201103P01`+`P02`+`P03` — « آفاق أدبيّة » (404 p.) | **À CONSOMMER.** La fiche `programme/1ere-sec/arabe.md` ne couvre que **195/404 pages (48 %)** et **synthétise** ces tranches sans tout reprendre. Le verbatim de l'appareil pédagogique n'existe que **ici**.          |
| `1ere-sec-physique/` | `223103P00` (276 p.)                               | **Reliquat.** `t1` = transcription du ch.1 (**absorbée** dans la fiche). `t2`–`t6` = rapports de relecture R-7 des ch.2–17 : 18 findings appliqués, le reste est **documenté en §6.1 bis de la fiche** (dette assumée). |

## Règle de vie

- **On consomme, on ne cite pas.** Un contenu utile ici doit être **remonté dans la fiche**, pas
  référencé depuis elle — la fiche doit rester auto-suffisante (elle est lue par la génération, qui
  ne rouvre jamais rien d'autre).
- **On supprime ce qui est absorbé.** Dès qu'une fiche couvre sa matière à la profondeur de
  génération et que sa dette est close, son dossier ici **disparaît**. Ce sas doit tendre vers le vide.
- **Aucune tranche ne vaut relecture indépendante (R-7).** Elles ont été écrites par des agents qui
  n'ont pas été contrôlés ; plusieurs se sont arrêtées avant la fin de leur tranche en le déclarant
  dans leur propre en-tête. **Lire l'en-tête de chaque fichier** avant de s'y fier : il annonce les
  pages réellement lues, qui sont souvent moins que les pages assignées.

## Ce qu'il reste à lire — arabe 1ère sec (par priorité, cf. `arabe.md` §6.1)

`p.151–224` (74 p., محور 3 « الشعر الوطنيّ », **entièrement absent**) → `p.28–85` (58 p.) →
`p.113–149` (37 p.) → `p.276–315` (40 p.) → `p.337–338` (2 p.).

**Protocole établi à la douleur** : **150 dpi minimum**, crop **300–400 dpi** pour tout verbatim
(3 erreurs de lecture prouvées à 150 dpi). **Dimensionner à ~30–40 pages par session** — sur cinq
agents lancés en parallèle, trois ont épuisé leur budget avant la fin de leur tranche et un n'a rien
produit.
