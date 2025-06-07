import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_profile_management_app/api_services/firestore_service.dart';
import 'edit_profile_screen_event.dart';
import 'edit_profile_screen_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final FirestoreService firestoreService;
  final FirebaseAuth auth;

  EditProfileBloc({required this.firestoreService, required this.auth})
      : super(const EditProfileState()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateImage>(_onUpdateImage);
    on<SubmitProfile>(_onSubmitProfile);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(isLoading: true, isError: false, isSuccess: false));

    final uid = auth.currentUser?.uid;
    if (uid == null) {
      emit(state.copyWith(isError: true, isLoading: false));
      return;
    }

    try {
      final doc = await firestoreService.getUserProfile(uid);
      if (doc.exists) {
        final data = doc.data()!;
        emit(state.copyWith(
          fullName: data["fullName"] ?? "",
          job: data["job"] ?? "",
          about: data["about"] ?? "",
          dob: data["dob"] ?? "",
          address: data["address"] ?? "",
          email: data["email"] ?? "",
          phone: data["phone"] ?? "",
          gender: data["gender"] ?? "",
          imageUrl: data["image"] ?? "",
          isLoading: false,
          isError: false,
          isSuccess: false,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isError: true, isLoading: false));
    }
  }

  void _onUpdateImage(UpdateImage event, Emitter<EditProfileState> emit) {
    emit(state.copyWith(image: event.image));
  }

  Future<void> _onSubmitProfile(
      SubmitProfile event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(isLoading: true, isError: false, isSuccess: false));

    final uid = auth.currentUser?.uid;
    if (uid == null) {
      emit(state.copyWith(isError: true, isLoading: false));
      return;
    }

    String? imageUrl;
    if (state.image != null) {
      try {
        imageUrl = await firestoreService.uploadProfileImage(uid, state.image!);
      } catch (e) {
        emit(state.copyWith(isError: true, isLoading: false));
        return;
      }
    }

    final data = {
      "fullName": event.fullName,
      "job": event.job,
      "about": event.about,
      "dob": event.dob,
      "address": event.address,
      "email": event.email,
      "phone": event.phone,
      "gender": event.gender,
      "image": imageUrl ?? state.imageUrl ?? "",
    };

    try {
      final doc = await firestoreService.getUserProfile(uid);
      if (doc.exists) {
        await firestoreService.updateUserProfile(uid, data);
      } else {
        await firestoreService.createUserProfile(uid, data);
      }
      emit(state.copyWith(isSuccess: true, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isError: true, isLoading: false));
    }
  }
}
