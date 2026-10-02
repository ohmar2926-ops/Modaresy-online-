
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await _db.collection('users').doc(credential.user!.uid).set({
      'name': name.trim(),
      'email': email.trim(),
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return credential;
  }

  Future<UserCredential> login(String email, String password) =>
      _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password);

  Future<void> logout() => _auth.signOut();

  Stream<User?> get authState => _auth.authStateChanges();

  Future<DocumentSnapshot<Map<String, dynamic>>> profile(String uid) =>
      _db.collection('users').doc(uid).get();
}
