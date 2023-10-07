import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/core/controllers/auth_repository.dart';
import 'package:holidrive/features/Authentication/models/user_model.dart';
import 'package:holidrive/features/Authentication/presentation/email_verify.dart';
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

  static final instance = Get.find<AuthController>();

  Rx<UserModel?>? _user;
  UserModel? get user => _user != null ? _user!.value : null;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  Future<void> onReady() async {
    super.onReady();
    resetControllers();
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
        Get.offAll(() => const MapScreen());
      }
    }
    _isLoading(false);
  }

  Future<UserModel?> getUserDataFromId(String uid) async {
    await Future.delayed(Duration.zero); //*WTF???
    _isLoading(true);
    final query = await _db
        .collection('Users')
        .where(
          'uid',
          isEqualTo: uid,
        )
        .get();
    final userData =
        query.docs.map((e) => UserModel.fromJson(e.data())).singleOrNull;
    final userInfo = userData;
    update();
    disposeControllers();
    _isLoading(false);
    return userInfo;
  }

  void registerUserLocal({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      fullName,
      email,
      password,
    );
    await getUserData();
    if (!_user!.value!.firebaseUser!.emailVerified) {
      Get.off(() => const EmailVerifyScreen());
      disposeControllers();
      _user!.value!.firebaseUser!.sendEmailVerification();
    }
  }

  void logInUserLocal(String email, String password) async {
    await _auth.signInWithUserAndPassword(email, password);
    if (!_user!.value!.firebaseUser!.emailVerified) {
      Get.off(const EmailVerifyScreen());
      _user!.value!.firebaseUser!.sendEmailVerification();
      return;
    }
    await getUserData(navigate: true);
  }

  void resetControllers() {
    name.text = '';
    email.text = '';
    password.text = '';
    confrimPassword.text = '';
    number.text = '';
  }

  void disposeControllers() {
    FocusScope.of(Get.context!).unfocus();
    name.dispose();
    email.dispose();
    password.dispose();
    confrimPassword.dispose();
    number.dispose();
  }

  void updateField(String field, String value) async {
    Get.dialog(
      AlertDialog.adaptive(
        title: Text(
          Messages.areYouSure.tr,
          style: Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
                color: Theme.of(Get.context!).colorScheme.surface,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              final currentUser = _user!.value!.firebaseUser!;
              field == 'fullName'
                  ? await currentUser.updateDisplayName(value)
                  : await currentUser.updateEmail(value);
              await _auth.updateUserData(field: field, value: value);
              Get.back;
            },
            child: Text(Messages.confirm.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              return;
            },
            child: Text(Messages.cancel.tr),
          ),
        ],
      ),
    );
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
