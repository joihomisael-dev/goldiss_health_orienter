import 'user.dart';

class Post {
  final String id;
  final User author;
  final String content;
  final int likes;

  Post({
    required this.id,
    required this.author,
    required this.content,
    this.likes = 0,
  });

  factory Post.fromJson(Map<String, dynamic> data) {
    return Post(
      id: data['id'],
      author: data['author'],
      content: data['content'],
      likes: data['likes'] != null ? data['likes'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author.toJson(),
      'content': content,
      'likes': likes,
    };
  }

  Post copyWith({String? id, User? author, String? content, int? likes}) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Post &&
        this.id == other.id &&
        this.author == other.author &&
        this.content == other.content &&
        this.likes == other.likes;
  }

  @override
  int get hashCode => Object.hash(id, author, content, likes);
}
