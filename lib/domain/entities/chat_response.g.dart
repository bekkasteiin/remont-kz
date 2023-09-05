// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) => ChatResponse(
      page: json['page'] as int?,
      pageSize: json['page_size'] as int?,
      totalCount: json['total_count'] as int?,
      results: (json['results'] as List<dynamic>)
          .map((e) => ChatData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatResponseToJson(ChatResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'page_size': instance.pageSize,
      'total_count': instance.totalCount,
      'results': instance.results,
    };

ChatData _$ChatDataFromJson(Map<String, dynamic> json) => ChatData(
      id: json['id'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      lastMsgId: json['last_msg_id'] as String?,
      lastMsgTs: json['last_msg_ts'] == null
          ? null
          : DateTime.parse(json['last_msg_ts'] as String),
      girlId: json['girl_id'] as int?,
      boyId: json['boy_id'] as int?,
      ualiId: json['uali_id'] as int?,
      status: json['status'] as String?,
      girlNewMsgCount: json['girl_new_msg_count'] as int?,
      boyNewMsgCount: json['boy_new_msg_count'] as int?,
      ualiNewMsgCount: json['uali_new_msg_count'] as int?,
      girl: json['girl'] == null
          ? null
          : User.fromJson(json['girl'] as Map<String, dynamic>),
      boy: json['boy'] == null
          ? null
          : User.fromJson(json['boy'] as Map<String, dynamic>),
      uali: json['uali'] == null
          ? null
          : User.fromJson(json['uali'] as Map<String, dynamic>),
      lastMsg: json['last_msg'] as String?,
    );

Map<String, dynamic> _$ChatDataToJson(ChatData instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'last_msg_id': instance.lastMsgId,
      'last_msg_ts': instance.lastMsgTs?.toIso8601String(),
      'girl_id': instance.girlId,
      'boy_id': instance.boyId,
      'uali_id': instance.ualiId,
      'status': instance.status,
      'girl_new_msg_count': instance.girlNewMsgCount,
      'boy_new_msg_count': instance.boyNewMsgCount,
      'uali_new_msg_count': instance.ualiNewMsgCount,
      'girl': instance.girl,
      'boy': instance.boy,
      'uali': instance.uali,
      'last_msg': instance.lastMsg,
    };
