import '../models/game_level.dart';
import '../models/question.dart';

/// SEVİYE 1 — uzun okuma soruları (10 saniye)
const List<Question> level1Questions = [
  // Q7 — Arda kedi/Fındık özel ad
  Question(
    prompt:
        '"arda küçük sokak kedisine fındık adını verdi." Bu cümlenin doğru yazılışı hangi seçenekte verilmiştir?',
    options: [
      'Arda küçük sokak kedisine Fındık adını verdi.',
      'Arda küçük sokak Kedisine Fındık adını verdi.',
    ],
    correctIndex: 0,
    explanation:
        '"Arda" kişi adı, "Fındık" da kedinin özel adıdır — ikisi de büyük harfle başlar. Ama "kedi" cins isim olduğu için küçük yazılır. B şıkkında "Kedisine" yanlış büyütülmüş.',
    topic: PunctuationTopic.buyukHarf,
    format: QuestionFormat.longChoice,
  ),
  // Q8 — Cumhuriyet Caddesi vs 15 mart
  Question(
    prompt: 'Aşağıdakilerden hangisi doğru yazılmıştır?',
    options: [
      'Teyzemler Cumhuriyet Caddesi, Menekşe Sokak\'ta oturuyorlar.',
      'Kardeşim 15 mart 2010\'da doğmuş.',
    ],
    correctIndex: 0,
    explanation:
        'A şıkkı doğru: yer adlarının (Cumhuriyet Caddesi, Menekşe Sokak) ilk harfi büyük yazılır. B şıkkında "mart" yanlış — ay adları her zaman büyük harfle başlar: "Mart".',
    topic: PunctuationTopic.buyukHarf,
    format: QuestionFormat.longChoice,
  ),
  // Q10 — Yakup okula gidemedi
  Question(
    prompt:
        'Yakup: "Dün okula gidemedim çünkü ..............." Yakup\'un cümlesi hangi seçenekle tamamlanabilir?',
    options: [
      'kendimi hiç iyi hissetmiyordum.',
      'yemek çok lezzetli olmuş.',
    ],
    correctIndex: 0,
    explanation:
        '"Çünkü" sebep belirtir — sonrasında okula gidememesinin mantıklı bir sebebi gelmeli. "Kendimi iyi hissetmiyordum" geçerli bir sebep; yemeğin lezzetli olması okula gidememeye sebep değildir.',
    topic: PunctuationTopic.nokta,
    format: QuestionFormat.longChoice,
  ),
];

/// SEVİYE 2 — orta uzunlukta noktalama soruları (8 saniye)
const List<Question> level2Questions = [
  // Q1 — Piknikte oyunlar
  Question(
    before: 'Piknikte şu oyunları oynadık',
    after: ' saklambaç, körebe ve yakalamaca.',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Bir cümleden sonra örnek/liste gelecekse iki nokta kullanılır. "Şu oyunları oynadık:" sonrasında oyunlar sıralanıyor.',
    topic: PunctuationTopic.ikiNokta,
  ),
  // Q2 — Mete mutluydu / Çünkü
  Question(
    before: 'Mete çok mutluydu',
    after: ' Çünkü en sevdiği arkadaşı ona misafirliğe gelmişti.',
    options: ['!', ':'],
    correctIndex: 0,
    explanation:
        '"Çünkü" yeni bir cümle başlatıyor (büyük harfle yazılmış). Önceki cümle "Mete çok mutluydu!" güçlü bir duygu ifade ettiği için ünlem işareti uygundur.',
    topic: PunctuationTopic.nokta,
  ),
  // Q3 — Millet tanımı
  Question(
    before: 'Millet',
    after: ' aynı topraklar üzerinde yaşayan, aralarında dil ve tarih birliği olan topluluk.',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Bir kavramın tanımı yapılırken iki nokta kullanılır. "Millet:" dedikten sonra tanımı geliyor.',
    topic: PunctuationTopic.ikiNokta,
  ),
];

/// SEVİYE 3 — kısa, hızlı sorular (5 saniye)
const List<Question> level3Questions = [
  // Q5 — Saat dakika ayırma
  Question(
    prompt:
        'Saat ve dakika gösteren sayıları ayırmak için ne kullanılır?',
    options: ['.', ','],
    correctIndex: 0,
    explanation:
        'Saat ve dakika yazılırken nokta kullanılır: 14.30, 21.45 gibi. Virgül ondalık sayılarda kullanılır (3,14 gibi).',
    topic: PunctuationTopic.nokta,
    format: QuestionFormat.shortAnswer,
  ),
  // Q6 — Kitap dergi sanat eseri D/Y
  Question(
    prompt: 'Kitap, dergi ve sanat eseri adları büyük harfle başlar.',
    options: ['Doğru', 'Yanlış'],
    correctIndex: 0,
    explanation:
        'Doğru. Kitap, dergi, gazete ve sanat eseri adlarının her kelimesi büyük harfle başlar: "Çalıkuşu", "Hayat Bilgisi", "Mona Lisa" gibi.',
    topic: PunctuationTopic.buyukHarf,
    format: QuestionFormat.shortAnswer,
  ),
  // Q9 — 23 Nisan 1920
  Question(
    prompt: '23 Nisan 1920 yılında ne açılmıştır?',
    options: ['Türkiye Büyük Millet Meclisi', 'Dolmabahçe Sarayı'],
    correctIndex: 0,
    explanation:
        '23 Nisan 1920\'de Atatürk önderliğinde Türkiye Büyük Millet Meclisi (TBMM) açılmıştır. Bu tarih Ulusal Egemenlik ve Çocuk Bayramı olarak kutlanır.',
    topic: PunctuationTopic.genelKultur,
    format: QuestionFormat.shortAnswer,
  ),
];

/// Tüm sorular birleşik (referans amaçlı)
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
