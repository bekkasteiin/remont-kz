import 'dart:async';

import 'package:remont_kz/domain/entities/toas_notification.dart';

class ToastService {
  final _controller = StreamController<ToastNotification>.broadcast();

  Stream<ToastNotification> get stream => _controller.stream;

  add(ToastNotification toast) {
    _controller.add(toast);
  }

  void dispose() {
    _controller.close();
  }
}
