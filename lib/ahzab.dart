import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AhzabPage extends StatefulWidget {
  @override
  _AhzabPageState createState() => _AhzabPageState();
}

class _AhzabPageState extends State<AhzabPage> {
  Timer? _navigationTimer;
  final ScrollController _scrollController = ScrollController();
  static const String _scrollPositionKey = 'ahzab_scroll_position';

  final List<Map<String, String>> ahzabList = [
    {'page': '1', 'first_word': 'البسملة', 'surah': 'سورة الفاتحة', 'ahzab': '01'},
    {'page': '11', 'first_word': 'واذا لقوا', 'surah': 'البقرة', 'ahzab': '02'},
    {'page': '22', 'first_word': 'سيقول السفهاء', 'surah': 'البقرة', 'ahzab': '03'},
    {'page': '32', 'first_word': 'واذكرواالله', 'surah': 'البقرة', 'ahzab': '04'},
    {'page': '42', 'first_word': 'تلك الرسل', 'surah': 'البقرة', 'ahzab': '05'},
    {'page': '51', 'first_word': 'قل أؤنبئكم', 'surah': 'أل عمران', 'ahzab': '06'},
    {'page': '62', 'first_word': 'لن تنالوا', 'surah': 'أل عمران', 'ahzab': '07'},
    {'page': '72', 'first_word': 'يستبشرون', 'surah': 'أل عمران', 'ahzab': '08'},
    {'page': '82', 'first_word': 'والمحصنات', 'surah': 'النساء', 'ahzab': '09'},
    {'page': '92', 'first_word': 'الله لااله الاهو', 'surah': 'النساء', 'ahzab': '10'},
    {'page': '102', 'first_word': 'لا يحب', 'surah': 'النساء', 'ahzab': '11'},
    {'page': '111', 'first_word': 'قال رجلان', 'surah': 'المائدة', 'ahzab': '12'},
    {'page': '121', 'first_word': 'لتجدن', 'surah': 'المائدة', 'ahzab': '13'},
    {'page': '132', 'first_word': 'انما يستجيب', 'surah': 'الأنعام', 'ahzab': '14'},
    {'page': '142', 'first_word': 'ولو أننا نزلنا', 'surah': 'الأنعام', 'ahzab': '15'},
    {'page': '151', 'first_word': 'المص كتب', 'surah': 'الأعراف', 'ahzab': '16'},
    {'page': '162', 'first_word': 'قال الملأ', 'surah': 'الأعراف', 'ahzab': '17'},
    {'page': '173', 'first_word': 'واذ نتقنا', 'surah': 'الأعراف', 'ahzab': '18'},
    {'page': '182', 'first_word': 'واعلموا', 'surah': 'الأنفال', 'ahzab': '19'},
    {'page': '192', 'first_word': 'ان كثيرا', 'surah': 'التوبة', 'ahzab': '20'},
    {'page': '201', 'first_word': 'انما السبيل', 'surah': 'التوبة', 'ahzab': '21'},
    {'page': '212', 'first_word': 'للذين أحسنوا', 'surah': 'يونس', 'ahzab': '22'},
    {'page': '222', 'first_word': 'ومامن دابة', 'surah': 'هود', 'ahzab': '23'},
    {'page': '231', 'first_word': 'والى مدين', 'surah': 'هود', 'ahzab': '24'},
    {'page': '242', 'first_word': 'وما أبرئ', 'surah': 'يوسف', 'ahzab': '25'},
    {'page': '252', 'first_word': 'أفمن يعلم', 'surah': 'الرعد', 'ahzab': '26'},
    {'page': '262', 'first_word': 'ربما', 'surah': 'الحجر', 'ahzab': '27'},
    {'page': '272', 'first_word': 'وقال الله لا تتخذوا', 'surah': 'النحل', 'ahzab': '28'},
    {'page': '282', 'first_word': 'سبحان', 'surah': 'الإسراء', 'ahzab': '29'},
    {'page': '292', 'first_word': 'أولم يروا', 'surah': 'الإسراء', 'ahzab': '30'},
    {'page': '302', 'first_word': 'قال ألم أقل', 'surah': 'الكهف', 'ahzab': '31'},
    {'page': '312', 'first_word': 'طه', 'surah': 'طه', 'ahzab': '32'},
    {'page': '322', 'first_word': 'اقترب', 'surah': 'الأنبياء', 'ahzab': '33'},
    {'page': '332', 'first_word': 'يأيها الناس', 'surah': 'الحج', 'ahzab': '34'},
    {'page': '342', 'first_word': 'قد أفلح', 'surah': 'المؤمنون', 'ahzab': '35'},
    {'page': '352', 'first_word': 'لا تتبعوا', 'surah': 'النور', 'ahzab': '36'},
    {'page': '362', 'first_word': 'وقال الذين', 'surah': 'الفرقان', 'ahzab': '37'},
    {'page': '371', 'first_word': 'قالوا أنومن', 'surah': 'الشعراء', 'ahzab': '38'},
    {'page': '382', 'first_word': 'فما كان جواب', 'surah': 'النمل', 'ahzab': '39'},
    {'page': '392', 'first_word': 'ولقد وصلنا', 'surah': 'القصص', 'ahzab': '40'},
    {'page': '402', 'first_word': 'ولا تجادلوا', 'surah': 'العنكبوت', 'ahzab': '41'},
    {'page': '413', 'first_word': 'ومن يسلم', 'surah': 'لقمن', 'ahzab': '42'},
    {'page': '422', 'first_word': 'ومن يقنت', 'surah': 'الأحزاب', 'ahzab': '43'},
    {'page': '431', 'first_word': 'قل من يرزقكم', 'surah': 'سبأ', 'ahzab': '44'},
    {'page': '442', 'first_word': 'وماأنزلنا', 'surah': 'يس', 'ahzab': '45'},
    {'page': '451', 'first_word': 'فنبذناه', 'surah': 'الصافات', 'ahzab': '46'},
    {'page': '462', 'first_word': 'فمن أظلم', 'surah': 'الزمر', 'ahzab': '47'},
    {'page': '472', 'first_word': 'وياقوم مالي', 'surah': 'غافر', 'ahzab': '48'},
    {'page': '482', 'first_word': 'اليه يرد', 'surah': 'فصلت', 'ahzab': '49'},
    {'page': '491', 'first_word': 'قل أولوجئتكم', 'surah': 'الزخرف', 'ahzab': '50'},
    {'page': '502', 'first_word': 'حم ماخلقنا', 'surah': 'الأحقاف', 'ahzab': '51'},
    {'page': '513', 'first_word': 'لقد رضي', 'surah': 'الفتح', 'ahzab': '52'},
    {'page': '522', 'first_word': 'قال فما خطبكم', 'surah': 'الذريات', 'ahzab': '53'},
    {'page': '531', 'first_word': 'الرحمن', 'surah': 'الرحمن', 'ahzab': '54'},
    {'page': '542', 'first_word': 'قد سمع', 'surah': 'المجادلة', 'ahzab': '55'},
    {'page': '553', 'first_word': 'يسبح لله', 'surah': 'الجمعة', 'ahzab': '56'},
    {'page': '562', 'first_word': 'تبرك الذي', 'surah': 'الملك', 'ahzab': '57'},
    {'page': '572', 'first_word': 'قل أوحي', 'surah': 'الجن', 'ahzab': '58'},
    {'page': '582', 'first_word': 'عم يتساءلون', 'surah': 'سورة النبأ', 'ahzab': '59'},
    {'page': '591', 'first_word': 'سبح', 'surah': 'الأعلى', 'ahzab': '60'},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _loadScrollPosition();
    _scrollController.addListener(_saveScrollPosition);
  }

  void _loadScrollPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final double? scrollPosition = prefs.getDouble(_scrollPositionKey);
    print('Loaded scroll position: $scrollPosition');
    if (scrollPosition != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(scrollPosition);
        print('Scrolled to position: $scrollPosition');
      });
    }
  }

  void _saveScrollPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final double scrollPosition = _scrollController.position.pixels;
    await prefs.setDouble(_scrollPositionKey, scrollPosition);
    print('Saving scroll position: $scrollPosition');
  }

  void _showNavigationTemporarily() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _navigationTimer?.cancel();
    _navigationTimer = Timer(const Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });
  }

  void _goToPage(String page) {
    Navigator.pop(context, int.parse(page));
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _scrollController.removeListener(_saveScrollPosition);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onVerticalDragUpdate: (_) => _showNavigationTemporarily(),
        onHorizontalDragUpdate: (_) => _showNavigationTemporarily(),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الصفحة', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'arabic_roman')),
                      Text('السورة', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'arabic_roman')),
                      Text('أول كلمة', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'arabic_roman')),
                      Text('الجزء', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'arabic_roman')),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: ahzabList.length,
                    itemBuilder: (context, index) {
                      final ahzab = ahzabList[index];
                      return InkWell(
                        onTap: () => _goToPage(ahzab['page']!),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text(
                                  ahzab['page']!,
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'amiri'),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${ahzab['first_word']} - ${ahzab['surah']}',
                                  style: TextStyle(fontSize: 21, fontFamily: 'amiri', color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text(
                                  ahzab['ahzab']!,
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'amiri'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  onPressed: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                  backgroundColor: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
