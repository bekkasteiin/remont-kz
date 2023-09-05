// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['created_at'] as String?,
      dataComplete: json['data_complete'] as bool?,
      termsAgree: json['terms_agree'] as bool?,
      height: json['height'] as int?,
      gender: json['gender'] as int?,
      ava: json['ava'] as String?,
      birthDate: json['birth_date'] as String?,
      blurPhotos: json['blur_photos'] as bool?,
      eyeColor: json['eye_color'] as String?,
      hairColor: json['hair_color'] as String?,
      hobbies:
          (json['hobbies'] as List<dynamic>?)?.map((e) => e as String).toList(),
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      weight: json['weight'] as int?,
      about: json['about_me'] as String?,
      familyStatus: json['family_status'] as int?,
      cityId: json['city_id'] as int?,
      marriagePeriod: json['marriage_period'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'phone': instance.phone,
      'ava': instance.ava,
      'name': instance.name,
      'about_me': instance.about,
      'data_complete': instance.dataComplete,
      'terms_agree': instance.termsAgree,
      'gender': instance.gender,
      'birth_date': instance.birthDate,
      'hobbies': instance.hobbies,
      'height': instance.height,
      'weight': instance.weight,
      'hair_color': instance.hairColor,
      'eye_color': instance.eyeColor,
      'photos': instance.photos,
      'blur_photos': instance.blurPhotos,
      'family_status': instance.familyStatus,
      'city_id': instance.cityId,
      'marriage_period': instance.marriagePeriod,
    };
