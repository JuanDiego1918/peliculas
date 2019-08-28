import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';


class DataSearch extends SearchDelegate{

  String seleccion = '';
  final peliculaProvider = new PeliculasProviders();

  final peliculas = [

  ];

  final peliculasRecientes = [

  ];


  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear,color: Colors.indigo),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Icono a la izquierda el App Bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        color: Colors.indigo,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  /* @override
  Widget buildResults(BuildContext context) {
    //Builder 'instruccion' que crear los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: ,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Son las sugerencias que aparecen mientras la persona escribe

    final listaBusqueda = ( query.isEmpty ) 
                            ? peliculasRecientes
                            : peliculas.where( 
                              (p)=> p.toLowerCase().startsWith(query.toLowerCase())
                            ).toList();


    return ListView.builder(
      itemCount: listaBusqueda.length,
      itemBuilder: (context,i){
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaBusqueda[i]),
          onTap: () {
            seleccion = listaBusqueda[i];
            showResults(context);
          },
        );
      },
    );
  } */

  @override
  Widget buildResults(BuildContext context) {
    //Builder 'instruccion' que crear los resultados que vamos a mostrar
    return Container(
      color: Colors.indigo,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Son las sugerencias que aparecen mientras la persona escribe
    if (query.isEmpty){
      return Container();
    }

    return FutureBuilder(
      future: peliculaProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        
        if (snapshot.hasData){

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map( (p){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(p.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(p.title),
                subtitle: Text(p.originalTitle),
                onTap: () {
                  close(context, null);
                  p.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle',arguments: p);
                },
              );
            }).toList()
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }

      },
    );
  }

}