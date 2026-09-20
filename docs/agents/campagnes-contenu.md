# Campagnes de contenu — conduite de session

> Playbook (étude 25 D-7). ⚠️ **Depuis la scission de l'étude 24 (2026-07-20), une campagne de
> contenu ne se lance plus depuis ce dépôt** : le corpus, les 41 skills `content-*`/`prof-*`, la
> méthode (`METHODE-GENERATION-CONTENU.md`) et les études vivent dans le dépôt **privé**
> `MBeji/yahia-quest-content`. Ce dépôt-ci ne garde que le **moteur** (`scripts/content/**`,
> `src/shared/content/**`), que la CI privée invoque par double checkout.
>
> Ce fichier reste ici parce que ce qu'il décrit — la **conduite** d'une session de campagne — est
> une leçon de process, pas du contenu : elle vaut quel que soit le dépôt où tourne la session.
> Les règles d'écriture, elles, vivent avec les skills, au privé.

## Le corpus source est à la source — plus sur un poste

Les manuels sont **publics chez le CNP** (`CNP_MANUEL_BASE_URL`, `src/shared/content/manuel-cnp.ts`)
et ne se copient nulle part : licence (`LICENSE-CONTENT.md`) et doctrine « en lien plutôt qu'en
copie ». Une session — cloud ou locale — les télécharge **par code** dans un dossier jetable, puis
rend les pages en images et les lit en vision (étude cloud-first, lot 3) :

```bash
npm run content:manuel:fetch -- 102905 --render --pages 18-24   # → ~/.cache/yqa-manuels/102905P00.pdf + PNG
```

L'URL se dérive du code, jamais saisie ; rien n'entre dans git — le cache est privé à
l'utilisateur, jamais le répertoire temporaire partagé, et un fichier existant n'est pas écrasé.
Le transfert est fait par `curl`, qui suit le proxy de la session nativement. En session cloud,
l'environnement doit autoriser `www.cnp.com.tn` (lot 0 de l'étude) — sinon la commande le **dit** :
« refusé par la politique réseau de l'environnement », pas « le CNP est tombé ». Le CNP sert son
certificat **sans l'intermédiaire** qui l'a signé : le hook de session ajoute cet intermédiaire
(`scripts/cloud/ca-chain/`) au magasin de curl, sans quoi c'est `curl 60 : unable to get local
issuer certificate` — que la commande nomme aussi. Pour les scripts
qui passent par le `fetch` de Node (`content:manuel:check`), le hook de session exporte
`NODE_USE_ENV_PROXY=1`, sans quoi Node ignore le proxy de la plateforme et échoue sur tout hôte.
Le wrapper `YahiaAcademy/` du poste n'est plus une condition ; ce qui n'est pas au
CNP (documents du ministère, notes, captures) vit sur Google Drive et se lit par le connecteur.
Une session headless sans abonnement échoue toujours (« Not logged in »), et une clé API n'est
pas une alternative acceptée ici.

## Budget de session

Vérifié sur le pilote maths 2ᵉ sec (manuel de 364 pages, 19 chapitres) : **~4 chapitres par
session** en lecture vision. Au-delà, la qualité chute avant le quota. Conséquences :

- **une matière par session**, pas une classe entière ;
- **livrer en petits lots poussés** — une PR par fiche, puis une PR par tranche de ≤ 4 chapitres.
  Jamais une longue session sans livrable : une session tuée par la limite d'usage perd tout ce
  qui n'est pas poussé.

## Lire les PDF

`Read` sur un PDF de manuel échoue en pratique (taille, pages scannées). Passer par le rendu en
images (`render.sh`, ~150 dpi) puis lecture vision. La couche texte, quand elle existe, est
fiable pour la prose et **trompeuse pour les mathématiques** (formules aplaties) — re-vérifier
toute formule à l'image.

### Quatre régimes, et un seul se mesure avant de s'engager

Mesuré le **2026-09-19** sur les 24 guides du primaire + maths 1ʳᵉ sec, en une commande :

```bash
pdfinfo "$f" | awk '/^Pages:/{print $2}'      # p
pdftotext "$f" - | wc -c                      # c   →   c/p = caractères par page
```

| c/p                               | Régime                             | Ce que ça coûte                                                                                                                                                                                                                |
| --------------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **< 20**                          | **scan pur** — aucune couche texte | vision page par page, sans exception                                                                                                                                                                                           |
| **200–2300, latin**               | **couche texte propre**            | extraction + comparaison automatiques ; c'est le régime confortable                                                                                                                                                            |
| **200–2300, arabe**               | **couche texte en POLICE PRIVÉE**  | ⚠️ **le piège** : `pdftotext` rend beaucoup de caractères, donc le chiffre dit « texte », mais ce sont des glyphes latins mappés sur des octets arabes — **indécodables sans le `ToUnicode` de la police**. Vision quand même. |
| CID `Identity-H` sans `ToUnicode` | **échec bruyant**                  | `pdftotext` refuse et le dit (« Unknown character collection ») — c'est le bon cas : il ne fabrique pas de faux texte.                                                                                                         |

**Le résultat de la mesure, pour ne pas la refaire** : sur les 24 guides, **4 seulement** sont
exploitables par extraction — les trois guides de **français** (`521326` 3ᵉ, `521415` 4ᵉ,
`521513` 5ᵉ) **et le manuel de maths de 1ʳᵉ secondaire `222104`**. ⚠️ **Ce dernier est le piège
dans le piège** : son code est arabe comme les autres, il a d'abord été rangé avec eux, et il est
en réalité **écrit en français**. Le code CNP ne dit pas la langue du livre — seul le texte
extrait la dit. Les **19 autres** sont en police privée (au moins trois familles de mojibake distinctes :
`ŗƒŕ°Ŷƃ¦…`, `qHDÒ∞«…`, `á«LƒZGó«Ñd…`) et **2 sont des scans purs** (`503104` éveil 1ʳᵉ,
`503204` éveil 2ᵉ). Tester le décodage est inutile : cp1256, mac_arabic, iso8859_6 et
mac_farsi ont tous été essayés sur les trois familles, aucun ne rend de l'arabe.

**Conséquence de planification** : une fiche francophone se reprend en une passe ; une fiche
arabophone de 200 pages se reprend en vision, et c'est un ordre de grandeur de plus. Ne pas
promettre les deux au même rythme.

### Le mojibake arabe est DÉCODABLE — constaté et prototypé le 2026-09-19

Le tableau ci-dessus dit que les guides arabes sont en police privée et donc « vision quand même ».
C'est vrai pour **transcrire**. Ça ne l'est pas pour **chercher, compter et naviguer** — et la
différence vaut des milliers de pages.

**Ce qui a été constaté.** La substitution n'est pas du bruit : c'est une **table déterministe**,
glyphe → lettre arabe, en **ordre visuel inversé**. Elle se dérive en alignant un texte dont on
connaît la vérité (lu à l'image) avec le mojibake de la même page. Exemple, sur `503504` p.36 :

| mojibake (inversé) | lettres      | mot     |
| ------------------ | ------------ | ------- |
| `G d û° ª ù¢`      | ا ل ش م س    | الشمس   |
| `G Ÿ ü° É O Q`     | ا لم ص ا د ر | المصادر |
| `G Ÿ †° « Ä á`     | ا لم ض ي ئ ة | المضيئة |

Trois règles suffisent à lire la table : **un `°` ou un `¢` qui suit un glyphe forme avec lui une
seule lettre pointée** (`û°`=ش, `ü°`=ص, `†°`=ض, `ù¢`=س) ; **certains glyphes sont des ligatures**
(`Ÿ`=لم, `’`=لا/لأ) ; et **le `q` est la shadda**, placée AVANT sa lettre côté mojibake.

**Ce qui rend la trouvaille utile : la table est PARTAGÉE entre guides.** Dérivée d'une seule page
du guide d'éveil de 5ᵉ (`503504`), une table de 38 glyphes décode déjà lisiblement le guide
d'éducation islamique de 5ᵉ (`511505`), un autre volume, une autre matière :

> `تنطل·ا···اتيجّيةالّت·اعلالأجتماعي·ن·موعة·نالأأ·دافالوجدانّيةالّتيتقودا···ل··نا`

à comparer avec ce que la page imprime vraiment, lu à l'image :

> « تنطلق استراتيجيّة التّفاعل الاجتماعي من مجموعة من الأهداف الوجدانيّة الّتي تقود إلى خلق مناخ… »

Les `·` sont les glyphes que la table de 38 entrées ne connaît pas encore. **Il y a au moins deux
familles de police** dans le corpus : celle-ci (`á q d G` — éveil, islamique, arabe 5ᵉ, arabe 6ᵉ) et
une autre (`W± b Ò I ‡ L ∞ «` — éveil 4ᵉ, islamique 4ᵉ, maths 3ᵉ), qui demandera sa propre table.

**Le contrat, et il n'est pas négociable.** Un décodeur à 90 % produit de l'arabe **plausible et
faux** — c'est exactement le mode de défaillance que les audits du 2026-09-19 ont passé la journée à
corriger. Donc :

- le décodage sert à **chercher, compter, localiser une section, mesurer une couverture** ;
- **aucune citation verbatim ne sort d'un décodage** : elle se lit à l'image, comme aujourd'hui ;
- un décodeur qui rend `·` sur les glyphes inconnus est **sûr par construction** — il montre ses
  trous au lieu de les combler.

**Reste à faire** pour en tirer un outil : compléter la table (les 28 lettres × leurs formes +
ligatures, ~150 entrées par famille), la dériver d'un corpus aligné plus large, et l'emballer dans
un script testé de `scripts/content/`. Le prototype et la méthode d'alignement sont décrits
ci-dessus ; c'est reproductible en une session.

**Pourquoi ça compte** : les 17 fiches arabophones du registre représentent ~3 400 pages qu'on ne
sait lire qu'à l'image. Rendre leur texte cherchable ne remplace pas la lecture, mais il dit **où**
lire — et c'est la différence entre auditer une fiche en une passe et la relire page à page.

### Télécharger un guide du CNP en session cloud

`npm run content:manuel:fetch -- <code>` dérive l'URL du code et écrit dans `~/.cache/yqa-manuels`.
⚠️ **L'état d'un shell ne survit pas d'un appel d'outil au suivant** : le hook de session pose
`CURL_CA_BUNDLE` une fois, mais un shell ouvert plus tard ne le voit pas, et le fetch échoue alors
en « certificat du serveur non vérifiable » — c'est-à-dire **en accusant le CNP**. Le réflexe, dans
la commande elle-même :

```bash
export CURL_CA_BUNDLE=~/.cache/yqa-ca/ca-bundle.pem \
       SSL_CERT_FILE=~/.cache/yqa-ca/ca-bundle.pem \
       NODE_EXTRA_CA_CERTS=~/.cache/yqa-ca/ca-bundle.pem
npm run content:manuel:fetch -- <code>
```

Si le bundle n'existe pas : `node scripts/cloud/ca-bundle.mjs`. Détail dans
[`scripts/cloud/ca-chain/README.md`](../../scripts/cloud/ca-chain/README.md).
Un code peut n'exister qu'en tomes (`222104` est servi en `P01`/`P02`, pas en `P00`) :
`suivi/corpus-cnp.json` dit lesquels.

## Vérifier l'existant AVANT de générer

Le registre `programmes-officiels/suivi/` dit ce qui est **déjà transcrit** (plages de pages,
statuts normés) ; `_INDEX.md` en est la vue **générée** (`npm run programme:index`), et
`npm run programme:check` est le gate. Un statut `[~]` signifie « déjà fait », pas « trou à
combler » — la double transcription est l'erreur la plus coûteuse de cette chaîne. Le registre se
met à jour **dans le même commit** que la fiche qu'il décrit.

## Ce que les gates ne voient pas

`content:qa:strict` vérifie la **structure** et la **notation**, pas la **correction** : une clé
de réponse fausse passe le gate. C'est le rôle du sweep `content-audit` (re-résolution de chaque
question) et de l'audit humain. Ne jamais conclure « le contenu est bon » sur un gate vert.

Corollaire observé : les erreurs se logent plus souvent dans les **exemples du cours** que dans
les clés de réponse — l'audit doit lire `cours.md`, pas seulement les quiz.

## Merger ne publie pas — et un run vert ne prouve pas la publication

Le contenu a quitté le framework de migrations (étude 24 D-3) : il est **appliqué** à la prod par
le workflow privé `apply-content.yml`, en `workflow_dispatch` **seul**. Un merge ne déclenche
rien. Une campagne mergée, auditée et verte peut donc n'atteindre **aucun élève** — c'est arrivé
sur 18 sujets à la fois (privé #124), et sur les 1 049 tags de misconception de C4bis, restés
invisibles entre leur merge et leur application.

**Cibler un sujet.** L'entrée `subjects` vide applique **tout le corpus** : ~45 min d'écriture
continue en prod, contre ~2 min pour un sujet. Sûr pour les données, pas pour la charge.
Toujours un `dry_run=true` d'abord : il affiche le plan et sort.

⚠️ **Et le run vert ne prouve pas que tout est arrivé.** L'étape de contrôle du workflow compte
les **chapitres et les questions** ; elle ne regarde **aucune colonne serveur-seul** —
`distractor_tags` (étude 04 D-1), `correct_option`, et demain tout champ exclu de la whitelist
`SELECT` de `questions`. Un canal peut donc s'afficher vert en ayant appliqué des lignes sans le
signal qui justifiait la campagne.

Le contrôle qui tranche, depuis l'extérieur et en lecture seule (clés **publiques** du `.env`) :
comparer le **décompte de questions du sujet en prod** au décompte du **corpus au SHA appliqué**.

```bash
# $URL / $KEY : VITE_SUPABASE_URL et VITE_SUPABASE_PUBLISHABLE_KEY du .env — publiques.
curl -s -H "apikey: $KEY" -H "Prefer: count=exact" -H "Range: 0-0" -o /dev/null -D - "$URL/rest/v1/questions?select=id,exercises!inner(id,chapters!inner(subject_id))&exercises.chapters.subject_id=eq.math"
# → Content-Range: 0-0/818   (à comparer au corpus au SHA appliqué)
```

Égalité ⇒ les lignes ont bien été ré-upsertées à ce SHA, et les colonnes serveur-seul voyagent
dans le **même** upsert : elles sont là. C'est la preuve la plus forte accessible sans accès
base. Contrôle négatif à faire une fois : demander `distractor_tags` en anon doit répondre
`42501 permission denied` — une réponse serait une fuite, pas une bonne nouvelle.

La preuve de bout en bout, elle, reste **produit** : `user_misconceptions` qui se remplit quand
des élèves ratent des questions taguées. Elle ne s'observe pas le jour de l'application.
