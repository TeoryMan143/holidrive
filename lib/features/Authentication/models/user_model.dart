import 'package:firebase_auth/firebase_auth.dart';
import 'package:holidrive/core/controllers/auth_repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String fullName, email, uid;
  final String? profilePicture;
  final bool mod;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final User? firebaseUser = AuthRepository.instance.firebaseUser;

  UserModel({
    required this.fullName,
    required this.email,
    this.mod = false,
    required this.uid,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
