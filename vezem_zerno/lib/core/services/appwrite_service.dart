import 'dart:io' as io;
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vezem_zerno/features/auth/data/models/user_model.dart';
import 'package:path/path.dart' as path;

class AppwriteService {
  late final Client _client;
  late final Account _account;
  late final Functions _functions;
  late final Databases _databases;
  late final Storage _imageStorage;

  final _storage = const FlutterSecureStorage();
  static const _sessionKey = 'session_id';

  Account get account => _account;

  AppwriteService() {
    _client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('6876329200226340a8bb');

    _account = Account(_client);
    _functions = Functions(_client);
    _databases = Databases(_client);
    _imageStorage = Storage(_client);
  }

  // USER

  Future<UserModel> getCurrentUser() async {
    final appwrite_models.User user = await account.get();
    final docs = await _databases.listDocuments(
      databaseId: '687f60b70012988ce25a',
      collectionId: '687f723c0008097bda88',
      queries: [Query.equal('userId', user.$id)],
    );
    if (docs.documents.isNotEmpty) {
      final doc = docs.documents.first;
      return UserModel(
        id: doc.$id,
        name: doc.data['name'] ?? '',
        surname: doc.data['surname'] ?? '',
        organization: doc.data['organization'] ?? '',
        role: doc.data['role'] ?? '',
        phone: doc.data['phone'] ?? '',
        profileImage: doc.data['profileImage'] ?? '',
      );
    } else {
      throw Exception('Пользователь не найден');
    }
  }

  Future<Map<String, dynamic>> getUserByPhone(String phone) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: '687f60b70012988ce25a',
        collectionId: '687f723c0008097bda88',
        queries: [Query.equal('phone', phone)],
      );

      if (response.documents.isEmpty) {
        throw Exception('Пользователь не найден');
      }

      return response.documents.first.data;
    } on AppwriteException catch (e) {
      throw Exception('Ошибка получения данных о пользователе: ${e.message}');
    }
  }

  Future<void> deleteUser() async {
    try {
      final user = await _account.get();
      final userId = user.$id;

      final response = await _functions.createExecution(
        functionId: '68cde36900053573d8ab',
        body: jsonEncode({'userId': userId}),
      );

      final result = jsonDecode(response.responseBody);
      if (result['success'] != true) {
        throw Exception(result['message'] ?? 'Не удалось удалить пользователя');
      }

      await logout();
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
        bucketId: '68bc5a62002b49eb959e',
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

  Future<void> updateUserProfile({
    String? name,
    String? surname,
    String? organization,
    String? role,
    String? phone,
    String? profileImage,
  }) async {
    final appwrite_models.User user = await account.get();
    final docs = await _databases.listDocuments(
      databaseId: '687f60b70012988ce25a',
      collectionId: '687f723c0008097bda88',
      queries: [Query.equal('userId', user.$id)],
    );
    if (docs.documents.isNotEmpty) {
      final docId = docs.documents.first.$id;
      Map<String, dynamic> data = {};

      if (name != null) data['name'] = name;
      if (surname != null) data['surname'] = surname;
      if (organization != null) data['organization'] = organization;
      if (role != null) data['role'] = role;
      if (phone != null) data['phone'] = phone;
      if (profileImage != null) data['profileImage'] = profileImage;

      await _databases.updateDocument(
        databaseId: '687f60b70012988ce25a',
        collectionId: '687f723c0008097bda88',
        documentId: docId,
        data: data,
      );
    } else {
      throw Exception('Пользователь не найден');
    }
  }

  // SESSION

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
    final sessionId = await _storage.read(key: _sessionKey);
    if (sessionId != null) {
      try {
        _client.setSession(sessionId);
        await _account.get();
        return true;
      } catch (e) {
        await _storage.delete(key: _sessionKey);
        return false;
      }
    }
    return false;
  }

  // AUTH

  Future<void> logout() async {
    try {
      final sessionId = await _storage.read(key: _sessionKey);
      if (sessionId != null) {
        await _account.deleteSession(sessionId: sessionId);
      }
    } on AppwriteException catch (e) {
      if (e.code != 401) {
        rethrow;
      }
    } finally {
      await _storage.delete(key: _sessionKey);
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
        functionId: '687f672c003d9a81e0d6',
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
      functionId: '687f73a60022fe36c951',
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
