part of 'search_cubit.dart';

enum SearchStatus { initial, loading, loaded, changed }

class SearchState extends AppBaseState {
  final String? last;
  final String? destination;
  final List<PlaceSearch>? results;

  const SearchState(SearchStatus status,
      {this.results,
      this.destination,
      this.last,
      bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const SearchState.initial() : this(SearchStatus.initial);

  const SearchState.resultsLoaded(
      List<PlaceSearch>? results, String? destination, String? last)
      : this(SearchStatus.loaded, results: results, destination: destination);

  const SearchState.destinationChanged(
      List<PlaceSearch>? results, String? destination,  String? last)
      : this(SearchStatus.changed, results: results, destination: destination, last: last);

  SearchState copyWith(
          {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      SearchState(this.status,
          results: this.results,
          destination: this.destination,
          last: this.last,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
