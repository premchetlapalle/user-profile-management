import 'dart:io';
import 'package:equatable/equatable.dart';

class EditProfileState extends Equatable {
  final String fullName;
  final String dob;
  final String gender;
  final String address;
  final String degree;
  final String institution;
  final String yearOfPassing;
  final String jobTitle;
  final String company;
  final String experience;
  final File? image;
  final String? imageUrl;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;

  const EditProfileState({
    this.fullName = "",
    this.dob = "",
    this.gender = "",
    this.address = "",
    this.degree = "",
    this.institution = "",
    this.yearOfPassing = "",
    this.jobTitle = "",
    this.company = "",
    this.experience = "",
    this.image,
    this.imageUrl,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
  });

  EditProfileState copyWith({
    String? fullName,
    String? dob,
    String? gender,
    String? address,
    String? degree,
    String? institution,
    String? yearOfPassing,
    String? jobTitle,
    String? company,
    String? experience,
    File? image,
    String? imageUrl,
    bool? isLoading,
    bool? isSuccess,
    bool? isError,
  }) {
    return EditProfileState(
      fullName: fullName ?? this.fullName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      degree: degree ?? this.degree,
      institution: institution ?? this.institution,
      yearOfPassing: yearOfPassing ?? this.yearOfPassing,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      experience: experience ?? this.experience,
      image: image ?? this.image,
      imageUrl: imageUrl ?? this.imageUrl,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    dob,
    gender,
    address,
    degree,
    institution,
    yearOfPassing,
    jobTitle,
    company,
    experience,
    image,
    imageUrl,
    isLoading,
    isSuccess,
    isError,
  ];
}
