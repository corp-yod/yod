abstract class SecureStorage {

  Future<T?> getKeyValue<T>(String key, {bool ensureSetup = false});

  Future<void> setKeyValue(String key, dynamic value);

  Future<Set<String>> getAllKey();

  Future<void> removeKeyValue(String key);
}