import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var user = Rxn<User>();
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    ever(user, _loadUserData);
  }


  Future<void> _loadUserData(User? firebaseUser) async {
    if (firebaseUser != null) {
      final doc = await _firestore.collection("users").doc(firebaseUser.uid).get();
      if (doc.exists) {
        userData.value = doc.data() ?? {};
      }
    } else {
      userData.value = {};
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

    } catch (e) {
      Get.snackbar('Login Error', e.toString());
      throw e;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      await _firestore.collection("users").doc(cred.user!.uid).set({
        "email": email,

        "name": "No Name",
      });

  
      await _loadUserData(cred.user);
    } catch (e) {
      Get.snackbar('Registration Error', e.toString());
      throw e;
    }
  }

  Future<void> updateDisplayName(String name) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await currentUser.updateDisplayName(name);
      await currentUser.reload();
      user.value = _auth.currentUser;
    }


    if (currentUser != null) {
      await _firestore.collection("users").doc(currentUser.uid).update({
        "name": name,
      });
      await _loadUserData(currentUser);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
