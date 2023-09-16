// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      mod: json['mod'] as bool? ?? false,
      number: json['number'] as int,
      password: json['password'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'password': instance.password,
      'uid': instance.uid,
      'number': instance.number,
      'mod': instance.mod,
    };
