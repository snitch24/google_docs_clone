import 'package:docs_clone/models/error.dart';
import 'package:docs_clone/models/user.dart';
import 'package:docs_clone/providers/auth_provider.dart';
import 'package:docs_clone/providers/user_provider.dart';
import 'package:docs_clone/screens/home_screen.dart';
import 'package:docs_clone/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    errorModel = await ref.read(authenticationProvider).getUserData();
    print("Get user Data called");
    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
    print(errorModel!.error??"Recieved Null in this too");
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return MaterialApp(
      title: 'Docs Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: user == null ? const SignInScreen() : const HomeScreen(),
    );
  }
}
