// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';


class CategoryModel {
  int id;
  String name;
  List<CategoryElement> categories;

  CategoryModel({
    required this.id,
    required this.name,
    required this.categories,
  });

  factory CategoryModel.fromJson(String str) => CategoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    categories: List<CategoryElement>.from(json["categories"].map((x) => CategoryElement.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "categories": List<dynamic>.from(categories.map((x) => x.toMap())),
  };
}

class CategoryElement {
  int id;
  String name;
  dynamic description;

  CategoryElement({
    required this.id,
    required this.name,
    this.description,
  });

  factory CategoryElement.fromMap(Map<String, dynamic> json) => CategoryElement(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
  };
  Map<String, dynamic> toMapId() => {'id': id ?? ''};
}
