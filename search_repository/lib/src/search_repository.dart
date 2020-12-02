abstract class SearchRepository {
  Future<List<String>> getWordsStartingWith({String term});

  Future<List<String>> getWordsMatching({String term});
}
