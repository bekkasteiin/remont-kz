// To parse this JSON data, do
//
//     final uploadPublication = uploadPublicationFromJson(jsonString);

import 'dart:convert';

import 'package:remont_kz/model/category/category_model.dart';
import 'package:remont_kz/model/cities/cities_model.dart';
import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';

UploadPublication uploadPublicationFromJson(String str) => UploadPublication.fromJson(json.decode(str));

String uploadPublicationToJson(UploadPublication data) => json.encode(data.toJson());

class UploadPublication {
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

  UploadPublication({
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
  });

  factory UploadPublication.fromJson(Map<String, dynamic> json) => UploadPublication(
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
    'price': price ?? '',
    'status': status ?? '',
    'title': title ?? '',
    'address': address ?? ''
  };
}





class EditPublication {
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

  EditPublication({
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
  });

  factory EditPublication.fromJson(Map<String, dynamic> json) => EditPublication(
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
    'address': address ?? ''
  };
}