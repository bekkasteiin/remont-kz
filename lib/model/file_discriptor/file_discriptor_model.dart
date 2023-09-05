// To parse this JSON data, do
//
//     final fileDescriptor = fileDescriptorFromJson(jsonString);

import 'dart:convert';

FileDescriptor fileDescriptorFromJson(String str) => FileDescriptor.fromJson(json.decode(str));

String fileDescriptorToJson(FileDescriptor data) => json.encode(data.toJson());

class FileDescriptor {
  dynamic id;
  String url;
  String name;
  String type;
  bool isMain;

  FileDescriptor({
    this.id,
    required this.url,
    required this.name,
    required this.type,
    required this.isMain,
  });

  factory FileDescriptor.fromJson(Map<String, dynamic> json) => FileDescriptor(
    id: json["id"],
    url: json["url"],
    name: json["name"],
    type: json["type"],
    isMain: json["isMain"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "name": name,
    "type": type,
    "isMain": isMain,
  };
}
