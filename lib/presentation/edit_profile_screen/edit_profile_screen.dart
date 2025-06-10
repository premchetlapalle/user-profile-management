import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/bloc/edit_profile_screen_bloc.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/bloc/edit_profile_screen_event.dart';
import 'package:user_profile_management_app/presentation/edit_profile_screen/bloc/edit_profile_screen_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _dobController;
  late final TextEditingController _addressController;
  late final TextEditingController _degreeController;
  late final TextEditingController _institutionController;
  late final TextEditingController _yearOfPassingController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _companyController;
  late final TextEditingController _experienceController;

  String? _selectedGender;
  final _formKey = GlobalKey<FormState>();

  bool _isInitialLoadDone = false;

  final InputDecoration roundedInputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  );

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _dobController = TextEditingController();
    _addressController = TextEditingController();
    _degreeController = TextEditingController();
    _institutionController = TextEditingController();
    _yearOfPassingController = TextEditingController();
    _jobTitleController = TextEditingController();
    _companyController = TextEditingController();
    _experienceController = TextEditingController();

    context.read<EditProfileBloc>().add(LoadUserProfile());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _degreeController.dispose();
    _institutionController.dispose();
    _yearOfPassingController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      context.read<EditProfileBloc>().add(UpdateImage(file));
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDob() async {
    final String dobText = _dobController.text.trim();
    final initialDate = dobText.isNotEmpty
        ? DateTime.tryParse(dobText) ?? DateTime.now()
        : DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = picked.toIso8601String().split('T')[0];
      setState(() {});
    }
  }


  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<EditProfileBloc>().add(SubmitProfile(
        fullName: _fullNameController.text.trim(),
        dob: _dobController.text.trim(),
        gender: _selectedGender ?? "",
        address: _addressController.text.trim(),
        degree: _degreeController.text.trim(),
        institution: _institutionController.text.trim(),
        yearOfPassing: _yearOfPassingController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
        company: _companyController.text.trim(),
        experience: _experienceController.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error updating profile')),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && !_isInitialLoadDone) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_isInitialLoadDone && state.fullName.isNotEmpty) {
            _fullNameController.text = state.fullName;
            _dobController.text = state.dob;
            _addressController.text = state.address;
            _degreeController.text = state.degree;
            _institutionController.text = state.institution;
            _yearOfPassingController.text = state.yearOfPassing;
            _jobTitleController.text = state.jobTitle;
            _companyController.text = state.company;
            _experienceController.text = state.experience;
            _selectedGender = state.gender.isNotEmpty ? state.gender : null;
            _isInitialLoadDone = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _showImageSourceActionSheet,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: state.image != null
                                ? FileImage(state.image!)
                                : (state.imageUrl != null && state.imageUrl!.isNotEmpty)
                                ? NetworkImage(state.imageUrl!) as ImageProvider
                                : const AssetImage('assets/images/profile.png'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Personal Info',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: roundedInputDecoration.copyWith(labelText: 'Name'),
                    validator: (val) => val == null || val.isEmpty ? 'Please enter name' : null,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _selectDob,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dobController,
                        decoration: roundedInputDecoration.copyWith(
                          labelText: 'Date of Birth',
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? 'Please select date of birth' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedGender?.isNotEmpty == true ? _selectedGender : null,
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Prefer not to say', child: Text('Prefer not to say')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedGender = val;
                      });
                    },
                    decoration: roundedInputDecoration.copyWith(labelText: 'Gender'),
                    validator: (val) =>
                    val == null || val.isEmpty ? 'Please select gender' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _addressController,
                    decoration: roundedInputDecoration.copyWith(labelText: 'Address'),
                  ),
                  const SizedBox(height: 24),
                  const Text('Education',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _degreeController,
                    decoration: roundedInputDecoration.copyWith(labelText: 'Degree'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _institutionController,
                    decoration: roundedInputDecoration.copyWith(labelText: 'Institution'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _yearOfPassingController,
                    decoration: roundedInputDecoration.copyWith(labelText: 'Year of Passing'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  const Text('Occupation',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _jobTitleController,
                    decoration: roundedInputDecoration.copyWith(labelText: 'Job Title'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _companyController,
                    decoration: roundedInputDecoration.copyWith(labelText: 'Company'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _experienceController,
                    decoration: roundedInputDecoration.copyWith(labelText: 'Experience'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: state.isLoading ? null : _submit,
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
