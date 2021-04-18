class Soiree {
  static String nom;
  static String theme;
  static double nombre;
  static double age;
  static DateTime date;

  static void setDataFistPage(String _nom, String _theme, double _nombre) {
    nom = _nom;
    theme = _theme;
    nombre = _nombre;
  }

  // attribut heure à rajouter
  static void setDataSecondPage(DateTime _date) {
    date = _date;
  }

  // attributs pour l'adress de la soirée à rajouter
  static void setDataThirdPage() {}
}
