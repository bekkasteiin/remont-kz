// To parse this JSON data, do
//
//     final publicationReview = publicationReviewFromJson(jsonString);

import 'dart:convert';

import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';

PublicationReview publicationReviewFromJson(String str) => PublicationReview.fromJson(json.decode(str));

String publicationReviewToJson(PublicationReview data) => json.encode(data.toJson());

class PublicationReview {
  List<Comment> comments;
  int commentsSize;
  List<CategoryElement> categories;
  List<Rating> ratings;

  PublicationReview({
    required this.comments,
    required this.commentsSize,
    required this.categories,
    required this.ratings,
  });

  factory PublicationReview.fromJson(Map<String, dynamic> json) => PublicationReview(
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    commentsSize: json["commentsSize"],
    categories: List<CategoryElement>.from(json["categories"].map((x) => CategoryElement.fromJson(x))),
    ratings: List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
    "commentsSize": commentsSize,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "ratings": List<dynamic>.from(ratings.map((x) => x.toJson())),
  };
}

class CategoryElement {
  CategoryCategory? category;
  int? countComments;

  CategoryElement({
     this.category,
     this.countComments,
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) => CategoryElement(
    category: CategoryCategory.fromJson(json["category"]),
    countComments: json["countComments"],
  );

  Map<String, dynamic> toJson() => {
    "category": category?.toJson(),
    "countComments": countComments,
  };
}

class CategoryCategory {
  int id;
  String name;
  dynamic description;

  CategoryCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CategoryCategory.fromJson(Map<String, dynamic> json) => CategoryCategory(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}

class Comment {
  int id;
  String feedback;
  int rating;
  String category;
  DateTime createdDate;
  String authorFullName;
  List<FileDescriptor> files;

  Comment({
    required this.id,
    required this.feedback,
    required this.rating,
    required this.category,
    required this.createdDate,
    required this.authorFullName,
    required this.files,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
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
    "createdDate": createdDate.toIso8601String(),
    "authorFullName": authorFullName,
    "files": List<dynamic>.from(files.map((x) => x.toJson())),
  };
}

class Rating {
  int id;
  String description;
  int count;

  Rating({
    required this.id,
    required this.description,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    id: json["id"],
    description: json["description"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "count": count,
  };
}
