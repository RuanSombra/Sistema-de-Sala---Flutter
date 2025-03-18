import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/senai.png', height: 25),
        centerTitle: true,
        backgroundColor: Color(0xFF0145B5),
        iconTheme: IconThemeData(color: Colors.white, size: 30),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0.8),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0145B5)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                        'assets/images/professor.png',
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Eduardo Almeida',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          'Técnico em TI',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.checklist, size: 25),
              title: Text(
                'Reservar Sala',
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.person_pin_outlined, size: 25),
              title: Text(
                'Fila de Espera',
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.settings, size: 25),
              title: Text(
                'Configuração',
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(height: 300),
            Divider(color: Colors.black, indent: 10, endIndent: 10),
            SizedBox(height: 10),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
