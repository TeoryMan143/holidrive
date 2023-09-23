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
  final _db = FirebaseFirestore.instance;

  late Rx<User?> _firebaseUser;
  User? get firebaseUser => _firebaseUser.value;

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    if (_firebaseUser.value == null) {
      Get.offAll(() => const SignInScreen());
    } else {
      Get.to(() => const UserDev());
    }
    super.onReady();
  }

  Future<void> createUserWithEmailAndPassword(
    String fullName,
    String email,
    String password,
    int number,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = UserModel(
        uid: _firebaseUser.value!.uid,
        fullName: fullName,
        email: email,
        number: number,
      );
      await _store.collection('Users').add(user.toJson());
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
      );

      final query = await _db
          .collection('Users')
          .where(
            'uid',
            isEqualTo: _firebaseUser.value?.uid,
          )
          .get();
      final userData =
          query.docs.map((e) => UserModel.fromJson(e.data())).singleOrNull;

      if (userData == null) {
        await _store.collection('Users').add(user.toJson());
      }
    } catch (e) {
      print('FirebaseAuth expeption $e');
    }
  }
}
