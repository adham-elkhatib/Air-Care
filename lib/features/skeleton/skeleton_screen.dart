import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Data/Model/Device/sensor_data.dart';
import '../../Data/Model/User/user.model.dart';
import '../../Data/Repositories/sensor_data.repo.dart';
import '../../Data/Repositories/user.repo.dart';
import '../../core/Services/Auth/auth.service.dart';
import '../../core/Services/Auth/src/Providers/firebase/firebase_auth_provider.dart';
import '../../core/Services/FCM Notification/fcm.notification.service.dart';
import '../Profile/presentation/pages/profile.screen.dart';
import '../community/pages/community_screen.dart';
import '../dashboard/presentation/pages/dashboard_screen.dart';

class SkeletonScreen extends StatefulWidget {
  const SkeletonScreen({super.key});

  @override
  State<SkeletonScreen> createState() => _SkeletonScreenState();
}

class _SkeletonScreenState extends State<SkeletonScreen> {
  int _selectedIndex = 0;
  UserModel? user;
  bool isLoading = true;
  String deviceId = "32971219363";
  SensorData? currentSensorData;

  final List<String> _titles = ["Dashboard", "Community"];

  final List<Widget> screens = const [DashboardScreen(), CommunityScreen()];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final userId = AuthService(
      authProvider: FirebaseAuthProvider(firebaseAuth: FirebaseAuth.instance),
    ).getCurrentUserId();

    String? token = FCMNotification.getFcmToken();

    try {
      final newData = await SensorDataRepo().read(deviceId);
      currentSensorData = newData;
      currentSensorData!.token = token;

      await SensorDataRepo().update(deviceId, currentSensorData);

      if (userId != null) {
        final value = await UserRepo().readSingle(userId);
        setState(() {
          user = value;
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error during init: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close drawer
  }

  void _logout() {
    AuthService(
      authProvider: FirebaseAuthProvider(firebaseAuth: FirebaseAuth.instance),
    ).signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // يخلّي زرار الـ Drawer يظهر
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 120,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 60,
              child: Image.asset(
                "assets/images/Logo 01 black background.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _titles[_selectedIndex],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Profile",
            icon: const Icon(Icons.person_outline, color: Colors.white70),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),

      drawer: _buildDrawer(theme),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1114), Color(0xFF1A1E23), Color(0xFF2C2F3A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: screens[_selectedIndex],
      ),
    );
  }

  Widget _buildDrawer(ThemeData theme) {
    return Drawer(
      backgroundColor: Colors.white.withOpacity(0.05),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (!isLoading && user != null)
            UserAccountsDrawerHeader(
              accountName: Text(
                user!.name,
                style: const TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                user!.email,
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://www.w3schools.com/howto/img_avatar.png",
                ),
              ),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
            )
          else
            const DrawerHeader(
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          _buildDrawerItem(icon: Icons.dashboard, label: "Dashboard", index: 0),
          _buildDrawerItem(icon: Icons.group, label: "Community", index: 1),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text("Logout", style: TextStyle(color: Colors.white)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool selected = _selectedIndex == index;

    return ListTile(
      leading: Icon(icon, color: selected ? Colors.amber : Colors.white70),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.amber : Colors.white,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      onTap: () => _onItemTapped(index),
    );
  }
}
