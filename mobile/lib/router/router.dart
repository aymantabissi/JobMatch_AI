
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/candidate/candidate_home_page.dart';
import '../features/recruiter/recruiter_home_page.dart';

final publicRoutes = [
  '/onboarding',
  '/login',
  '/register',
];

String homeForRole(String role) {
  switch (role) {
    case 'recruiter':
      return '/recruiter';

    case 'admin':
      return '/admin';

    default:
      return '/candidate';
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);

  ref.listen(authProvider, (previous, next) {
    refresh.value++;
  });

  final router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,

    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) =>
            const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
      ),

      GoRoute(
        path: '/onboarding',
        builder: (context, state) =>
            const Scaffold(
              body: Center(
                child: Text('Welcome to JobMatch AI'),
              ),
            ),
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) =>
            const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) =>
            const RegisterScreen(),
      ),

      GoRoute(
  path: '/candidate',
  builder: (context, state) =>
      const CandidateHomePage(),
),

GoRoute(
  path: '/recruiter',
  builder: (context, state) =>
      const RecruiterHomePage(),
),

GoRoute(
  path: '/admin',
  builder: (context, state) =>
      const RoleHomePage(role: 'Admin'),
),
    ],

    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loc = state.matchedLocation;

      if (auth.initializing) {
        return loc == '/splash' ? null : '/splash';
      }

      final user = auth.user;

      if (user == null) {
  if (loc == '/splash') {
    return '/onboarding';
  }

  return publicRoutes.contains(loc)
      ? null
      : '/login';
}

      final home = homeForRole(user.role);

      if (loc == '/splash' ||
          publicRoutes.contains(loc) ||
          loc == '/onboarding') {
        return home;
      }

      if (loc.startsWith('/admin') &&
          user.role != 'admin') {
        return home;
      }

      if (loc.startsWith('/recruiter') &&
          user.role != 'recruiter') {
        return home;
      }

      if (loc.startsWith('/candidate') &&
          user.role != 'candidate') {
        return home;
      }

      return null;
    },
  );

  ref.onDispose(() {
    refresh.dispose();
    router.dispose();
  });

  return router;
});

// Temporary pages until real dashboards are created
class RoleHomePage extends StatelessWidget {
  final String role;

  const RoleHomePage({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$role Dashboard'),
      ),
      body: Center(
        child: Text('Welcome to $role space'),
      ),
    );
  }
}
