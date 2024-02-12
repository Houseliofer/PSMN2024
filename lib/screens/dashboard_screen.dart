import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/1144/1144760.png'),
                ),
                accountName: const Text('Jebus Paredes Mora'),
                accountEmail: const Text('20030392@itcelaya.edu.mx')),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Practica 1'),
              subtitle: const Text('Aqui iria la descripcion si tuviera aqui'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Salir'),
              subtitle: const Text('Hasta Luego'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
