-- =========================================================
-- EXTENDED FRENCH QUIZZES - 9ème année Tunisie
-- Grammaire, Conjugaison, Compréhension, Orthographe,
-- Syntaxe, Production écrite, Niveau langue général
-- =========================================================

-- ===================================================================
-- NEW EXERCISES (continuing from e2000000-...-000000000014)
-- ===================================================================
INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, display_order) VALUES
  -- Grammaire (chapter 1)
  ('e2000000-0000-0000-0000-000000000015', 'c2000000-0000-0000-0000-000000000001', 'french', 'Les classes grammaticales', 1, 40, 8, 'practice', 4),
  ('e2000000-0000-0000-0000-000000000016', 'c2000000-0000-0000-0000-000000000001', 'french', 'Les fonctions dans la phrase', 2, 60, 12, 'practice', 5),
  ('e2000000-0000-0000-0000-000000000017', 'c2000000-0000-0000-0000-000000000001', 'french', 'Syntaxe et construction', 2, 60, 12, 'practice', 6),
  ('e2000000-0000-0000-0000-000000000018', 'c2000000-0000-0000-0000-000000000001', 'french', 'Orthographe grammaticale', 2, 60, 12, 'practice', 7),
  
  -- Conjugaison (chapter 2)
  ('e2000000-0000-0000-0000-000000000019', 'c2000000-0000-0000-0000-000000000002', 'french', 'Temps simples de l''indicatif', 1, 40, 8, 'practice', 4),
  ('e2000000-0000-0000-0000-000000000020', 'c2000000-0000-0000-0000-000000000002', 'french', 'Temps composés de l''indicatif', 2, 60, 12, 'practice', 5),
  ('e2000000-0000-0000-0000-000000000021', 'c2000000-0000-0000-0000-000000000002', 'french', 'Le subjonctif et le conditionnel', 2, 60, 12, 'practice', 6),
  ('e2000000-0000-0000-0000-000000000022', 'c2000000-0000-0000-0000-000000000002', 'french', 'Concordance des temps', 3, 80, 15, 'practice', 7),
  
  -- Vocabulaire (chapter 3) — Orthographe & niveau langue
  ('e2000000-0000-0000-0000-000000000023', 'c2000000-0000-0000-0000-000000000003', 'french', 'Orthographe d''usage', 1, 40, 8, 'practice', 4),
  ('e2000000-0000-0000-0000-000000000024', 'c2000000-0000-0000-0000-000000000003', 'french', 'Registres de langue', 2, 60, 12, 'practice', 5),
  ('e2000000-0000-0000-0000-000000000025', 'c2000000-0000-0000-0000-000000000003', 'french', 'Figures de style', 2, 60, 12, 'practice', 6),

  -- Compréhension (chapter 4)
  ('e2000000-0000-0000-0000-000000000026', 'c2000000-0000-0000-0000-000000000004', 'french', 'Compréhension : texte narratif', 1, 40, 8, 'practice', 4),
  ('e2000000-0000-0000-0000-000000000027', 'c2000000-0000-0000-0000-000000000004', 'french', 'Compréhension : texte argumentatif', 2, 60, 12, 'practice', 5),
  ('e2000000-0000-0000-0000-000000000028', 'c2000000-0000-0000-0000-000000000004', 'french', 'Analyse de texte littéraire', 3, 80, 15, 'practice', 6),
  
  -- Production écrite (chapter 5)
  ('e2000000-0000-0000-0000-000000000029', 'c2000000-0000-0000-0000-000000000005', 'french', 'Connecteurs et organisation', 1, 40, 8, 'practice', 4),
  ('e2000000-0000-0000-0000-000000000030', 'c2000000-0000-0000-0000-000000000005', 'french', 'Techniques argumentatives', 2, 60, 12, 'practice', 5),
  ('e2000000-0000-0000-0000-000000000031', 'c2000000-0000-0000-0000-000000000005', 'french', 'Rédaction et style', 2, 60, 12, 'practice', 6),
  
  -- Niveau langue général (boss-level mixed)
  ('e2000000-0000-0000-0000-000000000032', 'c2000000-0000-0000-0000-000000000001', 'french', 'Boss: Maître de la langue', 3, 150, 30, 'boss', 8)
ON CONFLICT (id) DO NOTHING;

-- ===================================================================
-- QUESTIONS: Les classes grammaticales (e...015)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000015',
 'Dans la phrase « Les petits enfants jouent joyeusement », quelle est la classe grammaticale de « joyeusement » ?',
 '[{"id":"a","text":"Adverbe"},{"id":"b","text":"Adjectif"},{"id":"c","text":"Nom"},{"id":"d","text":"Verbe"}]',
 'a', 'Les mots en -ment qui modifient un verbe sont des adverbes de manière.', 1),
('e2000000-0000-0000-0000-000000000015',
 'Quelle est la nature du mot « dont » dans : « Le livre dont je parle est intéressant » ?',
 '[{"id":"a","text":"Pronom relatif"},{"id":"b","text":"Conjonction"},{"id":"c","text":"Préposition"},{"id":"d","text":"Adverbe"}]',
 'a', '« Dont » est un pronom relatif qui remplace un complément introduit par « de ».', 2),
('e2000000-0000-0000-0000-000000000015',
 'Dans « Il est très intelligent », le mot « très » est :',
 '[{"id":"a","text":"Un adverbe d''intensité"},{"id":"b","text":"Un adjectif"},{"id":"c","text":"Une conjonction"},{"id":"d","text":"Un déterminant"}]',
 'a', '« Très » modifie l''adjectif « intelligent » → c''est un adverbe d''intensité.', 3),
('e2000000-0000-0000-0000-000000000015',
 'Parmi ces mots, lequel est un déterminant possessif ?',
 '[{"id":"a","text":"leur"},{"id":"b","text":"ils"},{"id":"c","text":"eux"},{"id":"d","text":"se"}]',
 'a', '« Leur » (devant un nom) est un déterminant possessif. « Ils/eux » sont des pronoms personnels.', 4),
('e2000000-0000-0000-0000-000000000015',
 'Dans « Malgré la pluie, nous sommes sortis », « malgré » est :',
 '[{"id":"a","text":"Une préposition"},{"id":"b","text":"Une conjonction de subordination"},{"id":"c","text":"Un adverbe"},{"id":"d","text":"Un pronom"}]',
 'a', '« Malgré » est une préposition qui introduit un complément circonstanciel de concession.', 5),
('e2000000-0000-0000-0000-000000000015',
 '« Celui-ci » est un :',
 '[{"id":"a","text":"Pronom démonstratif"},{"id":"b","text":"Déterminant démonstratif"},{"id":"c","text":"Adjectif"},{"id":"d","text":"Adverbe"}]',
 'a', '« Celui-ci » remplace un nom → c''est un pronom démonstratif (pas un déterminant, car il n''accompagne pas un nom).', 6);

-- ===================================================================
-- QUESTIONS: Les fonctions dans la phrase (e...016)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000016',
 'Dans « Pierre offre un cadeau à sa mère », quelle est la fonction de « à sa mère » ?',
 '[{"id":"a","text":"Complément d''objet indirect (COI)"},{"id":"b","text":"Complément d''objet direct (COD)"},{"id":"c","text":"Complément circonstanciel de lieu"},{"id":"d","text":"Attribut du sujet"}]',
 'a', 'On offre quelque chose À quelqu''un → « à sa mère » répond à la question « à qui ? » → COI.', 1),
('e2000000-0000-0000-0000-000000000016',
 'Dans « Cette fleur est magnifique », quelle est la fonction de « magnifique » ?',
 '[{"id":"a","text":"Attribut du sujet"},{"id":"b","text":"Épithète"},{"id":"c","text":"COD"},{"id":"d","text":"Complément du nom"}]',
 'a', 'Après le verbe d''état « est », l''adjectif est attribut du sujet (il qualifie le sujet via le verbe).', 2),
('e2000000-0000-0000-0000-000000000016',
 'Dans « Le chat de mon voisin dort », la fonction de « de mon voisin » est :',
 '[{"id":"a","text":"Complément du nom"},{"id":"b","text":"COI"},{"id":"c","text":"CC de lieu"},{"id":"d","text":"Attribut"}]',
 'a', '« De mon voisin » complète le nom « chat » → c''est un complément du nom.', 3),
('e2000000-0000-0000-0000-000000000016',
 'Identifiez la fonction de « rapidement » dans : « Il court rapidement. »',
 '[{"id":"a","text":"Complément circonstanciel de manière"},{"id":"b","text":"COD"},{"id":"c","text":"Attribut"},{"id":"d","text":"Épithète"}]',
 'a', '« Rapidement » indique la manière dont il court → CC de manière.', 4),
('e2000000-0000-0000-0000-000000000016',
 'Dans « Les élèves que j''ai rencontrés sont studieux », « que j''ai rencontrés » est :',
 '[{"id":"a","text":"Proposition subordonnée relative (complément de l''antécédent)"},{"id":"b","text":"Proposition subordonnée complétive"},{"id":"c","text":"Proposition subordonnée circonstancielle"},{"id":"d","text":"Proposition indépendante"}]',
 'a', 'Introduite par le pronom relatif « que », elle complète le nom « élèves » (antécédent).', 5),
('e2000000-0000-0000-0000-000000000016',
 'Dans « Je pense que tu as raison », la proposition « que tu as raison » est :',
 '[{"id":"a","text":"COD du verbe penser"},{"id":"b","text":"Complément du nom"},{"id":"c","text":"CC de cause"},{"id":"d","text":"Attribut du sujet"}]',
 'a', '« Je pense QUOI ? que tu as raison » → subordonnée complétive, fonction COD.', 6);

-- ===================================================================
-- QUESTIONS: Syntaxe et construction (e...017)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000017',
 'Quelle phrase est correctement construite ?',
 '[{"id":"a","text":"C''est à toi que je parle."},{"id":"b","text":"C''est à toi que je parle à."},{"id":"c","text":"C''est toi que je parle."},{"id":"d","text":"C''est à toi qui je parle."}]',
 'a', 'La mise en relief avec « c''est...que » est correcte. Pas de préposition en fin ni de confusion qui/que.', 1),
('e2000000-0000-0000-0000-000000000017',
 'Identifiez la phrase qui contient une erreur de construction :',
 '[{"id":"a","text":"Malgré qu''il pleut, je sors."},{"id":"b","text":"Bien qu''il pleuve, je sors."},{"id":"c","text":"Malgré la pluie, je sors."},{"id":"d","text":"Quoiqu''il pleuve, je sors."}]',
 'a', '« Malgré que » est considéré incorrect en français soutenu. On utilise « bien que + subjonctif » ou « malgré + nom ».', 2),
('e2000000-0000-0000-0000-000000000017',
 'Quel est le type de cette phrase : « Puissiez-vous réussir ! » ?',
 '[{"id":"a","text":"Phrase au subjonctif exprimant un souhait"},{"id":"b","text":"Phrase interrogative"},{"id":"c","text":"Phrase impérative"},{"id":"d","text":"Phrase déclarative"}]',
 'a', 'L''inversion sujet-verbe au subjonctif exprime un souhait/vœu. C''est une tournure littéraire.', 3),
('e2000000-0000-0000-0000-000000000017',
 'Dans « Plus il étudie, plus il comprend », on a :',
 '[{"id":"a","text":"Un système corrélatif de comparaison"},{"id":"b","text":"Une subordonnée de cause"},{"id":"c","text":"Une subordonnée de conséquence"},{"id":"d","text":"Une juxtaposition simple"}]',
 'a', '« Plus...plus » est un système corrélatif qui exprime la proportionnalité.', 4),
('e2000000-0000-0000-0000-000000000017',
 'Quelle est la bonne transformation au discours indirect : « Il dit : "Je viendrai demain" » ?',
 '[{"id":"a","text":"Il dit qu''il viendrait le lendemain."},{"id":"b","text":"Il dit qu''il viendra demain."},{"id":"c","text":"Il dit que je viendrai demain."},{"id":"d","text":"Il dit qu''il vient le lendemain."}]',
 'a', 'Discours indirect au passé : futur → conditionnel, demain → le lendemain, je → il.', 5),
('e2000000-0000-0000-0000-000000000017',
 'Quelle phrase utilise correctement le gérondif ?',
 '[{"id":"a","text":"En traversant la rue, il a vu un accident."},{"id":"b","text":"En traversant la rue, un accident s''est produit."},{"id":"c","text":"En traversant la rue, la voiture a freiné."},{"id":"d","text":"Traversant la rue, elle a été vue par un accident."}]',
 'a', 'Le sujet du gérondif doit être le même que celui de la principale. Seule la phrase (a) respecte cette règle.', 6);

-- ===================================================================
-- QUESTIONS: Orthographe grammaticale (e...018)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000018',
 'Complétez : « Les pommes que j''ai ……… étaient délicieuses. »',
 '[{"id":"a","text":"mangées"},{"id":"b","text":"mangé"},{"id":"c","text":"mangée"},{"id":"d","text":"manger"}]',
 'a', 'Avec l''auxiliaire avoir, le participe passé s''accorde avec le COD placé avant : « que » (= les pommes, fém. pluriel).', 1),
('e2000000-0000-0000-0000-000000000018',
 'Quelle est la bonne orthographe : « Elles se sont ……… les mains » ?',
 '[{"id":"a","text":"lavé"},{"id":"b","text":"lavées"},{"id":"c","text":"lavés"},{"id":"d","text":"laver"}]',
 'a', 'Verbe pronominal + COD après (les mains) → le PP ne s''accorde PAS avec le sujet. « Les mains » est COD placé après.', 2),
('e2000000-0000-0000-0000-000000000018',
 'Choisissez la bonne forme : « Il faut que tu ……… tes devoirs. »',
 '[{"id":"a","text":"fasses"},{"id":"b","text":"fais"},{"id":"c","text":"fait"},{"id":"d","text":"ferais"}]',
 'a', 'Après « il faut que » on utilise le subjonctif présent. Faire → que tu fasses.', 3),
('e2000000-0000-0000-0000-000000000018',
 '« Quoique » (en un mot) signifie :',
 '[{"id":"a","text":"Bien que (concession)"},{"id":"b","text":"N''importe quoi"},{"id":"c","text":"Quoi que ce soit"},{"id":"d","text":"Parce que"}]',
 'a', '« Quoique » (1 mot) = bien que (concession). « Quoi que » (2 mots) = quelle que soit la chose que.', 4),
('e2000000-0000-0000-0000-000000000018',
 'Complétez : « ……… soient les difficultés, il ne renonce pas. »',
 '[{"id":"a","text":"Quelles que"},{"id":"b","text":"Quelques"},{"id":"c","text":"Quel que"},{"id":"d","text":"Quelque"}]',
 'a', 'Devant le verbe être au subjonctif + nom féminin pluriel → « quelles que » (accord avec « difficultés »).', 5),
('e2000000-0000-0000-0000-000000000018',
 'Choisissez : « Ces livres, je ……… ai lus. »',
 '[{"id":"a","text":"les"},{"id":"b","text":"leurs"},{"id":"c","text":"lui"},{"id":"d","text":"le"}]',
 'a', '« Ces livres » = masculin pluriel → pronom COD « les ». Le PP « lus » s''accorde car COD avant avec avoir.', 6);

-- ===================================================================
-- QUESTIONS: Temps simples de l'indicatif (e...019)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000019',
 'Conjuguez « finir » au présent avec « nous » :',
 '[{"id":"a","text":"nous finissons"},{"id":"b","text":"nous finisons"},{"id":"c","text":"nous finons"},{"id":"d","text":"nous finissont"}]',
 'a', 'Verbe du 2ème groupe au présent : radical + iss + ons → finissons.', 1),
('e2000000-0000-0000-0000-000000000019',
 'Quel est le temps du verbe dans « Il courut sans s''arrêter » ?',
 '[{"id":"a","text":"Passé simple"},{"id":"b","text":"Imparfait"},{"id":"c","text":"Présent"},{"id":"d","text":"Plus-que-parfait"}]',
 'a', '« Courut » est la forme du passé simple du verbe courir (3ème personne du singulier).', 2),
('e2000000-0000-0000-0000-000000000019',
 'Conjuguez « aller » au futur simple, 1ère personne du singulier :',
 '[{"id":"a","text":"j''irai"},{"id":"b","text":"j''allerai"},{"id":"c","text":"j''irais"},{"id":"d","text":"je vais aller"}]',
 'a', 'Aller au futur : j''irai (radical irrégulier « ir- » + terminaison -ai).', 3),
('e2000000-0000-0000-0000-000000000019',
 'À l''imparfait, « nous » prend toujours la terminaison :',
 '[{"id":"a","text":"-ions"},{"id":"b","text":"-ons"},{"id":"c","text":"-iens"},{"id":"d","text":"-ons"}]',
 'a', 'L''imparfait de l''indicatif : je -ais, tu -ais, il -ait, nous -ions, vous -iez, ils -aient.', 4),
('e2000000-0000-0000-0000-000000000019',
 'Conjuguez « prendre » au passé simple, 3ème personne du pluriel :',
 '[{"id":"a","text":"ils prirent"},{"id":"b","text":"ils prenèrent"},{"id":"c","text":"ils prennent"},{"id":"d","text":"ils prendront"}]',
 'a', 'Prendre au passé simple : je pris, tu pris, il prit, nous prîmes, vous prîtes, ils prirent.', 5),
('e2000000-0000-0000-0000-000000000019',
 'Quel verbe est conjugué à l''imparfait dans cette phrase : « Il neigeait et les enfants jouaient dehors » ?',
 '[{"id":"a","text":"Les deux verbes sont à l''imparfait"},{"id":"b","text":"Seulement neigeait"},{"id":"c","text":"Seulement jouaient"},{"id":"d","text":"Aucun des deux"}]',
 'a', '« Neigeait » et « jouaient » sont tous les deux à l''imparfait (description, actions simultanées dans le passé).', 6);

-- ===================================================================
-- QUESTIONS: Temps composés de l'indicatif (e...020)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000020',
 'Conjuguez « partir » au passé composé avec « elle » :',
 '[{"id":"a","text":"elle est partie"},{"id":"b","text":"elle a parti"},{"id":"c","text":"elle a partie"},{"id":"d","text":"elle est parti"}]',
 'a', 'Partir se conjugue avec l''auxiliaire être → accord du PP avec le sujet féminin : « partie ».', 1),
('e2000000-0000-0000-0000-000000000020',
 'Quel est le plus-que-parfait de « il mange » ?',
 '[{"id":"a","text":"il avait mangé"},{"id":"b","text":"il a mangé"},{"id":"c","text":"il eut mangé"},{"id":"d","text":"il aurait mangé"}]',
 'a', 'Plus-que-parfait = auxiliaire à l''imparfait + PP. Avoir (imparfait) = avait → « il avait mangé ».', 2),
('e2000000-0000-0000-0000-000000000020',
 'Le passé antérieur se forme avec :',
 '[{"id":"a","text":"Auxiliaire au passé simple + participe passé"},{"id":"b","text":"Auxiliaire à l''imparfait + participe passé"},{"id":"c","text":"Auxiliaire au présent + participe passé"},{"id":"d","text":"Auxiliaire au futur + participe passé"}]',
 'a', 'Passé antérieur = auxiliaire (avoir/être) au passé simple + PP. Ex : il eut fini, elle fut partie.', 3),
('e2000000-0000-0000-0000-000000000020',
 'Dans « Quand il eut terminé, il sortit », « eut terminé » exprime :',
 '[{"id":"a","text":"Une action antérieure à une autre action passée"},{"id":"b","text":"Une action future"},{"id":"c","text":"Une action habituelle"},{"id":"d","text":"Un souhait"}]',
 'a', 'Le passé antérieur exprime une action achevée avant une autre action au passé simple.', 4),
('e2000000-0000-0000-0000-000000000020',
 'Avec quel auxiliaire se conjugue « se souvenir » ?',
 '[{"id":"a","text":"Être (verbe pronominal)"},{"id":"b","text":"Avoir"},{"id":"c","text":"Les deux sont possibles"},{"id":"d","text":"Aucun auxiliaire"}]',
 'a', 'Tous les verbes pronominaux se conjuguent avec l''auxiliaire être aux temps composés.', 5),
('e2000000-0000-0000-0000-000000000020',
 'Complétez : « Après qu''il ……… (arriver), nous sommes partis. »',
 '[{"id":"a","text":"fut arrivé"},{"id":"b","text":"soit arrivé"},{"id":"c","text":"est arrivé"},{"id":"d","text":"avait arrivé"}]',
 'a', 'Après « après que » + passé simple dans la principale → passé antérieur dans la subordonnée.', 6);

-- ===================================================================
-- QUESTIONS: Subjonctif et conditionnel (e...021)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000021',
 'Après « il faut que », on utilise :',
 '[{"id":"a","text":"Le subjonctif"},{"id":"b","text":"L''indicatif"},{"id":"c","text":"Le conditionnel"},{"id":"d","text":"L''infinitif"}]',
 'a', '« Il faut que » exprime une obligation/nécessité → toujours suivi du subjonctif.', 1),
('e2000000-0000-0000-0000-000000000021',
 'Conjuguez « être » au subjonctif présent, 3ème personne du singulier :',
 '[{"id":"a","text":"qu''il soit"},{"id":"b","text":"qu''il est"},{"id":"c","text":"qu''il serait"},{"id":"d","text":"qu''il sois"}]',
 'a', 'Être au subjonctif : que je sois, que tu sois, qu''il soit, que nous soyons, que vous soyez, qu''ils soient.', 2),
('e2000000-0000-0000-0000-000000000021',
 'Le conditionnel présent exprime :',
 '[{"id":"a","text":"Un souhait, une hypothèse, une politesse"},{"id":"b","text":"Uniquement le futur"},{"id":"c","text":"Un ordre"},{"id":"d","text":"Le passé"}]',
 'a', 'Le conditionnel exprime : hypothèse (si + imparfait), souhait (j''aimerais), politesse (pourriez-vous).', 3),
('e2000000-0000-0000-0000-000000000021',
 'Complétez : « Si j''avais de l''argent, j'' ……… un vélo. »',
 '[{"id":"a","text":"achèterais"},{"id":"b","text":"achèterai"},{"id":"c","text":"achetais"},{"id":"d","text":"achète"}]',
 'a', 'Si + imparfait → conditionnel présent dans la principale. Acheter → j''achèterais.', 4),
('e2000000-0000-0000-0000-000000000021',
 'Quelle phrase exige le subjonctif ?',
 '[{"id":"a","text":"Je souhaite qu''il vienne."},{"id":"b","text":"Je sais qu''il vient."},{"id":"c","text":"Je pense qu''il viendra."},{"id":"d","text":"Je crois qu''il est là."}]',
 'a', 'Les verbes de souhait/volonté/doute (souhaiter, vouloir, douter) sont suivis du subjonctif.', 5),
('e2000000-0000-0000-0000-000000000021',
 'Conjuguez « avoir » au conditionnel passé, 1ère personne : « j'' ……… »',
 '[{"id":"a","text":"aurais eu"},{"id":"b","text":"avais eu"},{"id":"c","text":"aurai eu"},{"id":"d","text":"ai eu"}]',
 'a', 'Conditionnel passé = auxiliaire au conditionnel présent + PP. Avoir → j''aurais eu.', 6);

-- ===================================================================
-- QUESTIONS: Concordance des temps (e...022)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000022',
 'Complétez : « Si tu étudies bien, tu ……… ton examen. »',
 '[{"id":"a","text":"réussiras (futur)"},{"id":"b","text":"réussirais (conditionnel)"},{"id":"c","text":"réussis (présent)"},{"id":"d","text":"as réussi (passé composé)"}]',
 'a', 'Si + présent → futur dans la principale. C''est la condition réalisable.', 1),
('e2000000-0000-0000-0000-000000000022',
 'Complétez : « Si tu avais étudié, tu ……… réussi. »',
 '[{"id":"a","text":"aurais"},{"id":"b","text":"avais"},{"id":"c","text":"auras"},{"id":"d","text":"as"}]',
 'a', 'Si + plus-que-parfait → conditionnel passé (condition irréelle dans le passé).', 2),
('e2000000-0000-0000-0000-000000000022',
 'Dans le discours indirect au passé, le présent devient :',
 '[{"id":"a","text":"L''imparfait"},{"id":"b","text":"Le passé simple"},{"id":"c","text":"Le conditionnel"},{"id":"d","text":"Le futur"}]',
 'a', 'Transposition temporelle : présent → imparfait. Ex : « Je suis fatigué » → Il a dit qu''il était fatigué.', 3),
('e2000000-0000-0000-0000-000000000022',
 'Dans le discours indirect au passé, le futur simple devient :',
 '[{"id":"a","text":"Le conditionnel présent"},{"id":"b","text":"L''imparfait"},{"id":"c","text":"Le plus-que-parfait"},{"id":"d","text":"Le futur antérieur"}]',
 'a', 'Transposition : futur → conditionnel. « Je viendrai » → Il a dit qu''il viendrait.', 4),
('e2000000-0000-0000-0000-000000000022',
 'Complétez : « Il fallait qu''il ……… avant midi. »',
 '[{"id":"a","text":"partît (subjonctif imparfait)"},{"id":"b","text":"parte (subjonctif présent)"},{"id":"c","text":"partait (indicatif imparfait)"},{"id":"d","text":"partirait (conditionnel)"}]',
 'b', 'En français moderne, on utilise le subjonctif présent même si la principale est au passé. Le subjonctif imparfait est littéraire.', 5),
('e2000000-0000-0000-0000-000000000022',
 'Après « avant que », on utilise :',
 '[{"id":"a","text":"Le subjonctif"},{"id":"b","text":"L''indicatif"},{"id":"c","text":"Le conditionnel"},{"id":"d","text":"L''infinitif obligatoirement"}]',
 'a', '« Avant que » exprime un fait non encore réalisé → subjonctif. Ex : Avant qu''il (ne) parte.', 6);

-- ===================================================================
-- QUESTIONS: Orthographe d'usage (e...023)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000023',
 'Quelle est la bonne orthographe ?',
 '[{"id":"a","text":"apparemment"},{"id":"b","text":"apparament"},{"id":"c","text":"apparement"},{"id":"d","text":"aparemment"}]',
 'a', 'Apparemment : deux « p », e-m-m-e-n-t (formé sur « apparent » → apparemment).', 1),
('e2000000-0000-0000-0000-000000000023',
 'Choisissez la bonne orthographe :',
 '[{"id":"a","text":"acquérir"},{"id":"b","text":"aquerir"},{"id":"c","text":"acquèrir"},{"id":"d","text":"acquérrir"}]',
 'a', 'Acquérir : a-c-q-u-é-r-i-r. Attention au « cqu » et à l''accent aigu.', 2),
('e2000000-0000-0000-0000-000000000023',
 '« ……… » signifie « qui peut se produire » :',
 '[{"id":"a","text":"éventuel"},{"id":"b","text":"éventuelle"},{"id":"c","text":"éventuellement"},{"id":"d","text":"éventualité"}]',
 'a', '« Éventuel » est l''adjectif (masc.) signifiant « qui peut se produire ». « Éventuelle » est le féminin.', 3),
('e2000000-0000-0000-0000-000000000023',
 'Complétez : « Il a fait ……… d''effort pour réussir. »',
 '[{"id":"a","text":"beaucoup"},{"id":"b","text":"beaucoups"},{"id":"c","text":"baucoup"},{"id":"d","text":"beaucou"}]',
 'a', '« Beaucoup » est invariable et ne prend jamais de « s ».', 4),
('e2000000-0000-0000-0000-000000000023',
 'Quelle est la bonne orthographe ?',
 '[{"id":"a","text":"développement"},{"id":"b","text":"dévellopement"},{"id":"c","text":"développment"},{"id":"d","text":"developpement"}]',
 'a', 'Développement : d-é-v-e-l-o-p-p-e-m-e-n-t (deux « p », un seul « l », accent sur le premier « e »).', 5),
('e2000000-0000-0000-0000-000000000023',
 'Le pluriel de « œil » est :',
 '[{"id":"a","text":"yeux"},{"id":"b","text":"œils"},{"id":"c","text":"oyeux"},{"id":"d","text":"œux"}]',
 'a', '« Œil » a un pluriel irrégulier : « yeux ». (Sauf dans des-œils-de-bœuf = les fenêtres rondes).', 6);

-- ===================================================================
-- QUESTIONS: Registres de langue (e...024)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000024',
 '« Grouille-toi, on va être en retard ! » est du registre :',
 '[{"id":"a","text":"Familier"},{"id":"b","text":"Courant"},{"id":"c","text":"Soutenu"},{"id":"d","text":"Littéraire"}]',
 'a', '« Grouille-toi » est une expression familière. En registre courant : « Dépêche-toi ».', 1),
('e2000000-0000-0000-0000-000000000024',
 'Quel est l''équivalent en registre soutenu de « bouquin » ?',
 '[{"id":"a","text":"ouvrage"},{"id":"b","text":"livre"},{"id":"c","text":"truc à lire"},{"id":"d","text":"bouquinage"}]',
 'a', 'Bouquin (familier) → livre (courant) → ouvrage (soutenu).', 2),
('e2000000-0000-0000-0000-000000000024',
 'Dans quel registre est la phrase : « Il convient de noter que cette hypothèse demeure incertaine » ?',
 '[{"id":"a","text":"Soutenu"},{"id":"b","text":"Courant"},{"id":"c","text":"Familier"},{"id":"d","text":"Populaire"}]',
 'a', 'L''usage de « il convient de », « noter que », « demeure » relève du registre soutenu/formel.', 3),
('e2000000-0000-0000-0000-000000000024',
 'Quel mot appartient au registre familier ?',
 '[{"id":"a","text":"bagnole"},{"id":"b","text":"automobile"},{"id":"c","text":"voiture"},{"id":"d","text":"véhicule"}]',
 'a', 'Bagnole (familier) → voiture (courant) → automobile/véhicule (soutenu).', 4),
('e2000000-0000-0000-0000-000000000024',
 'L''emploi du passé simple à l''oral relève plutôt du registre :',
 '[{"id":"a","text":"Soutenu / littéraire"},{"id":"b","text":"Courant"},{"id":"c","text":"Familier"},{"id":"d","text":"Populaire"}]',
 'a', 'Le passé simple est quasiment absent de l''oral courant en français moderne. Son emploi oral est très soutenu/littéraire.', 5),
('e2000000-0000-0000-0000-000000000024',
 'Reformulez en registre courant : « Je n''ai point compris. »',
 '[{"id":"a","text":"Je n''ai pas compris."},{"id":"b","text":"J''ai rien capté."},{"id":"c","text":"Je ne comprends mie."},{"id":"d","text":"J''ai pas pigé."}]',
 'a', '« Ne...point » est une forme de négation littéraire/soutenue. L''équivalent courant est « ne...pas ».', 6);

-- ===================================================================
-- QUESTIONS: Figures de style (e...025)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000025',
 '« La vie est un long fleuve tranquille » est :',
 '[{"id":"a","text":"Une métaphore"},{"id":"b","text":"Une comparaison"},{"id":"c","text":"Une hyperbole"},{"id":"d","text":"Une litote"}]',
 'a', 'Pas d''outil de comparaison (comme, tel) → c''est une métaphore (assimilation directe).', 1),
('e2000000-0000-0000-0000-000000000025',
 '« Il est fort comme un lion » est :',
 '[{"id":"a","text":"Une comparaison"},{"id":"b","text":"Une métaphore"},{"id":"c","text":"Une personnification"},{"id":"d","text":"Une antithèse"}]',
 'a', 'Présence de l''outil « comme » → c''est une comparaison (comparé + outil + comparant).', 2),
('e2000000-0000-0000-0000-000000000025',
 '« Ce n''est pas mal » pour dire « c''est très bien » est :',
 '[{"id":"a","text":"Une litote"},{"id":"b","text":"Un euphémisme"},{"id":"c","text":"Une antiphrase"},{"id":"d","text":"Une hyperbole"}]',
 'a', 'La litote consiste à dire moins pour suggérer plus. « Ce n''est pas mal » = c''est très bien.', 3),
('e2000000-0000-0000-0000-000000000025',
 '« J''ai mille choses à faire » est :',
 '[{"id":"a","text":"Une hyperbole"},{"id":"b","text":"Une litote"},{"id":"c","text":"Un pléonasme"},{"id":"d","text":"Une métonymie"}]',
 'a', 'L''hyperbole est une exagération volontaire. « Mille choses » exagère la quantité réelle.', 4),
('e2000000-0000-0000-0000-000000000025',
 '« Le vent gémit dans les arbres » est :',
 '[{"id":"a","text":"Une personnification"},{"id":"b","text":"Une métaphore"},{"id":"c","text":"Une comparaison"},{"id":"d","text":"Une synecdoque"}]',
 'a', 'Attribuer une action humaine (gémir) à un élément naturel (le vent) → personnification.', 5),
('e2000000-0000-0000-0000-000000000025',
 '« Boire un verre » est :',
 '[{"id":"a","text":"Une métonymie"},{"id":"b","text":"Une métaphore"},{"id":"c","text":"Une comparaison"},{"id":"d","text":"Un oxymore"}]',
 'a', 'On désigne le contenu (la boisson) par le contenant (le verre) → métonymie.', 6);

-- ===================================================================
-- QUESTIONS: Compréhension texte narratif (e...026)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000026',
 'Dans un récit, le narrateur qui dit « je » est un narrateur :',
 '[{"id":"a","text":"Interne (personnage de l''histoire)"},{"id":"b","text":"Externe (hors de l''histoire)"},{"id":"c","text":"Omniscient"},{"id":"d","text":"Neutre"}]',
 'a', 'Le narrateur à la 1ère personne participe à l''histoire → point de vue/focalisation interne.', 1),
('e2000000-0000-0000-0000-000000000026',
 'Le schéma narratif commence par :',
 '[{"id":"a","text":"La situation initiale"},{"id":"b","text":"L''élément perturbateur"},{"id":"c","text":"Les péripéties"},{"id":"d","text":"Le dénouement"}]',
 'a', 'Ordre : situation initiale → élément perturbateur → péripéties → dénouement → situation finale.', 2),
('e2000000-0000-0000-0000-000000000026',
 'L''imparfait dans un récit au passé sert principalement à :',
 '[{"id":"a","text":"Décrire et exprimer des actions en arrière-plan"},{"id":"b","text":"Raconter les actions principales"},{"id":"c","text":"Exprimer le futur dans le passé"},{"id":"d","text":"Donner un ordre"}]',
 'a', 'Imparfait = descriptions, habitudes, arrière-plan. Passé simple = actions ponctuelles, premier plan.', 3),
('e2000000-0000-0000-0000-000000000026',
 'Un texte qui raconte une histoire avec des personnages fictifs est un texte :',
 '[{"id":"a","text":"Narratif"},{"id":"b","text":"Argumentatif"},{"id":"c","text":"Explicatif"},{"id":"d","text":"Injonctif"}]',
 'a', 'Un texte narratif raconte une histoire (réelle ou fictive) avec des personnages et une chronologie.', 4),
('e2000000-0000-0000-0000-000000000026',
 'Dans « Soudain, un bruit retentit », le mot « soudain » est :',
 '[{"id":"a","text":"Un connecteur temporel marquant la rupture"},{"id":"b","text":"Un adjectif qualificatif"},{"id":"c","text":"Un verbe"},{"id":"d","text":"Une conjonction de coordination"}]',
 'a', '« Soudain » est un adverbe/connecteur temporel qui marque un changement brusque dans la narration.', 5),
('e2000000-0000-0000-0000-000000000026',
 'Le point de vue omniscient signifie que le narrateur :',
 '[{"id":"a","text":"Sait tout (pensées, passé, futur de tous les personnages)"},{"id":"b","text":"Ne sait rien"},{"id":"c","text":"Ne voit que ce qu''un personnage voit"},{"id":"d","text":"Est un personnage secondaire"}]',
 'a', 'Omniscient (= qui sait tout) : le narrateur connaît les pensées de tous les personnages.', 6);

-- ===================================================================
-- QUESTIONS: Compréhension texte argumentatif (e...027)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000027',
 'Un texte argumentatif a pour but de :',
 '[{"id":"a","text":"Convaincre ou persuader le lecteur"},{"id":"b","text":"Raconter une histoire"},{"id":"c","text":"Décrire un lieu"},{"id":"d","text":"Expliquer un phénomène scientifique"}]',
 'a', 'L''argumentation vise à faire adhérer le lecteur à une thèse en utilisant des arguments et des exemples.', 1),
('e2000000-0000-0000-0000-000000000027',
 'La thèse dans un texte argumentatif est :',
 '[{"id":"a","text":"L''opinion défendue par l''auteur"},{"id":"b","text":"Un exemple concret"},{"id":"c","text":"Un fait scientifique"},{"id":"d","text":"Le titre du texte"}]',
 'a', 'La thèse est l''idée principale que l''auteur cherche à défendre ou à prouver.', 2),
('e2000000-0000-0000-0000-000000000027',
 'Un argument est :',
 '[{"id":"a","text":"Une raison qui justifie la thèse"},{"id":"b","text":"Un récit illustratif"},{"id":"c","text":"Un mot de liaison"},{"id":"d","text":"La conclusion du texte"}]',
 'a', 'Un argument est une idée/raison qui soutient la thèse. Un exemple l''illustre concrètement.', 3),
('e2000000-0000-0000-0000-000000000027',
 '« D''une part... d''autre part » exprime :',
 '[{"id":"a","text":"L''addition/l''énumération"},{"id":"b","text":"L''opposition"},{"id":"c","text":"La cause"},{"id":"d","text":"La conséquence"}]',
 'a', '« D''une part... d''autre part » sert à ajouter des arguments (connecteur d''addition).', 4),
('e2000000-0000-0000-0000-000000000027',
 '« Cependant », « néanmoins », « toutefois » expriment :',
 '[{"id":"a","text":"L''opposition / la concession"},{"id":"b","text":"La cause"},{"id":"c","text":"La conséquence"},{"id":"d","text":"Le temps"}]',
 'a', 'Ces mots introduisent une idée contraire ou une nuance → connecteurs d''opposition/concession.', 5),
('e2000000-0000-0000-0000-000000000027',
 'Quel procédé vise à toucher les émotions du lecteur ?',
 '[{"id":"a","text":"La persuasion"},{"id":"b","text":"La conviction"},{"id":"c","text":"La démonstration"},{"id":"d","text":"L''explication"}]',
 'a', 'Persuader = toucher les sentiments/émotions. Convaincre = s''adresser à la raison avec des arguments logiques.', 6);

-- ===================================================================
-- QUESTIONS: Analyse de texte littéraire (e...028)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000028',
 'Le champ lexical de la tristesse inclut :',
 '[{"id":"a","text":"larmes, douleur, mélancolie, pleurer, sombre"},{"id":"b","text":"soleil, rire, bonheur, fête"},{"id":"c","text":"courir, sauter, voler, nager"},{"id":"d","text":"rouge, bleu, vert, jaune"}]',
 'a', 'Un champ lexical regroupe des mots liés à un même thème. Ici : le vocabulaire de la tristesse.', 1),
('e2000000-0000-0000-0000-000000000028',
 'L''ironie consiste à :',
 '[{"id":"a","text":"Dire le contraire de ce qu''on pense pour critiquer"},{"id":"b","text":"Exagérer la réalité"},{"id":"c","text":"Raconter une anecdote"},{"id":"d","text":"Répéter un mot pour l''emphase"}]',
 'a', 'L''ironie = dire l''inverse de ce qu''on pense. Souvent utilisée pour la critique ou l''humour.', 2),
('e2000000-0000-0000-0000-000000000028',
 'Un oxymore est :',
 '[{"id":"a","text":"L''association de deux mots contradictoires"},{"id":"b","text":"Une exagération"},{"id":"c","text":"Une comparaison sans outil"},{"id":"d","text":"Une répétition de sons"}]',
 'a', 'Exemples d''oxymores : « un silence assourdissant », « une douce violence », « obscure clarté ».', 3),
('e2000000-0000-0000-0000-000000000028',
 'L''allitération est la répétition :',
 '[{"id":"a","text":"De consonnes"},{"id":"b","text":"De voyelles"},{"id":"c","text":"De mots"},{"id":"d","text":"De phrases"}]',
 'a', 'Allitération = répétition de consonnes. Assonance = répétition de voyelles. Les deux créent des effets sonores.', 4),
('e2000000-0000-0000-0000-000000000028',
 'Dans un poème, l''enjambement c''est quand :',
 '[{"id":"a","text":"La phrase se poursuit au vers suivant"},{"id":"b","text":"Deux vers riment ensemble"},{"id":"c","text":"Un vers est plus court que les autres"},{"id":"d","text":"Le poème n''a pas de rimes"}]',
 'a', 'L''enjambement = la phrase déborde d''un vers sur le suivant, créant un effet de continuité ou de mise en relief.', 5),
('e2000000-0000-0000-0000-000000000028',
 'Le registre pathétique vise à provoquer chez le lecteur :',
 '[{"id":"a","text":"La pitié, la compassion"},{"id":"b","text":"Le rire"},{"id":"c","text":"La peur"},{"id":"d","text":"L''admiration"}]',
 'a', 'Pathétique (du grec pathos = souffrance) → vise à émouvoir, à susciter la pitié du lecteur.', 6);

-- ===================================================================
-- QUESTIONS: Connecteurs et organisation (e...029)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000029',
 '« Par conséquent » exprime :',
 '[{"id":"a","text":"La conséquence"},{"id":"b","text":"La cause"},{"id":"c","text":"L''opposition"},{"id":"d","text":"L''addition"}]',
 'a', '« Par conséquent » = donc, ainsi, c''est pourquoi → connecteur de conséquence.', 1),
('e2000000-0000-0000-0000-000000000029',
 'Pour introduire un premier argument, on utilise :',
 '[{"id":"a","text":"Tout d''abord / Premièrement / En premier lieu"},{"id":"b","text":"Enfin / En conclusion"},{"id":"c","text":"Cependant / Toutefois"},{"id":"d","text":"Car / Parce que"}]',
 'a', 'Les connecteurs d''organisation du discours : d''abord, ensuite, enfin ; premièrement, deuxièmement...', 2),
('e2000000-0000-0000-0000-000000000029',
 '« En effet » sert à :',
 '[{"id":"a","text":"Justifier / expliquer ce qui précède"},{"id":"b","text":"S''opposer à l''idée précédente"},{"id":"c","text":"Conclure le texte"},{"id":"d","text":"Ajouter un nouvel argument"}]',
 'a', '« En effet » introduit une explication ou une justification de l''affirmation précédente.', 3),
('e2000000-0000-0000-0000-000000000029',
 'Quel connecteur marque la conclusion ?',
 '[{"id":"a","text":"En somme / En définitive / Pour conclure"},{"id":"b","text":"D''abord / Tout d''abord"},{"id":"c","text":"Ensuite / De plus"},{"id":"d","text":"Parce que / Puisque"}]',
 'a', 'En somme, en définitive, pour conclure, bref, finalement → connecteurs de conclusion.', 4),
('e2000000-0000-0000-0000-000000000029',
 '« Bien que » est suivi de :',
 '[{"id":"a","text":"Du subjonctif"},{"id":"b","text":"De l''indicatif"},{"id":"c","text":"Du conditionnel"},{"id":"d","text":"De l''infinitif"}]',
 'a', '« Bien que » (concession) est toujours suivi du subjonctif : Bien qu''il soit malade, il travaille.', 5),
('e2000000-0000-0000-0000-000000000029',
 'Classez ces connecteurs : cause, conséquence, opposition. « Puisque / Donc / Pourtant »',
 '[{"id":"a","text":"Cause / Conséquence / Opposition"},{"id":"b","text":"Opposition / Cause / Conséquence"},{"id":"c","text":"Conséquence / Opposition / Cause"},{"id":"d","text":"Cause / Opposition / Conséquence"}]',
 'a', 'Puisque = cause, Donc = conséquence, Pourtant = opposition.', 6);

-- ===================================================================
-- QUESTIONS: Techniques argumentatives (e...030)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000030',
 'L''argument d''autorité consiste à :',
 '[{"id":"a","text":"Citer un expert ou une source reconnue"},{"id":"b","text":"Raconter une anecdote personnelle"},{"id":"c","text":"Utiliser des statistiques"},{"id":"d","text":"Faire appel aux émotions"}]',
 'a', 'L''argument d''autorité s''appuie sur la crédibilité d''un spécialiste, d''un scientifique ou d''une institution.', 1),
('e2000000-0000-0000-0000-000000000030',
 'Quel type d''exemple est le plus convaincant dans un texte argumentatif ?',
 '[{"id":"a","text":"Un exemple concret et vérifié (fait, statistique, étude)"},{"id":"b","text":"Une opinion personnelle"},{"id":"c","text":"Un proverbe populaire"},{"id":"d","text":"Une hypothèse non vérifiée"}]',
 'a', 'Les exemples concrets (faits, données chiffrées, études) sont plus convaincants car ils sont vérifiables.', 2),
('e2000000-0000-0000-0000-000000000030',
 'La concession dans l''argumentation consiste à :',
 '[{"id":"a","text":"Admettre un argument adverse avant de le réfuter"},{"id":"b","text":"Rejeter totalement l''argument adverse"},{"id":"c","text":"Ignorer l''opinion contraire"},{"id":"d","text":"Répéter sa thèse plus fort"}]',
 'a', 'La concession = reconnaître la validité partielle de l''argument adverse pour mieux le dépasser. Ex : Certes... mais...', 3),
('e2000000-0000-0000-0000-000000000030',
 'Un contre-argument sert à :',
 '[{"id":"a","text":"Réfuter la thèse adverse"},{"id":"b","text":"Soutenir sa propre thèse"},{"id":"c","text":"Résumer le texte"},{"id":"d","text":"Conclure le débat"}]',
 'a', 'Le contre-argument s''oppose directement à un argument de la thèse adverse pour le déconstruire.', 4),
('e2000000-0000-0000-0000-000000000030',
 'La question rhétorique est :',
 '[{"id":"a","text":"Une question qui n''attend pas de réponse"},{"id":"b","text":"Une question qui attend une réponse précise"},{"id":"c","text":"Une phrase exclamative"},{"id":"d","text":"Un ordre déguisé"}]',
 'a', 'La question rhétorique contient déjà sa réponse. Elle implique le lecteur et renforce l''argumentation.', 5),
('e2000000-0000-0000-0000-000000000030',
 'Pour introduire une concession, on utilise :',
 '[{"id":"a","text":"Certes... mais / Il est vrai que... cependant"},{"id":"b","text":"Donc / Par conséquent"},{"id":"c","text":"Car / Parce que"},{"id":"d","text":"D''abord / Ensuite"}]',
 'a', '« Certes... mais », « il est vrai que... cependant », « sans doute... toutefois » introduisent la concession.', 6);

-- ===================================================================
-- QUESTIONS: Rédaction et style (e...031)
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000031',
 'Une introduction de production écrite doit contenir :',
 '[{"id":"a","text":"Une accroche + présentation du sujet + annonce du plan"},{"id":"b","text":"Directement les arguments"},{"id":"c","text":"Un résumé de la conclusion"},{"id":"d","text":"Des exemples détaillés"}]',
 'a', 'L''introduction en 3 temps : accroche (phrase d''entrée), présentation du sujet, annonce du plan.', 1),
('e2000000-0000-0000-0000-000000000031',
 'Pour éviter la répétition du mot « dire », on peut utiliser :',
 '[{"id":"a","text":"affirmer, déclarer, préciser, soutenir"},{"id":"b","text":"manger, courir, dormir"},{"id":"c","text":"le, la, les, un"},{"id":"d","text":"et, mais, donc, car"}]',
 'a', 'La variété lexicale enrichit le style. Pour « dire » : affirmer, déclarer, avouer, rétorquer, préciser, soutenir...', 2),
('e2000000-0000-0000-0000-000000000031',
 'Un paragraphe argumentatif bien construit suit l''ordre :',
 '[{"id":"a","text":"Argument → Explication → Exemple → Transition"},{"id":"b","text":"Exemple → Argument → Conclusion"},{"id":"c","text":"Transition → Exemple → Argument"},{"id":"d","text":"Citation → Opinion → Fin"}]',
 'a', 'Structure AEET : Argument (idée) → Explication → Exemple (preuve) → Transition vers le paragraphe suivant.', 3),
('e2000000-0000-0000-0000-000000000031',
 'Quelle phrase d''accroche est la plus efficace pour un sujet sur la lecture ?',
 '[{"id":"a","text":"« Lire, c''est voyager sans bouger » : la lecture est-elle encore pertinente à l''ère du numérique ?"},{"id":"b","text":"Je vais parler de la lecture."},{"id":"c","text":"La lecture existe depuis longtemps."},{"id":"d","text":"Tout le monde lit des livres."}]',
 'a', 'Une bonne accroche interpelle le lecteur (citation, question, fait surprenant) et amène le sujet.', 4),
('e2000000-0000-0000-0000-000000000031',
 'La conclusion d''une production écrite doit :',
 '[{"id":"a","text":"Résumer les idées principales et ouvrir une perspective"},{"id":"b","text":"Ajouter de nouveaux arguments"},{"id":"c","text":"Contredire l''introduction"},{"id":"d","text":"Répéter mot pour mot l''introduction"}]',
 'a', 'Conclusion = bilan (synthèse des arguments) + ouverture (élargissement, question, perspective).', 5),
('e2000000-0000-0000-0000-000000000031',
 'Pour enrichir son style, il est conseillé de :',
 '[{"id":"a","text":"Varier la longueur des phrases et utiliser des figures de style"},{"id":"b","text":"Écrire uniquement des phrases courtes"},{"id":"c","text":"Répéter les mêmes expressions"},{"id":"d","text":"Utiliser uniquement des phrases longues et complexes"}]',
 'a', 'Un bon style alterne phrases courtes (impact) et longues (nuance), utilise des figures de style et un vocabulaire varié.', 6);

-- ===================================================================
-- QUESTIONS: Boss - Maître de la langue (e...032) — Mix de tout
-- ===================================================================
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
('e2000000-0000-0000-0000-000000000032',
 'Dans « Les enfants, dont les parents travaillent, restent à la cantine », « dont » remplace :',
 '[{"id":"a","text":"un complément du nom (les parents DES enfants)"},{"id":"b","text":"un COD"},{"id":"c","text":"un CC de lieu"},{"id":"d","text":"un attribut"}]',
 'a', '« Dont » remplace un complément introduit par « de ». Ici : les parents DE QUI → des enfants.', 1),
('e2000000-0000-0000-0000-000000000032',
 'Conjuguez « résoudre » au passé simple, 3ème personne : « il ……… le problème »',
 '[{"id":"a","text":"résolut"},{"id":"b","text":"résolvit"},{"id":"c","text":"résoudra"},{"id":"d","text":"résout"}]',
 'a', 'Résoudre au passé simple : je résolus, tu résolus, il résolut, nous résolûmes, vous résolûtes, ils résolurent.', 2),
('e2000000-0000-0000-0000-000000000032',
 'Quelle figure de style dans : « Cette obscure clarté qui tombe des étoiles » (Corneille) ?',
 '[{"id":"a","text":"Un oxymore"},{"id":"b","text":"Une métaphore"},{"id":"c","text":"Une hyperbole"},{"id":"d","text":"Une litote"}]',
 'a', '« Obscure clarté » associe deux termes contradictoires → oxymore.', 3),
('e2000000-0000-0000-0000-000000000032',
 'Complétez : « ……… tu ……… fait de tes vacances ? »',
 '[{"id":"a","text":"Qu''as-tu"},{"id":"b","text":"Qu''a tu"},{"id":"c","text":"Que as-tu"},{"id":"d","text":"Qu''as-toi"}]',
 'a', '« Que » s''élide devant une voyelle → « qu'' ». Inversion : as-tu (pas « a tu »).', 4),
('e2000000-0000-0000-0000-000000000032',
 'Le registre comique utilise souvent :',
 '[{"id":"a","text":"L''exagération, les jeux de mots, les quiproquos"},{"id":"b","text":"Le vocabulaire de la mort"},{"id":"c","text":"Les descriptions de paysages"},{"id":"d","text":"Les termes scientifiques"}]',
 'a', 'Le comique s''appuie sur : exagération (farce), jeux de mots, quiproquos, ironie, décalage.', 5),
('e2000000-0000-0000-0000-000000000032',
 'Transformez au subjonctif : « Il faut que nous (savoir) la vérité. »',
 '[{"id":"a","text":"sachions"},{"id":"b","text":"savons"},{"id":"c","text":"saurions"},{"id":"d","text":"savions"}]',
 'a', 'Savoir au subjonctif présent : que je sache, que tu saches, qu''il sache, que nous sachions.', 6),
('e2000000-0000-0000-0000-000000000032',
 'Dans un texte argumentatif, « en revanche » introduit :',
 '[{"id":"a","text":"Une opposition"},{"id":"b","text":"Une cause"},{"id":"c","text":"Une conséquence"},{"id":"d","text":"Un exemple"}]',
 'a', '« En revanche » = par contre, au contraire → connecteur d''opposition.', 7),
('e2000000-0000-0000-0000-000000000032',
 'Quel est le pluriel de « un festival » ?',
 '[{"id":"a","text":"des festivals"},{"id":"b","text":"des festivaux"},{"id":"c","text":"des festivales"},{"id":"d","text":"des festival"}]',
 'a', 'Les noms en -al font leur pluriel en -aux SAUF exceptions : festivals, carnavals, bals, récitals...', 8);
