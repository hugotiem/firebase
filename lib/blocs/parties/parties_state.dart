part of 'parties_cubit.dart';

enum PartiesStatus { initial, adding, loading, added, loaded }

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
  const PartiesState.adding() : this(PartiesStatus.adding);
  const PartiesState.loading()
      : this(PartiesStatus.loading, requestInProgress: true);
  const PartiesState.added(parties)
      : this(PartiesStatus.added, parties: parties);
  const PartiesState.loaded(parties)
      : this(PartiesStatus.loaded, parties: parties);
}
