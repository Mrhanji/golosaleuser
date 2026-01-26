import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurePreferenceStorage {
  // Singleton instance
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// ================= RESET APP =================
  Future<void> resetApp() async {
    await _storage.deleteAll();
  }

  /// ================= LOGIN USER =================
  Future<String?> getLoginUser() async {
    return await _storage.read(key: "user");
  }

  Future<bool> setLoginUser(String user) async {
    await _storage.write(key: "user", value: user);
    return true;
  }

  /// ================= LOGIN STATUS =================
  Future<bool> getLoginStatus() async {
    final value = await _storage.read(key: "loginStatus");
    return value == "true";
  }

  Future<bool> setLoginStatus(bool status) async {
    await _storage.write(
      key: "loginStatus",
      value: status.toString(),
    );
    return true;
  }

  /// ================= LANGUAGE =================
  Future<String> getDefaultLanguage() async {
    return await _storage.read(key: "language") ?? "en";
  }

  Future<bool> setDefaultLanguage(String language) async {
    await _storage.write(key: "language", value: language);
    return true;
  }

  /// ======== City ===============================

  Future<String>getDefaultCity()async{
    return await _storage.read(key: "city")??'';

  }

  Future<bool>setDefaultCity(String city)async{
    await _storage.write(key: "city", value: city);
    return true;
  }

}
