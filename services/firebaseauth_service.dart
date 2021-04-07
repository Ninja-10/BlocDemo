import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  // var _firebaseAuth = FirebaseAuth.instance;

  //TODO: refactor for error handling

  // User get user => _firebaseAuth.currentUser;

  User getUser() => FirebaseAuth.instance.currentUser;

  bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  Stream<User> get onAuthStateChanged =>
      FirebaseAuth.instance.authStateChanges();

  Future<UserCredential> logIn(String email, String password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future signOut() {
    return FirebaseAuth.instance.signOut();
  }

  Future sendEmailVerification() {
    return FirebaseAuth.instance.currentUser.sendEmailVerification();
  }

  //TODO: check if extra user variable is necessory
  Future<bool> isEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser.reload();
      var user = FirebaseAuth.instance.currentUser;
      return user.emailVerified;
    } catch (e) {
      return e;
    }
  }

  Future requestPasswordReset(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> reAuthUser(String password) async {
    return getUser().reauthenticateWithCredential(EmailAuthProvider.credential(
        email: getUser().email, password: password));
  }

  Future updateUserEmail(String newEmail) async {
    return getUser().updateEmail(newEmail);
  }

  Future updateUserPassword(String newPassword) async {
    return getUser().updatePassword(newPassword);
  }

  //TODO: check if it needs try catch block
  Future updateEmailAndPassword(String email, String password) async {
    var user = FirebaseAuth.instance.currentUser;
    return Future.wait(
        [user.updateEmail(email), user.updatePassword(password)]);
  }
}
