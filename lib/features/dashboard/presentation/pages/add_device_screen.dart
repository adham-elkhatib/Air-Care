import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Data/Model/Device/device.model.dart';
import '../../../../Data/Model/Device/sensor_data.dart';
import '../../../../Data/Repositories/sensor_data.repo.dart';
import '../../../../core/Services/Auth/auth.service.dart';
import '../../../../core/Services/Auth/src/Providers/firebase/firebase_auth_provider.dart';
import '../../../../core/Services/FCM Notification/fcm.notification.service.dart';
import '../../../../core/widgets/primary_button.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _smokeLevelThresholdController =
      TextEditingController();
  final TextEditingController _temperatureLevelThresholdController =
      TextEditingController();
  final TextEditingController _humidityLevelThresholdController =
      TextEditingController();

  Future<void> _saveDevice() async {
    if (_formKey.currentState!.validate()) {
      String? token = FCMNotification.getFcmToken();

      SensorData? currentSensorData = SensorData(
        id: _barcodeController.text,
        token: token,
        temperatureThreshold: double.tryParse(
          _temperatureLevelThresholdController.text,
        ),
        smokeLevelThreshold: double.tryParse(
          _smokeLevelThresholdController.text,
        ),
        humidityThreshold: double.tryParse(
          _humidityLevelThresholdController.text,
        ),
      );

      String? userId = AuthService(
        authProvider: FirebaseAuthProvider(firebaseAuth: FirebaseAuth.instance),
      ).getCurrentUserId();

      await SensorDataRepo().create(
        currentSensorData,
        key: _barcodeController.text,
        generateKey: false,
      );

      final newDevice = Device(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        barcode: _barcodeController.text,
        userId: userId!,
      );

      Navigator.pop(context, newDevice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // يخلّي زرار الـ Drawer يظهر
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 120,
        title: Column(
          children: [
            SizedBox(
              height: 60,
              child: Image.asset(
                "assets/images/Logo 01 black background.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Add New Device'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1114), Color(0xFF1A1E23), Color(0xFF2C2F3A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                padding: const EdgeInsets.all(24.0),
                margin: const EdgeInsets.symmetric(vertical: 12),

                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Register Your Device',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          hintText: "Enter device name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _barcodeController,
                        // readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Device Barcode",
                          hintText: "Tap to scan",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Barcode is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _smokeLevelThresholdController,
                        decoration: const InputDecoration(
                          labelText: "Smoke Threshold",
                          hintText: "0 - 1000",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final num = int.tryParse(value ?? '');
                          if (value == null || value.isEmpty) {
                            return 'Smoke threshold required';
                          } else if (num == null) {
                            return 'Enter a valid number';
                          } else if (num < 0) {
                            return 'Value can’t be negative';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _temperatureLevelThresholdController,
                        decoration: const InputDecoration(
                          labelText: "Temperature Threshold (°C)",
                          hintText: "-50 to 100",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final num = double.tryParse(value ?? '');
                          if (value == null || value.isEmpty) {
                            return 'Temperature threshold required';
                          } else if (num == null || num < -50 || num > 100) {
                            return 'Enter a realistic temperature (-50 to 100)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _humidityLevelThresholdController,
                        decoration: const InputDecoration(
                          labelText: "Humidity Threshold (%)",
                          hintText: "0 to 100",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final num = double.tryParse(value ?? '');
                          if (value == null || value.isEmpty) {
                            return 'Humidity threshold required';
                          } else if (num == null || num < 0 || num > 100) {
                            return 'Humidity must be between 0 and 100';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          title: "Add Device",
                          onPressed: _saveDevice,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
