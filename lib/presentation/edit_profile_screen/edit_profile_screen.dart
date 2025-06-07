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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      context.read<EditProfileBloc>().add(UpdateImage(file));
    }
  }

  Future<void> _selectDob() async {
    final initialDate = DateTime.tryParse(_dobController.text) ?? DateTime(1990);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = picked.toIso8601String().split('T')[0]; // yyyy-mm-dd
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
          } else if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error updating profile')),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Update controllers with loaded data (avoid infinite loop by checking if changed)
          if (_fullNameController.text != state.fullName) {
            _fullNameController.text = state.fullName;
          }
          if (_dobController.text != state.dob) {
            _dobController.text = state.dob;
          }
          if (_addressController.text != state.address) {
            _addressController.text = state.address;
          }
          if (_degreeController.text != state.degree) {
            _degreeController.text = state.degree;
          }
          if (_institutionController.text != state.institution) {
            _institutionController.text = state.institution;
          }
          if (_yearOfPassingController.text != state.yearOfPassing) {
            _yearOfPassingController.text = state.yearOfPassing;
          }
          if (_jobTitleController.text != state.jobTitle) {
            _jobTitleController.text = state.jobTitle;
          }
          if (_companyController.text != state.company) {
            _companyController.text = state.company;
          }
          if (_experienceController.text != state.experience) {
            _experienceController.text = state.experience;
          }
          if (_selectedGender != state.gender && state.gender.isNotEmpty) {
            _selectedGender = state.gender;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: state.image != null
                          ? FileImage(state.image!)
                          : (state.imageUrl != null && state.imageUrl!.isNotEmpty)
                          ? NetworkImage(state.imageUrl!) as ImageProvider
                          : const AssetImage('assets/images/profile_placeholder.png'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Personal Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter name' : null,
                  ),
                  GestureDetector(
                    onTap: _selectDob,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dobController,
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? 'Please select date of birth' : null,
                      ),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedGender?.isNotEmpty == true ? _selectedGender : null,
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedGender = val;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Gender'),
                    validator: (val) => val == null || val.isEmpty ? 'Please select gender' : null,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 24),
                  const Text('Education', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _degreeController,
                    decoration: const InputDecoration(labelText: 'Degree'),
                  ),
                  TextFormField(
                    controller: _institutionController,
                    decoration: const InputDecoration(labelText: 'Institution'),
                  ),
                  TextFormField(
                    controller: _yearOfPassingController,
                    decoration: const InputDecoration(labelText: 'Year of Passing'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  const Text('Occupation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _jobTitleController,
                    decoration: const InputDecoration(labelText: 'Job Title'),
                  ),
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(labelText: 'Company'),
                  ),
                  TextFormField(
                    controller: _experienceController,
                    decoration: const InputDecoration(labelText: 'Experience'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: state.isLoading ? null : _submit,
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(color: Colors.white),
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
