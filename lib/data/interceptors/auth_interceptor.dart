// import 'dart:developer';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:hitba/data/api_builder.dart';
// import 'package:hitba/di.dart';
// import 'package:hitba/domain/services/token_store_service.dart';
//
// class AuthInterceptor extends Interceptor with ChangeNotifier {
//   final Future<bool> Function() refreshSession;
//
//   AuthInterceptor({required this.refreshSession});
//
//   final _tokenStore = getIt.get<TokenStoreService>();
//   bool _locked = false;
//
//   static const flag = 'accessToken';
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     final headers = options.headers;
//     headers['Authorization'] = _tokenStore.accessToken;
//     options.headers = headers;
//
//     return handler.next(options);
//   }
//
//   @override
//   onError(DioError err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
//       final dio = getIt.get<ApiBuilder>().dio;
//       final requestOptions = err.requestOptions;
//       // RequestOptions origin = err.response.;
//
//       try {
//         // if (tik.tokenValid) {
//         if (requestOptions.headers['Repeated-Request'] == 'yes') {
//           return handler.next(err);
//         }
//         // }
//         _lockDio();
//         bool success = await refreshSession();
//         if (success) {
//         } else {
//           print('success: $success}');
//         }
//         _unlockDio();
//         requestOptions.headers['Repeated-Request'] = 'yes';
//         requestOptions.headers['Authorization'] = _tokenStore.accessToken;
//         return await dio.request(requestOptions.path);
//         // handler.resolve(await dio.fetch(err.requestOptions));
//         // return;
//       } catch (error, s) {
//         log(error.toString());
//         debugPrintStack(label: error.toString(), stackTrace: s);
//       }
//     }
//
//     return handler.next(err);
//   }
//
//   void _lockDio() {
//     final dio = getIt.get<ApiBuilder>().dio;
//     if (dio != null && !_locked) {
//       dio.lock();
//       dio.interceptors.responseLock.lock();
//       dio.interceptors.errorLock.lock();
//       _locked = true;
//     }
//   }
//
//   void _unlockDio() {
//     final dio = getIt.get<ApiBuilder>().dio;
//
//     if (dio != null && _locked) {
//       dio.unlock();
//       dio.interceptors.responseLock.unlock();
//       dio.interceptors.errorLock.unlock();
//       _locked = false;
//     }
//   }
// }
