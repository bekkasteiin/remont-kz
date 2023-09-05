import 'package:json_annotation/json_annotation.dart';
import 'package:remont_kz/domain/entities/user.dart';

part 'chat_response.g.dart';

@JsonSerializable()
class ChatResponse {
  ChatResponse({
    this.page,
    this.pageSize,
    this.totalCount,
    required this.results,
  });

  int? page;
  @JsonKey(name: 'page_size')
  int? pageSize;
  @JsonKey(name: 'total_count')
  int? totalCount;
  final List<ChatData> results;

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatResponseToJson(this);
}

@JsonSerializable()
class ChatData {
  ChatData({
    this.id,
    this.createdAt,
    this.lastMsgId,
    this.lastMsgTs,
    this.girlId,
    this.boyId,
    this.ualiId,
    this.status,
    this.girlNewMsgCount,
    this.boyNewMsgCount,
    this.ualiNewMsgCount,
    this.girl,
    this.boy,
    this.uali,
    this.lastMsg,
  });

  int? id;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'last_msg_id')
  String? lastMsgId;
  @JsonKey(name: 'last_msg_ts')
  DateTime? lastMsgTs;
  @JsonKey(name: 'girl_id')
  int? girlId;
  @JsonKey(name: 'boy_id')
  int? boyId;
  @JsonKey(name: 'uali_id')
  int? ualiId;
  String? status;
  @JsonKey(name: 'girl_new_msg_count')
  int? girlNewMsgCount;
  @JsonKey(name: 'boy_new_msg_count')
  int? boyNewMsgCount;
  @JsonKey(name: 'uali_new_msg_count')
  int? ualiNewMsgCount;
  User? girl;
  User? boy;
  User? uali;
  @JsonKey(name: 'last_msg')
  String? lastMsg;

  factory ChatData.fromJson(Map<String, dynamic> json) => _$ChatDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDataToJson(this);
}
