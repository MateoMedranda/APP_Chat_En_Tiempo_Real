import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../theme/theme.dart';
import '../../data/services/notification_service.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre de usuario es requerido';
    }
    if (value.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    if (value.length > 20) {
      return 'El nombre no puede exceder 20 caracteres';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Solo se permiten letras, números y guiones bajos';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _controller.text.trim();

      // Obtener token FCM y registrar usuario
      final token = await NotificationService.getDeviceToken();
      await ref.read(firebaseServiceProvider).registrarUsuario(name);

      if (token != null) {
        await ref.read(firebaseServiceProvider).guardarTokenFCM(name, token);
      }

      ref.read(userProvider.notifier).state = name;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Online'), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Icono
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              // Título
              Text(
                'Bienvenido',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 12),

              // Subtítulo
              Text(
                'Ingresa tu nombre para empezar a chatear',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),

              const SizedBox(height: 40),

              // Formulario
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controller,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Nombre de usuario',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.primary,
                        ),
                        hintText: 'ejemplo_123',
                      ),
                      validator: _validateUsername,
                      onFieldSubmitted: (_) => _handleLogin(),
                    ),

                    const SizedBox(height: 24),

                    // Botón
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Entrar al Chat'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Footer
              Text(
                'Crea un nombre único y comparte con tus amigos',
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
