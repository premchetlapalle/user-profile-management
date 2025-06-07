import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends EditProfileEvent {}

class UpdateImage extends EditProfileEvent {
  final File image;

  UpdateImage(this.image);

  @override
  List<Object?> get props => [image];
}

class SubmitProfile extends EditProfileEvent {
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

  SubmitProfile({
    required this.fullName,
    required this.dob,
    required this.gender,
    required this.address,
    required this.degree,
    required this.institution,
    required this.yearOfPassing,
    required this.jobTitle,
    required this.company,
    required this.experience,
  });

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
  ];
}
