-- ─────────────────────────────────────────────
-- HearIt – Seed Data
-- Run AFTER schema.sql
-- Audio URLs use bundle:// for now — replace
-- with real Supabase Storage URLs once uploaded
-- ─────────────────────────────────────────────

-- CATEGORIES

insert into categories (id, name_en, name_ar, icon, color_hex, total_questions) values
  ('arab-singers',  'Arab Singers',      'مطربون عرب',      '🎤', '#E91E63', 10),
  ('animals',       'Animals',           'حيوانات',          '🦁', '#4CAF50', 0),
  ('instruments',   'Music Instruments', 'آلات موسيقية',    '🎸', '#9C27B0', 0),
  ('car-engines',   'Car Engines',       'محركات السيارات', '🚗', '#FF5722', 0),
  ('languages',     'Languages',         'لغات',             '🌍', '#2196F3', 0),
  ('nature',        'Nature Sounds',     'أصوات الطبيعة',   '🌿', '#009688', 0),
  ('sports',        'Sports',            'رياضة',            '⚽', '#FF9800', 0),
  ('intl-singers',  'World Singers',     'مطربون عالميون',  '🌟', '#607D8B', 0)
on conflict (id) do nothing;

-- QUESTIONS — Arab Singers

insert into questions (id, category_id, audio_url, correct_index, hint_en, hint_ar) values
  ('q1',  'arab-singers', 'bundle://fairouz_01',      0, 'Lebanese icon',         'أيقونة لبنانية'),
  ('q2',  'arab-singers', 'bundle://umm_kulthum_01',  2, 'Egyptian legend',       'أسطورة مصرية'),
  ('q3',  'arab-singers', 'bundle://abdel_halim_01',  0, 'The dark nightingale',  'العندليب الأسمر'),
  ('q4',  'arab-singers', 'bundle://amr_diab_01',     1, 'Habibi ya nour el ain', 'حبيبي يا نور العين'),
  ('q5',  'arab-singers', 'bundle://kadhem_01',       0, 'Iraqi romantic singer', 'المطرب العراقي الرومانسي'),
  ('q6',  'arab-singers', 'bundle://majid_01',        2, 'Gulf superstar',        'نجم خليجي'),
  ('q7',  'arab-singers', 'bundle://warda_01',        1, 'Algerian-Egyptian diva','ديفا جزائرية مصرية'),
  ('q8',  'arab-singers', 'bundle://najwa_01',        1, 'Lebanese mountain voice','صوت الجبل اللبناني'),
  ('q9',  'arab-singers', 'bundle://mounir_01',       0, 'King of music',         'ملك'),
  ('q10', 'arab-singers', 'bundle://elissa_01',       1, 'Lebanese pop queen',    'ملكة البوب اللبنانية')
on conflict (id) do nothing;

-- ANSWERS

insert into answers (id, question_id, text_en, text_ar, sort_order) values
  -- q1 (correct: 0 = Fairouz)
  ('q1a0', 'q1', 'Fairouz',     'فيروز',      0),
  ('q1a1', 'q1', 'Warda',       'وردة',       1),
  ('q1a2', 'q1', 'Umm Kulthum', 'أم كلثوم',  2),
  ('q1a3', 'q1', 'Sabah',       'صباح',       3),
  -- q2 (correct: 2 = Umm Kulthum)
  ('q2a0', 'q2', 'Fairouz',     'فيروز',      0),
  ('q2a1', 'q2', 'Warda',       'وردة',       1),
  ('q2a2', 'q2', 'Umm Kulthum', 'أم كلثوم',  2),
  ('q2a3', 'q2', 'Sabah',       'صباح',       3),
  -- q3 (correct: 0 = Abdel Halim Hafez)
  ('q3a0', 'q3', 'Abdel Halim Hafez', 'عبد الحليم حافظ', 0),
  ('q3a1', 'q3', 'Mohamed Mounir',    'محمد منير',        1),
  ('q3a2', 'q3', 'Amr Diab',          'عمرو دياب',        2),
  ('q3a3', 'q3', 'Kadhem Al Saher',   'كاظم الساهر',      3),
  -- q4 (correct: 1 = Amr Diab)
  ('q4a0', 'q4', 'Tamer Hosny',    'تامر حسني',   0),
  ('q4a1', 'q4', 'Amr Diab',       'عمرو دياب',   1),
  ('q4a2', 'q4', 'Mohamed Fo''ad', 'محمد فؤاد',   2),
  ('q4a3', 'q4', 'Hani Shaker',    'هاني شاكر',   3),
  -- q5 (correct: 0 = Kadhem Al Saher)
  ('q5a0', 'q5', 'Kadhem Al Saher',   'كاظم الساهر',   0),
  ('q5a1', 'q5', 'Ilham Al Madfai',   'إلهام المدفعي', 1),
  ('q5a2', 'q5', 'Majid Al Mohandis', 'ماجد المهندس',  2),
  ('q5a3', 'q5', 'Saber Al Rebai',    'صابر الرباعي',  3),
  -- q6 (correct: 2 = Majid Al Mohandis)
  ('q6a0', 'q6', 'Rashed Al Majid',   'راشد الماجد',   0),
  ('q6a1', 'q6', 'Ahlam',             'أحلام',          1),
  ('q6a2', 'q6', 'Majid Al Mohandis', 'ماجد المهندس',  2),
  ('q6a3', 'q6', 'Nawal Al Kuwaitia', 'نوال الكويتية', 3),
  -- q7 (correct: 1 = Warda)
  ('q7a0', 'q7', 'Najwa Karam', 'نجوى كرم', 0),
  ('q7a1', 'q7', 'Warda',       'وردة',      1),
  ('q7a2', 'q7', 'Latifa',      'لطيفة',     2),
  ('q7a3', 'q7', 'Angham',      'أنغام',     3),
  -- q8 (correct: 1 = Najwa Karam)
  ('q8a0', 'q8', 'Elissa',        'إليسا',       0),
  ('q8a1', 'q8', 'Najwa Karam',   'نجوى كرم',   1),
  ('q8a2', 'q8', 'Carole Samaha', 'كارول سماحة', 2),
  ('q8a3', 'q8', 'Haifa Wehbe',   'هيفاء وهبي',  3),
  -- q9 (correct: 0 = Mohamed Mounir)
  ('q9a0', 'q9', 'Mohamed Mounir',  'محمد منير',    0),
  ('q9a1', 'q9', 'Hamid Al Shaeri', 'حميد الشاعري', 1),
  ('q9a2', 'q9', 'Mustafa Amar',    'مصطفى قمر',    2),
  ('q9a3', 'q9', 'Hisham Abbas',    'هشام عباس',    3),
  -- q10 (correct: 1 = Elissa)
  ('q10a0', 'q10', 'Nancy Ajram',   'نانسي عجرم',  0),
  ('q10a1', 'q10', 'Elissa',        'إليسا',        1),
  ('q10a2', 'q10', 'Carole Samaha', 'كارول سماحة',  2),
  ('q10a3', 'q10', 'Myriam Fares',  'ميريام فارس',  3)
on conflict (id) do nothing;
