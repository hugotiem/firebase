part of 'build_parties_cubit.dart';

enum BuildPartiesStatus { initial, adding, loading, added, loaded }

class BuildPartiesState extends AppBaseState<BuildPartiesStatus> {
  final Map<String, dynamic> parties;

  const BuildPartiesState(BuildPartiesStatus status,
      {this.parties,
      bool requestInProgress = false,
      String requestFailureCode,
      String requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const BuildPartiesState.initial() : this(BuildPartiesStatus.initial);
  const BuildPartiesState.adding() : this(BuildPartiesStatus.adding);
  const BuildPartiesState.loading()
      : this(BuildPartiesStatus.loading, requestInProgress: true);
  const BuildPartiesState.added(parties)
      : this(BuildPartiesStatus.added, parties: parties);
  const BuildPartiesState.loaded(parties)
      : this(BuildPartiesStatus.loaded, parties: parties);
}
