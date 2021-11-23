part of 'parties_cubit.dart';

enum PartiesStatus { initial, loading, loaded }

class PartiesState extends AppBaseState<PartiesStatus> {
  final List<Party>? parties;

  const PartiesState(PartiesStatus? status,
      {this.parties,
      bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const PartiesState.initial() : this(PartiesStatus.initial);
  const PartiesState.loading()
      : this(PartiesStatus.loading, requestInProgress: true);
  const PartiesState.loaded(parties)
      : this(PartiesStatus.loaded, parties: parties);

  @override
  AppBaseState<PartiesStatus> copyWith(
          {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      PartiesState(status,
          parties: this.parties,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
