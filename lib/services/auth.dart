import 'package:firebase_auth/firebase_auth.dart';
import 'package:Unify/models/user.dart';
import 'package:Unify/services/database.dart';

String uid = "";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user local unique id from user object
  User userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //  auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        // .map((FirebaseUser user) => _userFromFirebase(user));
        .map(userFromFirebase);
  }

  // sign in with email/pass
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      uid = userFromFirebase(user).uid;
      return userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
// call the method to update database from the databaseService class in database.dart
// this is whr u set up that sensor tag automatically

      await DatabaseService(uid: userFromFirebase(user).uid).setUPuser();
      uid = userFromFirebase(user).uid;
      return userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //forget password
  Future forgetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return 1;
    }
  }
}
