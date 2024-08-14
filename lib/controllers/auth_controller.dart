import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<UserModel?> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel newUser = UserModel(
        uid: userCredential.user?.uid ?? '',
        name: name,
        email: email,
      );
      await _firestore
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.toMap());
      return newUser;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
