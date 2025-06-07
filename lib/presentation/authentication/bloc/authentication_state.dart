// authentication_state.dart
class AuthState {
  final bool isLoading;
  final String? error;
  final bool isLoggedIn;
  final String? uid;
  final bool isNewlyRegistered;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isLoggedIn = false,
    this.uid,
    this.isNewlyRegistered = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
    String? uid,
    bool? isNewlyRegistered,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      uid: uid ?? this.uid,
      isNewlyRegistered: isNewlyRegistered ?? this.isNewlyRegistered,
    );
  }
}
