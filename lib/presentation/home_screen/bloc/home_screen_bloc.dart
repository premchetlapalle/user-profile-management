import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_profile_management_app/presentation/home_screen/bloc/home_screen_event.dart';
import 'package:user_profile_management_app/presentation/home_screen/bloc/home_screen_state.dart';
import '../../../api_services/firestore_service.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirestoreService firestoreService;
  List<Map<String, dynamic>> _allUsers = [];

  HomeBloc({required this.firestoreService}) : super(HomeInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<SearchUserEvent>(_onSearchUser);
  }

  Future<void> _onLoadUsers(
      LoadUsersEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final snapshot = await firestoreService.getAllUsers().first;
      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        data["id"] = doc.id;
        return data;
      }).toList();

      _allUsers = users;
      emit(HomeLoaded(users: users));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<HomeState> emit) async {
    add(LoadUsersEvent());
  }

  Future<void> _onSearchUser(
      SearchUserEvent event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final query = event.searchQuery.toLowerCase();
      final filteredUsers = _allUsers.where((user) {
        final name = (user["fullName"] ?? "").toLowerCase();
        return name.contains(query);
      }).toList();

      emit(HomeLoaded(users: filteredUsers));
    }
  }
}
