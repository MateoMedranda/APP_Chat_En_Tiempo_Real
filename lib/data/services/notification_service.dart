import 'package:firebase_messaging/firebase_messaging.dart';

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
      print('El usuario autorizó las notificaciones');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('El usuario concedió permisos provisionales');
    } else {
      print('El usuario rechazó las notificaciones');
    }

    // Escuchar mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notificación en primer plano:');
      print('Título: ${message.notification?.title}');
      print('Cuerpo: ${message.notification?.body}');
      print('Datos: ${message.data}');
    });

    // Escuchar cuando la app se abre desde notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notificación abierta:');
      print('Título: ${message.notification?.title}');
      print('Cuerpo: ${message.notification?.body}');
    });
  }

  // Obtener el token de dispositivo (necesario para enviar mensajes)
  static Future<String?> getDeviceToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      print('Token del dispositivo: $token');
      return token;
    } catch (e) {
      print('Error al obtener token: $e');
      return null;
    }
  }

  // Guardar el token en Firebase cuando se regenera
  static void onTokenRefresh(Function(String) onTokenUpdated) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('Nuevo token: $newToken');
      onTokenUpdated(newToken);
    });
  }
}
