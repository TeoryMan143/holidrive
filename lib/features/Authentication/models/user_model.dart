import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holidrive/core/auth_repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String fullName, email, uid;
  final int? number;
  final bool mod;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final User? firebaseUser;

  UserModel({
    required this.fullName,
    required this.email,
    this.mod = false,
    this.firebaseUser,
    this.number,
    required this.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    return UserModel(
      firebaseUser: AuthRepository.instance.firebaseUser.value,
      fullName: data['fullName'],
      email: data['email'],
      number: data['number'],
      uid: data['uid'],
    );
  }
}
