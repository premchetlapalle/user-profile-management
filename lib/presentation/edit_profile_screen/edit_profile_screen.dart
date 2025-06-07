import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/bloc/edit_profile_screen_bloc.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/bloc/edit_profile_screen_event.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/bloc/edit_profile_screen_state.dart';
import 'package:user_profile_management_app/utils/validator.dart';
import 'package:user_profile_management_app/presentation/home_screen/home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedGender;

  @override
  void initState() {
    super.initState();
    context.read<EditProfileBloc>().add(LoadUserProfile());
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      context.read<EditProfileBloc>().add(UpdateImage(File(pickedFile.path)));
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (dobController.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(dobController.text);
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text = picked.toIso8601String().split('T')[0];
    }
  }

  void _submitProfile(BuildContext context, EditProfileState state) {
    if (_formKey.currentState!.validate()) {
      context.read<EditProfileBloc>().add(
        SubmitProfile(
          fullName: fullNameController.text.trim(),
          job: jobController.text.trim(),
          about: aboutController.text.trim(),
          dob: dobController.text.trim(),
          address: addressController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          gender: selectedGender ?? '',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully!")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else if (state.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to update profile")),
          );
        }

        // Populate controllers on initial load from state
        if (!state.isLoading && fullNameController.text.isEmpty) {
          fullNameController.text = state.fullName;
          jobController.text = state.job;
          dobController.text = state.dob;
          aboutController.text = state.about;
          addressController.text = state.address;
          emailController.text = state.email;
          phoneController.text = state.phone;
          selectedGender = state.gender.isNotEmpty ? state.gender : null;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Edit Profile")),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      GestureDetector(
                        onTap: () => _showImageSourceActionSheet(context),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: state.image != null
                              ? FileImage(state.image!)
                              : (state.imageUrl != null &&
                              state.imageUrl!.isNotEmpty)
                              ? NetworkImage(state.imageUrl!)
                          as ImageProvider
                              : null,
                          child: state.image == null &&
                              (state.imageUrl == null ||
                                  state.imageUrl!.isEmpty)
                              ? Image.asset(
                            'assets/images/profile.png',
                            height: 200,
                          )
                              : null,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () =>
                              _showImageSourceActionSheet(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: fullNameController,
                    decoration:
                    const InputDecoration(labelText: "Full Name"),
                    validator: (v) =>
                        Validators.validateNotEmpty(v, "Full Name"),
                  ),
                  TextFormField(
                    controller: jobController,
                    decoration: const InputDecoration(labelText: "Job"),
                    validator: (v) =>
                        Validators.validateNotEmpty(v, "Job"),
                  ),
                  TextFormField(
                    controller: dobController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Date of Birth",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context),
                    validator: (v) =>
                        Validators.validateNotEmpty(v, "Date of Birth"),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(
                          value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        selectedGender = val;
                      });
                    },
                    decoration: const InputDecoration(labelText: "Gender"),
                    validator: (v) => v == null || v.isEmpty
                        ? "Please select gender"
                        : null,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration:
                    const InputDecoration(labelText: "Address"),
                    validator: (v) =>
                        Validators.validateNotEmpty(v, "Address"),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration:
                    const InputDecoration(labelText: "Email ID"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => Validators.validateEmail(v)
                        ? null
                        : "Enter valid email",
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration:
                    const InputDecoration(labelText: "Phone Number"),
                    keyboardType: TextInputType.phone,
                    validator: (v) => Validators.validatePhone(v)
                        ? null
                        : "Enter valid phone",
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: aboutController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: "About",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        Validators.validateNotEmpty(v, "About"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () => _submitProfile(context, state),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
