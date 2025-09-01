// File: auth_service.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'interfaces/auth_method.dart';
import 'interfaces/auth_provider.dart';
import 'models/auth.model.dart';

/// The AuthService provides a unified interface for handling
/// user authentication across different providers.
class AuthService {
  final AuthProvider _authProvider;

  /// Constructor accepts an [AuthProvider] instance.
  AuthService({required AuthProvider authProvider})
    : _authProvider = authProvider;

  /// Sign in a user using the provided [AuthMethod].
  /// Returns an [AuthModel] on successful authentication, or `null` if it fails.
  Future<AuthModel?> signIn(AuthMethod method) async {
    return await _authProvider.signIn(method);
  }

  /// Sign out the currently authenticated user.
  Future<void> signOut() async {
    await _authProvider.signOut();
  }

  /// Register a new user with the given [email] and [password].
  /// Returns an [AuthModel] for the registered user or `null` on failure.
  Future<AuthModel?> signUp(String email, String password) async {
    return await _authProvider.signUp(email, password);
  }

  /// Re-authenticate the currently signed-in user using their [password].
  /// Returns an [AuthModel] for the re-authenticated user or `null` on failure.
  Future<AuthModel?> reAuthenticate(String password) async {
    return await _authProvider.reAuthenticate(password);
  }

  /// Update the password for the currently authenticated user.
  /// Requires the [oldPassword] for re-authentication and the [newPassword].
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    return await _authProvider.updatePassword(oldPassword, newPassword);
  }

  /// Send a password reset email to the user with the given [email].
  /// Returns `true` if the reset email was sent successfully, `false` otherwise.
  Future<bool> resetPassword(String email) async {
    return await _authProvider.resetPassword(email);
  }

  /// Update the email address for the currently authenticated user.
  /// Requires the [password] for re-authentication and the [newEmail].
  /// Returns `true` if the email was updated successfully, `false` otherwise.
  Future<bool> updateEmail(String password, String newEmail) async {
    return await _authProvider.updateEmail(password, newEmail);
  }

  /// Get the current authenticated user's ID (UID).
  String? getCurrentUserId() {
    final currentUser = _authProvider.getCurrentUser();
    return currentUser;
  }

  Stream<firebase_auth.User?> isUserLoggedIn() {
    return _authProvider.authStateChanges();
  }
}
