import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String _tokenKey = 'auth_token';

  SharedPreferences _prefs = GetIt.instance<SharedPreferences>();

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? get authToken => _prefs.getString(_tokenKey);

  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<void> clearAuthToken() async {
    await _prefs.remove(_tokenKey);
  }
}
