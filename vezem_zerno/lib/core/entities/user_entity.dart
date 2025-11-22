class UserEntity {
  final String id;
  final String phone;
  final String name;
  final String surname;
  final String organization;
  final String role;
  final String? profileImage;
  final String? sessionId;
  final List<String>? applications;
  final List<String>? responses;

  const UserEntity({
    required this.id,
    required this.phone,
    this.responses,
    this.applications,
    this.profileImage,
    required this.name,
    required this.surname,
    required this.organization,
    required this.role,
    this.sessionId,
  });
}
