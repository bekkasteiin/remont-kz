// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) => TokenModel(
      refreshToken: json['refresh_token'] as String?,
      accessToken: json['access_token'] as String?,
    );

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{
      'refresh_token': instance.refreshToken,
      'access_token': instance.accessToken,
    };
