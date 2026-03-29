class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.emailVerified,
    this.photoUrl,
  });

  final String id;
  final String email;
  final String displayName;
  final bool emailVerified;
  final String? photoUrl;
}
