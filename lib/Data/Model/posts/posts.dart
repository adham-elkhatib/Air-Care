import 'comment.dart';

class Post {
  String id;
  String publisherName;
  String publisherImageUrl;
  String? text;
  String? imageUrl;
  DateTime publishedDate;
  List<Comment> comments;
  Map<String, bool> likes;

  Post({
    required this.id,
    required this.publisherName,
    required this.publisherImageUrl,
    this.text,
    this.imageUrl,
    required this.publishedDate,
    this.comments = const [],
    this.likes = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'publisherName': publisherName,
      'publisherImageUrl': publisherImageUrl,
      'text': text,
      'imageUrl': imageUrl,
      'publishedDate': publishedDate.toIso8601String(),
      'comments': comments.map((c) => c.toMap()).toList(),
      'likes': likes,
    };
  }

  // Convert from Firestore
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      publisherName: map['publisherName'],
      publisherImageUrl: map['publisherImageUrl'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      publishedDate: DateTime.parse(map['publishedDate']),
      comments: List<Comment>.from(
        map['comments']?.map((c) => Comment.fromMap(c)) ?? [],
      ),
      likes: Map<String, bool>.from(map['likes'] ?? {}),
    );
  }
}
