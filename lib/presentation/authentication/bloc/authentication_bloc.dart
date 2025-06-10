import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api_services/firebase_auth_service.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService _authService;

  AuthBloc(this._authService) : super(AuthState()) {
    on<AuthSignUp>(_onSignUp);
    on<AuthSignIn>(_onSignIn);
    on<AuthCheckLoggedIn>(_onCheckLoggedIn);
    on<AuthLogout>(_onLogout);
  }

  Future<void> _onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null, isSignUpSuccess: false));
    try {
      final user = await _authService.signUp(event.email, event.password);
      emit(state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        uid: user?.uid,
        isNewlyRegistered: true,
        isSignUpSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString(), isSignUpSuccess: false));
    }
  }

  Future<void> _onSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null, isSignUpSuccess: false));
    try {
      final user = await _authService.signIn(event.email, event.password);
      emit(state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        uid: user?.uid,
        isNewlyRegistered: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCheckLoggedIn(AuthCheckLoggedIn event, Emitter<AuthState> emit) async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      emit(state.copyWith(
        isLoggedIn: true,
        uid: user.uid,
        isNewlyRegistered: false,
        isSignUpSuccess: false,
      ));
    }
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    await _authService.signOut();
    emit(AuthState());
  }

}
