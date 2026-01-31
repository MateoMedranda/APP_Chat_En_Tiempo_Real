import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../theme/theme.dart';
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
        title: Text(receptor),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Tooltip(
            message: 'Información del chat',
            child: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Chat con $receptor'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Espacio para los mensajes
          Expanded(
            child: mensajesAsync.when(
              data: (mensajes) {
                if (mensajes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Inicia una conversación',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Envía un mensaje para comenzar',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: mensajes.length,
                  reverse: false,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  itemBuilder: (_, i) {
                    final m = mensajes[i];
                    final esMio = m.autor == usuario;

                    return Align(
                      alignment: esMio
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: esMio
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: esMio
                                  ? AppColors.messageMine
                                  : AppColors.messageOther,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(esMio ? 16 : 0),
                                bottomRight: Radius.circular(esMio ? 0 : 16),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: esMio
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (!esMio)
                                  Text(
                                    m.autor,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  m.texto,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: esMio
                                        ? AppColors.messageMineText
                                        : AppColors.messageOtherText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 2,
                            ),
                            child: Text(
                              _formatTime(m.timestamp),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),

          // Barra de entrada de texto
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: AppColors.inputBackground,
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (text) {
                          if (text.trim().isNotEmpty) {
                            _sendMessage(service, usuario, chatId);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (controller.text.trim().isEmpty) return;
                          _sendMessage(service, usuario, chatId);
                        },
                        tooltip: 'Enviar mensaje',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(dynamic service, String usuario, String chatId) {
    if (controller.text.trim().isEmpty) return;

    service.enviarMensaje(
      chatId,
      Mensaje(
        texto: controller.text.trim(),
        autor: usuario,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    controller.clear();
  }

  String _formatTime(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Ayer';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
