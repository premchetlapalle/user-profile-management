abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final Map<String, dynamic> userData;

  UserProfileLoaded({required this.userData});
}

class UserProfileError extends UserProfileState {
  final String message;

  UserProfileError({required this.message});
}
