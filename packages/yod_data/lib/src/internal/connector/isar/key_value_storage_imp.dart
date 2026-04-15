import 'package:isar/isar.dart';
import 'package:yod_data/src/internal/connector/isar_cache_entry/cache_entry.dart';
import 'package:yod_data/src/yod_data_interface/platform_interface/model/export_model.dart';

class KeyValueStorageImp extends KeyValueStorage {
  final String _storageName;
  final Isar isar;

  KeyValueStorageImp(this._storageName, this.isar);

  String get storageName => _storageName;

  // ===== Helpers =====
  // String _resolveKey(String key, {bool appendMyId = false}) {
  //   if (!appendMyId) return key;
  //   final id = myId;
  //   return (id != null && id.isNotEmpty) ? "${id}_$key" : key;
  // }

  Future<T?> _readValue<T>(String key, {bool appendMyId = false}) async {
    // String resolvedKey;
    // resolvedKey = _resolveKey(key, appendMyId: appendMyId);

    final entry = await isar.cacheEntrys.filter().keyEqualTo(key).findFirst();

    if (entry == null) return null;

    // ถ้าหมดอายุแล้ว ให้ลบทิ้งและคืนค่า null
    if (entry.isExpired) {
      await removeKeyValue(key);
      return null;
    }

    final value = entry.value;

    return value is T ? value : null;
  }

  Future<void> _setValue(
    String key,
    Object value, {
    Duration? ttl,
    bool appendMyId = false,
  }) async {
    final entry = CacheEntry()
      ..key = key
      ..value = value
      ..expiry = ttl != null ? DateTime.now().add(ttl) : null;

    await isar.writeTxn(() async {
      await isar.cacheEntrys.put(entry);
    });
  }

  Future<void> _cleanExpired() async {
    await isar.writeTxn(() async {
      await isar.cacheEntrys
          .filter()
          .expiryLessThan(DateTime.now())
          .deleteAll();
    });
  }

  // ===== Overrides =====
  @override
  Future<void> init() async {
    _cleanExpired();
  }

  @override
  Future<Set<String>> getAllKey() async {
    final keys = await isar.cacheEntrys.where().keyProperty().findAll();

    return keys.toSet();
  }

  @override
  Future<void> removeKeyValue(String key, {bool prefixMode = false}) async {
    await isar.writeTxn(() async {
      await isar.cacheEntrys.filter().keyEqualTo(key).deleteFirst();
    });
  }

  @override
  Future<void> clear() async {
    await isar.clear();
  }

  @override
  Future<void> close() => isar.close();

  // ===== Getters =====
  @override
  Future<bool?> getKeyValueBool(String key, {bool appendMyId = false}) =>
      _readValue<bool>(key, appendMyId: appendMyId);

  @override
  Future<DateTime?> getKeyValueDateTime(
    String key, {
    bool appendMyId = false,
  }) => _readValue<DateTime>(key, appendMyId: appendMyId);

  @override
  Future<double?> getKeyValueDouble(String key, {bool appendMyId = false}) =>
      _readValue<double>(key, appendMyId: appendMyId);

  @override
  Future<int?> getKeyValueInt(String key, {bool appendMyId = false}) =>
      _readValue<int>(key, appendMyId: appendMyId);

  @override
  Future<List?> getKeyValueList(String key, {bool appendMyId = false}) =>
      _readValue<List>(key, appendMyId: appendMyId);

  @override
  Future<Map<dynamic, dynamic>?> getKeyValueMap(
    String key, {
    bool appendMyId = false,
  }) => _readValue<Map>(key, appendMyId: appendMyId);

  @override
  Future<String?> getKeyValueString(String key, {bool appendMyId = false}) =>
      _readValue<String>(key, appendMyId: appendMyId);

  // ===== Setters =====
  @override
  Future<void> setKeyValueBool(
    String key,
    bool value, {
    Duration? ttl,
    bool appendMyId = false,
  }) => _setValue(key, value, ttl: ttl, appendMyId: appendMyId);

  @override
  Future<void> setKeyValueDateTime(
    String key,
    DateTime value, {
    Duration? ttl,
    bool appendMyId = false,
  }) => _setValue(key, value, ttl: ttl, appendMyId: appendMyId);

  @override
  Future<void> setKeyValueDouble(
    String key,
    double value, {
    Duration? ttl,
    bool appendMyId = false,
  }) => _setValue(key, value, ttl: ttl, appendMyId: appendMyId);

  @override
  Future<void> setKeyValueInt(
    String key,
    int value, {
    Duration? ttl,
    bool appendMyId = false,
  }) => _setValue(key, value, ttl: ttl, appendMyId: appendMyId);

  @override
  Future<void> setKeyValueList(
    String key,
    List value, {
    Duration? ttl,
    bool appendMyId = false,
  }) => _setValue(key, value, ttl: ttl, appendMyId: appendMyId);

  @override
  Future<void> setKeyValueMap(
    String key,
    Map<dynamic, dynamic> value, {
    Duration? ttl,
    bool appendMyId = false,
  }) => _setValue(key, value, ttl: ttl, appendMyId: appendMyId);

  @override
  Future<void> setKeyValueString(
    String key,
    String value, {
    Duration? ttl,
    bool appendMyId = false,
  }) => _setValue(key, value, ttl: ttl, appendMyId: appendMyId);
}
