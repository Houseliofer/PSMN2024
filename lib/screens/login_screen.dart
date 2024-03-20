import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:pmsn2024/services/email_auth_firebase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final authFirebase = EmailAuthFirebase();
  final conEmail = TextEditingController();
  final conPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final txtUser = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: conEmail,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final pwdUser = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: conPassword,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage('images/fondo.jpg'))),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('images/letras.png'),
              Positioned(
                top: 360,
                child: Opacity(
                  opacity: .5,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    height: 170,
                    width: MediaQuery.of(context).size.width * .9,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        txtUser,
                        const SizedBox(
                          height: 10,
                        ),
                        pwdUser
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width * .9,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SignInButton(Buttons.Email, onPressed: () {
                          setState(
                            () {
                              isLoading = !isLoading;
                            },
                          );
                          authFirebase
                              .signInUser(
                                  password: conPassword.text,
                                  email: conEmail.text)
                              .then((value) {
                            if (!value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('email o contraseña incorrecto')),
                              );
                            } else {
                              Navigator.pushNamed(context, "/dash").then((value) {
                                setState(() {
                                  isLoading = !isLoading;
                                });
                              });
                            }
                          });
                        }),
                        SignInButton(Buttons.Facebook, onPressed: () {}),
                        SignInButton(Buttons.GitHub, onPressed: () {}),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/registro');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_add,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 50.0),
                                child: Text(
                                  'Registrarse',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'RobotoMono'),
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0)),
                              textStyle: const TextStyle(fontSize: 14.0)),
                        ),
                      ],
                    )),
              ),
              isLoading
                  ? const Positioned(
                      top: 250,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
