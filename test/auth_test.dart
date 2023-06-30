import 'package:noting/services/auth/auth_exception.dart';
import 'package:noting/services/auth/auth_provider.dart';
import 'package:noting/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;
  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
     if (!isInitialized) {
      throw NotInitializedException();
    }
    if(email == "foo") throw UserNotFoundException();
    if(password == "bar") throw WrongPasswordException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async{
     if (!isInitialized) {
       throw NotInitializedException();
     }

    if(_user == null) {
      throw UserNotFoundException();
    }

    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async{
     if (!isInitialized) {
       throw NotInitializedException();
     }
    final user = _user;
    if(user == null)
    {
      throw UserNotFoundException();
    }
    _user = const AuthUser(isEmailVerified: true);
  }
}
