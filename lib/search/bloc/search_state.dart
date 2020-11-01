part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  SearchLoaded({this.searchList});

  final List<String> searchList;

  @override
  List<Object> get props => [searchList];
}

class SearchEmpty extends SearchState {
  SearchEmpty({this.emptyMessage});

  final String emptyMessage;

  @override
  List<Object> get props => [emptyMessage];
}

class SearchError extends SearchState {}
