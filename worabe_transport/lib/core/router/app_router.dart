import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worabe_transport/features/auth/presentation/providers/auth_providers.dart';
import 'package:worabe_transport/features/auth/presentation/screens/login_screen.dart';
import 'package:worabe_transport/features/auth/presentation/screens/register_screen.dart';
import 'package:worabe_transport/features/auth/presentation/screens/welcome_screen.dart';
import 'package:worabe_transport/features/driver/domain/driver_model.dart';
import 'package:worabe_transport/features/driver/presentation/screens/driver_directory_screen.dart';
import 'package:worabe_transport/features/driver/presentation/screens/driver_home_screen.dart';
import 'package:worabe_transport/features/rides/presentation/screens/offline_drafts_screen.dart';
import 'package:worabe_transport/features/rides/presentation/screens/passenger_home_screen.dart';
import 'package:worabe_transport/features/rides/presentation/screens/ride_request_screen.dart';
import 'package:worabe_transport/features/rides/presentation/screens/my_rides_screen.dart';
import 'package:worabe_transport/features/complaints/presentation/screens/complaints_screen.dart';
import 'package:worabe_transport/features/complaints/presentation/screens/submit_complaint_screen.dart';
import 'package:worabe_transport/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:worabe_transport/features/admin/presentation/screens/admin_complaints_screen.dart';
import 'package:worabe_transport/features/settings/presentation/screens/settings_screen.dart';
import 'package:worabe_transport/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:worabe_transport/features/admin/presentation/screens/admin_ride_history_screen.dart';
import 'package:worabe_transport/shared/models/user_model.dart';

String homePathForUser(UserModel user) {
  if (user.isAdmin) return '/admin/home';
  if (user.isDriver) return '/driver/home';
  return '/passenger/home';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final user = authState.value;
      final path = state.matchedLocation;
      final isPublic = path == '/' || path == '/login' || path == '/register';

      if (user == null) {
        if (isPublic) return null;
        return '/login';
      }

      if (path == '/login' || path == '/register' || path == '/') {
        return homePathForUser(user);
      }

      if (user.isPassenger && path.startsWith('/driver/')) {
        return '/passenger/home';
      }
      if (user.isDriver && path.startsWith('/passenger/')) {
        return '/driver/home';
      }
      if (!user.isAdmin && path.startsWith('/admin/')) {
        return homePathForUser(user);
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: '/passenger/home',
        builder: (_, __) => const PassengerHomeScreen(),
      ),
      GoRoute(
        path: '/passenger/drivers',
        builder: (_, __) => const DriverDirectoryScreen(),
      ),
      GoRoute(
        path: '/passenger/request',
        builder: (_, state) {
          final driver = state.extra as DriverModel?;
          if (driver == null) {
            return const Scaffold(
              body: Center(child: Text('Driver not found.')),
            );
          }
          return RideRequestScreen(driver: driver);
        },
      ),
      GoRoute(
        path: '/passenger/rides',
        builder: (_, __) => const MyRidesScreen(forDriver: false),
      ),
      GoRoute(
        path: '/passenger/drafts',
        builder: (_, __) => const OfflineDraftsScreen(),
      ),
      GoRoute(
        path: '/driver/home',
        builder: (_, __) => const DriverHomeScreen(),
      ),
      GoRoute(
        path: '/driver/rides',
        builder: (_, __) => const MyRidesScreen(forDriver: true),
      ),
      GoRoute(
        path: '/complaints',
        builder: (_, __) => const ComplaintsScreen(),
      ),
      GoRoute(
        path: '/complaints/new',
        builder: (_, state) {
          final rideId = state.uri.queryParameters['rideId'];
          return SubmitComplaintScreen(rideId: rideId);
        },
      ),
      GoRoute(path: '/admin/home', builder: (_, __) => const AdminHomeScreen()),
      GoRoute(
        path: '/admin/complaints',
        builder: (_, __) => const AdminComplaintsScreen(),
      ),
      GoRoute(
        path: '/admin/rides',
        builder: (_, __) => const AdminRideHistoryScreen(),
      ),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsScreen(),
      ),
    ],
  );
});
