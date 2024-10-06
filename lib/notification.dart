import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('adhkar_reminder_channel', 'Adhkar Reminder',
        channelDescription: 'Channel for adhkar reminder notifications',
        importance: Importance.max,
        priority: Priority.high);

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification with the specified channel
    await flutterLocalNotificationsPlugin.show(
      0,
      'حان موعد الذكر',
      'ورد القرأن الكريم',
      platformChannelSpecifics,
    );

    return Future.value(true);
  });
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  TimeOfDay? _selectedMorningTime;
  bool _isMorningReminderEnabled = false;

  TimeOfDay? _selectedEveningTime;
  bool _isEveningReminderEnabled = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false); // Set to false for production
    loadSettings();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMorningReminderEnabled = prefs.getBool('morningReminderEnabled') ?? false;
      _isEveningReminderEnabled = prefs.getBool('eveningReminderEnabled') ?? false;
      int? morningHour = prefs.getInt('morningNotificationHour');
      int? morningMinute = prefs.getInt('morningNotificationMinute');
      if (morningHour != null && morningMinute != null) {
        _selectedMorningTime = TimeOfDay(hour: morningHour, minute: morningMinute);
      }
      int? eveningHour = prefs.getInt('eveningNotificationHour');
      int? eveningMinute = prefs.getInt('eveningNotificationMinute');
      if (eveningHour != null && eveningMinute != null) {
        _selectedEveningTime = TimeOfDay(hour: eveningHour, minute: eveningMinute);
      }
    });
  }

  Future<void> checkNotificationPermissions() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (status != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى تفعيل الإشعارات للتذكيرات.'),
          ),
        );
      }
    }
  }

  Future<void> selectTime(BuildContext context, bool isMorning) async {
    if (isMorning && !_isMorningReminderEnabled) return;
    if (!isMorning && !_isEveningReminderEnabled) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMorning ? (_selectedMorningTime ?? TimeOfDay.now()) : (_selectedEveningTime ?? TimeOfDay.now()),
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale('ar'),
          child: child,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isMorning) {
          _selectedMorningTime = picked;
          scheduleNotification(isMorning: true);
        } else {
          _selectedEveningTime = picked;
          scheduleNotification(isMorning: false);
        }
      });
    }
  }

  Future<void> scheduleNotification({required bool isMorning}) async {
    await checkNotificationPermissions();
    TimeOfDay? selectedTime = isMorning ? _selectedMorningTime : _selectedEveningTime;
    bool isReminderEnabled = isMorning ? _isMorningReminderEnabled : _isEveningReminderEnabled;

    if (selectedTime == null || !isReminderEnabled) return;

    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // If the scheduled time has passed for today, schedule it for the next day.
    if (scheduledTime.isBefore(now)) {
      Workmanager().registerOneOffTask(
        isMorning ? 'morningTaskName_${DateTime.now().millisecondsSinceEpoch}' : 'eveningTaskName_${DateTime.now().millisecondsSinceEpoch}',
        isMorning ? 'morningNotificationTask' : 'eveningNotificationTask',
        initialDelay: Duration(
          days: 1,
          hours: selectedTime.hour,
          minutes: selectedTime.minute,
        ),
      );
    } else {
      final durationUntilNotification = scheduledTime.difference(now);
      Workmanager().registerOneOffTask(
        isMorning ? 'morningTaskName_${DateTime.now().millisecondsSinceEpoch}' : 'eveningTaskName_${DateTime.now().millisecondsSinceEpoch}',
        isMorning ? 'morningNotificationTask' : 'eveningNotificationTask',
        initialDelay: durationUntilNotification,
      );
    }

    final prefs = await SharedPreferences.getInstance();
    if (isMorning) {
      await prefs.setInt('morningNotificationHour', selectedTime.hour);
      await prefs.setInt('morningNotificationMinute', selectedTime.minute);
    } else {
      await prefs.setInt('eveningNotificationHour', selectedTime.hour);
      await prefs.setInt('eveningNotificationMinute', selectedTime.minute);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تحديد التذكير في ${selectedTime.format(context)}')),
    );
  }

  Future<void> saveReminderEnabledState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('morningReminderEnabled', _isMorningReminderEnabled);
    await prefs.setBool('eveningReminderEnabled', _isEveningReminderEnabled);
  }

  Widget buildReminderBox({
    required String title,
    required bool isReminderEnabled,
    required TimeOfDay? selectedTime,
    required Function(bool) onSwitchChanged,
    required Function() onTimeSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0x497F97CC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Amiri',
                  color: Colors.black,
                ),
              ),
              Switch(
                value: isReminderEnabled,
                onChanged: (bool value) {
                  setState(() {
                    onSwitchChanged(value);
                    if (value && selectedTime == null) {
                      onTimeSelected();
                    }
                  });
                  saveReminderEnabledState(); // Save state when switch is changed
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: isReminderEnabled ? onTimeSelected : null,
            child: Text(
              isReminderEnabled && selectedTime != null
                  ? 'الوقت المحدد: ${selectedTime.format(context)}'
                  : 'اختر الوقت',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Amiri',
                color: isReminderEnabled ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: Stack(
          children: [
            // Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/notification_page_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildReminderBox(
                      title: 'تفعيل التذكير الصباحي',
                      isReminderEnabled: _isMorningReminderEnabled,
                      selectedTime: _selectedMorningTime,
                      onSwitchChanged: (bool value) {
                        setState(() {
                          _isMorningReminderEnabled = value;
                          if (!_isMorningReminderEnabled) {
                            _selectedMorningTime = null;
                          }
                        });
                      },
                      onTimeSelected: () => selectTime(context, true),
                    ),
                    buildReminderBox(
                      title: 'تفعيل التذكير المسائي',
                      isReminderEnabled: _isEveningReminderEnabled,
                      selectedTime: _selectedEveningTime,
                      onSwitchChanged: (bool value) {
                        setState(() {
                          _isEveningReminderEnabled = value;
                          if (!_isEveningReminderEnabled) {
                            _selectedEveningTime = null;
                          }
                        });
                      },
                      onTimeSelected: () => selectTime(context, false),
                    ),
                  ],
                ),
              ),
            ),
            // Back to home button
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
}
