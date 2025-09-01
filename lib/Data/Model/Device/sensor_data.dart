import 'dart:convert';

import 'package:flutter/material.dart';

class SensorData {
  final String id;
  double? temperature;
  double? smokeLevel;
  double? humidity;

  double? temperatureThreshold;
  double? smokeLevelThreshold;
  double? humidityThreshold;

  Color temperatureColor;
  Color smokeLevelColor;
  bool? smokeTrigger;
  bool? temperatureTrigger;
  bool? humidityTrigger;

  String? token;

  SensorData({
    required this.id,
    this.temperature,
    this.humidity,
    this.smokeLevel,
    this.temperatureThreshold,
    this.smokeLevelThreshold,
    this.humidityThreshold,
    required this.token,
    this.humidityTrigger = false,
    this.temperatureTrigger = false,
    this.smokeTrigger = false,
  }) : temperatureColor = _getColor(temperature ?? 0),
       smokeLevelColor = _getColor(smokeLevel ?? 0);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "humidity": humidity,
      "humidity_threshold": humidityThreshold,
      "smoke_level": smokeLevel,
      "smoke_level_threshold": smokeLevelThreshold,
      "temperature": temperature,
      "temperature_threshold": temperatureThreshold,
      "token": token,
      "humidityTrigger": humidityTrigger,
      "temperatureTrigger": temperatureTrigger,
      "smokeTrigger": smokeTrigger,
    };
  }

  factory SensorData.fromMap(Map<String, dynamic> map) {
    return SensorData(
      id: map["id"],
      token: map["token"] ?? map["token"],
      humidity: map["humidity"] != null
          ? (map["humidity"] as num).toDouble()
          : null,
      humidityThreshold: map["humidity_threshold"] != null
          ? (map["humidity_threshold"] as num).toDouble()
          : null,
      smokeLevel: map["smoke_level"] != null
          ? (map["smoke_level"] as num).toDouble()
          : null,
      smokeLevelThreshold: map["smoke_level_threshold"] != null
          ? (map["smoke_level_threshold"] as num).toDouble()
          : null,
      temperature: map["temperature"] != null
          ? (map["temperature"] as num).toDouble()
          : null,
      temperatureThreshold: map["temperature_threshold"] != null
          ? (map["temperature_threshold"] as num).toDouble()
          : null,
      humidityTrigger: map["humidityTrigger"] ?? false,
      temperatureTrigger: map["temperatureTrigger"] ?? false,
      smokeTrigger: map["smokeTrigger"] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SensorData.fromJson(String source) =>
      SensorData.fromMap(json.decode(source) as Map<String, dynamic>);

  static Color _getColor(double level) {
    if (level < 200) return Colors.green;
    if (level < 500) return Colors.orange;
    return Colors.red;
  }
}
