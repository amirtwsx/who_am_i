import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String? error;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        error = null;
      });

      // здесь имитация логина
      if (password.length < 6) {
        setState(() {
          error = 'Пароль должен быть не менее 6 символов';
        });
        return;
      }

      Provider.of<AuthProvider>(context, listen: false).login(email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      setState(() {
        error = 'Пожалуйста, исправьте ошибки в форме';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход / Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (error != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.withOpacity(0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(error!, style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) =>
                    value != null && value.contains('@') ? null : 'Введите корректный email',
              ),
              const SizedBox(height: 12),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Пароль'),
                onChanged: (value) => password = value,
                validator: (value) =>
                    value != null && value.length >= 6 ? null : 'Минимум 6 символов',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
