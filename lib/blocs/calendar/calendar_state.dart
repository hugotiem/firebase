part of 'calendar_cubit.dart';

enum CalendarStatus { initial, dataLoaded }

class CalendarState extends AppBaseState<CalendarStatus> {
  final List<Meeting>? organisedParties;
  final List<Meeting>? invitedParties;

  const CalendarState(CalendarStatus? status,
      {this.organisedParties,
      this.invitedParties,
      requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const CalendarState.initial() : this(CalendarStatus.initial);
  const CalendarState.dataLoaded(
      List<Meeting> organisedParties, List<Meeting> invitedParties)
      : this(CalendarStatus.dataLoaded,
            organisedParties: organisedParties, invitedParties: invitedParties);

  @override
  AppBaseState<CalendarStatus> copyWith(
          {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      CalendarState(this.status,
          organisedParties: this.organisedParties,
          invitedParties: invitedParties,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
