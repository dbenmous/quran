import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SowarPage extends StatefulWidget {
  @override
  _SowarPageState createState() => _SowarPageState();
}

class _SowarPageState extends State<SowarPage> {
  Timer? _navigationTimer;

  final List<Map<String, String>> safahatList = [
    {'number': '1', 'surah': 'الفاتحة', 'type': 'مكية', 'ayat': '7', 'page': '1'},
    {'number': '2', 'surah': 'البقرة', 'type': 'مدنية', 'ayat': '286', 'page': '2'},
    {'number': '3', 'surah': 'آل عمران', 'type': 'مدنية', 'ayat': '200', 'page': '50'},
    {'number': '4', 'surah': 'النساء', 'type': 'مدنية', 'ayat': '176', 'page': '77'},
    {'number': '5', 'surah': 'المائدة', 'type': 'مدنية', 'ayat': '120', 'page': '106'},
    {'number': '6', 'surah': 'الأنعام', 'type': 'مكية', 'ayat': '165', 'page': '128'},
    {'number': '7', 'surah': 'الأعراف', 'type': 'مكية', 'ayat': '206', 'page': '151'},
    {'number': '8', 'surah': 'الأنفال', 'type': 'مدنية', 'ayat': '75', 'page': '177'},
    {'number': '9', 'surah': 'التوبة', 'type': 'مدنية', 'ayat': '129', 'page': '187'},
    {'number': '10', 'surah': 'يونس', 'type': 'مكية', 'ayat': '109', 'page': '208'},
    {'number': '11', 'surah': 'هود', 'type': 'مكية', 'ayat': '123', 'page': '221'},
    {'number': '12', 'surah': 'يوسف', 'type': 'مكية', 'ayat': '111', 'page': '235'},
    {'number': '13', 'surah': 'الرعد', 'type': 'مدنية', 'ayat': '43', 'page': '249'},
    {'number': '14', 'surah': 'ابراهيم', 'type': 'مكية', 'ayat': '52', 'page': '255'},
    {'number': '15', 'surah': 'الحجر', 'type': 'مكية', 'ayat': '99', 'page': '262'},
    {'number': '16', 'surah': 'النحل', 'type': 'مكية', 'ayat': '128', 'page': '267'},
    {'number': '17', 'surah': 'الإسراء', 'type': 'مكية', 'ayat': '111', 'page': '282'},
    {'number': '18', 'surah': 'الكهف', 'type': 'مكية', 'ayat': '110', 'page': '293'},
    {'number': '19', 'surah': 'مريم', 'type': 'مكية', 'ayat': '98', 'page': '305'},
    {'number': '20', 'surah': 'طه', 'type': 'مكية', 'ayat': '135', 'page': '312'},
    {'number': '21', 'surah': 'الأنبياء', 'type': 'مكية', 'ayat': '112', 'page': '322'},
    {'number': '22', 'surah': 'الحج', 'type': 'مدنية', 'ayat': '78', 'page': '332'},
    {'number': '23', 'surah': 'المؤمنون', 'type': 'مكية', 'ayat': '118', 'page': '342'},
    {'number': '24', 'surah': 'النور', 'type': 'مدنية', 'ayat': '64', 'page': '350'},
    {'number': '25', 'surah': 'الفرقان', 'type': 'مكية', 'ayat': '77', 'page': '359'},
    {'number': '26', 'surah': 'الشعراء', 'type': 'مكية', 'ayat': '227', 'page': '367'},
    {'number': '27', 'surah': 'النمل', 'type': 'مكية', 'ayat': '93', 'page': '377'},
    {'number': '28', 'surah': 'القصص', 'type': 'مكية', 'ayat': '88', 'page': '385'},
    {'number': '29', 'surah': 'العنكبوت', 'type': 'مكية', 'ayat': '69', 'page': '396'},
    {'number': '30', 'surah': 'الروم', 'type': 'مكية', 'ayat': '60', 'page': '404'},
    {'number': '31', 'surah': 'لقمان', 'type': 'مكية', 'ayat': '34', 'page': '411'},
    {'number': '32', 'surah': 'السجدة', 'type': 'مكية', 'ayat': '30', 'page': '415'},
    {'number': '33', 'surah': 'الأحزاب', 'type': 'مدنية', 'ayat': '73', 'page': '418'},
    {'number': '34', 'surah': 'سبأ', 'type': 'مكية', 'ayat': '54', 'page': '428'},
    {'number': '35', 'surah': 'فاطر', 'type': 'مكية', 'ayat': '45', 'page': '434'},
    {'number': '36', 'surah': 'يس', 'type': 'مكية', 'ayat': '83', 'page': '440'},
    {'number': '37', 'surah': 'الصافات', 'type': 'مكية', 'ayat': '182', 'page': '446'},
    {'number': '38', 'surah': 'سورة ص', 'type': 'مكية', 'ayat': '88', 'page': '453'},
    {'number': '39', 'surah': 'الزمر', 'type': 'مكية', 'ayat': '75', 'page': '458'},
    {'number': '40', 'surah': 'غافر', 'type': 'مكية', 'ayat': '85', 'page': '467'},
    {'number': '41', 'surah': 'فصلت', 'type': 'مكية', 'ayat': '54', 'page': '477'},
    {'number': '42', 'surah': 'الشورى', 'type': 'مكية', 'ayat': '53', 'page': '483'},
    {'number': '43', 'surah': 'الزخرف', 'type': 'مكية', 'ayat': '89', 'page': '489'},
    {'number': '44', 'surah': 'الدخان', 'type': 'مكية', 'ayat': '59', 'page': '496'},
    {'number': '45', 'surah': 'الجاثية', 'type': 'مكية', 'ayat': '37', 'page': '499'},
    {'number': '46', 'surah': 'الأحقاف', 'type': 'مكية', 'ayat': '35', 'page': '502'},
    {'number': '47', 'surah': 'محمد', 'type': 'مدنية', 'ayat': '38', 'page': '507'},
    {'number': '48', 'surah': 'الفتح', 'type': 'مدنية', 'ayat': '29', 'page': '511'},
    {'number': '49', 'surah': 'الحجرات', 'type': 'مدنية', 'ayat': '18', 'page': '515'},
    {'number': '50', 'surah': 'سورة ق', 'type': 'مكية', 'ayat': '45', 'page': '518'},
    {'number': '51', 'surah': 'الذاريات', 'type': 'مكية', 'ayat': '60', 'page': '520'},
    {'number': '52', 'surah': 'الطور', 'type': 'مكية', 'ayat': '49', 'page': '523'},
    {'number': '53', 'surah': 'النجم', 'type': 'مكية', 'ayat': '62', 'page': '526'},
    {'number': '54', 'surah': 'القمر', 'type': 'مكية', 'ayat': '55', 'page': '528'},
    {'number': '55', 'surah': 'الرحمن', 'type': 'مدنية', 'ayat': '78', 'page': '531'},
    {'number': '56', 'surah': 'الواقعة', 'type': 'مكية', 'ayat': '96', 'page': '534'},
    {'number': '57', 'surah': 'الحديد', 'type': 'مدنية', 'ayat': '29', 'page': '537'},
    {'number': '58', 'surah': 'المجادلة', 'type': 'مدنية', 'ayat': '22', 'page': '542'},
    {'number': '59', 'surah': 'الحشر', 'type': 'مدنية', 'ayat': '24', 'page': '545'},
    {'number': '60', 'surah': 'الممتحنة', 'type': 'مدنية', 'ayat': '13', 'page': '549'},
    {'number': '61', 'surah': 'الصف', 'type': 'مدنية', 'ayat': '14', 'page': '551'},
    {'number': '62', 'surah': 'الجمعة', 'type': 'مدنية', 'ayat': '11', 'page': '553'},
    {'number': '63', 'surah': 'المنافقون', 'type': 'مدنية', 'ayat': '11', 'page': '554'},
    {'number': '64', 'surah': 'التغابن', 'type': 'مدنية', 'ayat': '18', 'page': '556'},
    {'number': '65', 'surah': 'الطلاق', 'type': 'مدنية', 'ayat': '12', 'page': '558'},
    {'number': '66', 'surah': 'التحريم', 'type': 'مدنية', 'ayat': '12', 'page': '560'},
    {'number': '67', 'surah': 'الملك', 'type': 'مكية', 'ayat': '30', 'page': '562'},
    {'number': '68', 'surah': 'القلم', 'type': 'مكية', 'ayat': '52', 'page': '564'},
    {'number': '69', 'surah': 'الحاقة', 'type': 'مكية', 'ayat': '52', 'page': '566'},
    {'number': '70', 'surah': 'المعارج', 'type': 'مكية', 'ayat': '44', 'page': '568'},
    {'number': '71', 'surah': 'نوح', 'type': 'مكية', 'ayat': '28', 'page': '570'},
    {'number': '72', 'surah': 'الجن', 'type': 'مكية', 'ayat': '28', 'page': '572'},
    {'number': '73', 'surah': 'المزمل', 'type': 'مكية', 'ayat': '20', 'page': '574'},
    {'number': '74', 'surah': 'المدثر', 'type': 'مكية', 'ayat': '56', 'page': '575'},
    {'number': '75', 'surah': 'القيامة', 'type': 'مكية', 'ayat': '40', 'page': '577'},
    {'number': '76', 'surah': 'الإنسان', 'type': 'مدنية', 'ayat': '31', 'page': '578'},
    {'number': '77', 'surah': 'المرسلات', 'type': 'مكية', 'ayat': '50', 'page': '580'},
    {'number': '78', 'surah': 'النبأ', 'type': 'مكية', 'ayat': '40', 'page': '582'},
    {'number': '79', 'surah': 'النازعات', 'type': 'مكية', 'ayat': '46', 'page': '583'},
    {'number': '80', 'surah': 'عبس', 'type': 'مكية', 'ayat': '42', 'page': '585'},
    {'number': '81', 'surah': 'التكوير', 'type': 'مكية', 'ayat': '29', 'page': '586'},
    {'number': '82', 'surah': 'الإنفطار', 'type': 'مكية', 'ayat': '19', 'page': '587'},
    {'number': '83', 'surah': 'المطففين', 'type': 'مكية', 'ayat': '36', 'page': '587'},
    {'number': '84', 'surah': 'الانشقاق', 'type': 'مكية', 'ayat': '25', 'page': '589'},
    {'number': '85', 'surah': 'البروج', 'type': 'مكية', 'ayat': '22', 'page': '590'},
    {'number': '86', 'surah': 'الطارق', 'type': 'مكية', 'ayat': '17', 'page': '591'},
    {'number': '87', 'surah': 'الأعلى', 'type': 'مكية', 'ayat': '19', 'page': '591'},
    {'number': '88', 'surah': 'الغاشية', 'type': 'مكية', 'ayat': '26', 'page': '592'},
    {'number': '89', 'surah': 'الفجر', 'type': 'مكية', 'ayat': '30', 'page': '593'},
    {'number': '90', 'surah': 'البلد', 'type': 'مكية', 'ayat': '20', 'page': '594'},
    {'number': '91', 'surah': 'الشمس', 'type': 'مكية', 'ayat': '15', 'page': '595'},
    {'number': '92', 'surah': 'الليل', 'type': 'مكية', 'ayat': '21', 'page': '595'},
    {'number': '93', 'surah': 'الضحى', 'type': 'مكية', 'ayat': '11', 'page': '596'},
    {'number': '94', 'surah': 'الشرح', 'type': 'مكية', 'ayat': '8', 'page': '596'},
    {'number': '95', 'surah': 'التين', 'type': 'مكية', 'ayat': '8', 'page': '597'},
    {'number': '96', 'surah': 'العلق', 'type': 'مكية', 'ayat': '19', 'page': '597'},
    {'number': '97', 'surah': 'القدر', 'type': 'مكية', 'ayat': '5', 'page': '598'},
    {'number': '98', 'surah': 'البينة', 'type': 'مدنية', 'ayat': '8', 'page': '598'},
    {'number': '99', 'surah': 'الزلزلة', 'type': 'مدنية', 'ayat': '8', 'page': '599'},
    {'number': '100', 'surah': 'العاديات', 'type': 'مكية', 'ayat': '11', 'page': '599'},
    {'number': '101', 'surah': 'القارعة', 'type': 'مكية', 'ayat': '11', 'page': '600'},
    {'number': '102', 'surah': 'التكاثر', 'type': 'مكية', 'ayat': '8', 'page': '600'},
    {'number': '103', 'surah': 'العصر', 'type': 'مكية', 'ayat': '3', 'page': '601'},
    {'number': '104', 'surah': 'الهمزة', 'type': 'مكية', 'ayat': '9', 'page': '601'},
    {'number': '105', 'surah': 'الفيل', 'type': 'مكية', 'ayat': '5', 'page': '601'},
    {'number': '106', 'surah': 'قريش', 'type': 'مكية', 'ayat': '4', 'page': '602'},
    {'number': '107', 'surah': 'الماعون', 'type': 'مكية', 'ayat': '7', 'page': '602'},
    {'number': '108', 'surah': 'الكوثر', 'type': 'مكية', 'ayat': '3', 'page': '602'},
    {'number': '109', 'surah': 'الكافرون', 'type': 'مكية', 'ayat': '6', 'page': '603'},
    {'number': '110', 'surah': 'النصر', 'type': 'مدنية', 'ayat': '3', 'page': '603'},
    {'number': '111', 'surah': 'المسد', 'type': 'مكية', 'ayat': '5', 'page': '603'},
    {'number': '112', 'surah': 'الإخلاص', 'type': 'مكية', 'ayat': '4', 'page': '604'},
    {'number': '113', 'surah': 'الفلق', 'type': 'مدنية', 'ayat': '5', 'page': '604'},
    {'number': '114', 'surah': 'الناس', 'type': 'مدنية', 'ayat': '6', 'page': '604'},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
                      Text('عدد آياتها', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'arabic_roman')),
                      Text('نوعها', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'arabic_roman')),
                      Text('اسم السورة', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'arabic_roman')),
                      Text('رقم', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'arabic_roman')),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: safahatList.length,
                    itemBuilder: (context, index) {
                      final safahat = safahatList[index];
                      return InkWell(
                        onTap: () => _goToPage(safahat['page']!),
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
                                  safahat['page']!,
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'amiri'),
                                ),
                              ),
                              Text(
                                safahat['ayat']!,
                                style: TextStyle(fontSize: 16, fontFamily: 'amiri', color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                safahat['type']!,
                                style: TextStyle(fontSize: 16, fontFamily: 'amiri', color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              Expanded(
                                child: Text(
                                  safahat['surah']!,
                                  style: TextStyle(fontSize: 16, fontFamily: 'amiri', color: Colors.black),
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
                                  safahat['number']!,
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
