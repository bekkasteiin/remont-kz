// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dic_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DicRequest _$DicRequestFromJson(Map<String, dynamic> json) => DicRequest(
      hobbies: (json['hobbies'] as List<dynamic>?)
          ?.map((e) => SecondDic.fromJson(e as Map<String, dynamic>))
          .toList(),
      cities: (json['cities'] as List<dynamic>?)
          ?.map((e) => Dic.fromJson(e as Map<String, dynamic>))
          .toList(),
      familyStatuses: (json['family_statuses'] as List<dynamic>?)
          ?.map((e) => Dic.fromJson(e as Map<String, dynamic>))
          .toList(),
      genders: (json['genders'] as List<dynamic>?)
          ?.map((e) => Dic.fromJson(e as Map<String, dynamic>))
          .toList(),
      usrLikeActions: (json['usr_like_actions'] as List<dynamic>?)
          ?.map((e) => Dic.fromJson(e as Map<String, dynamic>))
          .toList(),
      marriagePeriods: (json['marriage_periods'] as List<dynamic>?)
          ?.map((e) => SecondDic.fromJson(e as Map<String, dynamic>))
          .toList(),
      chatMsgTypes: (json['chat_msg_types'] as List<dynamic>?)
          ?.map((e) => Dic.fromJson(e as Map<String, dynamic>))
          .toList(),
      chatStatuses: (json['chat_statuses'] as List<dynamic>?)
          ?.map((e) => SecondDic.fromJson(e as Map<String, dynamic>))
          .toList(),
      chatSystemMsgs: (json['chat_system_msgs'] as List<dynamic>?)
          ?.map((e) => SecondDic.fromJson(e as Map<String, dynamic>))
          .toList(),
      notificationTypes: (json['notification_types'] as List<dynamic>?)
          ?.map((e) => SecondDic.fromJson(e as Map<String, dynamic>))
          .toList(),
      ualiRels: (json['uali_rels'] as List<dynamic>?)
          ?.map((e) => SecondDic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DicRequestToJson(DicRequest instance) =>
    <String, dynamic>{
      'hobbies': instance.hobbies,
      'cities': instance.cities,
      'family_statuses': instance.familyStatuses,
      'genders': instance.genders,
      'usr_like_actions': instance.usrLikeActions,
      'marriage_periods': instance.marriagePeriods,
      'uali_rels': instance.ualiRels,
      'chat_statuses': instance.chatStatuses,
      'chat_msg_types': instance.chatMsgTypes,
      'chat_system_msgs': instance.chatSystemMsgs,
      'notification_types': instance.notificationTypes,
    };

SecondDic _$SecondDicFromJson(Map<String, dynamic> json) => SecondDic(
      id: json['id'] as String?,
      name: json['name'] as String?,
      ord: json['ord'] as int?,
    );

Map<String, dynamic> _$SecondDicToJson(SecondDic instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ord': instance.ord,
    };

Dic _$DicFromJson(Map<String, dynamic> json) => Dic(
      id: json['id'] as int?,
      name: json['name'] as String?,
      ord: json['ord'] as int?,
    );

Map<String, dynamic> _$DicToJson(Dic instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ord': instance.ord,
    };
