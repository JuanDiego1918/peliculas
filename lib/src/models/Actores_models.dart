
class Actores{

  List<Actor> actoresList = new List();
  
  Actores.fromJsonList(  List<dynamic> jsonList ){
    if( jsonList == null ) return;

    jsonList.forEach( (item){
      final actor = Actor.fromJsonMap(item);
      actoresList.add(actor);
    });
  }

}


class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });


  Actor.fromJsonMap( Map<String,dynamic> json){
    castId      = json['cast_id'];
    character   = json['character'];
    creditId    = json['credit_id'];
    gender      = json['gender'];
    id          = json['id'];
    name        = json['name'];
    order       = json['order'];
    profilePath = json['profile_path'];
  }

  getFoto(){

    if ( profilePath == null ){
      return 'https://www.lawscot.org.uk/media/9319/people-placeholder.png?anchor=center&mode=crop&width=400&height=400&rnd=132025671170000000';
    }else{
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }

}