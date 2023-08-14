import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/Search_delegated.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context );


    return Scaffold(
      appBar: AppBar(
          title: Text('Peliculas en cines'),
          elevation: 0,
          actions: [
            IconButton(onPressed: (){
              showSearch(context: context, delegate: MovieSearchDelegated());
            }, icon: Icon(Icons.search_outlined)),
          ],),
      body: SingleChildScrollView(
        child: Column(children: [
          CardSwiper(movies:moviesProvider.onDisplayMovies),
          MovieSlider(movies:moviesProvider.onDisplayMovies,
          tittle:'populares!',
          onNextPage: (){
            print('si entra aqui');
            moviesProvider.getPopularMovies();
          },),
          
        
      ],
      ), 
      )
    );
    
  }
}