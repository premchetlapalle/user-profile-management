class AuthState {
  final bool isLoading;
  final String? error;
  final bool isLoggedIn;
  final String? uid;
  final bool isNewlyRegistered;
  final bool isSignUpSuccess;
  AuthState({
    this.isLoading = false,
    this.error,
    this.isLoggedIn = false,
    this.uid,
    this.isNewlyRegistered = false,
    this.isSignUpSuccess = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
    String? uid,
    bool? isNewlyRegistered,
    bool? isSignUpSuccess,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      uid: uid ?? this.uid,
      isNewlyRegistered: isNewlyRegistered ?? this.isNewlyRegistered,
      isSignUpSuccess: isSignUpSuccess ?? this.isSignUpSuccess,

    );
  }
}
