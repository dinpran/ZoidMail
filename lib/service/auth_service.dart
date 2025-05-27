import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zoidmail/helper/helper_functions.dart';
import 'package:zoidmail/service/database_service.dart';

class AuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future login(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        QuerySnapshot snapshot =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .getuserdata(email);
        await HelperFunctions.setuserloggedinstatus(true);
        await HelperFunctions.setemailkeysf(email);
        await HelperFunctions.setusernamesf(snapshot.docs[0]["fullName"]);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future register(String email, String password, String fullname) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        await DatabaseService(uid: user.uid).updateUser(fullname, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signout() async {
    await HelperFunctions.setuserloggedinstatus(false);
    await HelperFunctions.setemailkeysf("");
    await HelperFunctions.setusernamesf("");
    await firebaseAuth.signOut();
  }
}
