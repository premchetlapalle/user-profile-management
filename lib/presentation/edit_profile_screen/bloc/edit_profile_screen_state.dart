import 'dart:io';
import 'package:equatable/equatable.dart';

class EditProfileState extends Equatable {
  final String fullName;
  final String job;
  final String about;
  final String dob;
  final String address;
  final String email;
  final String phone;
  final String gender;
  final File? image;
  final String? imageUrl;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;

  const EditProfileState({
    this.fullName = "",
    this.job = "",
    this.about = "",
    this.dob = "",
    this.address = "",
    this.email = "",
    this.phone = "",
    this.gender = "",
    this.image,
    this.imageUrl,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
  });

  EditProfileState copyWith({
    String? fullName,
    String? job,
    String? about,
    String? dob,
    String? address,
    String? email,
    String? phone,
    String? gender,
    File? image,
    String? imageUrl,
    bool? isLoading,
    bool? isSuccess,
    bool? isError,
  }) {
    return EditProfileState(
      fullName: fullName ?? this.fullName,
      job: job ?? this.job,
      about: about ?? this.about,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      imageUrl: imageUrl ?? this.imageUrl,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? false,
      isError: isError ?? false,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    job,
    about,
    dob,
    address,
    email,
    phone,
    gender,
    image,
    imageUrl,
    isLoading,
    isSuccess,
    isError,
  ];
}
