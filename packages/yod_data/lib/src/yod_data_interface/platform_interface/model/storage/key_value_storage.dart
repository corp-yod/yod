abstract class KeyValueStorage {
  Future<void> init();

  Future<String?> getKeyValueString(String key, {bool appendMyId = false});

  Future<int?> getKeyValueInt(String key, {bool appendMyId = false});

  Future<double?> getKeyValueDouble(String key, {bool appendMyId = false});

  Future<bool?> getKeyValueBool(String key, {bool appendMyId = false});

  Future<List<dynamic>?> getKeyValueList(String key, {bool appendMyId = false});

  Future<Map<dynamic, dynamic>?> getKeyValueMap(
    String key, {
    bool appendMyId = false,
  });

  Future<DateTime?> getKeyValueDateTime(String key, {bool appendMyId = false});

  Future<void> setKeyValueString(
    String key,
    String value, {
    Duration? ttl,
    bool appendMyId = false,
  });

  Future<void> setKeyValueInt(
    String key,
    int value, {
    Duration? ttl,
    bool appendMyId = false,
  });

  Future<void> setKeyValueDouble(
    String key,
    double value, {
    Duration? ttl,
    bool appendMyId = false,
  });

  Future<void> setKeyValueBool(
    String key,
    bool value, {
    Duration? ttl,
    bool appendMyId = false,
  });

  Future<void> setKeyValueList(
    String key,
    List<dynamic> value, {
    Duration? ttl,
    bool appendMyId = false,
  });

  Future<void> setKeyValueMap(
    String key,
    Map<dynamic, dynamic> value, {
    Duration? ttl,
    bool appendMyId = false,
  });

  Future<void> setKeyValueDateTime(
    String key,
    DateTime value, {
    Duration? ttl,
    bool appendMyId = false,
  });

  Future<Set<String>> getAllKey();

  Future<void> removeKeyValue(String key, {bool prefixMode = false});

  Future<void> clear();

  Future<void> close();
}
