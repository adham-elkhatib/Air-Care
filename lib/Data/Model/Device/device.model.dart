import 'dart:convert';

class Device {
  String id;
  String name;
  String userId;
  String barcode;

  Device({
    required this.id,
    required this.name,
    required this.userId,
    required this.barcode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      "userId": userId,
      'barcode': barcode,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] as String,
      name: map['name'],
      userId: map['userId'],
      barcode: map['barcode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) =>
      Device.fromMap(json.decode(source) as Map<String, dynamic>);
}
