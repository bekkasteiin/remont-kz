// To parse this JSON data, do
//
//     final uploadPublication = uploadPublicationFromJson(jsonString);

import 'dart:convert';

import 'package:remont_kz/model/category/category_model.dart';
import 'package:remont_kz/model/cities/cities_model.dart';
import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';

TaskPublication uploadPublicationFromJson(String str) => TaskPublication.fromJson(json.decode(str));

String uploadPublicationToJson(TaskPublication data) => json.encode(data.toJson());

class TaskPublication {
  String? address;
  CategoryElement? category;
  CitiesModel? city;
  String? description;
  List<FileDescriptor> files;
  int? id;
  bool? isContractual;
  int? price;
  String? status;
  String? title;
  String? workTime;

  TaskPublication({
    this.address,
    this.category,
    this.city,
    this.description,
    required this.files,
    this.id,
    this.isContractual,
    this.price,
    this.status,
    this.title,
    this.workTime,
  });

  factory TaskPublication.fromJson(Map<String, dynamic> json) => TaskPublication(
    address: json["address"],
    category: json["category"] == null
        ? null
        : CategoryElement.fromMap(json["category"]),
    city:json["city"] == null
        ? null
        : CitiesModel.fromMap(json["city"]),
    description: json["description"],
    files: List<FileDescriptor>.from(json["files"].map((x) => FileDescriptor.fromJson(x))),
    id: json["id"],
    isContractual: json["isContractual"],
    price: json["price"],
    status: json["status"],
    title: json["title"],
    workTime: json["workTime"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "category": category?.toMap(),
    "city": city?.toMap(),
    "description": description,
    "files": List<dynamic>.from(files.map((x) => x.toJson())),
    "id": id,
    "isContractual": isContractual,
    "price": price,
    "status": status,
    "title": title,
    "workTime": workTime,
  };

  Map<String, dynamic> toMapCreate() => {
    'id': id ?? null,
    'categoryId': category?.id,
    'cityId': city?.id,
    'description': description,
    'files': files == null
        ? null
        : List<dynamic>.from(files.map((x) => x.toJson())),
    'isContractual': isContractual ?? false,
    'price': price ?? 0,
    'status': status ?? '',
    'title': title ?? '',
    'address': address ?? '',
    'workTime': workTime ?? ''
  };
}


class TaskComment {

  String? feedback;
  String? executorUsername;
  List<FileDescriptor>? files;
  int? categoryId;
  int? rating;
  int? chatRoomId;

  TaskComment({

    this.feedback,
    this.executorUsername,
    this.files,
    this.categoryId,
    this.rating,
    this.chatRoomId,
  });

  factory TaskComment.fromJson(Map<String, dynamic> json) => TaskComment(
    feedback: json["feedback"],
    executorUsername: json["executorUsername"],
    files: List<FileDescriptor>.from(json["files"].map((x) => FileDescriptor.fromJson(x))),
    categoryId: json["categoryId"],
    rating: json["rating"],
    chatRoomId: json["chatRoomId"],
  );

  Map<String, dynamic> toJson() => {
    "feedback": feedback,
    "categoryId": categoryId,
    "executorUsername": executorUsername,
    "files": List<dynamic>.from(files!.map((x) => x.toJson())),
    "rating": rating,
    "chatRoomId": chatRoomId,
  };

  Map<String, dynamic> toMapCreate() => {
    "feedback": feedback,
    "files": List<dynamic>.from(files!.map((x) => x.toJson())),
    "rating": rating,
    "executorUsername": executorUsername,
    "categoryId": categoryId,
    "chatRoomId": chatRoomId,
  };
}