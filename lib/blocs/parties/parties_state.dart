part of 'parties_cubit.dart';

enum PartiesStatus { initial, loading, loaded }

class PartiesState extends AppBaseState<PartiesStatus> {
  final Map<String, dynamic> parties;

  const PartiesState(PartiesStatus status,
      {this.parties,
      bool requestInProgress = false,
      String requestFailureCode,
      String requestFailureMessage})
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
}
