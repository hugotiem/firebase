class Soiree {
  static String nom;
  static String theme;
  static String nombre;
  static DateTime date;
  static var heure;
  static String adresse;
  static String ville;
  static String codepostal;
  static bool paiement = true;
  static var prix;
  static String gratuit; 

  static void setDataFistPage(String _nom, String _theme, String _nombre) {
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
  static void setDataThirdPage(String _adresse, String _ville, String _codepostal) {
    adresse = _adresse;
    ville = _ville;
    codepostal = _codepostal;
  }

    static void setDataFourthPage(bool _paiement, var _prix, String _gratuit) {
      paiement = _paiement;
      prix = _prix;
      gratuit = _gratuit;
  }
}