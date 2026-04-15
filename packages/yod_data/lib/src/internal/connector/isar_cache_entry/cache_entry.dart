import 'package:isar/isar.dart';

part 'cache_entry.g.dart';

@collection
class CacheEntry {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late dynamic value; // เก็บเป็น String (แนะนำให้แปลงเป็น JSON ก่อนเก็บ)

  DateTime? expiry; // ถ้าเป็น null คือไม่มีวันหมดอายุ

  // ฟังก์ชันช่วยเช็คว่าหมดอายุหรือยัง
  bool get isExpired => expiry != null && DateTime.now().isAfter(expiry!);
}
