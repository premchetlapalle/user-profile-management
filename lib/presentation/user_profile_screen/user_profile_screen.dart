import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_profile_management_app/api_services/firestore_service.dart';
import 'bloc/user_profile_screen_bloc.dart';
import 'bloc/user_profile_screen_event.dart';
import 'bloc/user_profile_screen_state.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
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
                          height: 100,
                        )
                            : null,
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Personal Info
                                const Text("Personal Info",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                LabelValueRow(
                                    label: "Name",
                                    value: data["fullName"] ?? ""),
                                LabelValueRow(
                                    label: "Date of Birth",
                                    value: data["dob"] ?? ""),
                                LabelValueRow(
                                    label: "Gender",
                                    value: data["gender"] ?? ""),
                                LabelValueRow(
                                    label: "Address",
                                    value: data["address"] ?? ""),
                                const SizedBox(height: 20),

                                // Education
                                const Text("Education",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                LabelValueRow(
                                    label: "Degree",
                                    value: data["degree"] ?? ""),
                                LabelValueRow(
                                    label: "Institution",
                                    value: data["institution"] ?? ""),
                                LabelValueRow(
                                    label: "Year of Passing",
                                    value: data["yearOfPassing"] ?? ""),
                                const SizedBox(height: 20),

                                // Occupation
                                const Text("Occupation",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                LabelValueRow(
                                    label: "Job Title",
                                    value: data["job"] ?? ""),
                                LabelValueRow(
                                    label: "Company",
                                    value: data["company"] ?? ""),
                                LabelValueRow(
                                    label: "Experience",
                                    value: data["experience"] ?? ""),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
      ),
    );
  }
}
