import 'package:flutter/material.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/network/api_popular.dart';
import 'package:pmsn2024/screens/favorites_movies_screen.dart';
import 'package:pmsn2024/settings/custom_barnav.dart';

class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({super.key});

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  ApiPopular? apiPopular;
  final path = 'popular';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aquí manejas la navegación entre las diferentes pantallas
    if (index == 1) {
      // Pantalla de favoritos
      Navigator.pushReplacementNamed(context, '/favorite');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('lista de peliculas'),
      ),
      body: FutureBuilder(
        future: apiPopular!.getPopularMovie(path),
        builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .7,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    "/detail",
                    arguments: snapshot.data![index],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag: 'movie_poster_${snapshot.data![index].id}',
                      child: FadeInImage(
                        placeholder: const AssetImage('images/loding.gif'),
                        image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}",
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Ocurrio un error :"),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}