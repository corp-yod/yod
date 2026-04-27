import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:yod_data/src/internal/accessor/native/native_accessor.dart';
import 'package:yod_data/src/internal/connector/isar/key_value_storage_imp.dart';
import 'package:yod_data/src/internal/connector/isar_cache_entry/cache_entry.dart';
import 'package:yod_data/src/internal/exception/yod_data_exception.dart';
import 'package:yod_data/src/yod_data_interface/platform_interface/model/export_model.dart';

class IsarStorage {
  IsarStorage();
  final Map<String, KeyValueStorage> _storages = {};

  Future<void> init() async {
    if (!kIsWeb) {}
    return Future.value();
  }

  Future<void> register<T>({
    required String dbName,
    String? encryptKey,
    int retryCount = 0,
  }) async {
    if (_storages.containsKey(dbName)) {
      return;
    }

    try {
      final isarLocation = await NativeAccessor.instance.isarLocation;
      Isar isar = await Isar.open(
        [CacheEntrySchema],
        directory: isarLocation,
        name: dbName,
      );

      _storages[dbName] = KeyValueStorageImp(dbName, isar);

      print('#->>> IsarStorage register: dbName=$dbName, _storages=$_storages');

      return;
    } catch (e) {
      if (retryCount > 0) {
        print("Open box failed after retry. error=$e");
        rethrow;
      }

      // await deleteBox(dbName: dbName);

      // print("Deleted box from disk, retry open box. dbName=$dbNameMapping");
      return register<T>(
        dbName: dbName,
        encryptKey: encryptKey,
        retryCount: retryCount + 1,
      );
    }
  }

  KeyValueStorage getStorage({required String dbName}) {
    if (_storages.containsKey(dbName)) {
      return _storages[dbName]!;
    }

    throw YodDataException("$dbName is not register.");
  }

  Future<void> closeBox({required String dbName}) async {
    if (_storages.containsKey(dbName)) {
      final String dbNameMapping = "${dbName}_mapping";

      final storageBase = _storages.remove(dbName);
      await storageBase?.close();

      final storageMappingName = _storages.remove(dbNameMapping);
      await storageMappingName?.close();
    }
  }

  // Future<void> deleteBox({required String dbName}) async {
  //   if (_storages.containsKey(dbName)) {
  //     try {
  //       await closeBox(dbName: dbName);
  //     } catch (e) {
  //       print('Error closing box before deletion. dbName=$dbName, error=$e');
  //     }
  //   }
  //   try {
  //     print('delete box from disk. dbName=$dbName');
  //     await Hive.deleteBoxFromDisk(dbName);

  //     print('delete mapping box from disk. dbName=${dbName}_mapping');
  //     await Hive.deleteBoxFromDisk("${dbName}_mapping");
  //   } catch (e) {
  //     print('Error deleting box from disk. dbName=$dbName, error=$e');
  //   }
  // }

  bool isBoxOpen({required String dbName}) {
    return _storages.containsKey(dbName);
  }
}
