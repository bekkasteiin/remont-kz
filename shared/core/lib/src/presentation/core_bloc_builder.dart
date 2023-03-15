import 'package:core/src/presentation/skeleton.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/mixins/action_state_mixin.dart';
import 'core_state.dart';

/// пользовательский блок в который следуем заносить весь базовый функционал связанные с UI
/// Содержит в себе только bulder
class CoreUpgradeBlocBuilder<C extends Cubit<S>, S extends CoreState> extends StatefulWidget {
  final Function(String error)? httpErrorListener;
  final Function()? noInternetConnectionListener;
  final Function()? applicationExceptionListener;
  final Function()? redirectLoginListener;

  /// Функция [builder], которая будет вызываться при каждой сборке виджета.
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S>? builder;

  /// Функция [builder], которая будет вызываться при первом перестроении в случае ошибки,
  /// для того чтобы пользователь мог, позвторно сделать запрос
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S>? httpErrorBuilder;

  /// Функция [builder], которая будет вызываться в случае отсутвия интернета при первичном запуске,
  /// для того чтобы пользователь мог, позвторно сделать запрос,
  /// послудущие разы, данные кульбэк вызываться не будет
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S>? notInternetConnectionBuilder;

  /// Функция [builder], которая будет вызываться в случае сбоя в приложении при первичном запуске,
  /// для того чтобы пользователь мог, позвторно сделать запрос,
  /// послудущие разы, данные кульбэк вызываться не будет
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S>? applicationExceptionBuilder;

  /// Принимает `BuildContext` вместе с [cubit]` state`
  /// и отвечает за выполнение в ответ на изменения состояния.
  final BlocWidgetListener<S>? listener;

  /// [Cubit], с которым будет взаимодействовать [BlocConsumer].
  /// Если не указано, [BlocConsumer] автоматически выполнит поиск, используя
  /// `BlocProvider` и текущий` BuildContext`.
  final C? cubit;

  /// Принимает предыдущее `состояние` и текущее` состояние` и отвечает за
  /// возвращаем [bool], который определяет, запускать или нет
  /// [строитель] с текущим `состоянием`.
  final BlocBuilderCondition<S>? buildWhen;

  /// Принимает предыдущее `состояние` и текущее` состояние` и отвечает за
  /// возвращаем [bool], который определяет, вызывать ли [listener] из
  /// [BlocConsumer] с текущим `состоянием`.
  final BlocListenerCondition<S>? listenWhen;

  /// Функция [builder], которая будет вызываться при первичной загрузке.
  /// [Builder] принимает `BuildContext` и текущее` состояние` и
  /// должен возвращать виджет.
  /// Это аналог функции [builder] в [StreamBuilder].
  final BlocWidgetBuilder<S>? loadingBuilder;

  CoreUpgradeBlocBuilder({
    required this.builder,
    this.httpErrorBuilder,
    this.notInternetConnectionBuilder,
    this.applicationExceptionBuilder,
    this.cubit,
    this.buildWhen,
    this.listenWhen,
    this.listener,
    this.httpErrorListener,
    this.redirectLoginListener,
    this.noInternetConnectionListener,
    this.applicationExceptionListener,
    this.loadingBuilder,
  });

  @override
  _CoreUpgradeBlocBuilderState<C, S> createState() => _CoreUpgradeBlocBuilderState<C, S>();
}

class _CoreUpgradeBlocBuilderState<C extends Cubit<S>, S extends CoreState> extends State<CoreUpgradeBlocBuilder<C, S>>
    with ActionStateMixin {
  Widget? _widget;

  @override
  Widget build(BuildContext context) => BlocConsumer<C, S>(
    builder: (context, state) {
      if (state is CoreLoadingState) {
        if (widget.loadingBuilder == null) {
          return ListView.separated(
            itemCount: 8,
            separatorBuilder: (_, __) => Box(10.h),
            itemBuilder: (_, __) => SkeletonLoader(height: 100.h, radius: 8.r),
          );
        }
        return widget.loadingBuilder?.call(context, state) ?? const SizedBox();
      }
      final currentWidget = _widget ?? widget.builder?.call(context, state);
      return currentWidget ?? const SizedBox();
    },
    bloc: widget.cubit,
    buildWhen: (prevState, currentState) {
      return makeBuildWhenListener(prevState, currentState, (context, state) {
        _widget = null;
        return widget.buildWhen?.call(prevState, currentState) ?? true;
      }, () {
        _widget = widget.notInternetConnectionBuilder?.call(context, currentState);
      }, () {
        _widget = widget.httpErrorBuilder?.call(context, currentState);
      }, () {
        _widget = widget.applicationExceptionBuilder?.call(context, currentState);
      });
    },
    listenWhen: (prevState, state) {
      return widget.listenWhen?.call(prevState, state) ?? true;
    },
    listener: (context, state) {
      handleErrorListener(
        context,
        state,
        widget.httpErrorListener,
        widget.redirectLoginListener,
        widget.noInternetConnectionListener,
        widget.applicationExceptionListener,
      );
      widget.listener?.call(context, state);
    },
  );
}


class Box extends SizedBox {
  const Box(double height, {Key? key}) : super(height: height, width: 0, key: key);
}
