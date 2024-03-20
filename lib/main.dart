import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pmsn2024/screens/dashboard_screen.dart';
import 'package:pmsn2024/screens/despensa_screen.dart';
import 'package:pmsn2024/screens/detail_movie_screen.dart';
import 'package:pmsn2024/screens/popular_movies_screen.dart';
import 'package:pmsn2024/screens/products_firebase_screen.dart';
import 'package:pmsn2024/screens/register_screen.dart';
import 'package:pmsn2024/screens/splash_screen.dart';
import 'package:pmsn2024/settings/app_value_notifier.dart';
import 'package:pmsn2024/settings/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyALwSQA2J3UAxADdBU1Eu0TgoCi8YdSYKA", // paste your api key here
      appId:
          "1:1084682734458:android:bcbff327c80a43c07424c3", //paste your app id here
      messagingSenderId: "1084682734458", //paste your messagingSenderId here
      projectId: "psmn24-a3cba", //paste your project id here
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppValueNotifier.banTheme,
        builder: (context, value, child) {
          return MaterialApp(
              theme: value
                  ? ThemeApp.darkTheme(context)
                  : ThemeApp.lightTheme(context),
              home: SplashScreen(),
              routes: {
                "/dash": (BuildContext context) => DashboardScreen(),
                "/despensa": (BuildContext context) => DespensaScreen(),
                "/registro": (BuildContext context) => registerScreen(),
                "/movies": (BuildContext context) => PopularMoviesScreen(),
                "/detail": (BuildContext context) => DetailMovieScreen(),
                "/products": (BuildContext context) => ProductsFirebaseScreen(),
              },
              debugShowCheckedModeBanner: false);
        });
  }
}

/*class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Practica 1',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: Drawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            contador++;
            print(contador);
            setState(() {
              
            });
          },
          child: Icon(Icons.ads_click),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.network(
                        'https://sg.com.mx/sites/default/files/2018-04/LogoITCelaya.png',
                        height: 250,
                      ),
            ),
            Text('Valor del contador $contador')
          ],
        ),
      ),
    );
  }
}*/
