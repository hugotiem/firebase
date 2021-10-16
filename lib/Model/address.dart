class Address {
  final String label;
  final String streetName;
  final String streetNumber;
  final String city;
  final String postalCode;
  final String region;

  const Address(
      {this.label,
      this.streetName,
      this.streetNumber,
      this.city,
      this.postalCode,
      this.region});

  factory Address.fromJson(Map<String, dynamic> data) {
    List<String> context = (data['context'] as String).split(", ");
    return Address(
      label: data['label'],
      streetName: data['street'],
      streetNumber: data['housenumber'],
      city: data['city'],
      postalCode: data['postcode'],
      region: context[2],
    );
  }
}
