import 'package:riverpod/riverpod.dart';
import '../../data/data.services/firebase_service.dart';
import '../../domain/domain.models/mensaje.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

final userProvider = StateProvider<String?>((ref) => null);

// Provider para la lista de usuarios (contactos)
final usuariosProvider = StreamProvider<List<String>>((ref) {
  return ref.watch(firebaseServiceProvider).obtenerUsuarios();
});

// Provider para mensajes de un chat específico
// Usamos family para pasar el ID del chat
final chatMensajesProvider = StreamProvider.family<List<Mensaje>, String>((ref, chatPath) {
  return ref.watch(firebaseServiceProvider).recibirMensajes(chatPath);
});

// Función para generar un ID único para el chat entre dos personas
String getChatId(String user1, String user2) {
  List<String> ids = [user1, user2];
  ids.sort(); // Ordenar alfabéticamente para que siempre sea el mismo ID sin importar quién inicie
  return ids.join('_');
}
