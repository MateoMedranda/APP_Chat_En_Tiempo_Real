import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../../domain/domain.models/mensaje.dart';

class ChatView extends ConsumerWidget {
  final String chatId;
  final String receptor;

  ChatView({super.key, required this.chatId, required this.receptor});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos el provider que recibe el ID del chat
    final mensajesAsync = ref.watch(chatMensajesProvider(chatId));
    final service = ref.read(firebaseServiceProvider);
    final usuario = ref.watch(userProvider) ?? 'Desconocido';

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con $receptor'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Espacio para los mensajes
          Expanded(
            child: mensajesAsync.when(
              data: (mensajes) => ListView.builder(
                itemCount: mensajes.length,
                itemBuilder: (_, i) {
                  final m = mensajes[i];
                  final esMio = m.autor == usuario;
                  return Align(
                    alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: esMio ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: esMio ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.autor,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(m.texto),
                        ],
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),

          // Barra de entrada de texto
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje...',
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (controller.text.trim().isEmpty) return;

                      // Enviamos el mensaje al chat específico
                      service.enviarMensaje(
                        chatId,
                        Mensaje(
                          texto: controller.text.trim(),
                          autor: usuario,
                          timestamp: DateTime.now().millisecondsSinceEpoch,
                        ),
                      );
                      controller.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
