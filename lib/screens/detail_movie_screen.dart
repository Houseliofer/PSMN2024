import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pmsn2024/model/cast_model.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/model/videos_model.dart';
import 'package:pmsn2024/network/api_popular.dart';
import 'package:pmsn2024/settings/custom_barnav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({Key? key}) : super(key: key);

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isFavorited = false;
  late final TabController _tabController;
  Set<int> favoriteMovieIds = Set<int>();
  late SharedPreferences _prefs;
  late PopularModel _popularModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteMovieIds = _prefs
              .getStringList('favoriteMovieIds')
              ?.map((id) => int.parse(id))
              .toSet() ??
          Set<int>();
      _isFavorited = favoriteMovieIds.contains(_popularModel.id ?? 0);
    });
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorited = !_isFavorited;
    });

    if (_isFavorited) {
      favoriteMovieIds.add(_popularModel.id ?? 0);
      await ApiAddFavorite().postFavoriteMovie(_popularModel.id ?? 0);
    } else {
      favoriteMovieIds.remove(_popularModel.id ?? 0);
      await ApiDeleteFavorite().deleteFavoriteMovie(_popularModel.id ?? 0);
    }

    // Guarda la lista actualizada de ids de películas favoritas en sharedpreferences
    _prefs.setStringList('favoriteMovieIds',
        favoriteMovieIds.map((id) => id.toString()).toList());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      // Pantalla de favoritos
      //Navigator.pushReplacementNamed(context, '/favorite');
      Navigator.pop(context);
    }
    if (index == 0) {
      // Pantalla de listado de peliculas
      //Navigator.pushReplacementNamed(context, '/movies');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
    const space = SizedBox(
      height: 10,
    );
    YoutubePlayerController _controller;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details', style: TextStyle(fontFamily: 'Cursive', fontSize: 24, color: Colors.white)),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: Hero(
        tag: 'movie_poster_${_popularModel.id}',
        child: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: "https://image.tmdb.org/t/p/w500/${_popularModel.posterPath}",
                fit: BoxFit.cover,
                height: 400,
                width: double.infinity,
              ),
              _buildMovieDetails(),
              FutureBuilder<List<Result>?>(
                future: ApiVideos().getTrailer("${_popularModel.id}"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _controller = YoutubePlayerController(
                      initialVideoId: snapshot.data?.first.key ?? '',
                      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
                    );
                    return YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.amber,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.amber,
                          handleColor: Colors.amberAccent,
                        ),
                      ),
                      builder: (context, player) => Container(
                        height: 200,
                        child: player,
                      ),
                    );
                  } else {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("An error occurred :(", style: TextStyle(color: Colors.white, fontFamily: 'Cursive', fontSize: 18)),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(_popularModel.title??''),
              IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  Icons.favorite,
                  color: _isFavorited ? Colors.red : Colors.grey,
                  size: 32,
                ),
              ),
            ],
          ),
          const Text(
            'Rating',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
              fontFamily: 'Cursive',
            ),
          ),
          const SizedBox(height: 10),
          RatingBarIndicator(
            rating: _popularModel.voteAverage ?? 0.0,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 10,
            itemSize: 24.0,
            direction: Axis.horizontal,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return _buildOverviewModal();
                },
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Description',
              style: TextStyle(
                fontFamily: 'Cursive',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return _buildCastModal();
                },
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Cast',
              style: TextStyle(
                fontFamily: 'Cursive',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return _buildDetailsModal();
                },
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Details',
              style: TextStyle(
                fontFamily: 'Cursive',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewModal() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontFamily: 'Cursive',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              _popularModel.overview ?? '',
              style: const TextStyle(
                fontFamily: 'Cursive',
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCastModal() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Cast',
              style: TextStyle(
                fontFamily: 'Cursive',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: ApiCast().getCast("${_popularModel.id}"),
              builder: (context, AsyncSnapshot<List<CastMovie>?> snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: snapshot.data![index].profilePath != null
                              ? Image.network(
                                  "https://image.tmdb.org/t/p/w500/${snapshot.data![index].profilePath}")
                              : const Icon(Icons.account_circle),
                          title: Text(
                            snapshot.data![index].originalName ?? '',
                            style: const TextStyle(
                              fontFamily: 'Cursive',
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data![index].character ?? '',
                            style: const TextStyle(
                              fontFamily: 'Cursive',
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("An error occurred :(", style: TextStyle(color: Colors.black, fontFamily: 'Cursive', fontSize: 16)),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsModal() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Details',
              style: TextStyle(
                fontFamily: 'Cursive',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder<Map<String, dynamic>?>(
              future: ApiDetail().getDetail("${_popularModel.id}"),
              builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                if (snapshot.hasData) {
                  final Map<String, dynamic>? data = snapshot.data;
                  final int? runtime = data?['runtime'];
                  final String? releaseDate = data?['release_date'];
                  final List<dynamic>? spokenLanguages = data?['spoken_languages'];
                  final List<dynamic>? genres = data?['genres'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duration: ${runtime ?? 'Unknown'} minutes',
                        style: const TextStyle(
                          fontFamily: 'Cursive',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Release Date: ${releaseDate ?? 'Unknown'}',
                        style: const TextStyle(
                          fontFamily: 'Cursive',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Languages:',
                        style: TextStyle(
                          fontFamily: 'Cursive',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: spokenLanguages?.length ?? 0,
                          itemBuilder: (context, index) {
                            final language = spokenLanguages?[index];
                            return Text(
                              language?['name'] ?? '',
                              style: const TextStyle(
                                fontFamily: 'Cursive',
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Genres:',
                       style: TextStyle(
                         fontFamily: 'Cursive',
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     SizedBox(
                       height: 100,
                       child: ListView.builder(
                         shrinkWrap: true,
                         itemCount: genres?.length ?? 0,
                         itemBuilder: (context, index) {
                           final genre = genres?[index];
                           return Text(
                             genre?['name'] ?? '',
                             style: const TextStyle(
                               fontFamily: 'Cursive',
                               fontSize: 16,
                             ),
                           );
                         },
                       ),
                     ),
                   ],
                 );
               } else {
                 if (snapshot.hasError) {
                   return const Center(
                     child: Text(
                       "An error occurred :(",
                       style: TextStyle(
                         color: Colors.black,
                         fontFamily: 'Cursive',
                         fontSize: 16,
                       ),
                     ),
                   );
                 } else {
                   return const Center(
                     child: CircularProgressIndicator(),
                   );
                 }
               }
             },
           ),
         ],
       ),
     ),
   );
 }
}