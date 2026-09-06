# `ca-chain/` — les intermédiaires que des sites oublient de servir

Un certificat PEM par fichier, nommé par son sujet. Le hook de session
(`.claude/hooks/session-start.mjs`, via `scripts/cloud/ca-bundle.mjs`) les ajoute au magasin de la
session et exporte `CURL_CA_BUNDLE`, `SSL_CERT_FILE` et `NODE_EXTRA_CA_CERTS` — en session cloud
seulement. **Aucune clé privée n'entre ici, jamais** : ce sont des certificats publics d'autorités,
vérifiables par n'importe qui contre le magasin système.

## Pourquoi

`www.cnp.com.tn` sert son certificat feuille **seul** (constaté le 2026-09-06 : `openssl s_client`
rend une chaîne de profondeur 0, « unable to verify the first certificate »). Un navigateur va
chercher l'intermédiaire manquant tout seul (extension AIA) ; curl, OpenSSL et le `fetch` de Node
ne le font pas et échouent en `curl 60 : unable to get local issuer certificate` — **même quand la
politique réseau autorise l'hôte** (lot 0 appliqué). L'entrepôt de l'émetteur
(`crt.sectigo.com`) est hors liste blanche. L'intermédiaire, lui, est dans la chaîne d'hôtes déjà
autorisés : il a été extrait de celle de `nodejs.org` (`ghcr.io` sert le même), puis vérifié.

## Le contenu

| Fichier                                              | Sujet                                          | Émetteur (dans le magasin système)            | Valide jusqu'au | Empreinte SHA-256                                                                                 |
| ---------------------------------------------------- | ---------------------------------------------- | --------------------------------------------- | --------------- | ------------------------------------------------------------------------------------------------- |
| `sectigo-public-server-authentication-ca-dv-r36.pem` | Sectigo Public Server Authentication CA DV R36 | Sectigo Public Server Authentication Root R46 | 2036-03-21      | `8C:54:C3:34:B6:6B:A4:E4:26:77:2A:F4:A3:F9:13:6C:19:A1:AE:C7:29:FD:B2:8C:53:5C:07:A5:A4:EF:22:E0` |

Le certificat feuille du CNP expire le **2026-12-06** : s'il est renouvelé chez un autre émetteur,
la sonde de session le dira (« certificat non vérifiable ») et ce dossier change.

## Vérifier, ajouter, renouveler — depuis une session, sans geste humain

```bash
# Vérifier un fichier de ce dossier contre le magasin système : doit rendre « OK ».
openssl verify -CAfile /etc/ssl/certs/ca-certificates.crt scripts/cloud/ca-chain/<fichier>.pem

# Quand la sonde dit « certificat non vérifiable » sur un hôte : voir ce qu'il sert et qui a signé.
openssl s_client -proxy 127.0.0.1:$(echo "$HTTPS_PROXY" | sed 's#.*:##') -connect <hôte>:443 -servername <hôte> -showcerts </dev/null | openssl x509 -noout -subject -issuer

# Extraire l'intermédiaire manquant de la chaîne d'un hôte autorisé qui le sert (ici nodejs.org),
# le vérifier, puis le déposer ici sous le nom de son sujet.
openssl s_client -proxy 127.0.0.1:<port> -connect nodejs.org:443 -servername nodejs.org -showcerts </dev/null 2>/dev/null \
  | awk '/BEGIN CERT/{n++} n==2' > /tmp/inter.pem      # le 2e certificat de la chaîne
openssl x509 -noout -subject -issuer -dates -fingerprint -sha256 -in /tmp/inter.pem
openssl verify -CAfile /etc/ssl/certs/ca-certificates.crt /tmp/inter.pem                  # OK, sinon poubelle
```

Un test (`scripts/cloud/__tests__/ca-bundle.test.mjs`) affirme que chaque fichier est un
certificat, pas une clé, et que celui de Sectigo porte bien ce sujet et cette empreinte.
