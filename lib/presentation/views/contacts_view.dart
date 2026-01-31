import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import 'chat_view.dart';

class ContactsView extends ConsumerWidget {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuariosAsync = ref.watch(usuariosProvider);
    final currentUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(userProvider.notifier).state = null,
          )
        ],
      ),
      body: usuariosAsync.when(
        data: (usuarios) {
          // Filtrar al usuario actual de la lista
          final otrosUsuarios = usuarios.where((u) => u != currentUser).toList();

          if (otrosUsuarios.isEmpty) {
            return const Center(child: Text('No hay otros usuarios conectados'));
          }

          return ListView.builder(
            itemCount: otrosUsuarios.length,
            itemBuilder: (context, index) {
              final nombre = otrosUsuarios[index];
              return ListTile(
                leading: CircleAvatar(child: Text(nombre[0].toUpperCase())),
                title: Text(nombre),
                onTap: () {
                  final chatId = getChatId(currentUser!, nombre);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatView(
                        chatId: chatId,
                        receptor: nombre,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
