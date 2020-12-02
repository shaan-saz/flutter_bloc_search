import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_search/search/bloc/search_bloc.dart';

class BuildSearch extends StatelessWidget {
  const BuildSearch({
    Key key,
    @required SearchBloc searchBloc,
  })  : assert(searchBloc != null),
        _searchBloc = searchBloc,
        super(key: key);

  final SearchBloc _searchBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      cubit: _searchBloc,
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is SearchSuccess) {
          return SearchList(
            searchList: state.searchList,
          );
        }
        if (state is SearchEmpty) {
          return CenterText(text: state.emptyMessage);
        }
        if (state is SearchError) {
          return const CenterText(text: 'Error Occured');
        } else {
          return const Center(
            child: CenterText(text: 'Search Something'),
          );
        }
      },
    );
  }
}

class SearchList extends StatelessWidget {
  const SearchList({Key key, @required this.searchList}) : super(key: key);

  final List<String> searchList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            searchList[index],
          ),
        );
      },
    );
  }
}

class CenterText extends StatelessWidget {
  const CenterText({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}
