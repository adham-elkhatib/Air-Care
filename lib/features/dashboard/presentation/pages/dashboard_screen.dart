import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Data/Model/Device/device.model.dart';
import '../../../../Data/Model/User/user.model.dart';
import '../../../../Data/Repositories/device.repo.dart';
import '../../../../Data/Repositories/user.repo.dart';
import '../../../../core/Providers/src/condition_model.dart';
import '../../../../core/Services/Auth/auth.service.dart';
import '../../../../core/Services/Auth/src/Providers/firebase/firebase_auth_provider.dart';
import '../../../../core/widgets/section_placeholder.dart';
import '../../../../core/widgets/section_title.dart';
import 'add_device_screen.dart';
import 'device_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserModel? appUser;
  bool isLoading = true;
  String? deviceId;
  String? userId;
  List<Device?> devices = [];

  @override
  void initState() {
    super.initState();
    userId = AuthService(
      authProvider: FirebaseAuthProvider(firebaseAuth: FirebaseAuth.instance),
    ).getCurrentUserId();

    if (userId != null) {
      UserRepo().readSingle(userId!).then((value) {
        setState(() {
          appUser = value;
          isLoading = false;
        });
      });
    }
  }

  void _navigateToAddSensor() async {
    final newDevice = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDeviceScreen()),
    );
    if (newDevice != null) {
      await DevicesRepo().createSingle(newDevice, itemId: newDevice.id);
      devices.add(newDevice);
      setState(() {});
    }
  }

  void _navigateToDeviceDetails(Device device) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailsScreen(device: device),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final action = result['action'];
      final Device updatedDevice = result['device'];

      if (action == 'delete') {
        await DevicesRepo().deleteSingle(updatedDevice.id);
        devices.removeWhere((val) => val?.id == updatedDevice.id);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1114), Color(0xFF1A1E23), Color(0xFF2C2F3A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SectionTitle(
                      title: "All Devices",
                      onPressed: _navigateToAddSensor,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: FutureBuilder(
                        future: DevicesRepo().readAllWhere([
                          QueryCondition.equals(field: "userId", value: userId),
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            devices = snapshot.data!;
                            return isWide
                                ? GridView.builder(
                                    itemCount: devices.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 16,
                                          crossAxisSpacing: 16,
                                          childAspectRatio: 3.5,
                                        ),
                                    itemBuilder: (context, index) {
                                      return _buildDeviceCard(devices[index]!);
                                    },
                                  )
                                : ListView.builder(
                                    itemCount: devices.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: _buildDeviceCard(
                                          devices[index]!,
                                        ),
                                      );
                                    },
                                  );
                          } else {
                            return const Center(
                              child: SectionPlaceholder(
                                title: 'No devices are added yet!',
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard(Device device) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          device.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          'Device ID: ${device.barcode}',
          style: const TextStyle(color: Colors.white70),
        ),
        leading: const CircleAvatar(
          backgroundColor: Colors.white12,
          child: Icon(Icons.sensors_outlined, color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: () => _navigateToDeviceDetails(device),
      ),
    );
  }
}
