import 'dart:convert';

ErrorDescriptionModel errorDescriptionFromJson(String str) => ErrorDescriptionModel.fromJson(json.decode(str));

String errorDescriptionToJson(ErrorDescriptionModel data) => json.encode(data.toJson());

class ErrorDescriptionModel {
  String message;
  String code;

  ErrorDescriptionModel({
    required this.message,
    required this.code,
  });

  factory ErrorDescriptionModel.fromJson(Map<String, dynamic> json) => ErrorDescriptionModel(
    message: json["message"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "code": code,
  };
}
