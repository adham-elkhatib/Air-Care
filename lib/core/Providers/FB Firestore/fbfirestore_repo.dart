//t2 Core Packages Imports
//t2 Dependancies Imports
//t3 Services
//t3 Models
//t1 Exports

//
import '../../../core/Services/Error Handling/error_handling.service.dart';
import '../../../core/Services/Id Generating/id_generating.service.dart';
import '../src/condition_model.dart';
import 'fbfirestore.provider.dart';

class FirestoreRepo<T> {
  final String collectionId;

  FirestoreRepo(this.collectionId);

  //------------------------------------------------------
  // Provider.
  //------------------------------------------------------
  //
  final FirestoreProvider _firestore = FirestoreProvider();

  //
  //------------------------------------------------------
  //
  ////////////////////////////////////////////////////////////
  //SECTION Create
  ////////////////////////////////////////////////////////////
  //t2 Single
  /// Creates an item in the data storage and returns the id attached to it.
  Future<String?> createSingle(
    T item, {
    String? itemId,
    bool checkId = true,
    bool generateId = false,
    List<String>? keyChecks,
  }) async {
    //
    String id = (generateId || itemId == null) ? await _generateId() : itemId;

    if (checkId && !generateId) {
      if (await idExists(id)) {
        ErrorHandlingService.error("[ItemExists]", 'Repo/createSingle');
      }
    }
    try {
      String? r = await _firestore.createSingle(collectionId, id, {
        'id': id,
        'dateCreated': DateTime.now(),
        ...fromModel(item)!,
      }, uniques: keyChecks);
      if (r != null) {
        return r;
      }
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        "Repo/createSingle/firestore",
        stackTrace: s,
      );
      return null;
    }
    return null;
  }

  //t2 Multible
  /// Creates multible items in the data storage and returns the id list attached to them.
  Future<List<String?>?> createMultible(
    List<T> items, {
    List<String>? ids,
    bool checkId = true,
    bool generateId = false,
    bool batched = false,
    List<String>? keyChecks,
  }) async {
    //
    assert(ids == null || ids.length == items.length);
    //

    try {
      List<Map<String, dynamic>> itemsMap = [];
      for (var i = 0; i < items.length; i++) {
        // generate id
        String id = (generateId || ids == null) ? await _generateId() : ids[i];
        // check
        if (checkId && !generateId) {
          if (await idExists(id)) {
            ErrorHandlingService.error(
              "[ItemExists]",
              'Repo/createMultible/firestore',
            );
          }
        }
        itemsMap.add({
          'id': id,
          'dateCreated': DateTime.now(),
          ...fromModel(items[i])!,
        });
      }
      List<String?>? r = await _firestore.createMultible(
        collectionId,
        itemsMap.map((e) => e['id'].toString()).toList(),
        itemsMap,
        batched: batched,
        uniques: keyChecks,
      );
      if (r != null) {
        return r;
      }
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        "Repo/createMultible/firestore",
        stackTrace: s,
      );
      return null;
    }
    return null;
  }

  //!SECTION Create
  //
  //
  ////////////////////////////////////////////////////////////
  //SECTION Read
  ////////////////////////////////////////////////////////////
  //t2 Single
  /// Read a single item from the data storage
  Future<T?> readSingle(String id) async {
    //

    try {
      Map<String, dynamic>? r = await _firestore.readSingle(collectionId, id);
      if (r != null) {
        return toModel(r);
      }
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        "Repo/readSingle/firestore",
        stackTrace: s,
      );
      return null;
    }
    return null;
  }

  //t2 All
  /// Read all items from the data storage.
  Future<List<T?>?> readAll({String? orderedBy, int? limit}) async {
    //
    try {
      List<Map<String, dynamic>?>? r = await _firestore.readAll(
        collectionId,
        orderedBy: orderedBy,
        limit: limit,
      );
      if (r != null) {
        return r.map((e) => toModel(e)).toList();
      }
    } catch (e, s) {
      ErrorHandlingService.handle(e, "Repo/readAll/firestore", stackTrace: s);
      return null;
    }
    return null;
  }

  //t2 Where
  /// Read all items where satisfies a condition from the data storage.
  Future<List<T?>?> readAllWhere(
    List<QueryCondition> conditions, {
    String? orderedBy,
    int? limit,
  }) async {
    //

    try {
      List<Map<String, dynamic>?>? r = await _firestore.readWhere(
        collectionId,
        conditions,
        orderedBy: orderedBy,
        limit: limit,
      );
      if (r != null) {
        return r.map((e) => toModel(e)).toList();
      }
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        "Repo/readAllWhere/firestore",
        stackTrace: s,
      );
      return null;
    }
    return null;
  }

  //!SECTION Read
  //
  //
  ////////////////////////////////////////////////////////////
  //SECTION Update
  ////////////////////////////////////////////////////////////
  //t2 Single
  /// Update an item and returns it's id from the data storage.
  Future<String?> updateSingle(String id, T item) async {
    //
    try {
      String? r = await _firestore.updateSingle(
        collectionId,
        id,
        fromModel(item)!,
      );
      if (r != null) {
        return r;
      }
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        "Repo/updateSingle/firestore",
        stackTrace: s,
      );
      return null;
    }
    return null;
  }

  //t2 Multible
  /// Update all items supplied from the data storage.
  Future<List<String?>?> updateMultible(
    List<String> ids,
    List<T> items, {
    bool batched = false,
  }) async {
    //
    try {
      List<String?>? r = await _firestore.updateMultible(
        collectionId,
        ids,
        items.map((e) => fromModel(e)!).toList(),
        batched: batched,
      );
      if (r != null) {
        return r;
      }
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        "Repo/updateMultible/firestore",
        stackTrace: s,
      );
      return null;
    }
    return null;
  }

  //!SECTION Update
  //
  //
  ////////////////////////////////////////////////////////////
  //SECTION Delete
  ////////////////////////////////////////////////////////////
  //t2 Single
  /// Delete an item from the data storage.
  Future<void> deleteSingle(String id) async {
    //
    try {
      await _firestore.deleteSingle(collectionId, id);
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        "Repo/deleteSingle/firestore",
        stackTrace: s,
      );
    }
  }

  //t2 Multible
  /// Delete multible items from the data storage.
  Future<void> deleteMultible(List<String> ids, {bool batched = false}) async {
    //
    try {
      await _firestore.deleteMultible(collectionId, ids, batched: batched);
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        "Repo/deleteMultible/firestore",
        stackTrace: s,
      );
    }
  }

  //t2 Clear
  /// Delete all items from the data storage.
  Future<void> clear({bool batched = false}) async {
    //
    try {
      await _firestore.clear(collectionId, batched: batched);
    } catch (e, s) {
      ErrorHandlingService.handle(e, "Repo/clear/firestore", stackTrace: s);
    }
  }

  //!SECTION Delete
  //
  //
  ////////////////////////////////////////////////////////////
  //SECTION Stream
  ////////////////////////////////////////////////////////////
  //t2 Single
  /// Stream single item from the data storage.
  Stream<T?> streamSingle(String id) {
    //
    try {
      return _firestore
          .streamSingle(collectionId, id)
          .asyncMap((m) => toModel(m));
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        "Repo/streamSingle/firestore",
        stackTrace: s,
      );
      return const Stream.empty();
    }
  }

  //t2 All
  /// Stream all items from the data storage.
  Stream<List<T?>?> streamAll({String? orderedBy, int? limit}) {
    //
    try {
      return _firestore
          .streamAll(collectionId, orderedBy: orderedBy, limit: limit)
          .asyncMap((m) => m?.map((e) => toModel(e)).toList());
    } catch (e, s) {
      ErrorHandlingService.handle(e, "Repo/streamAll/firestore", stackTrace: s);
      return const Stream.empty();
    }
  }

  //t2 Where
  /// Stream all items where satisfies conditions from the data storage.
  Stream<List<T?>?> streamAllWhere(
    List<QueryCondition> conditions, {
    String? orderedBy,
    int? limit,
  }) {
    //
    try {
      return _firestore
          .streamWhere(
            collectionId,
            conditions,
            orderedBy: orderedBy,
            limit: limit,
          )
          .asyncMap((m) => m?.map((e) => toModel(e)).toList());
    } catch (e, s) {
      ErrorHandlingService.handle(e, "Repo/streamAll/firestore", stackTrace: s);
      return const Stream.empty();
    }
  }

  //!SECTION Stream
  //
  //
  ////////////////////////////////////////////////////////////
  //SECTION Helper methods
  ////////////////////////////////////////////////////////////
  //t2 Id Exists
  /// Check if an item with the same id exists.
  Future<bool> idExists(String id) async {
    //
    try {
      return await _firestore.exists(collectionId, id);
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        "UserRepo/idExists/Firestore",
        stackTrace: s,
      );
      return true;
    }
  }

  //t2 Generate Id
  /// Generate Id for the item.
  Future<String> _generateId({String format = '{16{w}}'}) async {
    late String id;
    try {
      id = IdGeneratingService.generate(pattern: format);
      if (await idExists(id)) {
        id = IdGeneratingService.generate(pattern: format);
      }
    } catch (e, s) {
      ErrorHandlingService.handle(e, "UserRepo/_generateId", stackTrace: s);
    }
    return id;
  }

  //t2 To Model
  /// Convert map to model.
  T? toModel(Map<String, dynamic>? item) {
    return null;
  }

  //t2 From Model
  /// Convert model to map.
  Map<String, dynamic>? fromModel(T? item) {
    return null;
  }

  //!SECTION Helper methods
  //
  //
}
