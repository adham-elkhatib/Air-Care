import '../../core/Providers/FB Firestore/fbfirestore_repo.dart';
import '../Model/posts/posts.dart';

class PostsRepo extends FirestoreRepo<Post> {
  PostsRepo() : super('Posts');

  @override
  Post? toModel(Map<String, dynamic>? item) => Post.fromMap(item ?? {});

  @override
  Map<String, dynamic>? fromModel(Post? item) => item?.toMap() ?? {};
}
