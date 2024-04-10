import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:pmsn2024/settings/app_value_notifier.dart';

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
                accountName: Text('Jebus Paredes Mora'),
                accountEmail: Text('20030392@itcelaya.edu.mx')),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Practica 1'),
              subtitle: Text('Aqui iria la descripcion si tuviera aqui'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Productos'),
              subtitle: Text('Productos de Firebase'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/productos'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies app'),
              subtitle: Text('Peliculas populares'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/movies'),
            ),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text('Mi despensa'),
              subtitle: Text('Relacion de productos que no voy a usar'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/despensa'),
            ),
            ListTile(
              leading: Icon(Icons.add_a_photo_sharp),
              title: Text('Productos'),
              subtitle: Text('Productos de firebase'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/products'),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Mapa'),
              subtitle: Text('Mapa ejemplo'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/map'),
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
            DayNightSwitcher(
              isDarkModeEnabled: AppValueNotifier.banTheme.value,
              onStateChanged: (isDarkModeEnabled) {
                AppValueNotifier.banTheme.value = isDarkModeEnabled;
              },
            ),
          ],
        ),
      ),
    );
  }
}
