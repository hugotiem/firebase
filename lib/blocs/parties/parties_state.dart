part of 'parties_cubit.dart';

enum PartiesStatus { initial, loading, loaded }

class PartiesState extends AppBaseState<PartiesStatus> {
  final List<Party>? parties;
  final DateTime? selectedDate;
  final Map<String, dynamic>? filters;
  final DateTime? currentDate;

  const PartiesState(PartiesStatus? status,
      {this.parties,
      this.selectedDate,
      this.filters,
      this.currentDate,
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
  const PartiesState.loaded(parties, filters, {DateTime? currentDate})
      : this(PartiesStatus.loaded,
            parties: parties, filters: filters, currentDate: currentDate);

  @override
  AppBaseState<PartiesStatus> copyWith(
          {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      PartiesState(status,
          parties: this.parties,
          filters: this.filters,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
