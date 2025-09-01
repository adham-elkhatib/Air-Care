import 'dart:convert';

enum AppErrorType { ignored, generic, presentable, fatal }

class AppError {
  AppErrorType type;
  String code;
  DateTime timestamp;

  //
  String? msg;
  String? location;

  AppError({
    required this.type,
    required this.code,
    required this.timestamp,
    this.msg,
    this.location,
  });

  AppError copyWith({
    AppErrorType? type,
    String? code,
    DateTime? timestamp,
    String? msg,
    String? location,
  }) {
    return AppError(
      type: type ?? this.type,
      code: code ?? this.code,
      timestamp: timestamp ?? this.timestamp,
      msg: msg ?? this.msg,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.index,
      'code': code,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'msg': msg,
      'location': location,
    };
  }

  factory AppError.fromMap(Map<String, dynamic> map) {
    return AppError(
      type: AppErrorType.values[map['type']],
      code: map['code'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      msg: map['msg'] != null ? map['msg'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppError.fromJson(String source) =>
      AppError.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppError(type: $type,code: $code, timestamp: $timestamp, msg: $msg, location: $location)';
  }

  @override
  bool operator ==(covariant AppError other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.code == code &&
        other.timestamp == timestamp &&
        other.msg == msg &&
        other.location == location;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        type.hashCode ^
        timestamp.hashCode ^
        msg.hashCode ^
        location.hashCode;
  }

  // ---------------------------------------------------------
  factory AppError.ignored({
    String? code,
    String? msg,
    String? location,
    DateTime? timestamp,
  }) {
    return AppError(
      type: AppErrorType.ignored,
      code: code ?? 'Ignored',
      msg: msg ?? "",
      timestamp: timestamp ?? DateTime.now(),
      location: location,
    );
  }

  //
  factory AppError.generic({
    String? code,
    String? msg,
    String? location,
    DateTime? timestamp,
  }) {
    return AppError(
      type: AppErrorType.generic,
      code: code ?? 'Generic',
      msg: msg ?? "",
      timestamp: timestamp ?? DateTime.now(),
      location: location,
    );
  }

  //
  factory AppError.presentable(
    String code,
    String msg, {
    String? location,
    DateTime? timestamp,
  }) {
    return AppError(
      type: AppErrorType.presentable,
      code: code,
      msg: msg,
      location: location,
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  //
  factory AppError.fatal(
    String code,
    String msg, {
    String? location,
    DateTime? timestamp,
  }) {
    return AppError(
      type: AppErrorType.fatal,
      code: code,
      msg: msg,
      location: location,
      timestamp: timestamp ?? DateTime.now(),
    );
  }
  // ---------------------------------------------------------
}
