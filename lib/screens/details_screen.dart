import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:peliculas/models/Movie.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     final Movie movie = ModalRoute.of(context)?.settings.arguments  as Movie;


    return Scaffold(
      body: CustomScrollView(
        scrollDirection:Axis.vertical ,
        slivers: [
          _customAppBar(movie: movie,),
          SliverList(
            delegate: SliverChildListDelegate([
              _posterAndTittle(movie: movie,),
              _overview(movie),      
              CastingCards(movie.id),
            ]
              
            )
            )
        ],)
    );
  }
}

class _customAppBar extends StatelessWidget {
  final Movie movie;

  const _customAppBar({Key? key,required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(centerTitle: true,
      titlePadding: EdgeInsets.all(0),
      title:Container(
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 10),
        color: Colors.black12,
        child: Text(movie.title,style: TextStyle(fontSize: 16),) ,
      ),
      background: FadeInImage(
        placeholder: AssetImage('assets/loading.gif'),
         image: NetworkImage(movie.fullPosterImg),
         fit: BoxFit.cover,
      ),),
    );
  }
}

class _posterAndTittle extends StatelessWidget {

  final Movie movie;

  const _posterAndTittle({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Hero(
          tag: movie.heroId!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg')
              , image: NetworkImage(movie.fullPosterImg),
              height: 150,
              //width: 100,
              fit:BoxFit.cover ,),
              
          ),
        ),
        SizedBox(width: 20,),
        ConstrainedBox(

          constraints: BoxConstraints(maxWidth: size.width - 190),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
            Text(movie.title,
            style:Theme.of(context).textTheme.headline5,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,),
             Text(movie.originalTitle,
            style:Theme.of(context).textTheme.subtitle1,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,),
            Row(children: [
              Icon(Icons.star_outline,
              size: 15,
              color: Colors.grey,),
              SizedBox(width: 5,),
              Text('${movie.voteAverage}',style:Theme.of(context).textTheme.caption)
            ],)
          ],
        
          ),
        )
      ],),
    );
  }
}

class _overview extends StatelessWidget {

  final Movie movie;

  const _overview( this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      child: Text(movie.overview,
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.subtitle1,),
    );
  }
}