import 'package:flutter/material.dart';
import 'package:skillhub_app/model/token_user.dart';
import 'package:skillhub_app/screen/login_screen.dart';
import 'package:skillhub_app/screen/profile_screen.dart';
import 'package:skillhub_app/screen/requests_received_screen.dart';
import 'package:skillhub_app/screen/requests_sent_screen.dart';
import 'package:skillhub_app/screen/services_available_screen.dart';
import 'package:skillhub_app/util/custom_nav.dart';
import 'package:skillhub_app/util/secure_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ServicesAvailableScreen(),
    RequestsSentScreen(),
    RequestsReceivedScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0A0F),
        centerTitle: true,
        title: Image.asset('assets/images/logo_name.png', height: 32),
        flexibleSpace: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0A0F), // dark absoluto
                Color(0xFF0A0A0F), // dark absoluto
                Color(0xFF1B263B), // azul aço escuro
                Color(0xFF415A77), // azul cinz
              ],
            ),
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A0A0F),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            label: 'Disponíveis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_outlined),
            label: 'Enviados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_outlined),
            label: 'Recebidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
