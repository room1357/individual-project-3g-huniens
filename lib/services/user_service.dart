import '../models/user.dart';

class UserService {
  static final List<User> _users = [];
  static User? _loggedInUser;

  static void register(User user) {
    _users.add(user);
  }

  static bool login(String username, String password) {
    try {
      final user = _users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      _loggedInUser = user;
      return true;
    } catch (e) {
      return false;
    }
  }

  static User? get loggedInUser => _loggedInUser;

  static void logout() {
    _loggedInUser = null;
  }
}
