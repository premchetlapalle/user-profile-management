import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/bloc/edit_profile_screen_bloc.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/edit_profile_screen.dart';
import 'package:user_profile_management_app/presentation/home_screen/bloc/home_screen_bloc.dart';
import 'package:user_profile_management_app/presentation/home_screen/bloc/home_screen_event.dart';
import 'package:user_profile_management_app/presentation/home_screen/bloc/home_screen_state.dart';
import 'package:user_profile_management_app/presentation/user_profile_screen/user_profile_screen.dart';
import '../../api_services/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  ImageProvider? _getUserImageProvider(dynamic imagePath) {
    if (imagePath == null) return null;

    final path = imagePath.toString();
    if (path.isEmpty) return null;

    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      HomeBloc(firestoreService: FirestoreService())..add(LoadUsersEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Home',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: () {
                    context.read<HomeBloc>().add(LoadUsersEvent());
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'logout') {
                      _logout(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Text('Logout',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500)),
                          SizedBox(width: 5),
                          Icon(Icons.logout_outlined,
                              color: Colors.red, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search name here...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (query) {
                      context.read<HomeBloc>().add(SearchUserEvent(query));
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is HomeLoaded) {
                        final currentUser = FirebaseAuth.instance.currentUser;

                        // Only filter if currentUser is not null
                        final users = currentUser == null
                            ? state.users
                            : state.users
                            .where((user) => user["id"] != currentUser.uid)
                            .toList();

                        if (users.isEmpty) {
                          return const Center(
                              child: Text("No other users found."));
                        }

                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final data = users[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                  _getUserImageProvider(data["image"]),
                                  child: (data["image"] == null ||
                                      data["image"].toString().isEmpty)
                                      ? Image.asset(
                                      'assets/images/profile.png',
                                      height: 200)
                                      : null,
                                ),
                                title: Text(
                                  data["fullName"] ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UserProfileScreen(
                                        userId: data["id"]),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is HomeError) {
                        return Center(
                            child: Text("Error: ${state.message}"));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => EditProfileBloc(
                        firestoreService: FirestoreService(),
                        auth: FirebaseAuth.instance,
                      ),
                      child: const EditProfileScreen(),
                    ),
                  ),
                ).then((_) {
                  context.read<HomeBloc>().add(UpdateProfileEvent());
                });
              },
              child: const Icon(Icons.edit, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
