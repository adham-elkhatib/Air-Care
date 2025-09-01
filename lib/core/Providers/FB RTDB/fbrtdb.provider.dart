//-------------------------------------------- TO-DO list for the realtime database service
/// [x] basic Connection operations
/// [x] basic CRUD operations
/// [] Transactions
/// [] Sorting & Filtering
/// []
/// []
//-----------------------------------------------------------------------------------------------
//
//t1 --Imports
//t2 Core Packages Imports
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

//t2 Dependancies Imports
import '../../Services/App/app.service.dart';
import '../../Services/Error Handling/error_handling.service.dart';
import '../index.dart';

//t3 Services

//t3 Models

//t1 Exports
export 'package:firebase_database/firebase_database.dart';

class RTDBProvider extends DataProvider {
  //
  final FirebaseDatabase _rtdb = FirebaseDatabase.instance;

  RTDBProvider() {
    String databaseName = App.env.get('FB_RTDB_NAME');
    String databaseRegion = App.env.get('FB_RTDB_REGION');
    _rtdb.databaseURL =
        "https://$databaseName.$databaseRegion.firebasedatabase.app/";
    _rtdb.setLoggingEnabled(App.env == AppEnvironment.dev);
    if (!kIsWeb) {
      // Web: Use enablePersistence with settings
      _rtdb.setPersistenceEnabled(true);
    }
  }

  //
  //SECTION Connection
  //t1 Go Offline
  Future<void> disconnect() async {
    try {
      return await _rtdb.goOffline();
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBProvider/disconnect', stackTrace: s);
    }
  }

  //t1 Go Online
  Future<void> reconnect() async {
    try {
      return await _rtdb.goOnline();
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBProvider/reconnect', stackTrace: s);
    }
  }

  //!SECTION Connection

  //
  //SECTION Create
  //t1 Set
  // sets the path value with the given data
  Future<void> set(String path, Object? data) async {
    try {
      return await _rtdb.ref(path).set(data);
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBProvider/set', stackTrace: s);
    }
  }

  // adds a child with the given data
  //t1 Push
  Future<String?> push(String path, Object? data) async {
    try {
      String? k = _rtdb.ref(path).push().key;
      if (k != null) {
        await _rtdb.ref("$path/$k").set(data);
        return k;
      }
      return null;
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBProvider/push', stackTrace: s);
      return null;
    }
  }

  //!SECTION Create

  //
  //SECTION Read
  //t1 Get
  // Tries to fetch data from the remote db.
  Future<Map?> get(String path) async {
    try {
      return await _rtdb
          .ref(path)
          .get()
          .then((snapshot) => snapshot.value as Map?);
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBProvider/get', stackTrace: s);
      return null;
    }
  }

  //t1 Once
  // Tries to fetch data from the local db.
  Future<Map?> once(String path) async {
    try {
      return await _rtdb
          .ref(path)
          .once()
          .then((snapshot) => snapshot.snapshot.value as Map?);
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBProvider/once', stackTrace: s);
      return null;
    }
  }

  //!SECTION Read
  //SECTION Update
  //t1 Update
  Future<void> update(String path, Map<String, dynamic> data) async {
    try {
      return await _rtdb.ref(path).update(data);
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBProvider/update', stackTrace: s);
    }
  }

  //t1 Update Multible
  Future<void> updateMultible(
    String parentPath,
    Map<String, dynamic> pathedData,
  ) async {
    try {
      return await _rtdb.ref(parentPath).update(pathedData);
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'RTDBProvider/updateMultible',
        stackTrace: s,
      );
    }
  }

  //!SECTION Update

  //
  //SECTION Delete
  //t1 Remove
  Future<void> remove(String path) async {
    try {
      return await _rtdb.ref(path).remove();
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBProvider/remove', stackTrace: s);
    }
  }

  //t1 Remove Multible
  Future<void> removeMulti(String parentPath, List<String> paths) async {
    try {
      return await updateMultible(parentPath, {
        for (var path in paths) path: null,
      });
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBProvider/removeMulti', stackTrace: s);
    }
  }

  //!SECTION Delete

  //
  //SECTION Stream
  //t1 onValue
  Stream<List<Object?>?> onValue(String path, {bool discardKey = false}) {
    try {
      return _rtdb.ref(path).onValue.asyncMap((event) {
        List<Object?>? r = discardKey
            ? (event.snapshot.value as Map?)?.values.toList()
            : event.snapshot.value as List;
        return r;
      });
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBProvider/onValue', stackTrace: s);
      return const Stream.empty();
    }
  }

  //t1 OnChildAdded
  // Logs each child as a seperate event [only initially,afterwards only the new child]
  Stream<Object?> onChildAdded(String path) {
    try {
      return _rtdb.ref(path).onChildAdded.asyncMap((event) {
        Object? r = event.snapshot.value;
        return r;
      });
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'RTDBProvider/onChildAdded',
        stackTrace: s,
      );
      return const Stream.empty();
    }
  }

  //t1 OnChildChanged
  Stream<Object?> onChildChanged(String path) {
    try {
      return _rtdb.ref(path).onChildChanged.asyncMap((event) {
        Object? r = event.snapshot.value;
        return r;
      });
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'RTDBProvider/onChildChanged',
        stackTrace: s,
      );
      return const Stream.empty();
    }
  }

  //t1 OnChildRemoved
  Stream<Object?> onChildRemoved(String path, {bool discardKey = false}) {
    try {
      return _rtdb.ref(path).onChildRemoved.asyncMap((event) {
        Object? r = event.snapshot.value;
        return r;
      });
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'RTDBProvider/onChildRemoved',
        stackTrace: s,
      );
      return const Stream.empty();
    }
  }

  //!SECTION Stream

  //
  //SECTION Helper Methods

  //t1 Transact
  Future<TransactionResult?> transact(
    String path,
    Object? Function(Object? currentData) process, {
    bool Function(Object? currentData)? assertion,
    bool applyLocally = true,
  }) async {
    try {
      return await _rtdb.ref(path).runTransaction((value) {
        //
        if (assertion != null && !assertion(value)) {
          return Transaction.abort();
        }
        //
        return Transaction.success(process(value));
      }, applyLocally: applyLocally);
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'RTDBProvider/transact', stackTrace: s);
      return null;
    }
  }

  //!SECTION Helper Methods
}
