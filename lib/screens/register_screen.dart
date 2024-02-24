import 'package:flutter/material.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final conEmail = TextEditingController();
    final conPass = TextEditingController();
    final conNombre = TextEditingController();

    final txtEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: conEmail,
      decoration: InputDecoration(labelText: "Correo Electronico"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa tu correo electrónico';
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Correo electrónico no válido';
        }
        return null;
      },
    );

    final txtPass = TextFormField(
      controller: conPass,
      decoration: InputDecoration(labelText: "Contraseña"),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa tu contraseña';
        }
        return null;
      },
    );

    final txtNombre = TextFormField(
      controller: conNombre,
      decoration: InputDecoration(labelText: "Nombre"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa tu nombre';
        }
        return null;
      },
    );

    final btnRegistrar = ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario registrado correctamente')),
          );
        }
      },
      child: Text('Registrarse'),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Registrarse"),
          actions: [],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [txtEmail, txtPass, txtNombre, btnRegistrar],
            ),
          ),
        ));
  }
}
