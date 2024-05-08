import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AjzaPage extends StatefulWidget {
  @override
  _AjzaPageState createState() => _AjzaPageState();
}

class _AjzaPageState extends State<AjzaPage> {
  final ScrollController _scrollController = ScrollController(); // Declare it as final
  Timer? _navigationTimer;
  static const String scrollPositionKey = 'ajza_scroll_position';

  final List<Map<String, String>> ajzaList = [
    {'page': '1', 'surah': 'الفاتحة', 'first_word': 'الحمد', 'juz': '1'},
    {'page': '22', 'surah': 'البقرة', 'first_word': 'سيقول', 'juz': '2'},
    {'page': '42', 'surah': 'البقرة', 'first_word': 'تلك الرسل', 'juz': '3'},
    {'page': '62', 'surah': 'آل عمران', 'first_word': 'كل الطعام', 'juz': '4'},
    {'page': '82', 'surah': 'النساء', 'first_word': 'والمحصنات', 'juz': '5'},
    {'page': '102', 'surah': 'النساء', 'first_word': 'لا يحب الله', 'juz': '6'},
    {'page': '121', 'surah': 'المائدة', 'first_word': 'لتجدن', 'juz': '7'},
    {'page': '142', 'surah': 'الأنعام', 'first_word': 'ولو أننا أنزلنا', 'juz': '8'},
    {'page': '162', 'surah': 'الأعراف', 'first_word': 'قال الملأ', 'juz': '9'},
    {'page': '182', 'surah': 'الأنفال', 'first_word': 'و اعلموا', 'juz': '10'},
    {'page': '201', 'surah': 'التوبة', 'first_word': 'إنما السبيل', 'juz': '11'},
    {'page': '222', 'surah': 'هود', 'first_word': 'وما من دابة', 'juz': '12'},
    {'page': '242', 'surah': 'يوسف', 'first_word': 'وما أبرئ نفسي', 'juz': '13'},
    {'page': '262', 'surah': 'الحجر', 'first_word': 'الر', 'juz': '14'},
    {'page': '282', 'surah': 'الإسراء', 'first_word': 'سبحان الذي', 'juz': '15'},
    {'page': '302', 'surah': 'الكهف', 'first_word': 'قال ألم', 'juz': '16'},
    {'page': '322', 'surah': 'الأنبياء', 'first_word': 'اقترب للناس', 'juz': '17'},
    {'page': '342', 'surah': 'المؤمنون', 'first_word': 'قد أفلح', 'juz': '18'},
    {'page': '362', 'surah': 'الفرقان', 'first_word': 'وقال الذين', 'juz': '19'},
    {'page': '382', 'surah': 'النمل', 'first_word': 'فما كان', 'juz': '20'},
    {'page': '402', 'surah': 'العنكبوت', 'first_word': 'ولا تجادلوا', 'juz': '21'},
    {'page': '422', 'surah': 'الأحزاب', 'first_word': 'ومن يقنت', 'juz': '22'},
    {'page': '442', 'surah': 'يس', 'first_word': 'وما أنزلنا على قومه', 'juz': '23'},
    {'page': '462', 'surah': 'الزمر', 'first_word': 'فمن أظلم', 'juz': '24'},
    {'page': '482', 'surah': 'فصلت', 'first_word': 'إليه يرد', 'juz': '25'},
    {'page': '502', 'surah': 'الأحقاف', 'first_word': 'حم تنزيل', 'juz': '26'},
    {'page': '522', 'surah': 'الذاريات', 'first_word': 'قال فما خطبكم', 'juz': '27'},
    {'page': '542', 'surah': 'المجادلة', 'first_word': 'قد سمع', 'juz': '28'},
    {'page': '562', 'surah': 'الملك', 'first_word': 'تبارك', 'juz': '29'},
    {'page': '582', 'surah': 'النبأ', 'first_word': 'عمّ يتساءلون', 'juz': '30'},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _loadScrollPosition();
    _scrollController.addListener(_saveScrollPosition);
  }

  void _showNavigationTemporarily() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _navigationTimer?.cancel();
    _navigationTimer = Timer(const Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });
  }

  Future<void> _saveScrollPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final double position = _scrollController.position.pixels;
    //print('Saving scroll position: $position');
    prefs.setDouble(scrollPositionKey, position);
  }

  Future<void> _loadScrollPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final double? scrollPosition = prefs.getDouble(scrollPositionKey);
    //print('Loaded scroll position: $scrollPosition');
    if (scrollPosition != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(scrollPosition);
        //print('Scrolled to position: $scrollPosition');
      });
    }
  }

  void _goToPage(String page) {
    Navigator.pop(context, int.parse(page));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_saveScrollPosition);
    _navigationTimer?.cancel();
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
                    itemCount: ajzaList.length,
                    itemBuilder: (context, index) {
                      final ajza = ajzaList[index];
                      return InkWell(
                        onTap: () => _goToPage(ajza['page']!),
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
                                  ajza['page']!,
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'amiri'),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${ajza['first_word']} - ${ajza['surah']}',
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
                                  ajza['juz']!,
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
