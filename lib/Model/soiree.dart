class Soiree {
  static String nom;
  static String theme;
  static String nombre;
  static var date;
  static var heure;
  static var prix;
  static String description;

  static void setDataNamePage(String _nom) {
    nom = _nom;
  }

  static void setDataThemePage(String _theme) {
    theme = _theme;
  }

  static void setDataDateHourPage(var _date, var _heure) {
    date = _date;
    heure = _heure;
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
}