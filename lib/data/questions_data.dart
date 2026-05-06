import '../models/game_level.dart';
import '../models/question.dart';

const List<Question> allQuestions = [
  // NOKTA (.)
  Question(
    before: 'Ali okula gitti',
    after: '',
    options: ['.', ','],
    correctIndex: 0,
    explanation:
        'Tamamlanmış bildirme cümlelerinin sonuna nokta konur. "Ali okula gitti." cümlesi bir bilgi veriyor ve burada bitiyor, bu yüzden sonuna nokta gelir.',
    topic: PunctuationTopic.nokta,
  ),
  Question(
    before: 'Bugün hava çok güzel',
    after: '',
    options: ['.', ':'],
    correctIndex: 0,
    explanation:
        'Cümlenin sonu geldiğinde ve cümle tamamlanmış bir düşünceyi anlatıyorsa nokta konur. İki nokta ise açıklama veya örnek getirileceği zaman kullanılır.',
    topic: PunctuationTopic.nokta,
  ),
  Question(
    before: 'Dr',
    after: ' Ahmet bizi muayene etti.',
    options: ['.', ','],
    correctIndex: 0,
    explanation:
        'Kısaltmaların sonuna nokta konur: "Dr." (Doktor), "Prof." (Profesör), "Cad." (Cadde) gibi. Burada virgül olmaz çünkü kısaltma bitiyor.',
    topic: PunctuationTopic.nokta,
  ),
  Question(
    before: '5',
    after: ' sınıfta okuyorum.',
    options: ['.', ','],
    correctIndex: 0,
    explanation:
        'Sıra sayıları rakamla yazıldığında sayıdan sonra nokta konur. "5." okunurken "beşinci" olur. Doğrusu: "5. sınıfta okuyorum."',
    topic: PunctuationTopic.nokta,
  ),
  Question(
    before: 'Annem markete gitti',
    after: '',
    options: ['.', ':'],
    correctIndex: 0,
    explanation:
        'Bildirme cümlesi bitince nokta konur. "Annem markete gitti." cümlesi tamamlanmış bir olayı anlatıyor.',
    topic: PunctuationTopic.nokta,
  ),

  // VİRGÜL (,)
  Question(
    before: 'Çantamda kalem',
    after: ' silgi ve defter var.',
    options: [',', '.'],
    correctIndex: 0,
    explanation:
        'Eş görevli (aynı türden) sözcükler sıralandığında aralarına virgül konur: "kalem, silgi, defter". "ve" bağlacından önce virgül kullanılmaz.',
    topic: PunctuationTopic.virgul,
  ),
  Question(
    before: 'Sevgili çocuklar',
    after: ' bugün ders var.',
    options: [',', ':'],
    correctIndex: 0,
    explanation:
        'Hitap için kullanılan sözlerden sonra virgül konur. "Sevgili çocuklar," ifadesi bir seslenmedir ve seslenmeden sonra virgül gelir.',
    topic: PunctuationTopic.virgul,
  ),
  Question(
    before: 'Evet',
    after: ' bu sınavı kazanacağım.',
    options: [',', ':'],
    correctIndex: 0,
    explanation:
        '"Evet", "hayır", "peki", "tamam" gibi onaylama-bildirme sözlerinden sonra virgül konur. Bu sözler cümleden ayrılarak vurgulanır.',
    topic: PunctuationTopic.virgul,
  ),
  Question(
    before: 'Hızlı koştu',
    after: ' yoruldu.',
    options: [',', '.'],
    correctIndex: 0,
    explanation:
        'Sıralı cümleleri birbirinden ayırmak için virgül kullanılır. İki ayrı eylem (koştu / yoruldu) virgülle bağlanıyor; nokta koysaydık iki ayrı cümle olurdu.',
    topic: PunctuationTopic.virgul,
  ),
  Question(
    before: 'Kırmızı',
    after: ' sarı ve mavi balonlar uçtu.',
    options: [',', '.'],
    correctIndex: 0,
    explanation:
        'Eş görevli sıfatlar (kırmızı, sarı, mavi) sıralandığında aralarına virgül konur. "ve" bağlacından önce virgül yazılmaz.',
    topic: PunctuationTopic.virgul,
  ),

  // İKİ NOKTA (:)
  Question(
    before: 'Sınıfta şu öğrenciler var',
    after: ' Ali, Veli, Ayşe.',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Kendisinden sonra örnek veya açıklama gelecek cümlelerin sonuna iki nokta konur. "Şu öğrenciler var:" dedikten sonra örnekler sıralanır.',
    topic: PunctuationTopic.ikiNokta,
  ),
  Question(
    before: 'Öğretmen şöyle dedi',
    after: ' "Çalışın."',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Birinin söylediklerini aktarmadan önce iki nokta konur. Sonra tırnak içinde söylenen söz yazılır.',
    topic: PunctuationTopic.ikiNokta,
  ),
  Question(
    before: 'Meyveler',
    after: ' elma, armut, muz.',
    options: [':', '.'],
    correctIndex: 0,
    explanation:
        'Bir başlığın ardından örnek veya liste gelecekse iki nokta kullanılır. Nokta koysaydık cümle biterdi, ama burada arkasından örnek geliyor.',
    topic: PunctuationTopic.ikiNokta,
  ),
  Question(
    before: 'Yanıma şunları aldım',
    after: ' kitap, defter, kalem.',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Bir cümleden sonra örnekler sıralanacaksa iki nokta gerekir. "Şunları aldım:" ifadesinden sonra hangi şeylerin alındığı listelenir.',
    topic: PunctuationTopic.ikiNokta,
  ),
  Question(
    before: 'Saat',
    after: ' 14.30',
    options: [':', ','],
    correctIndex: 0,
    explanation:
        'Bir bilgi öncesinde açıklama yapılıyorsa iki nokta kullanılır: "Saat: 14.30", "Doğum tarihi: 2010". Bu kullanım listeye/forma bilgi yazarken görülür.',
    topic: PunctuationTopic.ikiNokta,
  ),

  // BÜYÜK HARF (cümle başı, özel ad, gün/ay, yer/ülke)
  Question(
    before: '',
    after: 'li bugün okula gitti.',
    options: ['A', 'a'],
    correctIndex: 0,
    explanation:
        'Özel adlar (kişi isimleri) her zaman büyük harfle başlar. "Ali" bir özel addır, küçük "a" ile yazılmaz.',
    topic: PunctuationTopic.buyukHarf,
  ),
  Question(
    before: 'Ben ',
    after: 'stanbul\'da yaşıyorum.',
    options: ['İ', 'i'],
    correctIndex: 0,
    explanation:
        'Şehir, ülke, ilçe gibi yer adları büyük harfle başlar. "İstanbul" özel bir yer adıdır, küçük harfle yazılmaz.',
    topic: PunctuationTopic.buyukHarf,
  ),
  Question(
    before: 'Bugün ',
    after: 'azartesi günü.',
    options: ['P', 'p'],
    correctIndex: 0,
    explanation:
        'Gün adları (Pazartesi, Salı, Çarşamba…) büyük harfle başlar. Bir cümlenin ortasında bile olsa gün adının ilk harfi büyüktür.',
    topic: PunctuationTopic.buyukHarf,
  ),
  Question(
    before: '',
    after: 'aha sonra konuşuruz.',
    options: ['D', 'd'],
    correctIndex: 0,
    explanation:
        'Her cümle büyük harfle başlar. Cümlenin başındaki ilk kelimenin ilk harfi her zaman büyük yazılır.',
    topic: PunctuationTopic.buyukHarf,
  ),
  Question(
    before: '',
    after: 'art ayında doğdum.',
    options: ['M', 'm'],
    correctIndex: 0,
    explanation:
        'Ay adları (Ocak, Şubat, Mart…) büyük harfle başlar. Hem cümle başı hem ay adı olduğu için "M" büyük yazılır.',
    topic: PunctuationTopic.buyukHarf,
  ),
  Question(
    before: 'Doktor ',
    after: 'hmet bizi karşıladı.',
    options: ['A', 'a'],
    correctIndex: 0,
    explanation:
        'Kişi adları (özel adlar) her zaman büyük harfle başlar. "Ahmet" cümlenin ortasında olsa bile büyük harfle yazılır.',
    topic: PunctuationTopic.buyukHarf,
  ),
  Question(
    before: '',
    after: 'iz okulda toplandık.',
    options: ['B', 'b'],
    correctIndex: 0,
    explanation:
        'Cümlenin ilk harfi her zaman büyüktür. "Biz okulda toplandık." cümlesinin başındaki "B" büyük olmalı.',
    topic: PunctuationTopic.buyukHarf,
  ),
  Question(
    before: '',
    after: 'ürkiye Avrupa\'da yer alır.',
    options: ['T', 't'],
    correctIndex: 0,
    explanation:
        'Ülke adları büyük harfle başlar. "Türkiye" özel bir addır ve cümle başında olduğu için iki kat sebeple büyük yazılır.',
    topic: PunctuationTopic.buyukHarf,
  ),
  Question(
    before: 'Kardeşim ',
    after: 'yşe ile parka gitti.',
    options: ['A', 'a'],
    correctIndex: 0,
    explanation:
        'Kişi adları özel addır ve büyük harfle başlar. "Ayşe" küçük "a" ile yazılırsa kuralı bozar.',
    topic: PunctuationTopic.buyukHarf,
  ),
  Question(
    before: 'Tatilde ',
    after: 'ntalya\'ya gideceğiz.',
    options: ['A', 'a'],
    correctIndex: 0,
    explanation:
        'Şehir adları (Antalya, Ankara, İzmir…) büyük harfle başlar. Cümlenin ortasında da olsa yer adının ilk harfi büyüktür.',
    topic: PunctuationTopic.buyukHarf,
  ),
];

List<Question> questionsForLevel(GameLevel level) {
  return allQuestions.where((q) => level.topics.contains(q.topic)).toList();
}
