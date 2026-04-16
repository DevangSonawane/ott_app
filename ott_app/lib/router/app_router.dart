import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/account_settings_screen.dart';
import '../screens/browse_screen.dart';
import '../screens/content_detail_screen.dart';
import '../screens/genre_screen.dart';
import '../screens/home_screen.dart';
import '../screens/live_news_screen.dart';
import '../screens/login_screen.dart';
import '../screens/player_screen.dart';
import '../screens/profile_selection_screen.dart';
import '../screens/profile_settings_screen.dart';
import '../screens/songs_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/subscription_screen.dart';
import '../screens/movies_screen.dart';
import '../screens/search_screen.dart';
import '../screens/tv_screen.dart';
import '../widgets/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loggedIn = auth.isLoggedIn;
      final loc = state.uri.toString();
      final goingToAuth = loc.startsWith('/login') || loc.startsWith('/signup');
      final protected = loc.startsWith('/account') ||
          loc.startsWith('/subscription');
      if (!loggedIn && protected && !goingToAuth) return '/login';
      if (loggedIn && goingToAuth) return '/';
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/browse',
            name: 'browse',
            pageBuilder: (context, state) {
              final type = state.uri.queryParameters['type'];
              return NoTransitionPage(child: BrowseScreen(initialType: type));
            },
          ),
          GoRoute(
            path: '/content/:id',
            name: 'content',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return NoTransitionPage(
                  child: ContentDetailScreen(contentId: id));
            },
          ),
          GoRoute(
            path: '/player/:id',
            name: 'player',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return NoTransitionPage(child: PlayerScreen(contentId: id));
            },
          ),
          GoRoute(
            path: '/genre/:id',
            name: 'genre',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'] ?? 'action';
              return NoTransitionPage(child: GenreScreen(genreId: id));
            },
          ),
          GoRoute(
            path: '/subscription',
            name: 'subscription',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SubscriptionScreen()),
          ),
          GoRoute(
            path: '/pricing',
            name: 'pricing',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SubscriptionScreen()),
          ),
          GoRoute(
            path: '/account',
            name: 'account',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AccountSettingsScreen()),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            pageBuilder: (context, state) {
              final scope = state.uri.queryParameters['scope'] ?? 'all';
              return NoTransitionPage(child: SearchScreen(scope: scope));
            },
          ),
          GoRoute(
            path: '/songs',
            name: 'songs',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SongsScreen()),
          ),
          GoRoute(
            path: '/live-news',
            name: 'live-news',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: LiveNewsScreen()),
          ),
          GoRoute(
            path: '/tv',
            name: 'tv',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: TvScreen()),
          ),
          GoRoute(
            path: '/movies',
            name: 'movies',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MoviesScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/profiles',
        name: 'profiles',
        pageBuilder: (context, state) => const CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 350),
          child: ProfileSelectionScreen(),
          transitionsBuilder: _slideUp,
        ),
      ),
      GoRoute(
        path: '/profile-settings',
        name: 'profile-settings',
        pageBuilder: (context, state) => const CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 350),
          child: ProfileSettingsScreen(),
          transitionsBuilder: _slideUp,
        ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => const CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 350),
          child: LoginScreen(),
          transitionsBuilder: _slideUp,
        ),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder: (context, state) => const CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 350),
          child: SignupScreen(),
          transitionsBuilder: _slideUp,
        ),
      ),
    ],
  );
});

Widget _slideUp(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
  return SlideTransition(
    position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(curved),
    child: FadeTransition(opacity: curved, child: child),
  );
}
