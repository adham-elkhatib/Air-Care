// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

/// A data model representing an authenticated user.
///
/// This model contains the essential user details like `uid`,
/// `authenticationToken`, `refreshToken`, and other metadata.
class AuthModel {
  final String uid;
  final String authenticationToken;
  final String refreshToken;
  final String provider;
  final Map<String, dynamic> misc;

  /// Constructs an [AuthModel] instance.
  AuthModel({
    required this.uid,
    required this.authenticationToken,
    required this.refreshToken,
    required this.provider,
    required this.misc,
  });

  /// Creates a copy of the [AuthModel] with updated fields.
  AuthModel copyWith({
    String? uid,
    String? authenticationToken,
    String? refreshToken,
    String? provider,
    Map<String, dynamic>? misc,
  }) {
    return AuthModel(
      uid: uid ?? this.uid,
      authenticationToken: authenticationToken ?? this.authenticationToken,
      refreshToken: refreshToken ?? this.refreshToken,
      provider: provider ?? this.provider,
      misc: misc ?? this.misc,
    );
  }

  /// Converts the [AuthModel] instance to a `Map`.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'authenticationToken': authenticationToken,
      'refreshToken': refreshToken,
      'provider': provider,
      'misc': misc,
    };
  }

  /// Constructs an [AuthModel] instance from a `Map`.
  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      uid: map['uid'],
      authenticationToken: map['authenticationToken'],
      refreshToken: map['refreshToken'],
      provider: map['provider'],
      misc: Map<String, dynamic>.from(map['misc']),
    );
  }

  /// Converts the [AuthModel] instance to a JSON string.
  String toJson() => json.encode(toMap());

  /// Constructs an [AuthModel] instance from a JSON string.
  factory AuthModel.fromJson(String source) =>
      AuthModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthModel(uid: $uid, authenticationToken: $authenticationToken, refreshToken: $refreshToken, provider: $provider, misc: $misc)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthModel &&
        other.uid == uid &&
        other.authenticationToken == authenticationToken &&
        other.refreshToken == refreshToken &&
        other.provider == provider &&
        mapEquals(other.misc, misc);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        authenticationToken.hashCode ^
        refreshToken.hashCode ^
        provider.hashCode ^
        misc.hashCode;
  }
}
