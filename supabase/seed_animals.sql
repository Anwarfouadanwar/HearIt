-- ─────────────────────────────────────────────
-- HearIt – Animals Category Seed
-- Run in Supabase SQL Editor
-- ─────────────────────────────────────────────

-- Update total_questions for animals category
update categories set total_questions = 10 where id = 'animals';

-- QUESTIONS

insert into questions (id, category_id, audio_url, correct_index, hint_en, hint_ar) values
  ('an1',  'animals', 'bundle://lion_01',     0, 'King of the jungle',   'ملك الغابة'),
  ('an2',  'animals', 'bundle://elephant_01', 1, 'Largest land animal',  'أكبر حيوان بري'),
  ('an3',  'animals', 'bundle://wolf_01',     2, 'Howls at the moon',    'يعوي للقمر'),
  ('an4',  'animals', 'bundle://cat_01',      0, 'Common household pet', 'حيوان أليف شائع'),
  ('an5',  'animals', 'bundle://frog_01',     3, 'Lives near water',     'يعيش قرب الماء'),
  ('an6',  'animals', 'bundle://rooster_01',  1, 'Wakes you at dawn',    'يوقظك عند الفجر'),
  ('an7',  'animals', 'bundle://dolphin_01',  2, 'Intelligent marine animal', 'حيوان بحري ذكي'),
  ('an8',  'animals', 'bundle://dog_01',      0, 'Man''s best friend',   'أفضل أصدقاء الإنسان'),
  ('an9',  'animals', 'bundle://eagle_01',    3, 'Sharp vision, soars high', 'رؤية حادة وتحلق عالياً'),
  ('an10', 'animals', 'bundle://snake_01',    1, 'No legs, scales body', 'بلا أرجل وجسم متقشر')
on conflict (id) do nothing;

-- ANSWERS

insert into answers (id, question_id, text_en, text_ar, sort_order) values
  -- an1 (correct: 0 = Lion)
  ('an1a0', 'an1', 'Lion',    'أسد',     0),
  ('an1a1', 'an1', 'Tiger',   'نمر',     1),
  ('an1a2', 'an1', 'Leopard', 'فهد',     2),
  ('an1a3', 'an1', 'Cheetah', 'فهد صياد',3),
  -- an2 (correct: 1 = Elephant)
  ('an2a0', 'an2', 'Hippo',      'فرس النهر', 0),
  ('an2a1', 'an2', 'Elephant',   'فيل',       1),
  ('an2a2', 'an2', 'Rhinoceros', 'وحيد القرن',2),
  ('an2a3', 'an2', 'Giraffe',    'زرافة',     3),
  -- an3 (correct: 2 = Wolf)
  ('an3a0', 'an3', 'Fox',    'ثعلب', 0),
  ('an3a1', 'an3', 'Dog',    'كلب',  1),
  ('an3a2', 'an3', 'Wolf',   'ذئب',  2),
  ('an3a3', 'an3', 'Coyote', 'ابن آوى', 3),
  -- an4 (correct: 0 = Cat)
  ('an4a0', 'an4', 'Cat',    'قطة',  0),
  ('an4a1', 'an4', 'Rabbit', 'أرنب', 1),
  ('an4a2', 'an4', 'Dog',    'كلب',  2),
  ('an4a3', 'an4', 'Hamster','هامستر',3),
  -- an5 (correct: 3 = Frog)
  ('an5a0', 'an5', 'Fish',   'سمكة', 0),
  ('an5a1', 'an5', 'Duck',   'بطة',  1),
  ('an5a2', 'an5', 'Turtle', 'سلحفاة',2),
  ('an5a3', 'an5', 'Frog',   'ضفدع', 3),
  -- an6 (correct: 1 = Rooster)
  ('an6a0', 'an6', 'Hen',     'دجاجة', 0),
  ('an6a1', 'an6', 'Rooster', 'ديك',   1),
  ('an6a2', 'an6', 'Turkey',  'ديك رومي',2),
  ('an6a3', 'an6', 'Pigeon',  'حمامة', 3),
  -- an7 (correct: 2 = Dolphin)
  ('an7a0', 'an7', 'Whale',   'حوت',   0),
  ('an7a1', 'an7', 'Seal',    'فقمة',  1),
  ('an7a2', 'an7', 'Dolphin', 'دولفين',2),
  ('an7a3', 'an7', 'Shark',   'قرش',   3),
  -- an8 (correct: 0 = Dog)
  ('an8a0', 'an8', 'Dog',  'كلب',  0),
  ('an8a1', 'an8', 'Wolf', 'ذئب',  1),
  ('an8a2', 'an8', 'Fox',  'ثعلب', 2),
  ('an8a3', 'an8', 'Cat',  'قطة',  3),
  -- an9 (correct: 3 = Eagle)
  ('an9a0', 'an9', 'Parrot',  'ببغاء',  0),
  ('an9a1', 'an9', 'Hawk',    'صقر',    1),
  ('an9a2', 'an9', 'Owl',     'بومة',   2),
  ('an9a3', 'an9', 'Eagle',   'نسر',    3),
  -- an10 (correct: 1 = Snake)
  ('an10a0', 'an10', 'Lizard',  'سحلية', 0),
  ('an10a1', 'an10', 'Snake',   'ثعبان', 1),
  ('an10a2', 'an10', 'Worm',    'دودة',  2),
  ('an10a3', 'an10', 'Crocodile','تمساح',3)
on conflict (id) do nothing;
