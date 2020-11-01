part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchTermComplete extends SearchEvent {
  SearchTermComplete(this.term);

  final String term;
  @override
  List<Object> get props => [term];
}

class SearchTermTyping extends SearchEvent {
  SearchTermTyping(this.term);

  final String term;
  @override
  List<Object> get props => [term];
}

class SearchClear extends SearchEvent {}
