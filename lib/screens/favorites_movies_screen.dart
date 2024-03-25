import 'package:flutter/material.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/network/api_popular.dart';
import 'package:pmsn2024/settings/custom_barnav.dart';

class FavoriteMovieScreen extends StatefulWidget {
  const FavoriteMovieScreen({super.key});

  @override
  State<FavoriteMovieScreen> createState() => _FavoriteMovieScreenState();
}

class _FavoriteMovieScreenState extends State<FavoriteMovieScreen> {
  ApiGetFavorite? apigetfavorite;
  int _selectedIndex = 1;
  late Future<List<PopularModel>?> _favoriteMoviesFuture;

  @override
  void initState() {
    super.initState();
    apigetfavorite = ApiGetFavorite();
    _favoriteMoviesFuture = apigetfavorite!.getFavoriteMovie();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Pantalla de favoritos
      Navigator.pushReplacementNamed(context, '/movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de películas favoritas'),
      ),
      body: FutureBuilder<List<PopularModel>?>(
        future: _favoriteMoviesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.isEmpty ?? true) {
              return const Center(
                child: Text("Aun no tienes peliculas favoritas"),
              );
            }
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
                  ).then((value) {
                    if (value == true) {
                      setState(() {
                        _favoriteMoviesFuture =
                            apigetfavorite!.getFavoriteMovie();
                      });
                    }
                  }),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      placeholder: const AssetImage('images/loding.gif'),
                      image: NetworkImage(
                        "https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}",
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Ocurrio un error"),
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
