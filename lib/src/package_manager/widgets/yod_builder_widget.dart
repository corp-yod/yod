import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:yod/src/package_manager/core/domain/manager/kor_manager.dart';
import 'package:yod/src/package_manager/core/domain/manager/yod_proxy.dart';

typedef WidgetCallback = Widget Function();

class YodBuilder extends StatefulWidget {
  const YodBuilder({super.key, required this.builder});

  final WidgetCallback builder;

  @override
  State<YodBuilder> createState() => _YodBuilderState();
}

class _YodBuilderState extends State<YodBuilder> {
  Set<Kor> _detectedWatchers = {};

  void _update() {
    log(
      'YodBuilder: Detected change in one of the watchers, rebuilding... || $_detectedWatchers',
    );
    setState(() {});
  }

  void _updateListeners(Set<Kor> newWatchers) {
    final removed = _detectedWatchers.difference(newWatchers);
    for (var kor in removed) {
      log('YodBuilder: Removing listener from $kor');
      kor.removeListener(_update);
    }

    final added = newWatchers.difference(_detectedWatchers);
    for (var kor in added) {
      log('YodBuilder: Adding listener to $kor');
      kor.addListener(_update);
    }
    _detectedWatchers = Set.from(newWatchers);
  }

  bool _areSetsEqual(Set a, Set b) => a.length == b.length && a.containsAll(b);

  @override
  void dispose() {
    for (var kor in _detectedWatchers) {
      log('YodBuilder: Removing listener from $kor');
      kor.removeListener(_update);
    }
    _detectedWatchers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    YodProxy.startTracking();

    final result = widget.builder();

    final newWatchers = YodProxy.stopTracking() ?? {};

    if (!_areSetsEqual(_detectedWatchers, newWatchers)) {
      _updateListeners(newWatchers);
    }

    return result;
  }
}
