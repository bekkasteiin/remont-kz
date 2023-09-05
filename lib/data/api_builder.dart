import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:remont_kz/data/datasources/auth_api.dart';
import 'package:remont_kz/data/datasources/chat_api.dart';
import 'package:remont_kz/data/datasources/file_api.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/entities/token_model.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/utils/constants.dart';

final _defaultInterceptors = <Interceptor>[];

class ApiBuilder {
  final String _baseUrl = AppContsts.baseUrl;
  final String _fileUrl = AppContsts.fileUrl;

  ApiBuilder() {
    final options = BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        "Accept": "application/json",
      },
    );
    _dio = Dio(options);
    _dio.interceptors.addAll(_defaultInterceptors);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final tokenStore = getIt.get<TokenStoreService>();

          options.headers['Authorization'] = 'Bearer ${tokenStore.accessToken}';
          return handler.next(options);
        },
        onError: (DioError error, handler) async {
          if (error.response?.statusCode == 401) {
            if (await refreshToken()) {
              return handler.resolve(await _retry(error.requestOptions));
            } else {
              await getIt.get<TokenStoreService>().clearAndLogoutToken();
              return;
            }
          }
          if(error.type == DioErrorType.connectTimeout){

          }
          return handler.next(error);
        },
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(_prettyDioLogger);
    }
  }

  late Dio _dio;

  Dio get dio => _dio;

  /// логирование запроса
  PrettyDioLogger get _prettyDioLogger => PrettyDioLogger(
        requestHeader: false,
        requestBody: false,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 120,
      );

  /// API для авторизация
  AuthApi getAuthApi() {
    return AuthApi(_dio, baseUrl: _baseUrl);
  }

  /// API для chat
  ChatApi getChatApi() {
    return ChatApi(_dio, baseUrl: _baseUrl);
  }

  FileApi getFileApi() {
    return FileApi(_dio, baseUrl: _fileUrl);
  }

  Future<bool> refreshToken() async {
    final tokenStore = getIt.get<TokenStoreService>();

    final api = getIt.get<ApiBuilder>().getAuthApi();
    try {
      final response = await api.refreshSession({'refresh_token': '${tokenStore.refreshToken}'});
      print('------refreshSession!!!------');
      await tokenStore.saveToken(TokenModel(
        accessToken: response.accessToken,
        refreshToken: tokenStore.storage.refreshToken,
      ));
      return true;
    } catch (e) {
      print('------clearToken!!!------');
      await tokenStore.clearAndLogoutToken();
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data, queryParameters: requestOptions.queryParameters, options: options);
  }
}
