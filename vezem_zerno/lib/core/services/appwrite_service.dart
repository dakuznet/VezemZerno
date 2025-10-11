import 'dart:io' as io;
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:vezem_zerno/core/constants/string_constants.dart';
import 'package:vezem_zerno/features/auth/data/models/user_model.dart';
import 'package:path/path.dart' as path;
import 'package:vezem_zerno/features/user_application_list/data/models/application_model.dart';

class AppwriteService {
  late final Client _client;
  late final Account _account;
  late final Functions _functions;
  late final Storage _imageStorage;
  late final TablesDB _tablesDB;

  Account get account => _account;

  AppwriteService() {
    _client = Client()
        .setEndpoint(StringConstants.endPoint)
        .setProject(StringConstants.projectId);

    _account = Account(_client);
    _functions = Functions(_client);
    _imageStorage = Storage(_client);
    _tablesDB = TablesDB(_client);
  }

  // APPLICATIONS

  // Получение заявок пользователя по статусу заявки
  Future<List<ApplicationModel>> getUserApplicationsByStatus(
    String userId,
    String status,
  ) async {
    try {
      final userResponse = await _tablesDB.listRows(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        queries: [Query.equal('\$id', userId)],
      );

      if (userResponse.rows.isEmpty) {
        throw Exception('Пользователь не найден');
      }

      final userRow = userResponse.rows.first;
      List<dynamic> userApplicationIds = userRow.data['applications'] ?? [];

      if (userApplicationIds.isEmpty) {
        return [];
      }

      final applications = <ApplicationModel>[];

      for (var applicationId in userApplicationIds) {
        try {
          final applicationResponse = await _tablesDB.getRow(
            databaseId: StringConstants.dbApplicationsId,
            tableId: StringConstants.tableApplicationsId,
            rowId: applicationId,
          );

          final application = ApplicationModel.fromJson({
            ...applicationResponse.data,
            '\$id': applicationResponse.$id,
          });

          if (application.status == status) {
            applications.add(application);
          }
        } catch (e) {
          null;
        }
      }

      return applications;
    } on AppwriteException catch (e) {
      throw Exception(
        'Ошибка при получении заявок пользователя по статусу: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        'Ошибка при получении заявок пользователя по статусу: $e',
      );
    }
  }

  // Получение всех заявок по статусу заявки
  Future<List<ApplicationModel>> getAllApplicationsByStatus(
    String status,
  ) async {
    try {
      final response = await _tablesDB.listRows(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        queries: [
          Query.equal('status', status),
          Query.orderDesc('\$createdAt'),
        ],
      );

      return response.rows.map((row) {
        return ApplicationModel.fromJson({...row.data, '\$id': row.$id});
      }).toList();
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при получении заявок по статусу: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при получении заявок по статусу: $e');
    }
  }

  // Создание заявки
  Future<ApplicationModel> createApplication(
    ApplicationModel application,
  ) async {
    try {
      final currentUser = await getCurrentUser();

      // Создаем заявку
      final row = await _tablesDB.createRow(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        rowId: ID.unique(),
        data: {...application.toJson()},
      );

      final createdApplication = ApplicationModel.fromJson({
        ...row.data,
        '\$id': row.$id,
      });

      await _addApplicationToUser(currentUser.id, row.$id);

      return createdApplication;
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при создании заявки: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при создании заявки: $e');
    }
  }

  // Привязка заявки к пользователю
  Future<void> _addApplicationToUser(
    String userId,
    String applicationId,
  ) async {
    try {
      // Находим запись пользователя в таблице users
      final userResponse = await _tablesDB.listRows(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        queries: [Query.equal('\$id', userId)],
      );

      if (userResponse.rows.isEmpty) {
        throw Exception('Пользователь не найден');
      }

      final userRow = userResponse.rows.first;
      List<dynamic> currentApplications = userRow.data['applications'] ?? [];

      List<String> updatedApplications = List<String>.from(currentApplications);
      if (!updatedApplications.contains(applicationId)) {
        updatedApplications.add(applicationId);
      }

      await _tablesDB.updateRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: userRow.$id,
        data: {'applications': updatedApplications},
      );
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при обновлении пользователя: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при обновлении пользователя: $e');
    }
  }

  // USER

  Future<UserModel> getCurrentUser() async {
    final appwrite_models.User user = await account.get();
    final response = await _tablesDB.listRows(
      databaseId: StringConstants.dbAuthId,
      tableId: StringConstants.tableUsersId,
      queries: [Query.equal('\$id', user.$id)],
    );

    if (response.rows.isNotEmpty) {
      final row = response.rows.first;
      return UserModel(
        id: row.$id,
        name: row.data['name'] ?? '',
        surname: row.data['surname'] ?? '',
        organization: row.data['organization'] ?? '',
        role: row.data['role'] ?? '',
        phone: row.data['phone'] ?? '',
        profileImage: row.data['profileImage'] ?? '',
      );
    } else {
      throw Exception('Пользователь не найден');
    }
  }

  Future<Map<String, dynamic>> getUserByPhone(String phone) async {
    try {
      final response = await _tablesDB.listRows(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        queries: [Query.equal('phone', phone)],
      );

      if (response.rows.isEmpty) {
        throw Exception('Пользователь не найден');
      }

      return response.rows.first.data;
    } on AppwriteException catch (e) {
      throw Exception('Ошибка получения данных о пользователе: ${e.message}');
    }
  }

  Future<void> deleteUser() async {
    try {
      final response = await _functions.createExecution(
        functionId: StringConstants.funcDeleteUserId,
      );

      final result = jsonDecode(response.responseBody);
      if (result['success'] != true) {
        throw Exception(result['message'] ?? 'Не удалось удалить пользователя');
      }

      await forceLogout();
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при удалении пользователя: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при удалении пользователя: $e');
    }
  }

  // PROFILE

  Future<String> uploadProfileImage(io.File imageFile) async {
    try {
      String filePath = imageFile.path;

      String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(filePath)}';

      final response = await _imageStorage.createFile(
        bucketId: StringConstants.bucketProfileImagesId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: filePath, filename: fileName),
      );

      final String imageUrl =
          'https://cloud.appwrite.io/v1/storage/buckets/68bc5a62002b49eb959e/files/${response.$id}/view?project=6876329200226340a8bb';

      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _account.updatePassword(
        password: newPassword,
        oldPassword: oldPassword,
      );
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при изменении пароля: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при изменении пароля: $e');
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? surname,
    String? organization,
    String? role,
    String? phone,
    String? profileImage,
  }) async {
    final appwrite_models.User user = await account.get();
    final response = await _tablesDB.listRows(
      databaseId: StringConstants.dbAuthId,
      tableId: StringConstants.tableUsersId,
      queries: [Query.equal('\$id', user.$id)],
    );

    if (response.rows.isNotEmpty) {
      final rowId = response.rows.first.$id;
      Map<String, dynamic> data = {};

      if (name != null) data['name'] = name;
      if (surname != null) data['surname'] = surname;
      if (organization != null) data['organization'] = organization;
      if (role != null) data['role'] = role;
      if (phone != null) data['phone'] = phone;
      if (profileImage != null) data['profileImage'] = profileImage;

      await _tablesDB.updateRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: rowId,
        data: data,
      );
    } else {
      throw Exception('Пользователь не найден');
    }
  }

  // AUTH - УПРОЩЕННАЯ ЛОГИКА СЕССИЙ

  Future<Session> createSession(String phone, String password) async {
    final normalizedPhone = _normalizePhone(phone);
    final email = _buildEmailFromPhone(normalizedPhone);

    // Appwrite автоматически сохранит сессию
    return await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  Future<bool> restoreSession() async {
    try {
      // Просто пытаемся получить данные пользователя
      // Если сессия валидна - получим пользователя
      await _account.get();
      return true;
    } on AppwriteException catch (e) {
      // Сессия невалидна или истекла
      print('Нет валидной сессии: ${e.message}');
      return false;
    } catch (e) {
      // Любая другая ошибка
      print('Ошибка при восстановлении сессии: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Удаляем текущую сессию через Appwrite
      await _account.deleteSession(sessionId: 'current');
    } catch (e) {
      // Игнорируем ошибки при выходе
      print('Ошибка при выходе: $e');
    }
  }

  Future<void> forceLogout() async {
    try {
      await logout();
    } catch (e) {
      // Гарантированный выход даже с ошибками
      return;
    }
  }

  Future<Map<String, dynamic>> sendVerificationCode({
    required String phone,
  }) async {
    final normalizedPhone = _normalizePhone(phone);

    try {
      final response = await _functions.createExecution(
        functionId: StringConstants.funcSendVerfCodeId,
        body: jsonEncode({'phone': normalizedPhone}),
      );

      return jsonDecode(response.responseBody);
    } on AppwriteException catch (e) {
      if (e.response != null) {
        try {
          final responseBody = jsonDecode(e.response!);
          if (responseBody['error'] == 'USER_ALREADY_EXISTS') {
            throw Exception('USER_ALREADY_EXISTS');
          }
        } catch (_) {}
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyCode({
    required String phone,
    required String code,
    required String name,
    required String surname,
    required String organization,
    required String role,
    required String password,
  }) async {
    final normalizedPhone = _normalizePhone(phone);

    final response = await _functions.createExecution(
      functionId: StringConstants.funcVerifyCodeId,
      body: jsonEncode({
        'phone': normalizedPhone,
        'code': code,
        'name': name,
        'surname': surname,
        'organization': organization,
        'role': role,
        'password': password,
      }),
    );

    return jsonDecode(response.responseBody);
  }

  String _normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    return digits.startsWith('8')
        ? '7${digits.substring(1)}'
        : digits.startsWith('7')
        ? digits
        : '7$digits';
  }

  String _buildEmailFromPhone(String phone) {
    return '$phone@vezemzerno.com';
  }
}
