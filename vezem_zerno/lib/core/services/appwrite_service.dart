import 'dart:io' as io;
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:vezem_zerno/core/constants/string_constants.dart';
import 'package:path/path.dart' as path;
import 'package:vezem_zerno/core/models/application_model.dart';
import 'package:vezem_zerno/core/models/user_model.dart';
import 'package:vezem_zerno/features/filter/data/models/application_filter_model.dart';

class AppwriteService {
  late final Client _client;
  late final Account _account;
  late final Functions _functions;
  late final Storage _imageStorage;
  late final TablesDB _tablesDB;

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

  // Отметить заявку выполненной (Заказчик)
  Future<void> markApplicationCompleted({required String applicationId}) async {
    try {
      await _tablesDB.updateRow(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        rowId: applicationId,
        data: {'status': 'completed'},
      );
    } on AppwriteException catch (e) {
      throw Exception('Не удалось завершить заявку: ${e.message}');
    } catch (e) {
      throw Exception('Не удалось завершить заявку: $e');
    }
  }

  // Отметить заявку доставленной (Перевозчик)
  Future<void> markApplicationDelivered({required String applicationId}) async {
    try {
      await _tablesDB.updateRow(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        rowId: applicationId,
        data: {'delivered': true},
      );
    } on AppwriteException catch (e) {
      throw Exception(
        'Не удалось отметить заявку, как завершённая: ${e.message}',
      );
    } catch (e) {
      throw Exception('Не удалось отметить заявку, как завершённая: $e');
    }
  }

  // Принять отклик на заявку (Заказчик)
  Future<void> acceptResponse({
    required String carrierId,
    required String applicationId,
  }) async {
    try {
      final userRow = await _tablesDB.getRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: carrierId,
        queries: [
          Query.select(['applications', 'responses']),
        ],
      );

      final currentApplications = List<String>.from(
        userRow.data['applications'] ?? [],
      );
      final currentResponses = List<String>.from(
        userRow.data['responses'] ?? [],
      );

      final updatedApplications = currentApplications.contains(applicationId)
          ? currentApplications
          : [...currentApplications, applicationId];

      final updatedResponses = currentResponses
          .where((id) => id != applicationId)
          .toList();

      await Future.wait([
        _tablesDB.updateRow(
          databaseId: StringConstants.dbAuthId,
          tableId: StringConstants.tableUsersId,
          rowId: carrierId,
          data: {
            'applications': updatedApplications,
            'responses': updatedResponses,
          },
        ),
        _tablesDB.updateRow(
          databaseId: StringConstants.dbApplicationsId,
          tableId: StringConstants.tableApplicationsId,
          rowId: applicationId,
          data: {
            'status': 'processing',
            'responses': null,
            'carrierID': carrierId,
          },
        ),
      ]);
    } on AppwriteException catch (e) {
      throw Exception('Не удалось принять отклик по заявке: ${e.message}');
    } catch (e) {
      throw Exception('Не удалось принять отклик по заявке: $e');
    }
  }

  // Получение заявок пользователя
  Future<List<ApplicationModel>> getUserResponses({required String userId}) async {
    try {
      final userRow = await _tablesDB.getRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: userId,
        queries: [
          Query.select(['responses']),
        ],
      );

      final List<dynamic> responsesData = userRow.data['responses'] ?? [];

      if (responsesData.isEmpty) return [];

      final List<String> responsesIDs = List<String>.from(responsesData);

      final responses = await _tablesDB.listRows(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        queries: [Query.contains('\$id', responsesIDs)],
      );

      return responses.rows
          .map((row) => ApplicationModel.fromJson(row.data..['\$id'] = row.$id))
          .toList();
    } on AppwriteException catch (e) {
      throw Exception('Не удалось получить заявки пользователя: ${e.message}');
    } catch (e) {
      throw Exception('Не удалось получить заявки пользователя: $e');
    }
  }

  // Откликнуться на заявку
  Future<void> respondToApplication({required String applicationId, required String userId}) async {
    try {

      final userFuture = _tablesDB.getRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: userId,
        queries: [
          Query.select(['responses']),
        ],
      );

      final applicationFuture = _tablesDB.getRow(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        rowId: applicationId,
        queries: [
          Query.select(['responses']),
        ],
      );

      final userRow = await userFuture;
      final applicationRow = await applicationFuture;

      final userResponses = List<String>.from(userRow.data['responses'] ?? []);
      final applicationResponses = List<String>.from(
        applicationRow.data['responses'] ?? [],
      );

      final bool needUserUpdate = !userResponses.contains(applicationId);
      final bool needApplicationUpdate = !applicationResponses.contains(userId);

      if (!needUserUpdate && !needApplicationUpdate) return;

      final updates = <Future>[];

      if (needUserUpdate) {
        updates.add(
          _tablesDB.updateRow(
            databaseId: StringConstants.dbAuthId,
            tableId: StringConstants.tableUsersId,
            rowId: userId,
            data: {
              'responses': [...userResponses, applicationId],
            },
          ),
        );
      }

      if (needApplicationUpdate) {
        updates.add(
          _tablesDB.updateRow(
            databaseId: StringConstants.dbApplicationsId,
            tableId: StringConstants.tableApplicationsId,
            rowId: applicationId,
            data: {
              'responses': [...applicationResponses, userId],
            },
          ),
        );
      }

      if (updates.isNotEmpty) {
        await Future.wait(updates);
      }
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при отклике на заявку: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при отклике на заявку: $e');
    }
  }

  // Получение откликов на заявку
  Future<List<UserModel>> getApplicationResponses({
    required String applicationId,
  }) async {
    try {
      final applicationRow = await _tablesDB.getRow(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        rowId: applicationId,
        queries: [
          Query.select(['responses']),
        ],
      );

      final List<dynamic> responsesData =
          applicationRow.data['responses'] ?? [];

      if (responsesData.isEmpty) return [];

      final List<String> responses = List<String>.from(responsesData);

      final usersResponse = await _tablesDB.listRows(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        queries: [Query.contains('\$id', responses)],
      );

      return usersResponse.rows
          .map((row) => UserModel.fromJson(row.data..['\$id'] = row.$id))
          .toList();
    } on AppwriteException catch (e) {
      throw Exception(
        'Не удалось получить откликнувшихся пользователей: ${e.message}',
      );
    } catch (e) {
      throw Exception('Не удалось получить откликнувшихся пользователей: $e');
    }
  }

  // Получение заявок пользователя по статусу заявки
  Future<List<ApplicationModel>> getUserApplicationsByStatus({
    required String applicationStatus,
    required String userId,
  }) async {
    try {
      final userRow = await _tablesDB.getRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: userId,
        queries: [
          Query.select(['applications']),
        ],
      );

      final List<dynamic> applicationsIds = userRow.data['applications'] ?? [];

      if (applicationsIds.isEmpty) {
        return [];
      }

      final List<String> appsIds = List<String>.from(applicationsIds);

      final applicationsResponse = await _tablesDB.listRows(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        queries: [Query.contains('\$id', appsIds), Query.equal('status', applicationStatus)],
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

  double? _parsePrice(String priceStr) {
    try {
      final cleanStr = priceStr
          .replaceAll('₽', '')
          .replaceAll('/кг', '')
          .replaceAll(',', '.')
          .replaceAll(RegExp(r'[^\d.]'), '')
          .trim();
      return double.tryParse(cleanStr);
    } catch (e) {
      return null;
    }
  }

  double? _parseDistance(String distanceStr) {
    try {
      final cleanStr = distanceStr
          .replaceAll('км', '')
          .replaceAll(',', '.')
          .replaceAll(RegExp(r'[^\d.]'), '')
          .trim();
      return double.tryParse(cleanStr);
    } catch (e) {
      return null;
    }
  }

  List<ApplicationModel> _applyNumericFilters(
    List<ApplicationModel> applications,
    ApplicationFilter filter,
  ) {
    return applications.where((app) {
      // Фильтр по цене
      if (filter.minPrice != null || filter.maxPrice != null) {
        final price = _parsePrice(app.price);
        if (price == null) return false;

        if (filter.minPrice != null && price < filter.minPrice!) return false;
        if (filter.maxPrice != null && price > filter.maxPrice!) return false;
      }

      // Фильтр по расстоянию
      if (filter.minDistance != null || filter.maxDistance != null) {
        final distance = _parseDistance(app.distance);
        if (distance == null) return false;

        if (filter.minDistance != null && distance < filter.minDistance!) {
          return false;
        }
        if (filter.maxDistance != null && distance > filter.maxDistance!) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Получение всех заявок по статусу заявки
  Future<List<ApplicationModel>> getApplicationsByStatusWithFilter({
    required String applicationStatus,
    ApplicationFilter? filter,
  }) async {
    try {
      final queries = <String>[
        Query.equal('status', applicationStatus),
        Query.orderDesc('\$createdAt'),
      ];

      if (filter != null) {
        if (filter.loadingRegion != null && filter.loadingRegion!.isNotEmpty) {
          queries.add(Query.equal('loadingRegion', filter.loadingRegion));
        }

        if (filter.unloadingRegion != null &&
            filter.unloadingRegion!.isNotEmpty) {
          queries.add(Query.equal('unloadingRegion', filter.unloadingRegion));
        }

        if (filter.crop != null && filter.crop!.isNotEmpty) {
          queries.add(Query.equal('crop', filter.crop!));
        }

        if (filter.suitableForDumpTrucks) {
          queries.add(Query.equal('dumpTrucks', true));
        }

        if (filter.charterCarrier) {
          queries.add(Query.equal('charter', true));
        }

        if (filter.dateFilter != DateFilter.any) {
          final now = DateTime.now();
          DateTime startDate;

          switch (filter.dateFilter) {
            case DateFilter.last3Days:
              startDate = now.subtract(const Duration(days: 3));
              break;
            case DateFilter.last5Days:
              startDate = now.subtract(const Duration(days: 5));
              break;
            case DateFilter.last7Days:
              startDate = now.subtract(const Duration(days: 7));
              break;
            case DateFilter.any:
              startDate = now;
              break;
          }

          if (filter.dateFilter != DateFilter.any) {
            queries.add(
              Query.greaterThanEqual('\$createdAt', startDate.toString()),
            );
          }
        }
      }

      final response = await _tablesDB.listRows(
        databaseId: StringConstants.dbApplicationsId,
        tableId: StringConstants.tableApplicationsId,
        queries: queries,
      );

      List<ApplicationModel> applications = response.rows.map((row) {
        return ApplicationModel.fromJson({...row.data, '\$id': row.$id});
      }).toList();

      if (filter != null) {
        applications = _applyNumericFilters(applications, filter);
      }

      return applications;
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при получении заявок с фильтром: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при получении заявок с фильтром: $e');
    }
  }

  /// Создание новой заявки и привязка её к пользователю
  Future<ApplicationModel> createApplication({
    String? comment,
    bool? charter,
    bool? dumpTrucks,
    required String loadingRegion,
    required String loadingLocality,
    required String unloadingRegion,
    required String unloadingLocality,
    required String loadingMethod,
    required String loadingDate,
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
    required String userId,
  }) async {
    try {
      final userRow = await _tablesDB.getRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: userId,
        queries: [
          Query.select(['organization'])
        ]
      );

      final application = ApplicationModel(
        organization: userRow.data['organization'],
        customerId: userId,
        loadingRegion: loadingRegion,
        loadingLocality: loadingLocality,
        unloadingRegion: unloadingRegion,
        unloadingLocality: unloadingLocality,
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
        responses: null,
        carrier: null,
        delivered: false,
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

      await _addApplicationToUser(userId, row.$id);

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
      final userRow = await _tablesDB.getRow(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        rowId: userId,
        queries: [
          Query.select(["applications"]),
        ],
      );

      final currentApplications = List<String>.from(
        userRow.data['applications'] ?? [],
      );
      if (!currentApplications.contains(applicationId)) {
        await _tablesDB.updateRow(
          databaseId: StringConstants.dbAuthId,
          tableId: StringConstants.tableUsersId,
          rowId: userId,
          data: {
            'applications': [...currentApplications, applicationId],
          },
        );
      }
    } on AppwriteException catch (e) {
      throw Exception('Ошибка при обновлении пользователя: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при обновлении пользователя: $e');
    }
  }

  //USER
  Future<UserModel> getUserById({required String userId}) async {
    final userRow = await _tablesDB.getRow(
      databaseId: StringConstants.dbAuthId,
      tableId: StringConstants.tableUsersId,
      rowId: userId,
    );

    if (userRow.data.isNotEmpty) {
      final userData = userRow.data;
      return UserModel(
        id: userId,
        name: userData['name'] ?? '',
        surname: userData['surname'] ?? '',
        organization: userData['organization'] ?? '',
        role: userData['role'] ?? '',
        phone: userData['phone'] ?? '',
        profileImage: userData['profileImage'] ?? '',
        responses: userData['respones'] == null
            ? null
            : List<String>.from(userData['respones']),
        applications: userData['applications'] == null
            ? null
            : List<String>.from(userData['applications']),
      );
    } else {
      throw Exception('Пользователь не найден');
    }
  }

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
        responses: userData['respones'] == null
            ? null
            : List<String>.from(userData['respones']),
        applications: userData['applications'] == null
            ? null
            : List<String>.from(userData['applications']),
      );
    } else {
      throw Exception('Пользователь не найден');
    }
  }

  Future<UserModel> getUserByPhone(String phone) async {
    try {
      final response = await _tablesDB.listRows(
        databaseId: StringConstants.dbAuthId,
        tableId: StringConstants.tableUsersId,
        queries: [Query.equal('phone', phone)],
      );

      if (response.rows.isEmpty) {
        throw Exception('Пользователь не найден');
      }

      final userData = response.rows.first.data;
      return UserModel(
        id: userData['\$id'],
        name: userData['name'] ?? '',
        surname: userData['surname'] ?? '',
        organization: userData['organization'] ?? '',
        role: userData['role'] ?? '',
        phone: userData['phone'] ?? '',
        profileImage: userData['profileImage'] ?? '',
        responses: userData['respones'] == null
            ? null
            : List<String>.from(userData['respones']),
        applications: userData['applications'] == null
            ? null
            : List<String>.from(userData['applications']),
      );
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
    required String userId 
  }) async {
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
        rowId: userId,
        data: data,
      );
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
