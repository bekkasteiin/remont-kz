// To parse this JSON data, do
//
//     final chatRoom = chatRoomFromJson(jsonString);

import 'dart:convert';

List<ChatRoom> chatRoomFromJson(String str) => List<ChatRoom>.from(json.decode(str).map((x) => ChatRoom.fromJson(x)));

String chatRoomToJson(List<ChatRoom> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatRoom {
  int? id;
  String? executorUsername;
  String? clientUsername;
  String? senderUsername;
  String? recipientUsername;
  int? typeId;
  String? type;
  String? content;
  int? chatRoomId;
  DateTime? dateTime;
  String? status;
  bool? isSystemContent;

  ChatRoom({
    this.id,
    this.executorUsername,
    this.clientUsername,
    this.senderUsername,
    this.recipientUsername,
    this.typeId,
    this.type,
    this.content,
    this.chatRoomId,
    this.dateTime,
    this.status,
    this.isSystemContent,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
    id: json["id"],
    executorUsername: json["executorUsername"],
    clientUsername: json["clientUsername"],
    senderUsername: json["senderUsername"],
    recipientUsername: json["recipientUsername"],
    typeId: json["typeId"],
    type: json["type"],
    content: json["content"],
    chatRoomId: json["chatRoomId"],
    dateTime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
    status: json["status"],
    isSystemContent: json["isSystemContent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "executorUsername": executorUsername,
    "clientUsername": clientUsername,
    "senderUsername": senderUsername,
    "recipientUsername": recipientUsername,
    "typeId": typeId,
    "type": type,
    "content": content,
    "chatRoomId": chatRoomId,
    "dateTime": dateTime?.toIso8601String(),
    "status": status,
    "isSystemContent": isSystemContent,
  };
}
