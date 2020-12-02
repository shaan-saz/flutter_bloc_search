part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchTermSubmitted extends SearchEvent {
  SearchTermSubmitted(this.term);

  final String term;
  @override
  List<Object> get props => [term];
}

class SearchTermChanged extends SearchEvent {
  SearchTermChanged(this.term);

  final String term;
  @override
  List<Object> get props => [term];
}

class SearchClear extends SearchEvent {}
