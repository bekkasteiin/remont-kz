import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/core_state.dart';

/// отслеживаем состояние которые нужно выполнить в базовых случаях
mixin ActionStateMixin {
  bool makeBuildWhenListener<S>(
      S prevState,
      S currentState,
      BlocBuilderCondition<S>? buildWhen,
      Function()? noInternetConnectionListener,
      Function()? httpErrorListener,
      Function()? applicationExtensionListener,
      ) {
    /// в случае если нет интернет соеденения и загрузка была первичной
    if (currentState is CoreNotInternetConnectionState && prevState is CoreLoadingState) {
      noInternetConnectionListener?.call();
      return true;
    }

    /// в случае если произощел сбой в приложении и загрузка была первичной
    if (currentState is CoreErrorExceptionState && prevState is CoreLoadingState) {
      applicationExtensionListener?.call();
      return true;
    }

    /// в случае если произошла ошибка при http загрузке  и загрузка была первичной
    if (currentState is CoreHttpErrorState && prevState is CoreLoadingState) {
      httpErrorListener?.call();
      return true;
    }

    if (currentState is CoreNotInternetConnectionState ||
        currentState is CoreHttpErrorState ||
        currentState is CoreErrorExceptionState) {
      return false;
    }
    final value = (buildWhen?.call(prevState, currentState) ?? true);
    return value;
  }

  /// отслеживаем ошибки
  /// [bool disableNetworkErrorMessages] - если true, то ошибки не показваются дефолтным образом в SnackBar
  void handleErrorListener(
      BuildContext context,
      CoreState currentState,
      Function(String error)? httpErrorListener,
      Function()? redirectLoginListener,
      Function()? notInternetConnectionListener,
      Function()? applicationExceptionListener,
      ) {
    if (currentState is CoreHttpErrorState) {
      httpErrorListener == null
          ? _showSnackBar(context, currentState.error, true)
          : httpErrorListener.call(currentState.error);
    }

    if (currentState is CoreNotInternetConnectionState) {
      notInternetConnectionListener == null
          ? _showSnackBar(context, currentState.error, true)
          : notInternetConnectionListener.call();
    }

    if (currentState is CoreErrorExceptionState) {
      applicationExceptionListener == null
          ? _showSnackBar(
        context,
        currentState.error,
        true,
      )
          : applicationExceptionListener.call();
    }

    if (currentState is CoreErrorAuthErrorState) {
      redirectLoginListener?.call();
    }
  }

  /// показывает SnackBar об ошибке
  void _showSnackBar(
      BuildContext context,
      String error,
      bool isShowSnackBar,
      ) {
    if (isShowSnackBar) {
      final snackBar = SnackBar(content: Text(error));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
