abstract class MemoryStorage {

  T? getKeyValue<T>(String key);

  void setKeyValue(String key, dynamic value);

  Set<String> getAllKey();

  void removeKeyValue(String key);
}