import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lemme_in_profofconc/blocs/blocs.dart';
import '../screens/screens.dart';

class AppRouter {
  final AppBloc appState;
  AppRouter(this.appState);

  late final GoRouter router = GoRouter(
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
            path: '/login',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            },
            routes: [
              GoRoute(
                path: 'signup',
                builder: (BuildContext context, GoRouterState state) {
                  return const SignupScreen();
                },
              ),
            ]),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = appState.state.status == AppStatus.authenticated;
        final bool loggingIn = state.matchedLocation == '/login';
        final bool signingUp = state.matchedLocation == '/login/signup';

        if (!loggedIn) {
          if (signingUp) {
            return signingUp ? null : '/signup';
          }
          return loggingIn ? null : '/login';
        }

        if (loggingIn) {
          return '/';
        }

        return null;
      },
      refreshListenable: GoRouterRefreshStream(appState.stream));
}

class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterRefreshStream].
  ///
  /// Every time the [stream] receives an event the [GoRouter] will refresh its
  /// current route.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
