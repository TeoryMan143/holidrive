import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/controllers/auth_repository.dart';
import 'package:holidrive/features/Authentication/models/user_model.dart';
import 'package:holidrive/features/Authentication/presentation/sign_in.dart';
import 'package:holidrive/features/Map/presentation/map_screen.dart';

class AuthController extends GetxController {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confrimPassword = TextEditingController();
  final number = TextEditingController();

  final _db = FirebaseFirestore.instance;
  final _auth = AuthRepository.instance;
  final _fbInst = FirebaseAuth.instance;

  Rx<UserModel?>? _user;
  UserModel? get user => _user != null ? _user!.value : null;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  Future<void> onReady() async {
    super.onReady();
    disposeControllers();
    await getUserData();
  }

  Future<void> getUserData({bool navigate = false}) async {
    _isLoading(true);
    if (_auth.firebaseUser != null) {
      final query = await _db
          .collection('Users')
          .where(
            'uid',
            isEqualTo: _auth.firebaseUser?.uid,
          )
          .get();
      final userData =
          query.docs.map((e) => UserModel.fromJson(e.data())).singleOrNull;
      _user = Rx<UserModel?>(userData);
      if (navigate) {
        Get.offAll(() => MapScreen());
      }
    }
    _isLoading(false);
  }

  void registerUserLocal({
    required String fullName,
    required String email,
    required String password,
    required int number,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      fullName,
      email,
      password,
      number,
    );
    await getUserData(navigate: true);
  }

  void logInUserLocal(String email, String password) async {
    await _auth.signInWithUserAndPassword(email, password);
    await getUserData(navigate: true);
  }

  void disposeControllers() {
    name.text = '';
    email.text = '';
    password.text = '';
    confrimPassword.text = '';
    number.text = '';
  }

  void signInWithGoogle() async {
    await _auth.signInWithGoogle();
    await getUserData(navigate: true);
  }

  void logOut() {
    Get.offAll(() => const SignInScreen());
    _user = Rx<UserModel?>(null);
    _fbInst.signOut();
  }
}
