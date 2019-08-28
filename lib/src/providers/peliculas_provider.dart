import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/Actores_models.dart';
import 'dart:convert';
import 'dart:async';


import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProviders{

  String _apikey    = 'fccb51f4a4a32b8f7b4767934c67fb85';
  String _url       = 'api.themoviedb.org';
  String _language  = 'es-ES';

  int _popularesPage = 0;
  bool _cargando     = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStream(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta( Uri url ) async{
    
    final res = await http.get( url );
    final decodeData = json.decode(res.body);
    final peliculas = Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'   : _apikey,
      'language'  : _language
    });

    return await _procesarRespuesta(url);    

  }

  Future<List<Pelicula>> getPopular() async {

    if( _cargando ) return [];

    _cargando = true;
    _popularesPage++;

    final url = Uri.http(_url, '3/movie/popular',{
      'api_key'   : _apikey,
      'language'  : _language,
      'page'      : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink( _populares );
    _cargando = false;
    
    return resp;

  }

  Future<List<Actor>> getCast(String peliId) async{

    final url = Uri.https(_url, '3/movie/$peliId/credits',{
      'api_key'   : _apikey
    });

    final resp= await http.get(url);
    final decodeData = json.decode(resp.body);
    final actores = new Actores.fromJsonList(decodeData['cast']);

    return actores.actoresList;
  }


  Future<List<Pelicula>> buscarPelicula(String query) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key'   : _apikey,
      'language'  : _language,
      'query'     : query
    });

    return await _procesarRespuesta(url);    

  }

}