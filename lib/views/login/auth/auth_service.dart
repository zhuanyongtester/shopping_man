import '../../../network/network_service.dart';


class AuthService {
  final NetworkService _networkService;

  AuthService(String baseUrl) : _networkService = NetworkService(baseUrl);

  Future<dynamic> login(String username, String password) async {
    return await _networkService.post('/login', body: {
      'username': username,
      'password': password,
    });
  }

  Future<dynamic> register(String username, String password, String email) async {
    return await _networkService.post('/register', body: {
      'username': username,
      'password': password,
      'email': email,
    });
  }
  Future<dynamic> forgot(String username, String password ) async {
    return await _networkService.post('/forgot', body: {
      'username': username,
      'password': password,
    });
  }
}
