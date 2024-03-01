import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;
  final conEmail = TextEditingController();
  final conPass = TextEditingController();
  final conNombre = TextEditingController();


  @override
  Widget build(BuildContext context) {
    //------------------------------------TEXT FIELDS-----------------------------------

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

    //------------------------------------TEXT FIELDS-----------------------------------
    //------------------------------------SCAFFOLD--------------------------------------
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
              children: [
                GestureDetector(
                  onTap: () => _mostrarOpcionesImagen(context),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!.path)) as ImageProvider
                        : null,
                    child: _imageFile == null ? Icon(Icons.person) : null,
                  ),
                ),
                txtEmail,
                txtPass,
                txtNombre,
                btnRegistrar,
              ],
            ),
          ),
        ));
  }
  //------------------------------------SCAFFOLD--------------------------------------
  //------------------------------------METODOS---------------------------------------

  void _mostrarOpcionesImagen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Tomar una foto'),
            onTap: () async {
              final XFile? image =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              setState(() {
                _imageFile = image;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Elegir una imagen de la galería'),
            onTap: () async {
              final XFile? image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              setState(() {
                _imageFile = image;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
