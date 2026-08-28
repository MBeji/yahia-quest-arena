/**
 * Un argument de RPC que le SQL accepte à NULL, mais que les types générés
 * rendent non-nullable.
 *
 * Le générateur Supabase sait exprimer « optionnel » — `p_x?: string` quand le
 * paramètre porte un `DEFAULT` — mais **jamais « nullable »** : un `p_x TEXT`
 * sans défaut devient `p_x: string`, alors que Postgres y accepte NULL, et que
 * certaines fonctions l'EXIGENT. Deux cas vivants du dépôt :
 *
 *   - `set_ai_credential(p_base_url TEXT)` — la contrainte
 *     `ai_credentials_base_url_scope` impose `base_url IS NULL` pour tout
 *     fournisseur autre qu'`openai_compatible` ;
 *   - `create_forged_quiz(p_competency TEXT)` — NULL quand la portée du quiz est
 *     un chapitre et non une compétence.
 *
 * ⚠️ **Ne pas confondre avec le paramètre OPTIONNEL.** Si la signature SQL porte
 * un `DEFAULT NULL`, le type généré rend `p_x?: …` : il faut alors écrire
 * `?? undefined`, sans le moindre cast — l'argument omis prend son défaut, ce
 * qui vaut exactement NULL. Ce helper est réservé au paramètre **obligatoire**
 * dont la colonne est nullable, le seul cas qu'aucune écriture honnête ne couvre.
 * Lire la signature SQL avant de choisir : les deux se ressemblent à l'appel et
 * ne se comportent pas pareil.
 *
 * Il remplace un motif nettement pire, la « vue étroite » du client
 * (`supabase as unknown as XRpcClient`) : celle-ci désactivait la vérification de
 * TOUS les arguments de TOUS les appels d'un fichier pour compenser une seule
 * imprécision. Ici la brèche est d'un argument, elle est nommée, et elle se
 * cherche au grep le jour où le générateur saura dire « nullable ».
 */
export function nullableRpcArg<T>(value: T | null): T {
  return value as T;
}
