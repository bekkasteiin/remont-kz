// To parse this JSON data, do
//
//     final uploadPublication = uploadPublicationFromJson(jsonString);

import 'dart:convert';

import 'package:remont_kz/model/category/category_model.dart';
import 'package:remont_kz/model/cities/cities_model.dart';
import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';






class EditTask {
  String? address;
  int? categoryId;
  int? cityId;
  String? description;
  List<FileDescriptor> files;
  int? id;
  bool? isContractual;
  int? price;
  String? status;
  String? title;
  String? workTime;

  EditTask({
    this.address,
    this.categoryId,
    this.cityId,
    this.description,
    required this.files,
    this.id,
    this.isContractual,
    this.price,
    this.status,
    this.title,
    this.workTime,
  });

  factory EditTask.fromJson(Map<String, dynamic> json) => EditTask(
    address: json["address"],
    categoryId: json["categoryId"],
    cityId: json["cityId"],
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
    "categoryId": categoryId,
    "cityId": cityId,
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
    'categoryId': categoryId,
    'cityId': cityId,
    'description': description,
    'files': files == null
        ? null
        : List<dynamic>.from(files.map((x) => x.toJson())),
    'isContractual': isContractual ?? false,
    'price': price ?? '',
    'status': status ?? '',
    'title': title ?? '',
    'address': address ?? '',
    'workTime': workTime ?? ''
  };
}