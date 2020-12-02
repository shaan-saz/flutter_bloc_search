import 'package:cloud_firestore/cloud_firestore.dart';

import 'search_repository.dart';

class FirebaseSearchRepository implements SearchRepository {
  FirebaseSearchRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<List<String>> getWordsStartingWith({String term}) async {
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

  @override
  Future<List<String>> getWordsMatching({String term}) async {
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
