import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserService {
  static final List<User> _users = [];
  static User? _loggedInUser;

  // ✅ Register user baru
  static void register(User user) {
    _users.add(user);
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
      await prefs.setString('username', user.username);
      await prefs.setString('email', user.email);
      await prefs.setString('fullname', user.fullname);
      await prefs.setString('password', user.password);

      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Cek apakah ada user yang masih login
  static Future<bool> loadLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final email = prefs.getString('email');
    final fullname = prefs.getString('fullname');
    final password = prefs.getString('password');

    if (username != null && email != null && password != null) {
      _loggedInUser = User(
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
    await prefs.clear();
  }

  // ✅ Update data user
  static void updateUser(User updatedUser) {
    final index = _users.indexWhere((u) => u.username == updatedUser.username);
    if (index != -1) {
      _users[index] = updatedUser;
      _loggedInUser = updatedUser;
    }
  }
}
