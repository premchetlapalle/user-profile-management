abstract class UserProfileEvent {}

class LoadUserProfileEvent extends UserProfileEvent {
  final String userId;

  LoadUserProfileEvent({required this.userId});
}
