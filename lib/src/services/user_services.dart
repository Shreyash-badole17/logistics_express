import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logistics_express/src/models/user_auth_model.dart';
import '../models/user_model.dart';

class UserServices {
  final _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> createUser(UserModel user) async {
    await _fireStore.collection("users").add(user.toMap());
  }

  Future<void> createAuthUser(UserAuthModel user) async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _fireStore.collection("user_auth").doc(currentUser.uid).set(
            user.toMap(),
          );
    } else {
      throw Exception("No authenticated user found.");
    }
  }
}
