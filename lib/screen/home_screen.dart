import 'package:flutter/material.dart';
import 'package:skillhub_app/model/token_user.dart';
import 'package:skillhub_app/screen/login_screen.dart';
import 'package:skillhub_app/util/custom_nav.dart';
import 'package:skillhub_app/util/secure_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nameUser = "";
  String emailUser = "";

  @override
  void initState() {
    super.initState();

    _carregarUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF0A0A0F),
        centerTitle: true,
        title: Image.asset('assets/images/logo_name.png', height: 32),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0A0A0F)),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.person, size: 60, color: Colors.white),
                    Text(
                      nameUser,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Text(
                      emailUser,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text('Inico'),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.search),
              title: Text('Buscar Serviços'),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.build_outlined),
              title: Text('Meus Serviços'),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Perfil'),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    return Center(
      child: Text('Nome Usuario: ' + nameUser, style: TextStyle(fontSize: 20)),
    );
  }

  _carregarUser() async {
    TokenUser? _user = await SecureStorageService.getLoggedUser();

    setState(() {
      if (_user != null) {
        nameUser = _user.name;
        emailUser = _user.email;
        print(_user);
      }
    });
  }

  _logout() async{
    await SecureStorageService.clear();
    push(context, LoginScreen(), replace: true);
  }
}
