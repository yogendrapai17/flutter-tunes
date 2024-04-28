import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  /// Private constructor
  FirebaseService._();

  /// Creating singleton
  static final instance = FirebaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Read a document from a collection
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
      {required String collectionPath, required String documentId}) async {
    final docRef = _firestore.collection(collectionPath).doc(documentId);
    final snapshot = await docRef.get();
    return snapshot;
  }

  // Query a document from a collection with a field name
  Future<QuerySnapshot<Map<String, dynamic>>?> getDocumentsByField(
      {required String collectionPath,
      required String fieldName,
      required String value}) async {
    final docRef = _firestore
        .collection(collectionPath)
        .where(fieldName, isEqualTo: value);
    final snapshot = await docRef.get();
    return snapshot;
  }

  // Get all documents from a collection
  Future<QuerySnapshot<Map<String, dynamic>>> getDocuments(
      String collectionPath) async {
    final collectionRef = _firestore.collection(collectionPath);
    final snapshot = await collectionRef.get();
    return snapshot;
  }

  // Create a new document
  Future<void> createDocument(
      {required String collectionPath,
      required String documentId,
      required Map<String, dynamic> data}) async {
    final docRef = _firestore.collection(collectionPath).doc(documentId);
    await docRef.set(data);
  }

  // Update a document
  Future<bool> updateDocument(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    try {
      final docRef = _firestore.collection(collectionPath).doc(documentId);
      await docRef.update(data);
      return true;
    } on FirebaseException catch (e) {
      // Caught an exception from Firebase.
      debugPrint("Firebase error: '${e.code}': ${e.message}");
    } catch (e) {
      debugPrint('Update Doc Error: ${e.toString()}');
    }
    // Return false on SocketException or any firebase error.
    return false;
  }

  // Delete a document
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    final docRef = _firestore.collection(collectionPath).doc(documentId);
    await docRef.delete();
  }
}
