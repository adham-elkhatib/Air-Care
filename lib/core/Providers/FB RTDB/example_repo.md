```dart
class TestUserRepo extends RTDBRepo<AppUser> {
  TestUserRepo()
      : super(
          path: 'users',
          discardKey: true,
        );

  @override
  AppUser? toModel(Object? data) {
    //
    List<String> requiredFields = [
      "id",
    ];
    //
    try {
      Map<String, dynamic>? mappedData =
          data != null && data is Map? && (data as Map).isNotEmpty
              ? (data).map((key, value) => MapEntry(key.toString(), value))
              : null;
      //
      if (mappedData != null &&
          requiredFields.where((r) => mappedData[r] == null).toList().isEmpty) {
        return AppUser.fromMap(mappedData);
      } else {
        return null;
      }
    } catch (e, s) {
      ErrorHandlingService.handle(e, 'toModel', stackTrace: s);
      return null;
    }
    //
  }

  @override
  Map<String, dynamic>? fromModel(AppUser? item) => item?.toMap() ?? {};
}
```
