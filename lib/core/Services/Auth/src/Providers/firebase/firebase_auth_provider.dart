/// Firebase-specific implementation of the [AuthProvider] interface.
/// This class handles Firebase Authentication logic.
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../interfaces/auth_method.dart';
import '../../../interfaces/auth_provider.dart';
import '../../../models/auth.model.dart';
import 'methods/email_auth_method.dart';

class FirebaseAuthProvider implements AuthProvider {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthProvider({required firebase_auth.FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  Future<AuthModel?> signIn(AuthMethod method) async {
    try {
      firebase_auth.UserCredential userCredential;
      if (method is EmailAuthMethod) {
        userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: method.email,
          password: method.password,
        );
      } else {
        throw UnimplementedError('Authentication method not supported.');
      }
      final user = userCredential.user;
      if (user != null) {
        return AuthModel(
          uid: user.uid,
          authenticationToken: await user.getIdToken() ?? '',
          refreshToken: user.refreshToken ?? '',
          provider: 'firebase',
          misc: {'email': user.email, 'photoUrl': user.photoURL},
        );
      }
    } catch (e) {
      print('Error during sign-in: $e');
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<AuthModel?> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return AuthModel(
          uid: user.uid,
          authenticationToken: await user.getIdToken() ?? '',
          refreshToken: user.refreshToken ?? '',
          provider: 'firebase',
          misc: {'email': user.email, 'photoUrl': user.photoURL},
        );
      }
    } catch (e) {
      print('Error during sign-up: $e');
    }
    return null;
  }

  @override
  Future<AuthModel?> reAuthenticate(String password) async {
    final user = _firebaseAuth.currentUser;
    if (user != null && user.email != null) {
      try {
        final credential = firebase_auth.EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        return AuthModel(
          uid: user.uid,
          authenticationToken: await user.getIdToken() ?? '',
          refreshToken: user.refreshToken ?? '',
          provider: 'firebase',
          misc: {'email': user.email, 'photoUrl': user.photoURL},
        );
      } catch (e) {
        print('Error during re-authentication: $e');
      }
    }
    return null;
  }

  @override
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await reAuthenticate(oldPassword);
        await user.updatePassword(newPassword);
        return true;
      } catch (e) {
        print('Error during password update: $e');
      }
    }
    return false;
  }

  @override
  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Error during password reset: $e');
    }
    return false;
  }

  @override
  Future<bool> updateEmail(String password, String newEmail) async {
    final user = _firebaseAuth.currentUser;
    if (user != null && user.email != null) {
      try {
        await reAuthenticate(password);
        await user.verifyBeforeUpdateEmail(newEmail);
        return true;
      } catch (e) {
        print('Error during email update: $e');
      }
    }
    return false;
  }

  @override
  String? getCurrentUser() {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    return firebaseUser.uid;
  }

  @override
  Stream<firebase_auth.User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
