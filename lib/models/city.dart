class City {
  final String name;
  final int partiesNumber;

  const City(this.name, this.partiesNumber);

  factory City.fromJson(Map<String, dynamic> json) {
    var name = json['name'];
    var partiesNumber = json['partiesNumber'];
    return City(name, partiesNumber);
  }
}
