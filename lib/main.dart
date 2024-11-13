import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:url_launcher/url_launcher.dart';
import 'side_menu.dart';
import 'ajza.dart';
import 'ahzab.dart';
import 'sowar.dart';
import 'dua.dart';
import 'donate.dart';
import 'qibla.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  // Initialize WorkManager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(QuranApp());
}

class QuranApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'القرأن الكريم بدون إشهار',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'elmessiri',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Start with splash screen
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => QuranPageViewer(),
        '/ajza': (context) => AjzaPage(),
        '/ahzab': (context) => AhzabPage(),
        '/sowar': (context) => SowarPage(),
        '/dua': (context) => DuaPage(),
        '/donate': (context) => DonatePage(),
        '/notification': (context) => NotificationPage(),
        '/qibla': (context) => QiblaPage(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English
        const Locale('ar', ''), // Arabic
      ],
      locale: Locale('en', ''), // Set default locale to English
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Redirect to main page after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/main');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/splash/xxxhdpi/splash.png',
          fit: BoxFit.contain,
        ),
      ),
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
  bool _isMenuVisible = false;
  int? _bookmarkedPage;
  bool _isSettingsVisible = false;
  double _brightness = 0.5;
  final ScreenBrightness _screenBrightness = ScreenBrightness();
  Timer? _immersiveTimer;

  @override
  void initState() {
    super.initState();
    _loadLastPage();
    _loadBookmark();
    _initializeBrightness();
  }

  void _initializeBrightness() async {
    double currentBrightness = await _screenBrightness.current;
    setState(() {
      _brightness = currentBrightness;
    });
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

  void _loadBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarkedPage = prefs.getInt('bookmarked_page');
    });
  }

  void _saveBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('bookmarked_page', _currentPage);
    setState(() {
      _bookmarkedPage = _currentPage;
    });
  }

  void _goToBookmark() {
    if (_bookmarkedPage != null) {
      setState(() {
        _currentPage = _bookmarkedPage!;
        _pageController?.jumpToPage(604 - _bookmarkedPage!);
        _isMenuVisible = false;
      });
    } else {
      _toggleMenu();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('لم يتم العثور على علامة. الرجاء إضافة علامة أولاً'),
      ));
    }
  }

  void _saveBrightness(double brightness) async {
    await _screenBrightness.setScreenBrightness(brightness);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('screen_brightness', brightness);
    setState(() {
      _brightness = brightness;
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
      _isSettingsVisible = false;
    });
  }

  Future<void> _navigateTo(String route) async {
    setState(() {
      _isMenuVisible = false;
    });

    if (route == '/ajza') {
      final int? selectedPage = await Navigator.push<int>(
        context,
        MaterialPageRoute(builder: (context) => AjzaPage()),
      );
      if (selectedPage != null) {
        _pageController?.jumpToPage(604 - selectedPage);
      }
    } else if (route == '/ahzab') {
      final int? selectedPage = await Navigator.push<int>(
        context,
        MaterialPageRoute(builder: (context) => AhzabPage()),
      );
      if (selectedPage != null) {
        _pageController?.jumpToPage(604 - selectedPage);
      }
    } else if (route == '/sowar') {
      final int? selectedPage = await Navigator.push<int>(
        context,
        MaterialPageRoute(builder: (context) => SowarPage()),
      );
      if (selectedPage != null) {
        _pageController?.jumpToPage(604 - selectedPage);
      }
    } else if (route == 'privacy_policy') {
      final Uri url = Uri.parse('https://thedigits.co/quran/privacy-policy/');
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        print('Error launching URL: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('لا يمكن فتح سياسة الخصوصية'),
        ));
      }
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  void _toggleSettingsMenu() {
    setState(() {
      _isMenuVisible = false;
      _isSettingsVisible = !_isSettingsVisible;
    });
  }

  void _hideSettingsMenu() {
    setState(() {
      _isSettingsVisible = false;
    });
  }

  void _enableImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _showButtonsTemporarily() {
    _immersiveTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _immersiveTimer = Timer(const Duration(seconds: 2), _enableImmersiveMode);
  }

  @override
  void dispose() {
    _immersiveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _enableImmersiveMode();
          if (_isSettingsVisible) {
            _hideSettingsMenu();
          } else {
            _toggleMenu();
          }
        },
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta != null && details.primaryDelta! < 0) {
            _toggleMenu();
          } else if (details.primaryDelta != null && details.primaryDelta! > 0) {
            _toggleMenu();
          }
        },
        onVerticalDragUpdate: (details) {
          if ((details.primaryDelta != null && details.primaryDelta! > 10) ||
              (details.primaryDelta != null && details.primaryDelta! < -10)) {
            _showButtonsTemporarily();
          }
        },
        child: Stack(
          children: [
            _pageController == null
                ? Center(child: CircularProgressIndicator())
                : PageView.builder(
              controller: _pageController,
              itemCount: 604,
              itemBuilder: (context, index) {
                final pageNumber = 604 - index;
                return Stack(
                  children: [
                    Center(
                      child: Container(
                        color: Colors.white,
                        child: AspectRatio(
                          aspectRatio: 210 / 420,
                          child: Image.asset(
                            'assets/$pageNumber.jpg',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    if (pageNumber == _bookmarkedPage)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Icon(
                          Icons.bookmark,
                          color: Colors.black38,
                          size: 30,
                        ),
                      ),
                  ],
                );
              },
              onPageChanged: (index) {
                _enableImmersiveMode();
                setState(() {
                  _currentPage = 604 - index;
                });
                _saveLastPage(_currentPage);
              },
            ),
            if (_isMenuVisible)
              Positioned(
                right: 0,
                top: 0,
                child: SideMenu(
                  width: 220,
                  items: [
                    SideMenuItem(
                        icon: Icons.book, text: 'الأجزاء', route: '/ajza'),
                    SideMenuItem(
                        icon: Icons.collections_bookmark,
                        text: 'الأحزاب',
                        route: '/ahzab'),
                    SideMenuItem(
                        icon: Icons.pages, text: 'السور', route: '/sowar'),
                    SideMenuItem(
                        icon: Icons.bookmark_add_outlined,
                        text: 'حفظ العلامة',
                        route: 'add_bookmark'),
                    SideMenuItem(
                        icon: Icons.bookmark,
                        text: 'الإنتقال إلى العلامة',
                        route: 'go_to_bookmark'),
                    SideMenuItem(
                        icon: Icons.volunteer_activism,
                        text: 'دعاء الختم',
                        route: '/dua'),
                    SideMenuItem(
                        icon: Icons.settings,
                        text: 'إعدادات الشاشة',
                        route: 'settings'),
                    SideMenuItem(
                        icon: Icons.notifications,
                        text: 'منبه الورد',
                        route: '/notification'),
                    SideMenuItem(
                        icon: Icons.favorite, text: 'تبرع', route: '/donate'),
                    SideMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        text: 'سياسة الخصوصية',
                        route: 'privacy_policy'),
                  ],
                  onItemTap: (route) {
                    _enableImmersiveMode();
                    if (route == 'add_bookmark') {
                      _saveBookmark();
                    } else if (route == 'go_to_bookmark') {
                      _goToBookmark();
                    } else if (route == 'settings') {
                      _toggleSettingsMenu();
                    } else {
                      _navigateTo(route);
                    }
                  },
                ),
              ),
            if (_isSettingsVisible)
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300, maxHeight: 160),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF6F6F6F),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'درجة سطوع الشاشة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'amiri',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Slider(
                            value: _brightness,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label:
                            (_brightness * 100).toStringAsFixed(0) + '%',
                            activeColor: Colors.greenAccent,
                            onChanged: (value) {
                              _saveBrightness(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
