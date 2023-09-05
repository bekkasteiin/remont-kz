// To parse this JSON data, do
//
//     final publicationModel = publicationModelFromJson(jsonString);

import 'dart:convert';

import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';

List<PublicationModel> publicationModelFromJson(String str) => List<PublicationModel>.from(json.decode(str).map((x) => PublicationModel.fromJson(x)));

String publicationModelToJson(List<PublicationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PublicationModel {
  int id;
  int categoryId;
  String address;
  String title;
  String description;
  double price;
  bool isContractual;
  String status;
  dynamic category;
  String city;
  User user;
  List<FileDescriptor> files;
  bool favourite;

  PublicationModel({
    required this.id,
    required this.categoryId,
    required this.address,
    required this.title,
    required this.description,
    required this.price,
    required this.isContractual,
    required this.status,
    this.category,
    required this.city,
    required this.user,
    required this.files,
    required this.favourite
  });

  factory PublicationModel.fromJson(Map<String, dynamic> json) => PublicationModel(
    id: json["id"],
    categoryId: json["categoryId"],
    address: json["address"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    isContractual: json["isContractual"],
    status: json["status"],
    category: json["category"],
    city: json["city"],
    favourite: json["favourite"],
    user: User.fromJson(json["user"]),
    files: List<FileDescriptor>.from(json["files"].map((x) => FileDescriptor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryId": categoryId,
    "address": address,
    "title": title,
    "description": description,
    "price": price,
    "isContractual": isContractual,
    "status": status,
    "category": category,
    "city": city,
    "favourite": favourite,
    "user": user.toJson(),
    "files": List<dynamic>.from(files.map((x) => x.toJson())),
  };
}


class User {
  String fullName;
  String? username;

  User({
    required this.fullName,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    fullName: json["fullName"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "username": username,
  };
}
