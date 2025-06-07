import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_profile_management_app/presentation/user_profile_screen/bloc/user_profile_screen_bloc.dart';
import 'package:user_profile_management_app/presentation/user_profile_screen/bloc/user_profile_screen_event.dart';
import 'package:user_profile_management_app/presentation/user_profile_screen/bloc/user_profile_screen_state.dart';
import '../../api_services/firestore_service.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      UserProfileBloc(firestoreService: FirestoreService())
        ..add(LoadUserProfileEvent(userId: userId)),
      child: Scaffold(
        appBar: AppBar(title: const Text("User Profile")),
        body: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserProfileLoaded) {
              final data = state.userData;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (data["image"] != null &&
                            data["image"].toString().isNotEmpty)
                            ? NetworkImage(data["image"])
                            : null,
                        child: (data["image"] == null ||
                            data["image"].toString().isEmpty)
                            ? Image.asset(
                          'assets/images/profile.png',
                          height: 200,
                        )
                            : null,
                      ),
                      const SizedBox(height: 40),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelValueRow(
                                    label: "Full Name",
                                    value: data["fullName"] ?? ""),
                                const SizedBox(height: 10),
                                LabelValueRow(
                                    label: "Job", value: data["job"] ?? ""),
                                const SizedBox(height: 10),
                                LabelValueRow(
                                    label: "Date of Birth",
                                    value: data["dob"] ?? ""),
                                const SizedBox(height: 10),
                                LabelValueRow(
                                    label: "About", value: data["about"] ?? ""),
                                const SizedBox(height: 10),
                                LabelValueRow(
                                    label: "Email", value: data["email"] ?? ""),
                                const SizedBox(height: 10),
                                LabelValueRow(
                                    label: "Phone", value: data["phone"] ?? ""),
                                const SizedBox(height: 10),
                                LabelValueRow(
                                    label: "Address",
                                    value: data["address"] ?? ""),
                                const SizedBox(height: 10),
                                LabelValueRow(
                                    label: "Gender", value: data["gender"] ?? ""),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is UserProfileError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class LabelValueRow extends StatelessWidget {
  final String label;
  final String value;

  const LabelValueRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
