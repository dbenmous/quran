import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  TimeOfDay _selectedMorningTime = TimeOfDay(hour: 7, minute: 0); // Default morning time
  TimeOfDay _selectedEveningTime = TimeOfDay(hour: 19, minute: 0); // Default evening time
  bool _isMorningActivated = false; // Default switch state for morning
  bool _isEveningActivated = false; // Default switch state for evening
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    localNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
        iOS: IOSInitializationSettings(),
      ),
    );
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMorningTime = TimeOfDay(
        hour: prefs.getInt('morningHour') ?? 7,
        minute: prefs.getInt('morningMinute') ?? 0,
      );
      _selectedEveningTime = TimeOfDay(
        hour: prefs.getInt('eveningHour') ?? 19,
        minute: prefs.getInt('eveningMinute') ?? 0,
      );
      _isMorningActivated = prefs.getBool('morningActivated') ?? false;
      _isEveningActivated = prefs.getBool('eveningActivated') ?? false;
    });

    if (_isMorningActivated) {
      scheduleMorningNotification();
    }
    if (_isEveningActivated) {
      scheduleEveningNotification();
    }
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('morningHour', _selectedMorningTime.hour);
    await prefs.setInt('morningMinute', _selectedMorningTime.minute);
    await prefs.setBool('morningActivated', _isMorningActivated);
    await prefs.setInt('eveningHour', _selectedEveningTime.hour);
    await prefs.setInt('eveningMinute', _selectedEveningTime.minute);
    await prefs.setBool('eveningActivated', _isEveningActivated);
  }

  Future<void> scheduleMorningNotification() async {
    if (!_isMorningActivated) return;
    await scheduleNotification(
      id: 0,
      title: 'القرأن الكريم',
      body: 'حان وقت الورد الصباحي',
      scheduledTime: _selectedMorningTime,
    );
  }

  Future<void> scheduleEveningNotification() async {
    if (!_isEveningActivated) return;
    await scheduleNotification(
      id: 1,
      title: 'القرأن الكريم',
      body: 'حان وقت الورد المسائي',
      scheduledTime: _selectedEveningTime,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay scheduledTime,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    var androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iosDetails = IOSNotificationDetails();
    await localNotificationsPlugin.schedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/notification_page_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.only(left: 12, bottom: 20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildNotificationSection(
                      'تفعيل التنبيهات الصباحية',
                      _isMorningActivated,
                      _selectedMorningTime,
                          (bool value) {
                        setState(() => _isMorningActivated = value);
                        saveSettings();
                        scheduleMorningNotification();
                      },
                          (TimeOfDay? picked) {
                        if (picked != null && picked != _selectedMorningTime) {
                          setState(() => _selectedMorningTime = picked);
                          saveSettings();
                          scheduleMorningNotification();
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    buildNotificationSection(
                      'تفعيل التنبيهات المسائية',
                      _isEveningActivated,
                      _selectedEveningTime,
                          (bool value) {
                        setState(() => _isEveningActivated = value);
                        saveSettings();
                        scheduleEveningNotification();
                      },
                          (TimeOfDay? picked) {
                        if (picked != null && picked != _selectedEveningTime) {
                          setState(() => _selectedEveningTime = picked);
                          saveSettings();
                          scheduleEveningNotification();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: IconButton(
                icon: Image.asset('assets/go_back_button.png', width: 50, height: 50),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationSection(
      String title,
      bool isActive,
      TimeOfDay selectedTime,
      ValueChanged<bool> onToggle,
      ValueChanged<TimeOfDay?> onTimeChanged,
      ) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'arabic_roman',
            color: Color(0xFF8E470C),
          ),
        ),
        Switch(
          value: isActive,
          onChanged: onToggle,
        ),
        TextButton(
          onPressed: () async {
            TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: selectedTime,
              builder: (BuildContext context, Widget? child) {
                return Localizations.override(
                  context: context,
                  locale: Locale('ar', ''), // Arabic locale
                  child: child,
                );
              },
            );
            onTimeChanged(picked);
          },
          child: Text(
            isActive ? '${selectedTime.format(context)}' : 'غير مفعل',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'arabic_roman',
              color: Color(0xFF8E470C),
            ),
          ),
        ),
      ],
    );
  }
}
