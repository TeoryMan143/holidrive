import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/auth_repository.dart';
import 'package:holidrive/features/Authentication/models/user_model.dart';

class AuthController extends GetxController {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confrimPassword = TextEditingController();
  final number = TextEditingController();
  final _db = FirebaseFirestore.instance;

  late Rx<UserModel?>? user;

  @override
  void onReady() async {
    final query = await _db
        .collection('Users')
        .where(
          'uid',
          isEqualTo: AuthRepository.instance.firebaseUser.value?.uid,
        )
        .get();
    final userData =
        query.docs.map((e) => UserModel.fromSnapshot(e)).singleOrNull;
    user = Rx<UserModel?>(userData);
    super.onReady();
  }

  void registerUserLocal({
    required String fullName,
    required String email,
    required String password,
    required int number,
  }) {
    AuthRepository.instance
        .createUserWithEmailAndPassword(fullName, email, password, number);
  }

  void logInUserLocal(String email, String password) {
    AuthRepository.instance.signInWithUserAndPassword(email, password);
  }

  void disposeControllers() {
    name.text = '';
    email.text = '';
    password.text = '';
    confrimPassword.text = '';
    number.text = '';
  }

  void signInWithGoogle() async {
    await AuthRepository.instance.signInWithGoogle();
  }
}
