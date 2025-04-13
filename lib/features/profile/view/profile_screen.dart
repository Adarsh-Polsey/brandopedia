import 'dart:developer';

import 'package:brandopedia/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();
    Future.microtask(() {
      context.read<ProfileViewModel>().loadProfile();
      _updateControllers();
    });
  }

  void _updateControllers() {
    final profile = context.read<ProfileViewModel>().profile;
    log(profile.name.toString());
    _nameController.text = profile.name ?? '';
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone ?? '';
    _dobController.text = profile.dob ?? '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            actions: [
              Switch(
                value: viewModel.isEditMode,
                onChanged: (_) => viewModel.toggleEditMode(),
              ),
            ],
          ),
          body:
              viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap:
                                viewModel.isEditMode
                                    ? () => viewModel.updateProfileImage()
                                    : null,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  viewModel.profile.profileImagePath != null
                                      ? FileImage(
                                        File(
                                          viewModel.profile.profileImagePath!,
                                        ),
                                      )
                                      : null,
                              child:
                                  viewModel.profile.profileImagePath == null
                                      ? Icon(Icons.person, size: 60)
                                      : null,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            controller: _nameController,
                            label: 'Name',
                            enabled: viewModel.isEditMode,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                            enabled: viewModel.isEditMode,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value!)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            enabled: viewModel.isEditMode,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            controller: _dobController,
                            label: 'Date of Birth',
                            enabled: viewModel.isEditMode,
                            suffix:
                                viewModel.isEditMode
                                    ? IconButton(
                                      icon: Icon(Icons.calendar_today),
                                      onPressed: () => _selectDate(context),
                                    )
                                    : null,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please select your date of birth';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          if (viewModel.isEditMode)
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  viewModel.saveProfile(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    phone: _phoneController.text,
                                    dob: _dobController.text,
                                  );
                                }
                              },
                              child: Text('Save Profile'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool enabled,
    Widget? suffix,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: suffix,
      ),
      enabled: enabled,
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}
