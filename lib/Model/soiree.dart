class Soiree {
  static String nom;
  static String theme;
  static String nombre;
  static var date;
  static var starthour;
  static var endhour;
  static DateTime datedebut;
  static DateTime datefin;
  static var prix;
  static String description;
  static String adresse;
  static String ville;
  static String codepostal;
  static String smoke;
  static String animals;

  static void setDataNamePage(String _nom) {
    nom = _nom;
  }

  static void setDataThemePage(String _theme) {
    theme = _theme;
  }

  static void setDataDateHourPage(var _date, DateTime _datedebut, DateTime _datefin) {
    date = _date;
    datedebut = _datedebut;
    datefin = _datefin;
  }

  static void setDataLocationPage(String _adresse, String _ville, String _codepostal) {
    adresse = _adresse;
    ville = _ville;
    codepostal = _codepostal;
  }

  static void setDataNumberPricePage(var _nombre, var _prix) {
    nombre = _nombre;
    prix = _prix;
  }
    
  static void setDataDescriptionPage(String _animals, String _smoke, String _description) {
    animals = _animals;
    smoke = _smoke;
    description = _description;
  }
}