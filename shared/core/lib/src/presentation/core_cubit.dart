import 'package:dependencies/dependencies.dart';

import '../utils/mixins/request_worker_mixin.dart';
import 'core_state.dart';

abstract class CoreCubit extends Cubit<CoreState> with CoreRequestWorketMixin {
  List<CoreRequestWorketMixin>? _useCaseLaunchers;

  CoreCubit(
    CoreState state, {
    List<CoreRequestWorketMixin>? useCaseLaunchers,
  }) : super(state) {
    _useCaseLaunchers = useCaseLaunchers;
    _useCaseLaunchers?.forEach((element) {
      element.showErrorHttpCallback = (errorMessage, code) {
        emit(CoreHttpErrorState(errorMessage, code));
      };
      element.showAuthErrorCallback = () {
        emit(CoreErrorAuthErrorState());
      };
      element.showErrorInternetConnection = (error) {
        emit(CoreNotInternetConnectionState(error: error));
      };
      element.showErrorExceptionCallback = (error) {
        emit(CoreErrorExceptionState(error: error));
      };
    });

    showErrorInternetConnection = (error) {
      emit(CoreNotInternetConnectionState(error: error));
    };

    showAuthErrorCallback = () {
      emit(CoreErrorAuthErrorState());
    };

    showErrorHttpCallback = (errorMessage, code) {
      emit(CoreHttpErrorState(errorMessage, code));
    };

    showErrorExceptionCallback = (error) {
      emit(CoreErrorExceptionState(error: error));
    };
  }

  @override
  Future<void> close() {
    _useCaseLaunchers?.forEach((element) {
      element.clear();
    });
    clear();
    return super.close();
  }
}
