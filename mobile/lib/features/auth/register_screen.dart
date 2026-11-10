
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends ConsumerState<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _company = TextEditingController();

  String _role = 'candidate';

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _company.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .register(
          fullName: _fullName.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
          role: _role,
          companyName: _role == 'recruiter'
              ? _company.text.trim()
              : null,
        );

    if (!mounted) return;

    if (success) {
      // GoRouter redirects according to the new role.
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              const Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _fullName,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Nom obligatoire';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      !value.contains('@')) {
                    return 'Email invalide';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.length < 6) {
                    return 'Minimum 6 caractères';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Choose your role',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'candidate',
                    label: Text('Candidate'),
                  ),
                  ButtonSegment(
                    value: 'recruiter',
                    label: Text('Recruiter'),
                  ),
                ],
                selected: {_role},
                onSelectionChanged: (selection) {
                  setState(() {
                    _role = selection.first;
                  });
                },
              ),

              if (_role == 'recruiter') ...[
                const SizedBox(height: 16),

                TextFormField(
                  controller: _company,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_role == 'recruiter' &&
                        (value == null ||
                            value.trim().isEmpty)) {
                      return 'Company name obligatoire';
                    }

                    return null;
                  },
                ),
              ],

              const SizedBox(height: 16),

              if (auth.error != null)
                Text(
                  auth.error!,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: auth.loading ? null : _submit,
                child: auth.loading
                    ? const CircularProgressIndicator()
                    : const Text('Create Account'),
              ),

              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text(
                  'Already have an account? Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
