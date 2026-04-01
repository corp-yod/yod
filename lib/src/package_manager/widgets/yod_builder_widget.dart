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
  @override
  void initState() {
    super.initState();
    _makeConnection();
  }

  void _makeConnection() {
    for (var kor in _detectedWatchers) {
      kor.removeListener(_update);
    }

    YodProxy.startTracking();

    widget.builder();

    final found = YodProxy.stopTracking();

    final added = newWatchers.difference(_detectedWatchers);
    for (var kor in added) {
      log('YodBuilder: Adding listener to $kor');
      kor.addListener(_update);
    }
    _detectedWatchers = Set.from(newWatchers);
  }

  void _update() {
    if (mounted) setState(() {});
  }

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
