//t3 Services
import '../../Services/Error Handling/error_handling.service.dart';
import 'fbrtdb.provider.dart';

//t3 Models
//t1 Exports

//

class RTDBRepo<T> {
  final String path;
  final bool discardKey;

  RTDBRepo({required this.path, required this.discardKey});

  //
  //------------------------------------------------------
  // Provider.
  //------------------------------------------------------
  //
  final RTDBProvider _db = RTDBProvider();

  //
  //------------------------------------------------------
  //
  //
  //SECTION Connection
  //t1 Go Offline
  Future<void> disconnect() async => await _db.disconnect();

  //t1 Go Online
  Future<void> reconnect() async => await reconnect();

  //!SECTION Connection

  //
  //SECTION Create
  //t1 Create
  Future create(T item, {String? key, bool generateKey = true}) async {
    //
    assert(
      generateKey || key != null,
      'Provide a key if generating key is disabled',
    );
    //
    try {
      if (generateKey) {
        return await _db.push(path, fromModel(item));
      } else {
        return await _db.set("$path/$key", fromModel(item));
      }
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBRepo<$T>/create', stackTrace: s);
    }
  }

  //t1 Create Multiple
  Future createMultiple(
    List<T> items, {
    List<String>? keys,
    bool generateKey = true,
  }) async {
    //
    assert(
      generateKey || (keys != null && keys.length == items.length),
      'Provide keys if generating key is disabled',
    );
    //
    try {
      if (generateKey) {
        for (var item in items) {
          await _db.push(path, fromModel(item));
        }
      } else {
        for (var item in items) {
          await _db.set("$path/${keys![items.indexOf(item)]}", fromModel(item));
        }
      }
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'RTDBRepo<$T>/createMultiple',
        stackTrace: s,
      );
    }
  }

  //!SECTION Create

  //
  //SECTION Read
  //t1 Read
  Future<T?> read(String key) async {
    try {
      Map? map = await _db.get("$path/$key");
      if (map != null) {
        return toModel(map);
      }
      return null;
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBRepo<$T>/read', stackTrace: s);
      return null;
    }
  }

  //t1 Read All
  Future<List<T?>?> readAll() async {
    try {
      Map? map = await _db.get(path);
      if (map != null) {
        return (map).values.map((e) => toModel(e as Object?)).toList();
      }
      return null;
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBRepo<$T>/readAll', stackTrace: s);
      return null;
    }
  }

  //!SECTION Read

  //
  //SECTION Update
  //t1 Update
  Future<bool> update(
    String itemKey,
    T? updatedItem, {
    bool isTransact = false,
    T Function(T item)? transactionProcess,
    bool Function(T item)? transactionassertion,
    bool applyTransactLocally = true,
  }) async {
    //
    assert(!isTransact || (transactionProcess != null && updatedItem == null));
    //
    try {
      if (!isTransact) {
        //
        return _db
            .update(
              "$path/$itemKey",
              fromModel(updatedItem as T) as Map<String, dynamic>,
            )
            .then((value) => true);
        //
      } else {
        //
        TransactionResult? result = await _db.transact(
          "$path/$itemKey",
          (currentData) {
            if (currentData != null) {
              return fromModel(transactionProcess!(toModel(currentData) as T));
            } else {
              return Transaction.abort();
            }
          },
          assertion: transactionassertion != null
              ? (currentData) {
                  if (currentData != null) {
                    return transactionassertion(toModel(currentData) as T);
                  } else {
                    return false;
                  }
                }
              : null,
          applyLocally: applyTransactLocally,
        );
        //
        return result?.committed ?? false;
      }
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBRepo<$T>/update', stackTrace: s);
      return false;
    }
  }

  //t1 Update Multible
  Future<bool> updateMultible(
    List<String> itemKeys,
    List<T> updatedItems,
  ) async {
    //
    assert(
      itemKeys.length == updatedItems.length,
      "Provide the same length of keys and items.",
    );
    //
    try {
      //
      return _db
          .updateMultible(
            path,
            Map.fromIterables(
              itemKeys.map((e) => e),
              updatedItems.map((e) => fromModel(e)),
            ),
          )
          .then((value) => true);
      //
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBRepo<$T>/update', stackTrace: s);
      return false;
    }
  }

  //!SECTION Update

  //
  //SECTION Delete
  //t1 Delete
  Future<void> delete(String key) async => _db.remove("$path/$key");

  //t1 Delete Multible
  Future<void> deleteMultible(List<String> keys) async =>
      _db.removeMulti(path, keys);

  //t1 Delete All
  Future<void> deleteAll() async => _db.remove(path);

  //!SECTION Delete

  //
  //SECTION Stream
  //t1 Watch
  Stream<List<T?>?> watch() => _db
      .onValue(path, discardKey: discardKey)
      .asyncMap((l) => l?.map((o) => toModel((o))).toList());

  //t1 OnCreate
  // Logs each child as a seperate event [only initially,afterwards only the new child]
  Stream<T?> onCreate() => _db.onChildAdded(path).asyncMap((o) => toModel((o)));

  //t1 OnUpdate
  // Logs each child as a seperate event [only initially,afterwards only the new child]
  Stream<T?> onUpdate() =>
      _db.onChildChanged(path).asyncMap((o) => toModel((o)));

  //t1 OnDelete
  Stream<T?> onDelete() => _db
      .onChildRemoved(path, discardKey: discardKey)
      .asyncMap((o) => toModel((o)));

  //!SECTION Stream

  //
  //SECTION Helper Methods
  //t1 From Model
  Object? fromModel(T item) {
    throw UnimplementedError();
  }

  //t1 To Model
  T? toModel(Object? data) {
    throw UnimplementedError();
  }

  Object? fromJson(String item) {
    throw UnimplementedError();
  }

  String toJson(T item) {
    throw UnimplementedError();
  }

  //!SECTION Helper Methods
}
