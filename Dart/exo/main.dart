import 'post.dart';
import 'user.dart';

void main() {
  print("Hello World !");
  User u1 = User(
    id: "24LO13IU",
    email: "bardo@gmail.com",
    displayName: "Bargui",
  );

  Post p0 = Post(id: "001", author: u1, content: "Mangez, Bougez.fr", likes: 2);
  final u2 = u1.copyWith(id: "24GLO12IU");
  final p1 = p0.copyWith(author: u2);
  final p2 = p1.copyWith(id: "0001");
  print("salut: ${p1.author.id}");
  p2 == p1 ? print("true") : print('false');
  Post resul = MostLikes([
    Post(id: "001", author: u1, content: "Mangez, Bougez.fr", likes: 1),
    Post(id: "001", author: u1, content: "Mangez, Bougez.fr", likes: 1),
    Post(id: "001", author: u1, content: "Mangez, Bougez.fr", likes: 1),
    Post(id: "001", author: u1, content: "Mangez, Bougez.fr", likes: 0),
    Post(id: "001", author: u1, content: "Mangez, Bougez.fr", likes: 0),
  ]);
  print("le plus grand post à: ${resul.likes} de likes");
}

Post MostLikes(List<Post> postList) {
  Post p;
  late Post r;
  int max = 0;
  for (p in postList) {
    if (p.likes > max) {
      max = p.likes;
      r = p;
    }
  }
  return r;
}
