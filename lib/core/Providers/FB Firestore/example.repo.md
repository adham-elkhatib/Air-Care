```dart
class UserRepo extends FirestoreRepo<AppUser> {
  UserRepo()
      : super(
          'Users',
        );

  @override
  AppUser? toModel(Map<String, dynamic>? item) => AppUser.fromMap(item ?? {});

  @override
  Map<String, dynamic>? fromModel(AppUser? item) => item?.toMap() ?? {};
}
```
