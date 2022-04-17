part of 'card_registration_cubit.dart';

enum CardRegistrationStatus { initial, dataLoaded, failed }

class CardRegistrationState extends AppBaseState<CardRegistrationStatus> {
  final List<CreditCard>? cards;

  const CardRegistrationState(CardRegistrationStatus? status,
      {this.cards,
      bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const CardRegistrationState.initial() : this(CardRegistrationStatus.initial);
  const CardRegistrationState.dataLoaded(List<CreditCard>? cards)
      : this(CardRegistrationStatus.dataLoaded, cards: cards);
  const CardRegistrationState.failed() : this(CardRegistrationStatus.failed);

  @override
  AppBaseState<CardRegistrationStatus> copyWith(
          {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      CardRegistrationState(this.status);
}
