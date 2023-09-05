import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/screens/connection/screens/connection_error_screen.dart';
import 'package:remont_kz/utils/routes.dart';


class ConnectivityService {
  bool _isConnected = true;
  final StreamController<bool> _connectionStateController = StreamController<bool>();

  Stream<bool> get stream {
    return _connectionStateController.stream;
  }

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setIsConnected(result);
    });

    init();
  }

  bool get isConnected {
    return _isConnected;
  }

  Future<void> init() async {
    final result = await (Connectivity().checkConnectivity());
    setIsConnected(result);
  }

  setIsConnected(ConnectivityResult connectivityResult) {
    bool isConnected = false;

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      rootNavigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.root,(route) => false); isCurrentScreenConnection = true;
      isConnected = true;
    } else if (connectivityResult == ConnectivityResult.none) {
      isConnected = false;
      if(isCurrentScreenConnection) {
      rootNavigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.connectionError,(route) => false);
      }
    }
    _isConnected = isConnected;
    _connectionStateController.add(isConnected);
  }
}
