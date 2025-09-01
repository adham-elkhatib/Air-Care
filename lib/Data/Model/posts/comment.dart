import 'dart:convert';

class Comment {
  String publisherName;
  String commentText;
  DateTime commentedDate;

  Comment({
    required this.publisherName,
    required this.commentText,
    required this.commentedDate,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'publisherName': publisherName,
      'commentText': commentText,
      'commentedDate': commentedDate.toIso8601String(),
    };
  }

  // Convert from Map (Firestore)
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      publisherName: map['publisherName'],
      commentText: map['commentText'],
      commentedDate: DateTime.parse(map['commentedDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);
}
