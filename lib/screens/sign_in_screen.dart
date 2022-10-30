import 'package:docs_clone/models/error.dart';
import 'package:docs_clone/providers/auth_provider.dart';
import 'package:docs_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});


  void signInUsingGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final ErrorModel errorModel =
        await ref.read(authenticationProvider).signInWithGoogle();
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace('/'); 
    } else {
      
      sMessenger.showSnackBar(SnackBar(
        content: Text(errorModel.error!),
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInUsingGoogle(ref, context),
          icon: const Icon(
            CarbonIcons.logo_google,
            color: Colors.blue,
          ),
          label: const Text(
            "Sign in",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(150, 50),
          ),
        ),
      ),
    );
  }
}
