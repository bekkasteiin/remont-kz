import 'package:json_annotation/json_annotation.dart';

part 'msg_response.g.dart';

@JsonSerializable()
class MsgResponse {
  MsgResponse({
    this.page,
    this.pageSize,
    this.totalCount,
    this.results,
  });

  int? page;
  @JsonKey(name: 'page_size')
  int? pageSize;
  @JsonKey(name: 'total_count')
  int? totalCount;
  List<Massage>? results;

  factory MsgResponse.fromJson(Map<String, dynamic> json) =>
      _$MsgResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MsgResponseToJson(this);
}

@JsonSerializable()
class Massage {
  Massage({
    this.id,
    this.ts,
    this.tp,
    this.content,
    this.chatId,
    this.usrId,
    this.toUsrId,
    this.toMsgId,
  });

  String? id;
  DateTime? ts;
  int? tp;
  String? content;
  @JsonKey(name: 'chat_id')
  int? chatId;
  @JsonKey(name: 'usr_id')
  int? usrId;
  @JsonKey(name: 'to_usr_id')
  int? toUsrId;
  @JsonKey(name: 'to_msg_id')
  String? toMsgId;

  factory Massage.fromJson(Map<String, dynamic> json) =>
      _$MassageFromJson(json);

  Map<String, dynamic> toJson() => _$MassageToJson(this);
}
