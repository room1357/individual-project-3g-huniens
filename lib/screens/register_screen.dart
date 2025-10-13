import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password tidak cocok')),
        );
        return;
      }

      final newUser = User(
        username: _usernameController.text,
        fullname: _fullnameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      UserService.register(newUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun Baru'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullnameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama lengkap wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email wajib diisi';
                  if (!value.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Username wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) =>
                    value == null || value.length < 6 ? 'Minimal 6 karakter' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Konfirmasi password wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('DAFTAR', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Sudah punya akun? Masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
