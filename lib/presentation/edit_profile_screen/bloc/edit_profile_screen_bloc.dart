import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_profile_management_app/api_services/firestore_service.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/bloc/edit_profile_screen_event.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/bloc/edit_profile_screen_state.dart';


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
          dob: data["dob"] ?? "",
          gender: data["gender"] ?? "",
          address: data["address"] ?? "",
          degree: data["degree"] ?? "",
          institution: data["institution"] ?? "",
          yearOfPassing: data["yearOfPassing"] ?? "",
          jobTitle: data["jobTitle"] ?? "",
          company: data["company"] ?? "",
          experience: data["experience"] ?? "",
          imageUrl: data["image"]?.toString(),
          isLoading: false,
          isError: false,
          isSuccess: false,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (_) {
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
      } catch (_) {
        emit(state.copyWith(isError: true, isLoading: false));
        return;
      }
    }

    final data = {
      "fullName": event.fullName,
      "dob": event.dob,
      "gender": event.gender,
      "address": event.address,
      "degree": event.degree,
      "institution": event.institution,
      "yearOfPassing": event.yearOfPassing,
      "jobTitle": event.jobTitle,
      "company": event.company,
      "experience": event.experience,
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
    } catch (_) {
      emit(state.copyWith(isError: true, isLoading: false));
    }
  }
}
