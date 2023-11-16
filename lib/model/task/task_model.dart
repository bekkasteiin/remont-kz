// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';

List<TaskModel> publicationModelFromJson(String str) => List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

String publicationModelToJson(List<TaskModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskModel {
  int id;
  String address;
  String title;
  String description;
  double price;
  bool isContractual;
  bool openRequest;
  String status;
  dynamic category;
  int categoryId;
  String city;
  String workTime;
  UserFullName user;
  List<FileDescriptor> files;
  bool favourite;

  TaskModel({
    required this.id,
    required this.address,
    required this.title,
    required this.description,
    required this.price,
    required this.isContractual,
    required this.openRequest,
    required this.status,
    this.category,
    required this.city,
    required this.categoryId,
    required this.user,
    required this.workTime,
    required this.files,
    required this.favourite
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json["id"],
    address: json["address"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    isContractual: json["isContractual"],
    openRequest: json["openRequest"],
    status: json["status"],
    category: json["category"] ?? '',
    city: json["city"],
    workTime: json["workTime"],
    favourite: json["favourite"],
    categoryId: json["categoryId"],
    user: UserFullName.fromJson(json["user"]),
    files: List<FileDescriptor>.from(json["files"].map((x) => FileDescriptor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "title": title,
    "description": description,
    "price": price,
    "isContractual": isContractual,
    "openRequest": openRequest,
    "status": status,
    "category": category,
    "city": city,
    "favourite": favourite,
    "categoryId": categoryId,
    "workTime": workTime,
    "user": user.toJson(),
    "files": List<dynamic>.from(files.map((x) => x.toJson())),
  };
}


class UserFullName {
  String fullName;
  String username;

  UserFullName({
    required this.fullName,
    required this.username,
  });

  factory UserFullName.fromJson(Map<String, dynamic> json) => UserFullName(
    fullName: json["fullName"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "username": username,
  };
}
