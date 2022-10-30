import 'dart:convert';

class Document {
  final String title;
  final String uid;
  final List content;
  final DateTime createdAt;
  final String id;
  Document({
    required this.title,
    required this.uid,
    required this.content,
    required this.createdAt,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'uid': uid,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'id': id,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      title: map['title'] ?? '',
      uid: map['uid'] ?? '',
      content: List.from(map['content']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      id: map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Document.fromJson(String source) =>
      Document.fromMap(json.decode(source));
}
