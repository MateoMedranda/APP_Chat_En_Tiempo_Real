import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as developer;
import 'firebase_options.dart';
import 'presentation/views/contacts_view.dart';
import 'presentation/views/login_view.dart';
import 'presentation/providers/chat_provider.dart';
import 'presentation/theme/theme.dart';
import 'data/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (!e.toString().contains('duplicate-app')) {
      rethrow;
    }
  }

  // Inicializar Cloud Messaging
  await NotificationService.initNotifications();
  NotificationService.onTokenRefresh((newToken) {
    developer.log('Token actualizado');
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Online',
      theme: AppTheme.lightTheme(),
      home: user == null ? const LoginView() : const ContactsView(),
    );
  }
}
