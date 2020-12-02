import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:search_repository/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    @required FirebaseSearchRepository searchRepository,
  })  : assert(searchRepository != null),
        _searchRepository = searchRepository,
        super(
          SearchInitial(),
        );

  final FirebaseSearchRepository _searchRepository;

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
    if (event is SearchTermSubmitted) {
      yield* _mapSearchTermCompleteToState(term: event.term);
    }
    if (event is SearchTermChanged) {
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
          await _searchRepository.getWordsMatching(term: term);
      if (searchResults.isEmpty) {
        yield SearchEmpty(emptyMessage: 'No Search Results');
      } else {
        yield SearchSuccess(
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
          await _searchRepository.getWordsStartingWith(term: term);
      if (searchSuggestions.isEmpty) {
        yield SearchEmpty(emptyMessage: 'No Search Suggestions');
      } else {
        yield SearchSuccess(
          searchList: searchSuggestions,
        );
      }
    } catch (e) {
      yield SearchError();
    }
  }
}
