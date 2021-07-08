extension CapExtension on String {
  // permet d'avoir la première lettre du phrase en majuscule
  // exemple : 'hello world' => 'Hello world'
  String get inCaps => this.length > 0
    ? '${this[0].toUpperCase()}${this.substring(1)}'
    : '';
}