import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
initNotifications() async {
  // timezone
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  // init notifs
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // checking first launch for permission
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("firstLaunch") ?? true) {
    // asking permission
    if (Platform.isAndroid) {
      final androidPlugin =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.requestNotificationsPermission();
    }
    await _scheduleCravingNotifications();

    // set firstLaunch to false
    prefs.setBool("firstLaunch", false);
  }
}

Future<void> _scheduleCravingNotifications() async {
  final List<Map<String, dynamic>> cravingTimes = [
    {
      'hour': 8,
      'minute': 0,
      'id': 1,
      'title': '🥐 Morning Craving',
      'body': 'Good morning! Craving something buttery and warm?'
    },
    {
      'hour': 12,
      'minute': 0,
      'id': 2,
      'title': '🍛 Lunch Time',
      'body': 'It’s lunch time! What’s on your craving list?'
    },
    {
      'hour': 16,
      'minute': 0,
      'id': 3,
      'title': '🍟 Snack Break',
      'body': 'Snack o\'clock! Fries? Chaat? Your call 😋'
    },
    {
      'hour': 19,
      'minute': 0,
      'id': 4,
      'title': '🍕 Dinner Vibes',
      'body': 'Dinner plans? Let\'s make cravings come true.'
    },
  ];

  for (var notif in cravingTimes) {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notif['id'], // Unique ID
      notif['title'],
      notif['body'],
      _nextInstanceOfTime(notif['hour'], notif['minute']),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'craving_channel_id',
          'Craving Notifications',
          channelDescription: 'Daily food craving nudges',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }
}
tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final now = tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}