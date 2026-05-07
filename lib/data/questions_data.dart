import '../models/game_level.dart';
import '../models/question.dart';

/// 9 soru — Seviye 1, 2, 3'e 3'er bölünür.
const List<Question> level1Questions = [
  Question(
    before: 'Piknikte şu oyunları oynadık',
    after: ' saklambaç, körebe ve yakalamaca.',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Bir cümleden sonra örnek/liste gelecekse iki nokta kullanılır. "Şu oyunları oynadık:" dedikten sonra oyunlar sıralanıyor.',
    topic: PunctuationTopic.ikiNokta,
  ),
  Question(
    before: 'Millet',
    after: ' aynı topraklar üzerinde yaşayan, aralarında dil ve tarih birliği olan topluluk.',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Bir kavramın tanımı yapılırken iki nokta kullanılır. "Millet:" dedikten sonra tanımı geliyor.',
    topic: PunctuationTopic.ikiNokta,
  ),
  Question(
    before: 'Tatilde şu yerleri gezdik',
    after: ' Antalya, Mersin ve İzmir.',
    options: [':', '.'],
    correctIndex: 0,
    explanation:
        'Bir cümleden sonra örnek/liste gelecekse iki nokta gerekir. "Şu yerleri gezdik:" sonrasında yerler sıralanıyor.',
    topic: PunctuationTopic.ikiNokta,
  ),
];

const List<Question> level2Questions = [
  Question(
    before: 'Öğretmen',
    after: ' okulda öğrencilere bilgi öğreten, onlara yol gösteren kişi.',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Bir kavramın tanımı yapılırken iki nokta kullanılır. "Öğretmen:" dedikten sonra ne olduğu açıklanıyor.',
    topic: PunctuationTopic.ikiNokta,
  ),
  Question(
    before: 'Sevdiğim renkler',
    after: ' kırmızı, mavi ve sarı.',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Bir başlığın ardından örnek listesi gelecekse iki nokta kullanılır. "Sevdiğim renkler:" sonrasında renkler sıralanıyor.',
    topic: PunctuationTopic.ikiNokta,
  ),
  Question(
    before: 'Anne',
    after: ' çocukların anaları, evin direği, sevgi kaynağı.',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Bir kavramın tanımı yapılırken iki nokta kullanılır. "Anne:" dedikten sonra anlamı veriliyor.',
    topic: PunctuationTopic.ikiNokta,
  ),
];

const List<Question> level3Questions = [
  Question(
    before: 'Mete çok mutluydu',
    after: ' Çünkü en sevdiği arkadaşı ona misafirliğe gelmişti.',
    options: ['.', ':'],
    correctIndex: 0,
    explanation:
        '"Çünkü" yeni bir cümle başlatıyor (büyük harfle yazılmış). Bu yüzden öncesinde bir önceki cümle nokta ile bitirilir.',
    topic: PunctuationTopic.nokta,
  ),
  Question(
    before: 'Ayşe çok yorgundu',
    after: ' Bütün gün koşturmuştu.',
    options: ['.', ','],
    correctIndex: 0,
    explanation:
        'İki ayrı cümle birbirinden ayrılırken nokta kullanılır. "Bütün gün koşturmuştu" yeni bir cümledir, "B" büyük yazıldığı için öncesi nokta ile biter.',
    topic: PunctuationTopic.nokta,
  ),
  Question(
    before: 'Bayrak',
    after: ' bir milletin sembolü, bağımsızlığın işareti.',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Bir kavramın tanımı yapılırken iki nokta kullanılır. "Bayrak:" dedikten sonra ne anlama geldiği açıklanıyor.',
    topic: PunctuationTopic.ikiNokta,
  ),
];

/// Tüm sorular (eski referans)
const List<Question> allQuestions = [
  ...level1Questions,
  ...level2Questions,
  ...level3Questions,
];

List<Question> questionsForLevel(GameLevel level) {
  switch (level) {
    case GameLevel.level1:
      return level1Questions;
    case GameLevel.level2:
      return level2Questions;
    case GameLevel.level3:
      return level3Questions;
  }
}
