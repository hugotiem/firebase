class Address {
  final String? label;
  final String? streetName;
  final String? streetNumber;
  final String? city;
  final String? postalCode;
  final String? region;
  final double? longitude;
  final double? latitude;

  const Address({
    this.label,
    this.streetName,
    this.streetNumber,
    this.city,
    this.postalCode,
    this.region,
    this.longitude,
    this.latitude,
  });

  factory Address.fromJson(Map<String, dynamic> data) {
    var properties = data['properties'];
    var coordinates = data['geometry']['coordinates'];
    List<String> context = (properties['context'] as String).split(", ");
    return Address(
      label: properties['label'],
      streetName: properties['street'],
      streetNumber: properties['housenumber'],
      city: properties['city'],
      postalCode: properties['postcode'],
      region: context[2],
      longitude: coordinates[0],
      latitude: coordinates[1],
    );
  }
}
