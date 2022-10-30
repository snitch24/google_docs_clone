import 'package:docs_clone/screens/document_screen.dart';
import 'package:docs_clone/screens/home_screen.dart';
import 'package:docs_clone/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class AppRoutes {
  static final loggedOutRoute = RouteMap(routes: {
    '/': (route) => const MaterialPage(child: SignInScreen()),
  });
  static final loggedInRoute = RouteMap(routes: {
    '/': (route) => const MaterialPage(child: HomeScreen()),
    '/document/:id': (route) => MaterialPage(
          child: DocumentScreen(
            id: route.pathParameters['id'] ?? " ",
          ),
        ),
  });
}
