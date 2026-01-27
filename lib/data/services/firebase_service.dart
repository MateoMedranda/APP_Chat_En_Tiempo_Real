import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../domain/mensaje.dart';

class FirebaseService {
  final  DatabaseReference _ref= FirebaseDatabase.instance.ref('chat/general');

  Future <void> enviarMensaje(Mensaje mensaje) async{
    await _ref.push().set(mensaje.toJson());
  }

  DatabaseReference get mensajeRef => _ref;

//recibir mensaje
  Stream<List<Mensaje>> recibirMensajes(){
    return _ref.onValue.map((event) {
      //obtener datos
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      //evitar errores cuando la lista este vacía
      if(data == null) return [];
      final mensajes = data.values
        .map((e) => Mensaje.fromjson(e))
        .toList();

      mensajes.sort((a,b) => a.timestamp.compareTo(b.timestamp));

      return mensajes;
    });

  }
}