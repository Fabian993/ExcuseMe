class User {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final int school;
  final String role;

  // ctor
  const User({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.school,
    required this.role,
  });

  // class-method
  factory User.fromJson(Map<String, dynamic> json) {
    // construct User from json response (method: GET)
    return User(
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      school: json['school'],
      role: json['role'],
    );
  }
}
