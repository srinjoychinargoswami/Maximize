class User {
  final int? id; // Optional ID for the user, useful for database operations
  final String username;
  final String email;

  // Constructor
  User({
    this.id,
    required this.username,
    required this.email,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  // Extract a User object from a Map object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
    );
  }
}