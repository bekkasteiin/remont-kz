import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core.dart';
import '../../exceptions/http_exception.dart';

typedef CoreResultData<T> = void Function(T result);

/// результат выполнения загрузчика (лоадера)
typedef CoreLoadingData = void Function(bool isLoading);

mixin CoreRequestWorketMixin {
  /// Timer для запроса
  Timer? _timer;

  final String _defaultError = "Произошла ошибка";

  /// показывает сообщение об ошибке с возможность передачи http кода
  /// [errorMessage] сообщение об ошибке
  /// [code] http код ошибки
  Function(String errorMessage, int code)? showErrorHttpCallback;

  Function()? showAuthErrorCallback;

  /// показывает сообщение об ошибке при отсутвии интернета
  /// [errorMessage] сообщение об ошибке
  Function(String errorMessage)? showErrorInternetConnection;

  /// показывает сообщение об ошибке при cбое самого приложения
  /// [errorMessage] сообщение об ошибке
  Function(String errorMessage)? showErrorExceptionCallback;

  /// функиця безопастно запускает запрос без обработки пользовательской
  ///  ошибки(будут выводиться ошибки в стандартных полях предусмотренные сервером)
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке

  void launch<T>({
    Future<T>? request,
    CoreLoadingData? loading,
    CoreResultData<T?>? resultData,
    CoreResultData<String>? errorData,
  }) async {
    loading?.call(true);
    try {
      final result = await request;
      loading?.call(false);
      resultData?.call(result);
    } on HttpRequestException catch (ex) {
      loading?.call(false);
      _makeHttpException<String>(ex, errorData);
    } on Exception catch (ex) {
      loading?.call(false);
      _makeException<String>(ex, errorData);
    }
  }

  /// функиця безопастно запускает запрос c обработкой пользовательской
  ///  ошибки c возможностью добавить задержку
  /// [delay] время задержки запроса
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке
  void launchDelayWithError<T, V extends HttpRequestException>(
    int delay, {
    Future<T>? request,
    CoreLoadingData? loading,
    CoreResultData<T?>? resultData,
    @required Function(V)? errorData,
  }) async {
    _delay(delay, () async {
      loading?.call(true);
      try {
        final result = await request;
        loading?.call(false);
        resultData?.call(result);
      } on HttpRequestException catch (ex) {
        loading?.call(false);
        _makeHttpException<V>(ex, errorData);
      } on Exception catch (ex, s) {
        loading?.call(false);
        _makeException<V>(s, errorData);
      }
    });
  }

  /// функиця безопастно запускает запрос c обработкой пользовательской
  ///  ошибки c возможностью добавить задержку
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке
  void launchWithError<T, V extends HttpRequestException>({
    Future<T>? request,
    CoreLoadingData? loading,
    CoreResultData<T?>? resultData,
    @required Function(V)? errorData,
  }) async {
    loading?.call(true);
    try {
      final result = await request;
      loading?.call(false);
      resultData?.call(result);
    } on HttpRequestException catch (ex) {
      loading?.call(false);
      _makeHttpException<V>(ex, errorData);
    } on Exception catch (ex, s) {
      loading?.call(false);
      _makeException<V>(s, errorData);
    }
  }

  /// функиця безопастно запускает запрос без обработки пользовательской
  ///  ошибки(будут выводиться ошибки в стандартных полях предусмотренные сервером)
  /// [delay] время задержки запроса
  /// [request] запрос принимает фнкция useCase
  /// [loading] callback функция информирующая старт загрузки
  /// [resultState] callback успешном результате
  /// [errorState]  callback при ошибке
  void launchDelay<T>(
    int delay, {
    Future<T>? request,
    CoreLoadingData? loading,
    CoreResultData<T?>? resultData,
    CoreResultData<String>? errorData,
  }) async {
    _delay(delay, () async {
      loading?.call(true);
      try {
        final result = await request;
        loading?.call(false);
        resultData?.call(result);
      } on HttpRequestException catch (ex) {
        loading?.call(false);
        _makeHttpException<String>(ex, errorData);
      } on Exception catch (ex) {
        loading?.call(false);
        _makeException<String>(ex, errorData);
      }
    });
  }

  void clear() {
    _timer = null;
  }

  /// отображает http ошибки
  void _makeHttpException<T>(
    HttpRequestException? ex,
    CoreResultData<T>? errorData,
  ) {
    if (ex?.httpTypeError == HttpTypeError.notInternetConnection) {
      showErrorInternetConnection?.call(ex?.error?.toString() ?? CoreConstant.empty);
    }

    if (ex?.code == 401) {
      showAuthErrorCallback?.call();
    }

    if (errorData != null) {
      if (ex is T) {
        errorData.call(ex as T);
        return;
      }

      errorData.call(ex?.error);
      return;
    }

    if (ex?.httpTypeError == HttpTypeError.http) {
      showErrorHttpCallback?.call(
        ex?.error?.toString() ?? CoreConstant.empty,
        ex?.code ?? CoreConstant.zeroInt,
      );
      return;
    }
  }

  /// функция запускает таймер на определенное время
  void _delay(int delay, Function? run) {
    if (null != _timer) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: delay), () {
      run?.call();
    });
  }

  /// отображает различные исключения
  void _makeException<T>(ex, CoreResultData<T>? errorData) {
    showErrorExceptionCallback?.call(_defaultError);
  }
}
