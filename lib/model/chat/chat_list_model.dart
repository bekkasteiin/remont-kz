// To parse this JSON data, do
//
//     final chatList = chatListFromJson(jsonString);

import 'dart:convert';


List<ChatList> chatListFromJson(String str) => List<ChatList>.from(json.decode(str).map((x) => ChatList.fromJson(x)));

String chatListToJson(List<ChatList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatList {
  int? id;
  String? lastMessage;
  bool? fromMe;
  bool? isRead;
  int? countOfNewMessages;
  String? time;
  String? userFullName;
  String? photoUrl;
  String? username;
  String? status;
  String? type;
  int? typeId;

  ChatList({
    this.id,
    this.lastMessage,
    this.fromMe,
    this.isRead,
    this.countOfNewMessages,
    this.time,
    this.userFullName,
    this.photoUrl,
    this.username,
    this.status,
    this.type,
    this.typeId
  });

  factory ChatList.fromJson(Map<String, dynamic> json) => ChatList(
    id: json["id"],
    lastMessage: json["lastMessage"],
    fromMe: json["fromMe"],
    isRead: json["isRead"],
    countOfNewMessages: json["countOfNewMessages"],
    time:json["time"],
    userFullName: json["userFullName"],
    username: json["username"],
    photoUrl: json["photoUrl"],
    status: json["status"],
    type: json["type"],
    typeId: json["typeId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lastMessage": lastMessage,
    "fromMe": fromMe,
    "isRead": isRead,
    "countOfNewMessages": countOfNewMessages,
    "time": time,
    "userFullName": userFullName,
    "username": username,
    "photoUrl": photoUrl,
    "status": status,
    "typeId": typeId,
    "type": type,
  };
}
