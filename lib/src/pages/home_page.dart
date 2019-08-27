import 'package:flutter/material.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';
import 'package:peliculas/src/widgets/swiper_widget.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';

class HomePage extends StatelessWidget {

  final PeliculasProviders peliculasProviders=new PeliculasProviders();

  @override
  Widget build(BuildContext context) {

    peliculasProviders.getPopular();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas'),
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiper(),
            _footer(context),
            ],
        ),
      ),
    );
  }

  Widget _swiper() {
    
    return FutureBuilder(
      future: peliculasProviders.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        
        if ( snapshot.hasData ){
          return SwiperWidget(peliculas:snapshot.data);
        }else{
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
        
      },
    );

  }

  Widget _footer(BuildContext context) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares',style: Theme.of(context).textTheme.subhead)
          ),
          SizedBox(height: 5.0,),
          StreamBuilder(
            stream: peliculasProviders.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

              if (snapshot.hasData ){
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProviders.getPopular,
                  );
              }else{
                return Center(child: CircularProgressIndicator());
              }

            },
          ),
        ],
      ),
    );

  }
}
