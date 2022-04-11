part of 'build_parties_cubit.dart';

enum BuildPartiesStatus { initial, adding, loading, added, loaded }

class BuildPartiesState extends AppBaseState<BuildPartiesStatus> {
  final Party? party;

  const BuildPartiesState(BuildPartiesStatus? status,
      {this.party,
      bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const BuildPartiesState.initial() : this(BuildPartiesStatus.initial);
  const BuildPartiesState.adding(Party? party)
      : this(BuildPartiesStatus.adding, party: party);
  const BuildPartiesState.loading()
      : this(BuildPartiesStatus.loading, requestInProgress: true);
  const BuildPartiesState.added(parties)
      : this(BuildPartiesStatus.added, party: parties);
  const BuildPartiesState.loaded(parties)
      : this(BuildPartiesStatus.loaded, party: parties);

  @override
  AppBaseState<BuildPartiesStatus> copyWith(
          {Party? party,
          bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      BuildPartiesState(status,
          party: party ?? this.party,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
