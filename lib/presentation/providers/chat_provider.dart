import 'package:riverpod/riverpod.dart';
import '../../data/services/firebase_service.dart';
import '../../domain/mensaje.dart';

//una instancia a FirebaseService
final firebaseServiceProvider = Provider<FirebaseService> ((ref) => FirebaseService());

//clases streamprovider

final mensajeProvider = StreamProvider<List<Mensaje>>((ref){
  final service = ref.read(firebaseServiceProvider);
  return service.recibirMensajes();
});
