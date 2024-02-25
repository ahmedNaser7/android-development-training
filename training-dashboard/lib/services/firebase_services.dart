import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:training_questions_form/models/resources.dart';
import 'package:training_questions_form/models/status.dart';
import 'package:training_questions_form/screens/sessions/model/session_model.dart';

class FirebaseServices {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  static final FirebaseServices _instance = FirebaseServices._internal();

  FirebaseServices._internal();

  factory FirebaseServices() {
    return _instance;
  }

  User? getCurrentUserData() {
    return auth.currentUser;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<Resource<UserCredential>> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return Resource(Status.SUCCESS, data: userCredential);
    } catch (e) {
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }

  Future<Resource<UserCredential>> loginWithGoogle() async {
    try {
      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await auth.signInWithPopup(googleProvider);
      return Resource(Status.SUCCESS, data: userCredential);
    } catch (e) {
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }
  
  Future<Resource<List<SessionModel>>> getSessions()async{
    try{
      final result = await  db.collection('trainingQuestionsFormApp').doc("trainingQuestionsForm").collection('sessions').get();
      final sessions = result.docs.map((e) => SessionModel.fromJson(e.data())).toList();
      return Resource(Status.SUCCESS, data: sessions);
    }catch(e){
      return Resource(Status.ERROR, errorMessage: e.toString());
    }
  }
}
