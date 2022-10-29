import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  void setToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('x-auth-token');
  }
}
