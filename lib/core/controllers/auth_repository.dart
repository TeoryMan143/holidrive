import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holidrive/core/constants.dart';
import 'package:holidrive/features/Authentication/models/user_model.dart';
import 'package:holidrive/features/Authentication/presentation/email_verify.dart';
import 'package:holidrive/features/Authentication/presentation/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:holidrive/features/Authentication/widgets/error_dialog.dart';
import 'package:holidrive/features/Map/presentation/map_screen.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  final _db = FirebaseFirestore.instance;

  late Rx<User?> _firebaseUser;
  User? get firebaseUser => _firebaseUser.value;

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    if (_firebaseUser.value == null) {
      Get.offAll(() => const SignInScreen());
    } else if (!_firebaseUser.value!.emailVerified) {
      _firebaseUser.value!.sendEmailVerification();
      Get.off(() => const EmailVerifyScreen());
    } else {
      Get.offAll(() => const MapScreen());
    }
    super.onReady();
  }

  Future<void> createUserWithEmailAndPassword(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final userData = await getUserDataWithEmail(email);

      if (userData != null) {
        errorDialog(
          title: Messages.numberFoundTit.tr,
          body: Messages.numberFoundCont.tr,
        );
        return;
      }

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = UserModel(
        uid: _firebaseUser.value!.uid,
        fullName: fullName,
        email: email,
      );
      await _store.collection('Users').add(user.toJson());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorDialog(
          title: Messages.emailFoundTit.tr,
          body: Messages.emailFoundCont.tr,
        );
      } else if (e.code == 'weak-password') {
        errorDialog(
          title: Messages.weakPassTit.tr,
          body: Messages.weakPassCont.tr,
        );
      }
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
          msg: 'FirebaseFirestore expeption ${e.message}, ${e.code}');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Expeption $e');
    }
  }

  Future<void> signInWithUserAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorDialog(
          title: Messages.userNotFoundTit.tr,
          body: Messages.userNotFoundCont.tr,
        );
      } else if (e.code == 'wrong-password') {
        errorDialog(title: Messages.wrongPassTit.tr);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _auth.signInWithCredential(credential);

      final user = UserModel(
        uid: _firebaseUser.value!.uid,
        fullName: googleUser!.displayName!,
        email: googleUser.email,
        profilePicture: googleUser.photoUrl,
      );

      final userData = await getUserDataWithUid(_firebaseUser.value!.uid);

      if (userData == null) {
        await _store.collection('Users').add(user.toJson());
      }
    } on PlatformException catch (e) {
      debugPrint(
          'FirebaseAuth expeption code: ${e.code} message: ${e.message}');
    }
  }

  Future<UserModel?> getUserDataWithUid(String uid) async {
    final query = await _db
        .collection('Users')
        .where(
          'uid',
          isEqualTo: uid,
        )
        .get();
    final userData =
        query.docs.map((e) => UserModel.fromJson(e.data())).singleOrNull;
    return userData;
  }

  Future<UserModel?> getUserDataWithEmail(String email) async {
    final query = await _db
        .collection('Users')
        .where(
          'email',
          isEqualTo: email,
        )
        .get();
    final userData =
        query.docs.map((e) => UserModel.fromJson(e.data())).singleOrNull;
    return userData;
  }

  Future<void> updateUserData({
    required String field,
    required String value,
  }) async {
    final query = await _db
        .collection('Users')
        .where(
          'uid',
          isEqualTo: _auth.currentUser?.uid,
        )
        .get();
    final userQuery = query.docs.singleOrNull;
    final userData =
        userQuery == null ? null : UserModel.fromJson(userQuery.data());

    if (userData == null) {
      printError(info: 'User not found');
      return;
    }

    if (userData.email == value) {
      return;
    }

    userQuery!.reference.update({
      field: value,
    });
  }
}
