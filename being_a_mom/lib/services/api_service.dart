import 'package:dio/dio.dart';
import '../models/child.dart';
import '../models/message.dart';
import 'storage_service.dart';

class ApiService {
  final StorageService _storage;
  late Dio _dio;

  // Update this to your server IP
  static const String baseUrl = 'http://127.0.0.1:8000';

  ApiService(this._storage) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Token $token';
        }
        return handler.next(options);
      },
    ));
  }

  // Authentication
  Future<Map<String, dynamic>> register(String username, String password, String email) async {
    final response = await _dio.post('/api/register/', data: {
      'username': username,
      'password': password,
      'email': email,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _dio.post('/api/login/', data: {
      'username': username,
      'password': password,
    });

    if (response.data['user_id'] != null) {
      await _storage.setUserId(response.data['user_id']);
      await _storage.setUsername(response.data['username']);
      await _storage.setToken('token_${response.data['user_id']}');
    }

    return response.data;
  }

  Future<void> logout() async {
    await _dio.get('/api/logout/');
    await _storage.clearAll();
  }

  // Child profiles
  Future<Child> createChild(String name, DateTime birthDate, String? avatarUrl) async {
    final response = await _dio.post('/api/children/create/', data: {
      'name': name,
      'birth_date': birthDate.toIso8601String().split('T')[0],
      'avatar_url': avatarUrl ?? '',
    });

    return Child.fromJson(response.data);
  }

  Future<List<Child>> getChildren() async {
    final response = await _dio.get('/api/children/');
    final List<dynamic> childrenJson = response.data['children'];
    return childrenJson.map((json) => Child.fromJson(json)).toList();
  }

  // Chat
  Future<String> sendMessage(String message, int? childId) async {
    final response = await _dio.post('/api/chat/', data: {
      'message': message,
      'child_id': childId,
    });
    return response.data['response'];
  }

  // Image analysis
  Future<Map<String, dynamic>> analyzeImage(String imageUrl, int? childId, String description) async {
    final response = await _dio.post('/api/analyze-image/', data: {
      'image_url': imageUrl,
      'child_id': childId,
      'description': description,
    });
    return response.data;
  }

  // Health logs
  Future<void> createHealthLog(int childId, String logType, String description, String? imageUrl) async {
    await _dio.post('/api/health-log/', data: {
      'child_id': childId,
      'log_type': logType,
      'description': description,
      'image_url': imageUrl ?? '',
    });
  }

  Future<List<Map<String, dynamic>>> getHealthLogs(int childId) async {
    final response = await _dio.get('/api/health-logs/$childId/');
    return List<Map<String, dynamic>>.from(response.data['health_logs']);
  }
}