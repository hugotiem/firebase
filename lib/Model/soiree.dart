class Soiree {
  static String nom;
  static String theme;
  static var nombre;
  static DateTime date;
  static var heure;

  static void setDataFistPage(String _nom, String _theme, var _nombre) {
    nom = _nom;
    theme = _theme;
    nombre = _nombre;
  }

  // attribut heure à rajouter
  static void setDataSecondPage(DateTime _date, var _heure) {
    date = _date;
    heure = _heure;
  }

  // attributs pour l'adress de la soirée à rajouter
  static void setDataThirdPage() {}
}
