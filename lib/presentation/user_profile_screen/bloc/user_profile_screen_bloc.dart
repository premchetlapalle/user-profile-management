import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_profile_management_app/presentation/user_profile_screen/bloc/user_profile_screen_event.dart';
import 'package:user_profile_management_app/presentation/user_profile_screen/bloc/user_profile_screen_state.dart';
import '../../../api_services/firestore_service.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final FirestoreService firestoreService;

  UserProfileBloc({required this.firestoreService}) : super(UserProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfileEvent event,
      Emitter<UserProfileState> emit,
      ) async {
    emit(UserProfileLoading());
    try {
      final snapshot = await firestoreService.getUser(event.userId);
      if (snapshot.exists) {
        emit(UserProfileLoaded(userData: snapshot.data()!));
      } else {
        emit(UserProfileError(message: "User not found"));
      }
    } catch (e) {
      emit(UserProfileError(message: e.toString()));
    }
  }
}
