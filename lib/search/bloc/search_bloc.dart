import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc_search/repository/search_repository.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    @required SearchRepository searchRepository,
  })  : assert(searchRepository != null),
        _searchRepository = searchRepository,
        super(
          SearchInitial(),
        );

  final SearchRepository _searchRepository;

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
    Stream<SearchEvent> events,
    TransitionFunction<SearchEvent, SearchState> transitionFn,
  ) {
    return events
        .debounceTime(
          const Duration(milliseconds: 350),
        )
        .switchMap(transitionFn);
  }

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchTermComplete) {
      yield* _mapSearchTermCompleteToState(term: event.term);
    }
    if (event is SearchTermTyping) {
      yield* _mapSearchTermTypingToState(term: event.term);
    }
    if (event is SearchClear) {
      yield SearchInitial();
    }
  }

  Stream<SearchState> _mapSearchTermCompleteToState({String term}) async* {
    try {
      yield SearchLoading();
      final searchResults =
          await _searchRepository.handleSearchComplete(term: term);
      if (searchResults.isEmpty) {
        yield SearchEmpty(emptyMessage: 'No Search Results');
      } else {
        yield SearchLoaded(
          searchList: searchResults,
        );
      }
    } catch (_) {
      yield SearchError();
    }
  }

  Stream<SearchState> _mapSearchTermTypingToState({String term}) async* {
    try {
      yield SearchLoading();
      final searchSuggestions =
          await _searchRepository.handleSearchTyping(term: term);
      if (searchSuggestions.isEmpty) {
        yield SearchEmpty(emptyMessage: 'No Search Suggestions');
      } else {
        yield SearchLoaded(
          searchList: searchSuggestions,
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      yield SearchError();
    }
  }
}
