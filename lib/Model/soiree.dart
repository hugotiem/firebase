class Soiree {
  static String nom;
  static String theme;
  static String nombre;
  static var date;
  static var starthour;
  static var endhour;
  static var prix;
  static String description;
  static String adresse;
  static String ville;
  static String codepostal;

  static void setDataNamePage(String _nom) {
    nom = _nom;
  }

  static void setDataThemePage(String _theme) {
    theme = _theme;
  }

  static void setDataDatePage(var _date) {
    date = _date;
  }

  static void setDataHourPage(var _heuredebut, var _heurefin) {
    starthour = _heuredebut;
    endhour = _heurefin;
  }

  static void setDataLocationPage(String _adresse, String _ville, String _codepostal) {
    adresse = _adresse;
    ville = _ville;
    codepostal = _codepostal;
  }

  static void setDataNumberPage(var _nombre) {
    nombre = _nombre;
  }

  static void setDataPricePage(var _prix) {
    prix = _prix;
  }
    
  static void setDataDescriptionPage(String _description) {
    description = _description;
  }

  static void setDataDateHourPage(starthour, endhour) {}

}