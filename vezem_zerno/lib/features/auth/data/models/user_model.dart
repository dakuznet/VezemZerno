import 'package:vezem_zerno/core/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.phone,
    super.name,
    super.surname,
    super.organization,
    super.role,
    super.profileImage,
    super.sessionId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] ?? json['id'] ?? '',
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
    );
  }
}
