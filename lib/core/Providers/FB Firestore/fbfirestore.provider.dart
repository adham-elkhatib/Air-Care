//t1 --Imports
//t2 Core Packages Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

//t2 Dependencies Imports
import '../../../core/Services/Error Handling/error_handling.service.dart';
import '../index.dart';
import '../src/condition_model.dart';
import '../src/operators.dart';
//t3 Services

//t3 Models

//t1 Exports

class FirestoreProvider extends DataProvider {
  //
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  //
  FirestoreProvider() {
    if (!kIsWeb) {
      // Web: Use enablePersistence with settings
      _store.settings = const Settings(persistenceEnabled: true);
    }
  }

  //
  //SECTION Create
  //t1 Single
  Future<String?> createSingle(
    String collection,
    String documentId,
    Map<String, dynamic> documentData, {
    List<String>? uniques,
  }) async {
    try {
      //t2 Check Uniques exist
      List<bool> uniquesCheck = [];
      if (uniques != null) {
        for (var f in uniques) {
          assert(documentData.containsKey(f));
          bool result = await existsWhere(collection, [
            QueryCondition.equals(field: f, value: documentData[f]),
          ]);
          uniquesCheck.add(result);
        }
      }
      if (!uniquesCheck.contains(true) || uniques == null) {
        await _store.collection(collection).doc(documentId).set(documentData);
        return documentId;
      } else {
        throw ("[c/firestore-item-exists]");
      }
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'FirestoreProvider/createSingle',
        stackTrace: s,
      );
    }
    return null;
  }

  //t1 Multible
  Future<List<String>?> createMultible(
    String collection,
    List<String> documentIds,
    List<Map<String, dynamic>> documentsData, {
    bool batched = false,
    List<String>? uniques,
  }) async {
    //
    assert(
      documentsData.length == documentIds.length,
      "Data list doesn't equal ids list!",
    );
    assert(uniques == null || batched);
    //
    if (batched) {
      WriteBatch batch = _store.batch();
      try {
        for (var i = 0; i < documentIds.length; i++) {
          DocumentReference ref = _store
              .collection(collection)
              .doc(documentIds[i]);
          batch.set(ref, documentsData[i]);
        }
        await batch.commit();
        return documentIds;
      } catch (e, s) {
        ErrorHandlingService.handle(
          e,
          'FirestoreProvider/createMultible/batched',
          stackTrace: s,
        );
      }
    } else {
      try {
        for (var i = 0; i < documentIds.length; i++) {
          await createSingle(
            collection,
            documentIds[i],
            documentsData[i],
            uniques: uniques,
          );
        }
      } catch (e, s) {
        ErrorHandlingService.handle(
          e,
          'FirestoreProvider/createMultible',
          stackTrace: s,
        );
      }
    }
    return null;
  }

  //!SECTION Create

  //SECTION Read
  //t1 Single
  Future<Map<String, dynamic>?> readSingle(
    String collection,
    String documentId,
  ) async {
    try {
      return await _store
          .collection(collection)
          .doc(documentId)
          .get()
          .then((value) => value.data());
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'FirestoreProvider/readSingle',
        stackTrace: s,
      );
    }
    return null;
  }

  //t1 All
  Future<List<Map<String, dynamic>>?> readAll(
    String collection, {
    String? orderedBy,
    int? limit,
  }) async {
    try {
      //t2 Ref
      CollectionReference<Map<String, dynamic>> ref = _store.collection(
        collection,
      );
      //t2 Querying
      Query<Map<String, dynamic>> query = ref;
      //t3 Ordering
      if (orderedBy != null) {
        query = query.orderBy(orderedBy);
      }
      //t3 Cursoring
      //t3 Limiting
      if (limit != null) {
        query = query.limit(limit);
      }
      //t2 Getting
      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      //t2 Returning
      return snapshot.docs.map((e) => e.data()).toList();
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'FirestoreProvider/readAll',
        stackTrace: s,
      );
    }
    return null;
  }

  //t1 Where
  Future<List<Map<String, dynamic>>?> readWhere(
    String collection,
    List<QueryCondition> conditions, {
    String? orderedBy,
    int? limit,
  }) async {
    try {
      //t2 Ref
      CollectionReference<Map<String, dynamic>> ref = _store.collection(
        collection,
      );
      //t2 Querying
      Query<Map<String, dynamic>> query = ref;
      for (var i = 0; i < conditions.length; i++) {
        query = query.where(
          conditions[i].field,
          isEqualTo: conditions[i].operator == QueryOperator.equals
              ? conditions[i].value
              : null,
          isNotEqualTo: conditions[i].operator == QueryOperator.notEquals
              ? conditions[i].value
              : null,
          isGreaterThan: conditions[i].operator == QueryOperator.greater
              ? conditions[i].value
              : null,
          isGreaterThanOrEqualTo:
              conditions[i].operator == QueryOperator.greaterOrEqual
              ? conditions[i].value
              : null,
          isLessThan: conditions[i].operator == QueryOperator.less
              ? conditions[i].value
              : null,
          isLessThanOrEqualTo:
              conditions[i].operator == QueryOperator.lessOrEqual
              ? conditions[i].value
              : null,
          isNull: conditions[i].operator == QueryOperator.isNull
              ? conditions[i].value
              : null,
        );
      }
      //t3 Ordering
      if (orderedBy != null) {
        query = query.orderBy(orderedBy);
      }
      //t3 Cursoring
      //t3 Limiting
      if (limit != null) {
        query = query.limit(limit);
      }
      //t2 Getting
      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      //t2 Returning
      return snapshot.docs.map((e) => e.data()).toList();
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'FirestoreProvider/readWhere',
        stackTrace: s,
      );
    }
    return null;
  }

  //!SECTION Read

  //SECTION Update
  //t1 Single
  Future<String?> updateSingle(
    String collection,
    String documentId,
    Map<String, dynamic> documentData,
  ) async {
    try {
      await _store.collection(collection).doc(documentId).update(documentData);
      return documentId;
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'FirestoreProvider/updateSingle',
        stackTrace: s,
      );
    }
    return null;
  }

  //t1 Multible
  Future<List<String>?> updateMultible(
    String collection,
    List<String> documentIds,
    List<Map<String, dynamic>> documentsData, {
    bool batched = false,
  }) async {
    //
    assert(
      documentsData.length == documentIds.length,
      "Data list doesn't equal ids list!",
    );
    //
    if (batched) {
      WriteBatch batch = _store.batch();
      try {
        for (var i = 0; i < documentIds.length; i++) {
          DocumentReference ref = _store
              .collection(collection)
              .doc(documentIds[i]);
          batch.update(ref, documentsData[i]);
        }
        await batch.commit();
        return documentIds;
      } catch (e, s) {
        ErrorHandlingService.handle(
          e,
          'FirestoreProvider/updateMultible/batched',
          stackTrace: s,
        );
      }
    }
    //
    else {
      try {
        for (var i = 0; i < documentIds.length; i++) {
          await updateSingle(collection, documentIds[i], documentsData[i]);
        }
      } catch (e, s) {
        ErrorHandlingService.handle(
          e,
          'FirestoreProvider/updateMultible',
          stackTrace: s,
        );
      }
    }
    return null;
  }

  //!SECTION Update

  //SECTION Delete
  //t1 Single
  Future<void> deleteSingle(String collection, String documentId) async {
    try {
      return await _store.collection(collection).doc(documentId).delete();
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'FirestoreProvider/deleteSingle',
        stackTrace: s,
      );
    }
  }

  //t1 Multible
  Future<void> deleteMultible(
    String collection,
    List<String> documentsIds, {
    bool batched = true,
  }) async {
    //
    if (batched) {
      WriteBatch batch = _store.batch();
      try {
        for (var i = 0; i < documentsIds.length; i++) {
          DocumentReference ref = _store
              .collection(collection)
              .doc(documentsIds[i]);
          batch.delete(ref);
        }
        await batch.commit();
      } catch (e, s) {
        ErrorHandlingService.handle(
          e,
          'FirestoreProvider/deleteMultible/batched',
          stackTrace: s,
        );
      }
    } else {
      try {
        for (var i = 0; i < documentsIds.length; i++) {
          await deleteSingle(collection, documentsIds[i]);
        }
      } catch (e, s) {
        ErrorHandlingService.handle(
          e,
          'FirestoreProvider/deleteMultible',
          stackTrace: s,
        );
      }
    }
  }

  //t1 Clear
  Future<void> clear(String collection, {bool batched = true}) async {
    try {
      //t2 Ref
      CollectionReference<Map<String, dynamic>> ref = _store.collection(
        collection,
      );
      //t2 Getting
      QuerySnapshot<Map<String, dynamic>> snapshot = await ref.get();
      List<String> ids = snapshot.docs.map((e) => e.id).toList();
      return await deleteMultible(collection, ids, batched: batched);
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'FirestoreProvider/clear', stackTrace: s);
    }
  }

  //!SECTION Delete

  //SECTION Stream
  //t1 Single
  Stream<Map<String, dynamic>?> streamSingle(
    String collection,
    String documentId,
  ) {
    try {
      return _store
          .collection(collection)
          .doc(documentId)
          .snapshots()
          .map((v) => v.data());
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'FirestoreProvider/streamSingle',
        stackTrace: s,
      );
    }
    return Stream.value(null);
  }

  //t1 All
  Stream<List<Map<String, dynamic>>?> streamAll(
    String collection, {
    String? orderedBy,
    int? limit,
  }) {
    try {
      //t2 Ref
      CollectionReference<Map<String, dynamic>> ref = _store.collection(
        collection,
      );
      //t2 Querying
      Query<Map<String, dynamic>> query = ref;
      //t3 Ordering
      if (orderedBy != null) {
        query = query.orderBy(orderedBy);
      }
      //t3 Cursoring
      //t3 Limiting
      if (limit != null) {
        query = query.limit(limit);
      }
      //t2 Getting
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = query.snapshots();

      //t2 Returning
      return snapshot.map((v) {
        return v.docs.map((e) => e.data()).toList();
      });
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'FirestoreProvider/streamAll',
        stackTrace: s,
      );
    }
    return Stream.value(null);
  }

  //t1 Where
  Stream<List<Map<String, dynamic>>?> streamWhere(
    String collection,
    List<QueryCondition> conditions, {
    String? orderedBy,
    int? limit,
  }) {
    try {
      //t2 Ref
      CollectionReference<Map<String, dynamic>> ref = _store.collection(
        collection,
      );
      //t2 Querying
      Query<Map<String, dynamic>> query = ref;
      for (var i = 0; i < conditions.length; i++) {
        query = query.where(
          conditions[i].field,
          isEqualTo: conditions[i].operator == QueryOperator.equals
              ? conditions[i].value
              : null,
          isNotEqualTo: conditions[i].operator == QueryOperator.notEquals
              ? conditions[i].value
              : null,
          isGreaterThan: conditions[i].operator == QueryOperator.greater
              ? conditions[i].value
              : null,
          isGreaterThanOrEqualTo:
              conditions[i].operator == QueryOperator.greaterOrEqual
              ? conditions[i].value
              : null,
          isLessThan: conditions[i].operator == QueryOperator.less
              ? conditions[i].value
              : null,
          isLessThanOrEqualTo:
              conditions[i].operator == QueryOperator.lessOrEqual
              ? conditions[i].value
              : null,
          isNull: conditions[i].operator == QueryOperator.isNull
              ? conditions[i].value
              : null,
        );
      }
      //t3 Ordering
      if (orderedBy != null) {
        query = query.orderBy(orderedBy);
      }
      //t3 Cursoring
      //t3 Limiting
      if (limit != null) {
        query = query.limit(limit);
      }
      //t2 Getting
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = query.snapshots();

      //t2 Returning
      return snapshot.map((sc) => sc.docs.map((e) => e.data()).toList());
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'FirestoreProvider/streamWhere',
        stackTrace: s,
      );
    }
    return Stream.value(null);
  }

  //!SECTION Stream

  //SECTION Helper methods
  //t1 Exists
  Future<bool> exists(String collection, String documentId) async {
    try {
      return _store.collection(collection).path.isNotEmpty
          ? await _store
                .collection(collection)
                .doc(documentId)
                .get()
                .then((value) => value.exists)
          : false;
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'FirestoreProvider/exists', stackTrace: s);
    }
    return true;
  }

  //t1 Exists Where
  Future<bool> existsWhere(
    String collection,
    List<QueryCondition> conditions,
  ) async {
    try {
      //t2 Ref
      CollectionReference<Map<String, dynamic>> ref = _store.collection(
        collection,
      );
      //t2 Querying
      Query<Map<String, dynamic>> query = ref;
      for (var i = 0; i < conditions.length; i++) {
        query = query.where(
          conditions[i].field,
          isEqualTo: conditions[i].operator == QueryOperator.equals
              ? conditions[i].value
              : null,
          isNotEqualTo: conditions[i].operator == QueryOperator.notEquals
              ? conditions[i].value
              : null,
          isGreaterThan: conditions[i].operator == QueryOperator.greater
              ? conditions[i].value
              : null,
          isGreaterThanOrEqualTo:
              conditions[i].operator == QueryOperator.greaterOrEqual
              ? conditions[i].value
              : null,
          isLessThan: conditions[i].operator == QueryOperator.less
              ? conditions[i].value
              : null,
          isLessThanOrEqualTo:
              conditions[i].operator == QueryOperator.lessOrEqual
              ? conditions[i].value
              : null,
          isNull: conditions[i].operator == QueryOperator.isNull
              ? conditions[i].value
              : null,
        );
      }
      //t3 Ordering
      //t2 Getting
      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      //t2 Returning
      return snapshot.docs.isNotEmpty;
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'FirestoreProvider/existsWhere',
        stackTrace: s,
      );
    }
    return true;
  }

  //!SECTION Helper methods
}
