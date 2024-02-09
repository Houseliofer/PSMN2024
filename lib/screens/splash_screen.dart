import 'package:flutter/material.dart';
import 'package:pmsn2024/screens/login_screen.dart';
import 'package:splash_view/source/presentation/pages/pages.dart';
import 'package:splash_view/source/presentation/presentation.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashView(
      backgroundColor: Colors.green[600],
      logo: Image.network(
                        'https://sg.com.mx/sites/default/files/2018-04/LogoITCelaya.png',
                        height: 250,
                      ),
      loadingIndicator: Image.asset('images/loding.gif'),
      done: Done(
        LoginScreen(),
        animationDuration: const Duration(milliseconds: 3000),
        
      ),
    );
  }
}