import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'upload_image.g.dart';

@JsonSerializable()
class UploadImage {
  const UploadImage({
    this.path,
  });

  @JsonKey(name: 'path')
  final String? path;

  factory UploadImage.fromJson(Map<String, dynamic> json) => _$UploadImageFromJson(json);

  Map<String, dynamic> toJson() => _$UploadImageToJson(this);

  String serialize() => json.encode(toJson());

  static UploadImage deserialize(String source) => UploadImage.fromJson(json.decode(source));
}
