import 'dart:io' as io;
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:vezem_zerno/core/constants/string_constants.dart';
import 'package:vezem_zerno/features/auth/data/models/user_model.dart';
import 'package:path/path.dart' as path;
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

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

  Future<List<ApplicationModel>> getUserResponses() async {
    try {
      final user = await _account.get();

      final userRow = await _tablesDB.getRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: user.$id,
      );

      final List<dynamic> responseIds = userRow.data['responses'] ?? [];

      if (responseIds.isEmpty) return [];

      final responses = await Future.wait(
        responseIds.map((id) async {
          try {
            final response = await _tablesDB.getRow(
              databaseId: StringConstants.dbApplicationsId,
              tableId: StringConstants.tableApplicationsId,
              rowId: id.toString(),
            );

            return ApplicationModel.fromJson({
              ...response.data,
              '\$id': response.$id,
            });
          } catch (e, stackTrace) {
            debugPrint('Ошибка при получении заявки $id: $e\n$stackTrace');
            return null;
          }
        }),
      );
      return responses.whereType<ApplicationModel>().toList();
    } on AppwriteException catch (e) {
      throw Exception('Не удалось получить заявки пользователя: ${e.message}');
    } catch (e) {
      throw Exception('Не удалось получить заявки пользователя: $e');
    }
  }

  Future<void> respondToApplicaiton({required String applicationId}) async {
    try {
      final User user = await _account.get();

      final userRow = await _tablesDB.getRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: user.$id,
      );

      List<dynamic> currentResponses = userRow.data['responses'] ?? [];

      List<String> updatedResponses = List<String>.from(currentResponses);
      if (!updatedResponses.contains(applicationId)) {
        updatedResponses.add(applicationId);
      }

      await _tablesDB.updateRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: userRow.$id,
        data: {'responses': updatedResponses},
      );
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при обновлении пользователя: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при обновлении пользователя: $e');
    }
  }

  // Получение заявок пользователя по статусу заявки
  Future<List<ApplicationModel>> getUserApplicationsByStatus({
    required String applicationStatus,
  }) async {
    try {
      final user = await _account.get();

      final userRow = await _tablesDB.getRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: user.$id,
      );

      final List<dynamic> applicationIds = userRow.data['applications'] ?? [];

      if (applicationIds.isEmpty) {
        return [];
      }

      final applicationsResponse = await _tablesDB.listRows(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        queries: [
          Query.contains(
            '\$id',
            applicationIds.map((e) => e.toString()).toList(),
          ),
          Query.equal('status', applicationStatus),
        ],
      );

      final applications = applicationsResponse.rows.map((row) {
        return ApplicationModel.fromJson({...row.data, '\$id': row.$id});
      }).toList();

      return applications;
    } on AppwriteException catch (e) {
      throw Exception('Не удалось получить заявки пользователя: ${e.message}');
    } catch (e) {
      throw Exception('Не удалось получить заявки пользователя: $e');
    }
  }

  // Получение всех заявок по статусу заявки
  Future<List<ApplicationModel>> getApplicationsByStatus({
    required String applicationStatus,
    bool descending = true,
  }) async {
    try {
      final queries = <String>[
        Query.equal('status', applicationStatus),
        descending
            ? Query.orderDesc('\$createdAt')
            : Query.orderAsc('\$createdAt'),
      ];

      final response = await _tablesDB.listRows(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        queries: queries,
      );

      final applications = response.rows.map((row) {
        return ApplicationModel.fromJson({...row.data, '\$id': row.$id});
      }).toList();

      return applications;
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при получении заявок по статусу: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при получении заявок по статусу: $e');
    }
  }

  /// Создание новой заявки и привязка её к пользователю
  Future<ApplicationModel> createApplication({
    String? comment,
    bool? charter,
    bool? dumpTrucks,
    required String loadingPlace,
    required String loadingMethod,
    required String loadingDate,
    required String unloadingPlace,
    required String crop,
    required String tonnage,
    required String distance,
    required String scalesCapacity,
    required String price,
    required String downtime,
    required String shortage,
    required String paymentTerms,
    required String paymentMethod,
    required String status,
  }) async {
    try {
      final currentUser = await getCurrentUserDocument();

      final application = ApplicationModel(
        organization: currentUser.organization ?? '',
        customerId: currentUser.id,
        loadingPlace: loadingPlace,
        unloadingPlace: unloadingPlace,
        distance: distance,
        crop: crop,
        tonnage: tonnage,
        comment: comment ?? '',
        loadingMethod: loadingMethod,
        loadingDate: loadingDate,
        scalesCapacity: scalesCapacity,
        price: price,
        downtime: downtime,
        shortage: shortage,
        paymentTerms: paymentTerms,
        dumpTrucks: dumpTrucks ?? false,
        charter: charter ?? false,
        paymentMethod: paymentMethod,
        status: status,
      );

      final row = await _tablesDB.createRow(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        rowId: ID.unique(),
        data: application.toJson(),
      );

      final createdApplication = ApplicationModel.fromJson({
        ...row.data,
        '\$id': row.$id,
      });

      await _addApplicationToUser(currentUser.id, row.$id);

      debugPrint(
        '✅ Заявка ${row.$id} успешно создана пользователем ${currentUser.id}',
      );
      return createdApplication;
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при создании заявки: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при создании заявки: $e');
    }
  }

  /// Привязка заявки к пользователю
  Future<void> _addApplicationToUser(
    String userId,
    String applicationId,
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

      final currentApplications = List<String>.from(
        userRow.data['applications'] ?? const <String>[],
      );

      if (!currentApplications.contains(applicationId)) {
        currentApplications.add(applicationId);

        await _tablesDB.updateRow(
          databaseId: StringConstants.dbAuthId,
          tableId: StringConstants.tableUsersId,
          rowId: userRow.$id,
          data: {'applications': currentApplications},
        );
      }
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при обновлении пользователя: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при обновлении пользователя: $e');
    }
  }

  // USER
  Future<UserModel> getCurrentUserDocument() async {
    final User user = await _account.get();

    final userRow = await _tablesDB.getRow(
      databaseId: StringConstants.dbAuthId,
      tableId: StringConstants.tableUsersId,
      rowId: user.$id,
    );

    if (userRow.data.isNotEmpty) {
      final userData = userRow.data;
      return UserModel(
        id: user.$id,
        name: userData['name'] ?? '',
        surname: userData['surname'] ?? '',
        organization: userData['organization'] ?? '',
        role: userData['role'] ?? '',
        phone: userData['phone'] ?? '',
        profileImage: userData['profileImage'] ?? '',
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
    final User user = await _account.get();
    final response = await _tablesDB.getRow(
      databaseId: StringConstants.dbAuthId,
      tableId: StringConstants.tableUsersId,
      rowId: user.$id,
    );

    if (response.data.isNotEmpty) {
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
        rowId: user.$id,
        data: data,
      );
    } else {
      throw Exception('Пользователь не найден');
    }
  }

  // AUTH
  Future<Session> createSession(String phone, String password) async {
    final normalizedPhone = _normalizePhone(phone);
    final email = _buildEmailFromPhone(normalizedPhone);
    return await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  Future<bool> restoreSession() async {
    try {
      await _account.get();
      return true;
    } on AppwriteException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }

  Future<void> forceLogout() async {
    await logout();
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

  Future<void> requestPasswordReset({required String phone}) async {
    try {
      final normalizedPhone = _normalizePhone(phone);

      final response = await _functions.createExecution(
        functionId: StringConstants.funcRequestPasswordResetId,
        body: jsonEncode({'phone': normalizedPhone}),
      );

      return jsonDecode(response.responseBody);
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при запросе сброса пароля: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при запросе сброса пароля: $e');
    }
  }

  Future<void> confirmPasswordReset({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    try {
      final normalizedPhone = _normalizePhone(phone);

      final response = await _functions.createExecution(
        functionId: StringConstants.funcConfirmPasswordResetId,
        body: jsonEncode({
          'phone': normalizedPhone,
          'code': code,
          'newPassword': newPassword,
        }),
      );

      final result = jsonDecode(response.responseBody);
      if (result['success'] != true) {
        throw Exception(result['message'] ?? 'Не удалось сбросить пароль');
      }
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при сбросе пароля: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при сбросе пароля: $e');
    }
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
