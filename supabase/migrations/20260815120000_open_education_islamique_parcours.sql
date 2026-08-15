-- Ouvrir la rubrique « Éducation islamique » : « coming_soon » → « available ».
--
-- POURQUOI MAINTENANT. Le thème et son parcours ont été semés `coming_soon` par
-- 20260814120000, à dessein : la sous-rubrique فقه vit dans le dépôt privé et
-- n'était pas encore appliquée en prod, donc la carte aurait mené à une page
-- vide. Elle l'est depuis (`apply-content.yml`, run du 2026-08-15, journalisé
-- dans `content_releases`), et la matière est jouable. Une carte pourvue et
-- muette, c'est du contenu écrit et jamais servi.
--
-- COUVERTURE À L'OUVERTURE. Le sujet `fiqh` porte **16 chapitres**, chacun
-- complet (cours, résumé, quiz et cinq missions) : 480 questions de missions et
-- 80 de quiz. Ils couvrent l'entrée du livre — la croyance, toute la طهارة, et
-- l'essentiel de la صلاة (les temps, l'appel, la description, l'imamat, la
-- prosternation de récitation, le voyage, le vendredi, la peur, les deux fêtes).
--
-- R-8 assume l'ouverture AVANT la complétude — même geste et même justification
-- que 20260813120000 pour les onze classes du lycée : une première tranche
-- complète ouvre la rubrique, le reste s'ajoute sous un parcours déjà ouvert,
-- sans nouvelle migration. La matière suit « الرسالة » d'Ibn Abî Zayd al-Qayrawânî,
-- dont les 45 أبواب sont écrits par lots ; les 29 restants arriveront ainsi.
--
-- LES TROUS DE `display_order` NE SE VOIENT PAS. Le `display_order` d'un chapitre
-- est le NUMÉRO DU باب dans le livre, pas sa position dans la matière : c'est ce
-- qui permet à un باب écrit plus tard de se loger à sa place exacte sans
-- renuméroter (renuméroter re-clèrerait les UUID v5 — piège n°2 de
-- docs/content-generation-pipeline.md). L'élève, lui, ne voit pas ces numéros :
-- `subject-hub` étiquette les chapitres par leur RANG dans la liste triée
-- (`ci + 1`), donc « الفصل 1 » à « الفصل 16 » sans discontinuité.
--
-- PHASE GRATUITE — rien n'est gaté. Le parcours est né `is_premium = false` et
-- `preview_policy = 'full'` ; `resolve_exercise_access` court-circuite à OPEN.
-- L'ouverture ne crée donc aucune surface « premium » (invariant AGENTS.md).
--
-- Idempotent : re-jouer est un no-op une fois le statut déjà 'available'.
UPDATE public.parcours
SET status = 'available'
WHERE id = 'education-islamique'
  AND status <> 'available';
