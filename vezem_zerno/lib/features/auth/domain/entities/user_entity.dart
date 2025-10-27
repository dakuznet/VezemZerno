class UserEntity {
  final String id;
  final String phone;
  final String? name;
  final String? surname;
  final String? organization;
  final String? role;
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
    this.name,
    this.surname,
    this.organization,
    this.role,
    this.sessionId,
  });
}
