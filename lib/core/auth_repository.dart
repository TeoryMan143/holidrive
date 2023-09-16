import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holidrive/features/Authentication/models/user_model.dart';
import 'package:holidrive/features/Authentication/presentation/sign_in.dart';
import 'package:holidrive/features/Authentication/presentation/user_dev.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;

  void _init(User? user) {
    if (user == null) {
      Get.offAll(() => const SignInScreen());
    } else {
      Get.to(() => const UserDev());
    }
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _init);
  }

  Future<void> createUserWithEmailAndPassword(
    String fullName,
    String email,
    String password,
    int number,
  ) async {
    try {
      final user = UserModel(
        uid: firebaseUser.value!.uid,
        fullName: fullName,
        email: email,
        password: password,
        number: number,
        firebaseUser: firebaseUser.value,
      );
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _store.collection('Users').add(
            user.toJson(),
          );

      user.firebaseUser == null
          ? Get.offAll(() => const SignInScreen())
          : Get.offAll(() => const UserDev());
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: 'FirebaseAuth expeption ${e.message}');
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: 'FirebaseFirestore expeption ${e.message}');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Expeption $e');
    }
  }

  Future<void> signInWithUserAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: 'FirebaseAuth expeption ${e.message}');
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }
}
