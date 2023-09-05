// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgResponse _$MsgResponseFromJson(Map<String, dynamic> json) => MsgResponse(
      page: json['page'] as int?,
      pageSize: json['page_size'] as int?,
      totalCount: json['total_count'] as int?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Massage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MsgResponseToJson(MsgResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'page_size': instance.pageSize,
      'total_count': instance.totalCount,
      'results': instance.results,
    };

Massage _$MassageFromJson(Map<String, dynamic> json) => Massage(
      id: json['id'] as String?,
      ts: json['ts'] == null ? null : DateTime.parse(json['ts'] as String),
      tp: json['tp'] as int?,
      content: json['content'] as String?,
      chatId: json['chat_id'] as int?,
      usrId: json['usr_id'] as int?,
      toUsrId: json['to_usr_id'] as int?,
      toMsgId: json['to_msg_id'] as String?,
    );

Map<String, dynamic> _$MassageToJson(Massage instance) => <String, dynamic>{
      'id': instance.id,
      'ts': instance.ts?.toIso8601String(),
      'tp': instance.tp,
      'content': instance.content,
      'chat_id': instance.chatId,
      'usr_id': instance.usrId,
      'to_usr_id': instance.toUsrId,
      'to_msg_id': instance.toMsgId,
    };
