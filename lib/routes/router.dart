import 'package:docs_clone/screen/home_view.dart';
import 'package:docs_clone/screen/log_in_view.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../screen/document_view.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginView()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: HomeView()),
  '/document/:id': (route) => MaterialPage(
          child: DocumentView(
        id: route.pathParameters['id'] ?? '',
      )),
});
