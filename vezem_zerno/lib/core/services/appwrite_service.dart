import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppwriteService {
  late final Client _client;
  late final Account _account;
  late final Functions _functions;
  late final Databases _databases;

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
  }

  Future<void> saveSession(String sessionId) async {
    await _storage.write(key: _sessionKey, value: sessionId);
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

  Future<void> logout() async {
    try {
      final sessionId = await _storage.read(key: _sessionKey);
      if (sessionId != null) {
        await _account.deleteSession(sessionId: sessionId);
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

  Future<Session> createSession(String phone, String password) {
    final normalizedPhone = _normalizePhone(phone);
    final email = _buildEmailFromPhone(normalizedPhone);

    return _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
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
