import 'package:flutter/material.dart';

import 'bloc/search_bloc.dart';
import 'widgets/build_search.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({@required SearchBloc searchBloc})
      : assert(searchBloc != null),
        _searchBloc = searchBloc;

  final SearchBloc _searchBloc;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _searchBloc.add(
            SearchClear(),
          );
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query != '') {
      _searchBloc.add(
        SearchTermSubmitted(query),
      );
    }
    return BuildSearch(searchBloc: _searchBloc);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query != '') {
      _searchBloc.add(
        SearchTermChanged(query),
      );
    }
    return BuildSearch(searchBloc: _searchBloc);
  }

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);
}
