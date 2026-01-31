import 'package:firebase_database/firebase_database.dart';
import '../../domain/domain.models/mensaje.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // Guardar usuario para que otros lo vean en la lista de contactos
  Future<void> registrarUsuario(String nombre) async {
    await _db.child('usuarios').child(nombre).set({
      'nombre': nombre,
      'ultimo_acceso': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Guardar token FCM del usuario
  Future<void> guardarTokenFCM(String nombreUsuario, String token) async {
    await _db.child('usuarios').child(nombreUsuario).update({
      'fcm_token': token,
      'ultimo_acceso': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Obtener token FCM de un usuario
  Future<String?> obtenerTokenFCM(String nombreUsuario) async {
    final snapshot = await _db.child('usuarios').child(nombreUsuario).get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data['fcm_token'];
    }
    return null;
  }

  // Stream para la lista de usuarios
  Stream<List<String>> obtenerUsuarios() {
    return _db.child('usuarios').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      return data.keys.map((e) => e.toString()).toList();
    });
  }

  // Enviar mensaje a una conversacion específica
  Future<void> enviarMensaje(String chatPath, Mensaje mensaje) async {
    await _db.child('chats').child(chatPath).push().set(mensaje.toJson());
  }

  // Recibir mensajes de una conversacion específica
  Stream<List<Mensaje>> recibirMensajes(String chatPath) {
    return _db.child('chats').child(chatPath).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      final mensajes = data.values.map((e) => Mensaje.fromjson(e)).toList();
      mensajes.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return mensajes;
    });
  }
}
