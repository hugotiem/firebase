import 'package:equatable/equatable.dart';

class CardRegistration extends Equatable {
  final String id;
  final String accessKey;
  final String preRegistrationData;
  final String cardRegistrationURL;

  CardRegistration(this.id, this.accessKey, this.preRegistrationData,
      this.cardRegistrationURL);

  factory CardRegistration.fromJson(Map<String, dynamic> json) {
    var id = json['Id'];
    var accessKey = json['AccessKey'];
    var preRegistrationData = json['PreregistrationData'];
    var cardRegistrationURL = json['CardRegistrationURL'];

    return CardRegistration(
        id, accessKey, preRegistrationData, cardRegistrationURL);
  }

  @override
  List<Object?> get props => [id, accessKey, preRegistrationData, cardRegistrationURL];
}
