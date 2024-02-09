import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'),),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/1144/1144760.png'),),
              accountName: Text('Jebus Paredes Mora'), 
              accountEmail: Text('20030392@itcelaya.edu.mx')
            )
          ],
        ),
      ),
    );
  }
}