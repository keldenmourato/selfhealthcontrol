import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Inicializa timezone
    tz.initializeTimeZones();
    final mozambiqueLocation = tz.getLocation('Africa/Maputo');
    tz.setLocalLocation(mozambiqueLocation);



    // Configuração Android
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuração iOS
    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // Vamos pedir manualmente
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    // Cria canal de notificação para Android
    await _createNotificationChannel();

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id', // Mesmo id usado nas notificações
      'Task Reminders', // Nome visível para o usuário
      description: 'Channel for task reminders',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<bool> _requestPermissions() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> agendarNotificacao({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    // Solicita permissão
    final granted = await _requestPermissions();
    if (!granted) {
      debugPrint('Permissão para notificações não concedida');
      return;
    }

    // Hora atual
    final now = tz.TZDateTime.now(tz.local);

    // Hora agendada
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Se a hora já passou hoje, agenda para o dia seguinte
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Detalhes da notificação para Android
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id', // deve bater com o canal criado
      'Task Reminders',
      channelDescription: 'Channel for task reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    // Detalhes para iOS
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    // Agenda a notificação
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    debugPrint('Notificação agendada para: $scheduledDate');
  }


  Future<void> scheduleNotification({
    required BuildContext context,
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      // Verifica e solicita permissões
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        throw Exception('Permissão para notificações não concedida');
      }

      // Converte para fuso horário de Moçambique
      final mozambiqueTime = tz.TZDateTime.from(scheduledTime, tz.local);

      // Configuração detalhada para Android
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'channel_id',
        'Task Reminders',
        channelDescription: 'Channel for task reminders',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      // Configuração para iOS
      const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Agenda a notificação
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        mozambiqueTime,
        NotificationDetails(
          android: androidDetails,
          iOS: iOSDetails,
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Notificação agendada para: ${mozambiqueTime.toLocal()}');
    } catch (e) {
      debugPrint('Erro ao agendar notificação: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao agendar: ${e.toString()}')),
      );
      rethrow;
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Método para testar notificação imediatamente
  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Task Reminders',
      channelDescription: 'Channel for task reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();

    await _notificationsPlugin.show(
      0,
      'Teste de Notificação',
      'Esta é uma notificação de teste',
      NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      ),
    );
  }
}