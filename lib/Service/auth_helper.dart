import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whispr_chat_application/Model/user_model.dart';

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
      final userDoc = await _firestore.collection('Users').doc(user.uid).get();

      String defaultPhotoUrl =
          'https://img.freepik.com/premium-vector/round-gray-circle-with-simple-human-silhouette-light-gray-shadow-around-circle_213497-4963.jpg';

      String name =
          user.displayName ?? user.email?.split('@')[0] ?? 'Unknown User';

      Map<String, dynamic> userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': name,
        'photoURL': user.photoURL ?? defaultPhotoUrl,
        'name': name,
        'profilePictureUrl': user.photoURL ?? defaultPhotoUrl,
        'initials': name.isNotEmpty ? name[0].toUpperCase() : '',
        'isOnline': true,
        'lastLogin': FieldValue.serverTimestamp(),
      };
      if (!userDoc.exists) {
        userData['createdAt'] = FieldValue.serverTimestamp();
      }
      await _firestore.collection('Users').doc(user.uid).set(
            userData,
            SetOptions(merge: true),
          );
    } catch (e) {
      log("Error creating/updating user document: $e");
      throw Exception("Failed to create/update user document: $e");
    }
  }

  // Fetch all users as a stream
  Stream<List<UserModel>> getAllUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromJson(
          doc.data(),
          docId: doc.id,
        );
      }).toList();
    });
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) throw Exception("Please provide an email address.");
    await _auth.sendPasswordResetEmail(email: email);
  }
}
