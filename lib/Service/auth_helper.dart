
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Sign in with Email & Password
  Future<UserCredential> signInWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await _createUserDocument(userCredential.user!);
      return userCredential;
    } catch (e) {
      throw Exception("Invalid email or password.");
    }
  }

  // Register with Email & Password
  Future<UserCredential> registerWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _createUserDocument(userCredential.user!);
      return userCredential;
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception("Google Sign-In canceled.");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      await _createUserDocument(userCredential.user!);
      return userCredential;
    } catch (e) {
      throw Exception("Google sign-in failed.");
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Create User Document in Firestore
  Future<void> _createUserDocument(User user) async {
    try {
      await _firestore.collection('Users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Failed to create user document.");
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) throw Exception("Please provide an email address.");
    await _auth.sendPasswordResetEmail(email: email);
  }
}
