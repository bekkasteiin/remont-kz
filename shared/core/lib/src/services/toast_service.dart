import 'dart:async';

import 'package:equatable/equatable.dart';

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

enum ToastNotificationType {
  info,
  error,
}

class ToastNotification extends Equatable {
  final ToastNotificationType type;
  final String? text;
  final Object? error;
  final StackTrace? stackTrace;
  final Duration duration;
  final bool closable;
  final bool dev;

  const ToastNotification({
    this.type = ToastNotificationType.info,
    this.text,
    this.error,
    this.stackTrace,
    this.duration = const Duration(seconds: 5),
    this.closable = true,
    this.dev = false,
  });

  @override
  List<Object?> get props => [type, text, error, stackTrace, closable, dev];
}
