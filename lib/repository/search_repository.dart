import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRepository {
  SearchRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<List<String>> handleSearchTyping({String term}) async {
    final searchSuggestions = await _firebaseFirestore
        .collection('search')
        .where('name', isGreaterThanOrEqualTo: term)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => e.data()['name'] as String,
              )
              .toList(),
        );
    return searchSuggestions;
  }

  Future<List<String>> handleSearchComplete({String term}) async {
    final searchResults = await _firebaseFirestore
        .collection('search')
        .where('name', isEqualTo: term)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => e.data()['name'] as String,
              )
              .toList(),
        );
    return searchResults;
  }
}
