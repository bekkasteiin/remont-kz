// To parse this JSON data, do
//
//     final getProfile = getProfileFromJson(jsonString);

import 'dart:convert';

GetProfile getProfileFromJson(String str) => GetProfile.fromJson(json.decode(str));

String getProfileToJson(GetProfile data) => json.encode(data.toJson());

class GetProfile {
  int? id;
  String? username;
  String? keycloakId;
  String? name;
  String? lastname;
  dynamic photoUrl;
  bool? isClient;
  String? email;
  String? address;
  String? aboutMe;
  String? cityDto;
  DateTime? createdDate;

  GetProfile({
    this.id,
    this.username,
    this.keycloakId,
    this.name,
    this.lastname,
    this.photoUrl,
    this.isClient,
    this.email,
    this.address,
    this.aboutMe,
    this.cityDto,
    this.createdDate,
  });

  factory GetProfile.fromJson(Map<String, dynamic> json) => GetProfile(
    id: json["id"],
    username: json["username"],
    keycloakId: json["keycloakId"],
    name: json["name"],
    lastname: json["lastname"],
    photoUrl: json["photoUrl"],
    isClient: json["isClient"],
    email: json["email"],
    address: json["address"],
    aboutMe: json["aboutMe"],
    cityDto: json["cityDto"],
    createdDate: DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "keycloakId": keycloakId,
    "name": name,
    "lastname": lastname,
    "photoUrl": photoUrl,
    "isClient": isClient,
    "email": email,
    "address": address,
    "aboutMe": aboutMe,
    "cityDto": cityDto,
    "createdDate": createdDate?.toIso8601String(),
  };
}
