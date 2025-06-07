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
  final String job;
  final String about;
  final String dob;
  final String address;
  final String email;
  final String phone;
  final String gender;

  SubmitProfile({
    required this.fullName,
    required this.job,
    required this.about,
    required this.dob,
    required this.address,
    required this.email,
    required this.phone,
    required this.gender,
  });

  @override
  List<Object?> get props =>
      [fullName, job, about, dob, address, email, phone, gender];
}
