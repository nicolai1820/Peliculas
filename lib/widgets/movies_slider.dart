import 'package:flutter/material.dart';
import 'package:peliculas/models/Movie.dart';

class MovieSlider extends StatefulWidget {

   final List<Movie> movies;
   final String? tittle;
  final Function onNextPage;

  const MovieSlider({Key? key, 
                      required this.movies, 
                      this.tittle,
                      required this.onNextPage}) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
    if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500)  {
      print('esto es scroll $scrollController.position.pixels');
      widget.onNextPage();
    }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    
    return Container(
      width: double.infinity,
      height: 250,
      child: (Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(this.widget.tittle != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(this.widget.tittle!, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),) ,
            ),
            SizedBox(height: 5,),
         Expanded(
           child: ListView.builder(
             controller: scrollController,
             scrollDirection: Axis.horizontal,
             itemCount: widget.movies.length,
             itemBuilder: (_, int index) {
               return _MoviePoster(widget.movies[index],'${widget.tittle}-$index-${widget.movies[index].id}');
             },),
         ),
        ],
      )),
    );
  }
}

class _MoviePoster extends StatelessWidget {

  final Movie movie;
  final String heroId;
  const _MoviePoster(this.movie,this.heroId);
  @override
  Widget build(BuildContext context) {

    movie.heroId = heroId;
    return Container(
                 width: 130,
                 height: 260,
                 margin: EdgeInsets.symmetric(horizontal: 10),
                 child: Column(
                   children: [
                     GestureDetector(
                        onTap: () =>Navigator.pushNamed(context, 'details',arguments: movie),
                       child: Hero(
                         tag: movie.heroId!,
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(20),
                           child: FadeInImage(placeholder: AssetImage('assets/no-image.jpg'),
                            image: NetworkImage(movie.fullPosterImg),
                            width: 130,
                            height: 190,
                            fit: BoxFit.cover,),
                         ),
                       ),
                     ),
                      SizedBox(height: 5,),
                      Text(movie.title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,)
                   ], 
                 ),
               ) ;
  }
}