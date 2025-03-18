// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:async';

import 'package:flutter/gestures.dart';

export 'permission_util.dart';
export 'shared_preference.dart';
export 'validate_util.dart';

/// Function debounce
/// [func]: Method to execute
/// [delay]: Delay duration
GestureTapCallback tapDebounce(
  Function func, {
  Duration delay = const Duration(milliseconds: 500),
}) {
  Timer? timer;
  final target = () {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(delay, () {
      func.call();
    });
  };
  return target;
}

/// Function throttle
/// [func]: Method to execute
Function throttle(
  Future Function() func,
) {
  var enable = true;
  Function target = () {
    if (enable == true) {
      enable = false;
      func().then((_) {
        enable = true;
      });
    }
  };
  return target;
}
