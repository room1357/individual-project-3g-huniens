import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserService {
  static final List<User> _users = [];
  static User? _loggedInUser;

  static Future<void> register(User user) async {
    _users.add(user);

    // Simpan data user ke local storage (tapi jangan auto-login)
    final prefs = await SharedPreferences.getInstance();
    List<String> existingUsers = prefs.getStringList('users') ?? [];

    // Simpan data user sebagai JSON string agar bisa banyak user
    final newUserData = {
      'id': user.id,
      'username': user.username,
      'fullname': user.fullname,
      'email': user.email,
      'password': user.password,
    };

    existingUsers.add(newUserData.toString());
    await prefs.setStringList('users', existingUsers);
  }

  // ✅ Login pakai username atau email
  static Future<bool> login(String identifier, String password) async {
    try {
      final user = _users.firstWhere(
        (u) =>
            (u.username == identifier || u.email == identifier) &&
            u.password == password,
      );
      _loggedInUser = user;

      // Simpan data user ke local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', user.id);
      await prefs.setString('username', user.username);
      await prefs.setString('fullname', user.fullname);
      await prefs.setString('email', user.email);
      await prefs.setString('password', user.password);

      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Cek apakah ada user yang masih login (ambil dari local storage)
  static Future<bool> loadLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getString('id');
    final username = prefs.getString('username');
    final fullname = prefs.getString('fullname');
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    // Pastikan semua data penting tersedia
    if (username != null && email != null && password != null) {
      _loggedInUser = User(
        id: id ?? username, // fallback: gunakan username sebagai id
        username: username,
        fullname: fullname ?? '',
        email: email,
        password: password,
      );
      return true;
    }
    return false;
  }

  static User? get loggedInUser => _loggedInUser;

  // ✅ Logout user & hapus dari local storage
  static Future<void> logout() async {
    _loggedInUser = null;
    final prefs = await SharedPreferences.getInstance();

    // Hapus hanya data login user, bukan semua data
    await prefs.remove('id');
    await prefs.remove('username');
    await prefs.remove('fullname');
    await prefs.remove('email');
    await prefs.remove('password');
  }

  // ✅ Update data user (misal ganti nama/email)
  static void updateUser(User updatedUser) {
    final index = _users.indexWhere((u) => u.username == updatedUser.username);
    if (index != -1) {
      _users[index] = updatedUser;
      _loggedInUser = updatedUser;
    }
  }
}
