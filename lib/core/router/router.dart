import 'package:firebase_test/features/auth/presentation/ui/login_screen.dart';
import 'package:firebase_test/features/home/presentation/ui/home_screen.dart';
import 'package:firebase_test/features/splash/presentation/ui/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);