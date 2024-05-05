import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Ensure full-screen mode with immersive UI
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(QuranApp());
}

class QuranApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: QuranPageViewer(),
      debugShowCheckedModeBanner: false, // Hide the debug banner
    );
  }
}

class QuranPageViewer extends StatefulWidget {
  @override
  _QuranPageViewerState createState() => _QuranPageViewerState();
}

class _QuranPageViewerState extends State<QuranPageViewer> {
  PageController? _pageController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadLastPage();
  }

  void _loadLastPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentPage = prefs.getInt('last_page') ?? 1;
      _pageController = PageController(initialPage: 604 - _currentPage);
    });
  }

  void _saveLastPage(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('last_page', page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pageController == null
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
        controller: _pageController,
        itemCount: 604,
        itemBuilder: (context, index) {
          final pageNumber = 604 - index;
          return Center(
            child: Container(
              color: Colors.white, // White background for the A4-like appearance
              child: AspectRatio(
                aspectRatio: 210 / 420, // A4 Aspect Ratio (Width / Height)
                child: Image.asset(
                  'assets/$pageNumber.jpg',
                  fit: BoxFit.fill, // Fill within the A4-like dimensions
                ),
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentPage = 604 - index;
          });
          _saveLastPage(_currentPage);
        },
      ),
    );
  }
}
