import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../models/auth.model.dart';
import 'auth_method.dart';

/// Abstract base class representing an authentication provider.
///
/// This class defines the common interface for authentication providers,
/// ensuring consistency across different implementations (e.g., Firebase, custom backend).
abstract class AuthProvider {
  /// Sign in a user using the provided [AuthMethod].
  ///
  /// Returns an [AuthModel] representing the authenticated user
  /// or `null` if authentication fails.
  Future<AuthModel?> signIn(AuthMethod method);

  /// Sign out the currently authenticated user.
  Future<void> signOut();

  /// Register a new user with the given [email] and [password].
  ///
  /// Returns an [AuthModel] for the registered user or `null` on failure.
  Future<AuthModel?> signUp(String email, String password);

  /// Re-authenticate the currently signed-in user using their [password].
  ///
  /// Returns an [AuthModel] for the re-authenticated user or `null` on failure.
  Future<AuthModel?> reAuthenticate(String password);

  /// Update the password for the currently authenticated user.
  ///
  /// Requires the [oldPassword] for re-authentication and the [newPassword].
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> updatePassword(String oldPassword, String newPassword);

  /// Send a password reset email to the user with the given [email].
  ///
  /// Returns `true` if the reset email was sent successfully, `false` otherwise.
  Future<bool> resetPassword(String email);

  /// Update the email address for the currently authenticated user.
  ///
  /// Requires the [password] for re-authentication and the [newEmail].
  /// Returns `true` if the email was updated successfully, `false` otherwise.
  Future<bool> updateEmail(String password, String newEmail);

  /// Get the current authenticated user.
  ///
  /// Returns an [AuthModel] representing the current user or `null`
  /// if no user is authenticated.
  String? getCurrentUser();

  Stream<firebase_auth.User?> authStateChanges();
}
