import 'dart:async';

import 'package:dependencies/dependencies.dart';

class ConnectivityService {
  bool _isConnected = true;
  final StreamController<bool> _connectionStateController = StreamController<bool>();

  Stream<bool> get stream {
    return _connectionStateController.stream;
  }

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen(setIsConnected);

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
    var isConnected = false;

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      isConnected = true;
    } else if (connectivityResult == ConnectivityResult.none) {
      isConnected = false;
    }

    _isConnected = isConnected;
    _connectionStateController.add(isConnected);
  }
}
