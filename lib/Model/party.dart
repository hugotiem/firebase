class Party {
  String nom;
  String theme;
  String nombre;
  var date;
  var starthour;
  var endhour;
  DateTime datedebut;
  DateTime datefin;
  var prix;
  String description;
  String adresse;
  String ville;
  String codepostal;
  String smoke;
  String animals;

  Party();

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party();
  }
}
