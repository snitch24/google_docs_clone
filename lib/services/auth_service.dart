import 'dart:convert';

import 'package:docs_clone/constants/url_constants.dart';
import 'package:docs_clone/models/error.dart';
import 'package:docs_clone/models/user.dart';
import 'package:docs_clone/services/local_storage_service.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

class AuthService {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageService _localStorageService;
  AuthService({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorageService localStorageService,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageService = localStorageService;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = User(
          email: user.email,
          name: user.displayName ?? '',
          profilePic: user.photoUrl ?? '',
          uid: '',
          token: '',
        ); 

        var res = await _client.post(
            Uri.parse('${URLConstants.host}/api/signup'),
            body: userAcc.toJson(),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            });

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(error: null, data: newUser);
            _localStorageService.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _localStorageService.getToken();

      if (token != null) {
        var res =
            await _client.get(Uri.parse('${URLConstants.host}/'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });
        switch (res.statusCode) {
          case 200:
            final newUser = User.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);
            print(newUser.email);
            error = ErrorModel(error: null, data: newUser);
            _localStorageService.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorageService.setToken('');
  }
}
