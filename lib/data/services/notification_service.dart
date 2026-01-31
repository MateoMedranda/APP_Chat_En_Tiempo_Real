import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as developer;

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // Inicializar notificaciones
  static Future<void> initNotifications() async {
    // Solicitar permiso al usuario
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      developer.log('El usuario autorizó las notificaciones');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      developer.log('El usuario concedió permisos provisionales');
    } else {
      developer.log('El usuario rechazó las notificaciones');
    }

    // Escuchar mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      developer.log(
        'Notificación en primer plano: ${message.notification?.title}',
      );
    });

    // Escuchar cuando la app se abre desde notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log('Notificación abierta: ${message.notification?.title}');
    });
  }

  // Obtener el token de dispositivo (necesario para enviar mensajes)
  static Future<String?> getDeviceToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      developer.log('Token del dispositivo obtenido');
      return token;
    } catch (e) {
      developer.log('Error al obtener token: $e');
      return null;
    }
  }

  // Guardar el token en Firebase cuando se regenera
  static void onTokenRefresh(Function(String) onTokenUpdated) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      developer.log('Token actualizado');
      onTokenUpdated(newToken);
    });
  }
}
