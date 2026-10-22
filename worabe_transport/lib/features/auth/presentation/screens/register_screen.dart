import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worabe_transport/core/errors/app_exception.dart';
import 'package:worabe_transport/shared/widgets/loading_button.dart';
import 'package:worabe_transport/shared/widgets/error_message.dart';
import 'package:worabe_transport/features/auth/presentation/providers/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  String _role = 'passenger';
  bool _obscure = true;
  bool _submitting = false;
  String? _error;
  bool _success = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _plateCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _error = null;
      _success = false;
      _submitting = true;
    });

    try {
      await ref
          .read(authNotifierProvider.notifier)
          .register(
            fullName: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            password: _passwordCtrl.text,
            role: _role,
            vehiclePlate: _role == 'driver' ? _plateCtrl.text.trim() : null,
          );

      if (!mounted) return;
      final authState = ref.read(authNotifierProvider);
      authState.when(
        data: (_) => setState(() => _success = true),
        error: (e, _) => setState(
          () => _error = e is AppException ? e.message : e.toString(),
        ),
        loading: () => setState(
          () =>
              _error = 'The registration request did not complete. Try again.',
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(
          () =>
              _error = error is AppException ? error.message : error.toString(),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bajaj1.jpg', fit: BoxFit.cover),
          Container(color: Colors.black45),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _success
                    ? _SuccessBanner(
                        isDriver: _role == 'driver',
                        onLogin: () => context.go('/login'),
                      )
                    : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_error != null) ...[
                              ErrorMessage(_error!),
                              const SizedBox(height: 16),
                            ],
                            TextFormField(
                              controller: _nameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Full name',
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Full name is required.'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: 'Phone number',
                                prefixIcon: Icon(Icons.phone),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Phone is required.'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                ),
                              ),
                              validator: (v) => v == null || v.length < 8
                                  ? 'Password must be at least 8 characters.'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              initialValue: _role,
                              decoration: const InputDecoration(
                                labelText: 'Account type',
                                prefixIcon: Icon(Icons.badge),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'passenger',
                                  child: Text('Passenger'),
                                ),
                                DropdownMenuItem(
                                  value: 'driver',
                                  child: Text('Driver'),
                                ),
                              ],
                              onChanged: (v) => setState(() => _role = v!),
                            ),
                            if (_role == 'driver') ...[
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _plateCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Vehicle plate',
                                  prefixIcon: Icon(Icons.directions_car),
                                ),
                                validator: (v) =>
                                    _role == 'driver' &&
                                        (v == null || v.trim().isEmpty)
                                    ? 'Vehicle plate is required for drivers.'
                                    : null,
                              ),
                            ],
                            const SizedBox(height: 24),
                            LoadingButton(
                              label: 'Register',
                              loading: _submitting,
                              onPressed: _submit,
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: const Text(
                                'Already have an account? Sign in',
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({required this.isDriver, required this.onLogin});
  final bool isDriver;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Icon(
          Icons.check_circle,
          size: 72,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Registration successful!',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          isDriver
              ? 'Your driver account is pending admin verification. You will be able to go online once approved.'
              : 'You can now sign in.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(onPressed: onLogin, child: const Text('Go to Sign In')),
      ],
    );
  }
}
