import 'dart:io' as io;
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vezem_zerno/core/constants/string_constants.dart';
import 'package:vezem_zerno/features/auth/data/models/user_model.dart';
import 'package:path/path.dart' as path;

class AppwriteService {
  late final Client _client;
  late final Account _account;
  late final Functions _functions;
  late final Storage _imageStorage;
  late final TablesDB _tablesDB;

  final _storage = const FlutterSecureStorage();
  static const _sessionKey = 'session_id';

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

  // USER

  Future<UserModel> getCurrentUser() async {
    final appwrite_models.User user = await account.get();
    final response = await _tablesDB.listRows(
      databaseId: StringConstants.dbAuthId,
      tableId: StringConstants.tableUsersId,
      queries: [Query.equal('userId', user.$id)],
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

  //PROFILE

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
      queries: [Query.equal('userId', user.$id)],
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

  // AUTH
  Future<void> saveSession(String sessionId) async {
    await _storage.write(key: _sessionKey, value: sessionId);
  }

  Future<Session> createSession(String phone, String password) {
    final normalizedPhone = _normalizePhone(phone);
    final email = _buildEmailFromPhone(normalizedPhone);

    return _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  Future<bool> restoreSession() async {
    try {
      final sessionId = await _storage.read(key: _sessionKey);

      if (sessionId == null || sessionId.isEmpty) {
        return false;
      }

      _client.setSession(sessionId);

      try {
        await _account.getSession(sessionId: sessionId);
        return true;
      } on AppwriteException catch (e) {
        if (_isSessionInvalid(e)) {
          await forceLogout();
          return false;
        }
        rethrow;
      }
    } catch (e) {
      return false;
    }
  }

  bool _isSessionInvalid(AppwriteException e) {
    return e.code == 401 ||
        e.code == 404 ||
        e.message?.contains('session') == true &&
            e.message?.contains('invalid') == true;
  }

  Future<void> logout() async {
    String? sessionId;
    try {
      sessionId = await _storage.read(key: _sessionKey);
      if (sessionId != null) {
        await _account.deleteSession(sessionId: sessionId);
      }
    } finally {
      if (sessionId != null) {
        await _storage.delete(key: _sessionKey);
      }
      _client.setSession('');
    }
  }

  Future<void> forceLogout() async {
    try {
      await _storage.delete(key: _sessionKey);
      _client.setSession('');
    } catch (e) {
      return;
    }
  }

  Future<Map<String, dynamic>> sendVerificationCode({
    required String phone,
    required String name,
    required String surname,
    required String organization,
    required String role,
    required String password,
  }) async {
    final normalizedPhone = _normalizePhone(phone);
    final email = _buildEmailFromPhone(normalizedPhone);

    try {
      final response = await _functions.createExecution(
        functionId: StringConstants.funcSendVerfCodeId,
        body: jsonEncode({
          'phone': normalizedPhone,
          'email': email,
          'name': name,
          'surname': surname,
          'organization': organization,
          'role': role,
          'password': password,
        }),
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
  }) async {
    final normalizedPhone = _normalizePhone(phone);

    final response = await _functions.createExecution(
      functionId: StringConstants.funcVerifyCodeId,
      body: jsonEncode({'phone': normalizedPhone, 'code': code}),
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
    return '$phone@example.com';
  }
}
