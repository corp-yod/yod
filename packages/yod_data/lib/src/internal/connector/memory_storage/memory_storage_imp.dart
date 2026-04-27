import 'package:yod_data/src/yod_data_interface/platform_interface/model/export_model.dart';

class MemoryStorageImp extends MemoryStorage {
  final Map<String, dynamic> _storage = {};

  @override
  Set<String> getAllKey() {
    return _storage.keys.toSet();
  }

  @override
  T? getKeyValue<T>(String key) {
    if (_storage.containsKey(key)) {
      return _storage[key] as T?;
    }
    return null;
  }

  @override
  Future<void> removeKeyValue(String key) {
    _storage.remove(key);
    return Future.value();
  }

  @override
  void setKeyValue(String key, value) {
    _storage[key] = value;
  }
}
