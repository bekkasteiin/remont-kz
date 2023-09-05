import 'package:remont_kz/domain/entities/dic_response.dart';import 'package:remont_kz/domain/entities/token_model.dart';import 'package:remont_kz/domain/entities/user.dart';import 'package:retrofit/retrofit.dart';import 'package:dio/dio.dart';part 'auth_api.g.dart';@RestApi(baseUrl: "https://remontor.kz/authentication/")abstract class AuthApi {  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;  @POST("/api/auth")  Future<TokenModel> login(@Body() Map<String, dynamic> map);  @POST('/users/verify-sms')  Future<void> sendSms(@Body() Map<String, dynamic> map);  @POST('/api/registration')  Future<void> registration(@Body() Map<String, dynamic> map);  @POST('/users/verify-sms')  Future<void> checkSms(@Body() Map<String, dynamic> map);  @GET('/profile')  Future<User?> getUser();  @PUT('/profile')  Future<void> updateUser(@Body() Map<String, dynamic> mapUser);  @POST('/profile/auth/token')  Future<TokenModel> refreshSession(@Body() Map<String, dynamic> map);  @GET('/dic')  Future<DicRequest> getDics();}