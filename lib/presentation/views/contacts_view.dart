import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../theme/theme.dart';
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
        elevation: 0,
        actions: [
          Tooltip(
            message: 'Cerrar sesión',
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cerrar sesión'),
                    content: const Text('¿Deseas cerrar tu sesión?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(userProvider.notifier).state = null;
                        },
                        child: const Text(
                          'Cerrar sesión',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: usuariosAsync.when(
        data: (usuarios) {
          // Filtrar al usuario actual de la lista
          final otrosUsuarios = usuarios
              .where((u) => u != currentUser)
              .toList();

          if (otrosUsuarios.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay otros usuarios',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Invita a tus amigos para empezar a chatear',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: otrosUsuarios.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final nombre = otrosUsuarios[index];
              final initial = nombre[0].toUpperCase();

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  child: Text(
                    initial,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  nombre,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Disponible'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                onTap: () {
                  final chatId = getChatId(currentUser!, nombre);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatView(chatId: chatId, receptor: nombre),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Error al cargar contactos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                e.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
