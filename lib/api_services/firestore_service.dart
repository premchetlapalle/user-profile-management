import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../utils/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Create new user profile
  Future<void> createUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection(usersCollection).doc(uid).set(data);
  }

  // Update existing user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection(usersCollection).doc(uid).update(data);
  }

  // Get user profile document
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(String uid) async {
    return await _firestore.collection(usersCollection).doc(uid).get();
  }

  // Upload image to Firebase Storage and get download URL
  Future<String> uploadProfileImage(String uid, File imageFile) async {
    final ref = _storage.ref().child('profile_images/$uid.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // Stream of all users
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return _firestore.collection(usersCollection).snapshots();
  }

  // Get single user document
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String userId) {
    return _firestore.collection(usersCollection).doc(userId).get();
  }
}
