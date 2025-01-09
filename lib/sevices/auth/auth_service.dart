import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Získání instance firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Získání momentálního uživatele
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Přihlásit se tlačítko funkce
  Future<UserCredential> signInWithEmailAndPassword(
      String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException {
      throw Exception("wrong email or password");
    }
  }

  // Zaregistrovat se tlačítko funkce
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException {
      throw Exception("wrong email or password");
    }
  }

  // Odhlasit se tlačítko funkce
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Odeslat email pro reset hesla
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      throw Exception("Failed to send password reset email enter an email");
    }
  }
}
