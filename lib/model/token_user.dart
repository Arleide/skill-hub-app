class TokenUser {
  final int id;
  final String name;
  final String email;

  TokenUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory TokenUser.fromClaims(Map<String, dynamic> claims) {
    return TokenUser(
      id: claims['id'],
      name: claims['name'],
      email: claims['email'],
    );
  }
}
