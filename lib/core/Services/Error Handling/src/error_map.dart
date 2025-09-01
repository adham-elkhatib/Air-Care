import 'error_model.dart';

final Map<String, AppError> errorMap = {
  //t1 /==============================================================================/ FIREBASE
  //t2 Firebase Authentication
  // E-mail is badly formatted
  "firebase_auth/invalid-email": AppError.presentable("Auth501", "auth_error"),
  // E-mail is already in use during sign up
  "firebase_auth/email-already-in-use": AppError.presentable(
    "Auth405",
    "auth_error",
  ),
  // User E-mail not found during Sign in/ resetting password
  "firebase_auth/user-not-found": AppError.presentable(
    "Auth404",
    "User email not found, check your input and try again.",
  ),
  // Wrong password during E-mail Sign in / Not the same provider
  "firebase_auth/wrong-password": AppError.presentable(
    "Auth400",
    "Email/Password not correct, check your input and try again.",
  ),
  //t2 Firebase Firestore
  // An Error that happens randomly regarding Firestore connection.
  "cloud_firestore/unavailable": AppError.ignored(code: 'Unavailable001'),
  // Item already exists in the firestore database (for unique identifiers)
  "c/firestore-item-exists": AppError.presentable(
    "Id400",
    "The firestore item exists in the database with the same unique field",
  ),
  //t1 /==============================================================================/ FIREBASE

  //t2 Dio Errors
  // The request returned a bad response, usually a bad request's fault.
  "dio/bad-response": AppError.presentable(
    "dio-br",
    "There has been an error connecting, please try again later.",
  ),
  // Unknown error passed by the dio client.
  "dio/unknown": AppError.presentable(
    "dio-u",
    "There has been an error connecting, please try again later.",
  ),
  //t2 Permissions
  // Permission has been denied perminentaly.
  "c/permission_denied": AppError.presentable(
    "P500",
    "{} permission has been denied, Some functionality might not work correctly..",
  ),
  "c/permission_denied_permenanytly": AppError.presentable(
    "P500",
    "{} permission has been perminently denied, please enable in settings screen",
  ),
};
