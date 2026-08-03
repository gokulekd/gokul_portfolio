import 'package:cloud_firestore/cloud_firestore.dart';

/// Generic Firestore CRUD helper for the many admin-editable content lists
/// (skills, achievements, testimonials, FAQ, education, ...). Every such
/// collection follows the same shape — ordered docs with `displayOrder` and
/// `isVisible` — so the read/write plumbing is written once here instead of
/// once per collection. [FirebasePortfolioService] wraps one of these per
/// collection behind a named `streamX`/`saveX`/`deleteX` API to keep call
/// sites readable.
class FirestoreListRepository<T> {
  FirestoreListRepository({
    required this.collection,
    required this.fromFirestore,
    required this.toFirestore,
  });

  final CollectionReference<Map<String, dynamic>> collection;
  final T Function(DocumentSnapshot<Map<String, dynamic>> doc) fromFirestore;
  final Map<String, dynamic> Function(T item) toFirestore;

  Stream<List<T>> stream() {
    return collection
        .orderBy('displayOrder')
        .snapshots()
        .map((snap) => snap.docs.map(fromFirestore).toList(growable: false));
  }

  Future<void> save(String id, T item) async {
    final docRef = id.isEmpty ? collection.doc() : collection.doc(id);
    await docRef.set(toFirestore(item), SetOptions(merge: true));
  }

  Future<void> delete(String id) async {
    if (id.isEmpty) return;
    await collection.doc(id).delete();
  }

  /// Seeds the collection from [seedDocs] (docId -> field map) only if it is
  /// currently empty, so re-running seeding never overwrites live edits.
  Future<void> seedIfEmpty(Map<String, Map<String, dynamic>> seedDocs) async {
    final snapshot = await collection.limit(1).get();
    if (snapshot.docs.isNotEmpty) return;
    final batch = collection.firestore.batch();
    for (final entry in seedDocs.entries) {
      batch.set(collection.doc(entry.key), entry.value);
    }
    await batch.commit();
  }
}
