import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.phone,
    super.name,
    super.surname,
    super.organization,
    super.role,
    super.profileImage,
    super.sessionId,
    super.activeApplications = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      activeApplications: List<String>.from(json['active_applications'] ?? []),
      id: json['\$id'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'],
      surname: json['surname'],
      organization: json['organization'],
      role: json['role'],
      sessionId: json['sessionId'],
      profileImage: json['profileImage'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      phone: phone,
      name: name,
      surname: surname,
      organization: organization,
      role: role,
      profileImage: profileImage,
      activeApplications: activeApplications,
    );
  }
}
