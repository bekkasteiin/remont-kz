import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';


part 'error_message.g.dart';

@JsonSerializable()

class ErrorMessage {
  const ErrorMessage({
    this.message,
    this.code,
  });

  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'code')
  final String? code;

  factory ErrorMessage.fromJson(Map<String, dynamic> json) => _$ErrorMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);

  String serialize() => json.encode(toJson());

  static ErrorMessage deserialize(String source) => ErrorMessage.fromJson(json.decode(source));
}
