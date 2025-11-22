import 'package:vezem_zerno/core/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.phone,
    required super.name,
    required super.surname,
    required super.organization,
    required super.role,
    super.profileImage,
    super.sessionId,
    super.applications = const [],
    super.responses = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      applications: List<String>.from(json['applications'] ?? []),
      id: json['\$id'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'],
      surname: json['surname'],
      organization: json['organization'],
      role: json['role'],
      sessionId: json['sessionId'],
      profileImage: json['profileImage'],
      responses:  List<String>.from(json['responses'] ?? []),
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
      applications: applications,
      responses: responses,
    );
  }
}
