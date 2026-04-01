import 'package:yod/src/package_manager/core/domain/manager/kor_manager.dart';

class YodProxy {
  static final List<Set<Kor>> _stack = [];

  static void startTracking() {
    _stack.add(<Kor>{});
  }

  static Set<Kor>? stopTracking() {
    if (_stack.isEmpty) return null;
    return _stack.removeLast();
  }

  static void register(Kor kor) {
    if (_stack.isNotEmpty) {
      _stack.last.add(kor);
    }
  }
}
