class User {
  final String id;
  final String email;
  final String? displayName;

  User({required this.id, required this.email, this.displayName});

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      email: data['email'],
      displayName: (data['displayName']!) ? data['displayName'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'displayName': displayName};
  }

  User copyWith({String? id, String? email, String? displayName}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.displayName == displayName;
  }

  @override
  int get hashcode => Object.hash(id, email, displayName);
}
