import 'package:docs_clone/services/auth_service.dart';
import 'package:docs_clone/services/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authenticationProvider = Provider<AuthService>((ref) {
  return AuthService(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageService: LocalStorageService(),
  );
});
