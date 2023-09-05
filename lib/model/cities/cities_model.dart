// To parse this JSON data, do
//
//     final cities = citiesFromJson(jsonString);

import 'dart:convert';



class CitiesModel {
  int? id;
  String? name;
  String? code;

  CitiesModel({
     this.id,
     this.name,
     this.code,
  });

  factory CitiesModel.fromJson(String str) => CitiesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CitiesModel.fromMap(Map<String, dynamic> json) => CitiesModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "code": code,
  };
  Map<String, dynamic> toMapId() => {'id': id ?? ''};
}
