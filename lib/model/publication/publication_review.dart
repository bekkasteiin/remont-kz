import 'dart:convert';

import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';

class PublicationReview {
  int? id;
  String? feedback;
  int? rating;
  String? category;
  DateTime? createdDate;
  String? authorFullName;
  List<FileDescriptor> files;

  PublicationReview({
     this.id,
     this.feedback,
     this.rating,
     this.category,
     this.createdDate,
     this.authorFullName,
     required this.files,
  });

  PublicationReview uploadPublicationFromJson(String str) => PublicationReview.fromJson(json.decode(str));

  String uploadPublicationToJson(PublicationReview data) => json.encode(data.toJson());

  factory PublicationReview.fromJson(Map<String, dynamic> json) => PublicationReview(
    id: json["id"],
    feedback: json["feedback"],
    rating: json["rating"],
    category: json["category"],
    createdDate: DateTime.parse(json["createdDate"]),
    authorFullName: json["authorFullName"],
    files: List<FileDescriptor>.from(json["files"].map((x) => FileDescriptor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "feedback": feedback,
    "rating": rating,
    "category": category,
    "createdDate": createdDate?.toIso8601String(),
    "authorFullName": authorFullName,
    "files": List<dynamic>.from(files.map((x) => x.toJson())),
  };
}