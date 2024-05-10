import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DonatePage extends StatefulWidget {
  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  Timer? _navigationTimer;
  double _fontSize = 16.0;

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

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('نسخ إلى الحافظة: $text ' )),
    );
  }

  void _zoomIn() {
    setState(() {
      _fontSize += 2.0;
    });
  }

  void _zoomOut() {
    setState(() {
      if (_fontSize > 10.0) {
        _fontSize -= 2.0;
      }
    });
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
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'معلومات التبرع',
                    style: TextStyle(
                      fontFamily: 'amiri',
                      fontSize: 24,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    '(تستخدم الأموال لتطوير التطبيق ولدعم فريق العمل)',
                    style: TextStyle(
                      fontFamily: 'amiri',
                      fontSize: _fontSize,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    children: [
                      _buildDonationSection(
                        title: 'للدفع باليورو',
                        details: [
                          {'label': 'IBAN', 'value': 'BE90 9671 8501 4732'},
                          {'label': 'Account holder', 'value': 'Magnum Alibi Ltd'},
                          {'label': 'Swift/BIC', 'value': 'TRWIBEB1XXX'},
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildDonationSection(
                        title: 'للدفع بالدولار',
                        details: [
                          {'label': 'Routing number', 'value': '026073150'},
                          {'label': 'Account holder', 'value': 'Magnum Alibi Ltd'},
                          {'label': 'Swift/BIC', 'value': 'CMFGUS33'},
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  FloatingActionButton(
                    heroTag: 'backToHome',
                    onPressed: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                    backgroundColor: Colors.blueGrey,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationSection({required String title, required List<Map<String, String>> details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.monetization_on, color: Colors.blueGrey, size: 24),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'arabic_roman',
                fontSize: _fontSize,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final detail in details)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${detail['label']}: ${detail['value']}',
                  style: TextStyle(
                    fontFamily: 'arabic_roman',
                    fontSize: _fontSize,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy, color: Colors.green, size: 24),
                onPressed: () => _copyToClipboard(detail['value']!),
              ),
            ],
          ),
      ],
    );
  }
}
