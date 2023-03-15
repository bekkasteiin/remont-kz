import 'package:equatable/equatable.dart';

/// общий класс обработки састояния
abstract class CoreState extends Equatable {
  @override
  List<Object> get props => [];
}

/// общий класс обработки састояния c уникальный index-ом для постоянного эмита в bloc/cubit
abstract class CoreIndexedState extends CoreState {
  final index = DateTime.now().microsecondsSinceEpoch;

  @override
  List<Object> get props => [index];
}

class CoreLoadingState extends CoreState {}

class CoreNotInternetConnectionState extends CoreState {
  final String error;

  CoreNotInternetConnectionState({required this.error});

  @override
  List<Object> get props => [error];
}

class CoreHttpErrorState extends CoreIndexedState {
  final String error;
  final int code;

  CoreHttpErrorState(this.error, this.code);

  @override
  List<Object> get props => [error, code, index];
}

class CoreErrorAuthErrorState extends CoreIndexedState {}

/// состояние при внутреней ошибке приложения
class CoreErrorExceptionState extends CoreState {
  final String error;

  CoreErrorExceptionState({required this.error});

  @override
  List<Object> get props => [error];
}
