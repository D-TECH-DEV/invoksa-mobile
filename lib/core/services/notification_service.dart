import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // Navigation if tapped
      },
    );
  }

  Future<void> scheduleInvoiceReminder(
      int id, String invoiceNumber, DateTime dueDate) async {
    if (dueDate.isBefore(DateTime.now())) {
      return; 
    }

    // Schedule 1 hr from now arbitrarily for the test if due date is close, or use due date.
    final scheduledDate = tz.TZDateTime.from(dueDate, tz.local)
            .subtract(const Duration(hours: 24)); // 1 day before

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return; // Already past reminder time
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: 'Relance Facture Invoksa',
      body: 'La facture $invoiceNumber arrive à échéance demain !',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'invoice_reminders',
          'Rappels de Facture',
          channelDescription: 'Notifications pour factures',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
