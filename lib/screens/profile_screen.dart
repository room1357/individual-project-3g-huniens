import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Data profil user
  String _fullName = '';
  String _email = '';
  String _username = '';
  String _password = '';

  // Controller untuk edit data
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = UserService.loggedInUser;
    if (user != null) {
      setState(() {
        _fullName = user.fullname;
        _email = user.email;
        _username = user.username;
        _password = user.password;

        _fullNameController.text = _fullName;
        _emailController.text = _email;
        _usernameController.text = _username;
        _passwordController.text = _password;
      });
    }
  }

  void _saveProfile() {
    setState(() {
      _fullName = _fullNameController.text;
      _email = _emailController.text;
      _username = _usernameController.text;
      _password = _passwordController.text;
      _isEditing = false;
    });

    // 🔹 Simpan perubahan ke UserService
    final updatedUser = User(
      id: UserService.loggedInUser?.id ?? '0',
      username: _username,
      fullname: _fullName,
      email: _email,
      password: _password, 
    );

    UserService.updateUser(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserService.loggedInUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil Pengguna')),
        body: const Center(child: Text('Tidak ada pengguna yang login')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildTextField('Nama Lengkap', _fullNameController, enabled: _isEditing),
            const SizedBox(height: 12),
            _buildTextField('Email', _emailController, enabled: _isEditing),
            const SizedBox(height: 12),
            _buildTextField('Username', _usernameController, enabled: false),
            const SizedBox(height: 12),
            _buildTextField('Password', _passwordController,
                enabled: _isEditing, obscureText: true),
            const SizedBox(height: 24),
            if (!_isEditing)
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool enabled = false, bool obscureText = false}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
