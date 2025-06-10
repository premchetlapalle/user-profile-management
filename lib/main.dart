import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:user_profile_management_app/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:user_profile_management_app/presentation/authentication/bloc/authentication_event.dart';
import 'package:user_profile_management_app/presentation/authentication/forget_password_screen.dart';
import 'package:user_profile_management_app/presentation/authentication/login_screen.dart';
import 'package:user_profile_management_app/presentation/authentication/signup_screen.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/bloc/edit_profile_screen_bloc.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/bloc/edit_profile_screen_event.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/edit_profile_screen.dart';
import 'package:user_profile_management_app/presentation/home_screen/home_screen.dart';

import 'api_services/firebase_auth_service.dart';
import 'api_services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuthService _authService = FirebaseAuthService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(_authService)..add(AuthCheckLoggedIn()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/forgot-password': (_) => const ForgotPasswordScreen(),
          '/home': (_) => const HomeScreen(),

          '/edit-profile': (context) => BlocProvider(
            create: (_) => EditProfileBloc(
              firestoreService: FirestoreService(),
              auth: FirebaseAuth.instance,
            )..add(LoadUserProfile()),
            child: const EditProfileScreen(),
          ),
        },
      ),
    );
  }
}
