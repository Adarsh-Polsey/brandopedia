import 'package:brandopedia/common/app_theme.dart';
import 'package:brandopedia/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    // Set up animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start animation
    _animationController.forward();
    
    // Load profile data
    Future.microtask(() async {
      await context.read<ProfileViewModel>().loadProfile();
      final profile = context.read<ProfileViewModel>().profile;
      _nameController.text = profile.name ?? '';
      _emailController.text = profile.email ?? '';
      _phoneController.text = profile.phone ?? '';
      _dobController.text = profile.dob ?? '';
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        viewModel.isEditMode ? 'Edit Mode' : 'View Mode',
                        key: ValueKey<bool>(viewModel.isEditMode),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: viewModel.isEditMode 
                            ? theme.primaryColor 
                            : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: viewModel.isEditMode,
                        onChanged: (_) {
                          HapticFeedback.lightImpact();
                          viewModel.toggleEditMode();
                        },
                        activeColor: theme.primaryColor,
                        activeTrackColor: theme.primaryColor.withValues(alpha:0.3),
                        inactiveThumbColor: Colors.grey.shade400,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),
                            Hero(
                              tag: 'profileImage',
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha:0.1),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: viewModel.isEditMode
                                      ? () {
                                          HapticFeedback.mediumImpact();
                                          viewModel.updateProfileImage();
                                        }
                                      : null,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 70,
                                        backgroundColor: theme.cardColor,
                                        backgroundImage: viewModel.profile.profileImagePath != null
                                            ? FileImage(
                                                File(
                                                  viewModel.profile.profileImagePath!,
                                                ),
                                              )
                                            : null,
                                        child: viewModel.profile.profileImagePath == null
                                            ? Icon(Icons.person, size: 70, color: theme.disabledColor)
                                            : null,
                                      ),
                                      if (viewModel.isEditMode)
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: theme.primaryColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: theme.scaffoldBackgroundColor,
                                                width: 2,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            ..._buildFormFields(theme, viewModel),
                            const SizedBox(height: 32),
                            if (viewModel.isEditMode)
                              _buildSaveButton(viewModel, theme),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  List<Widget> _buildFormFields(ThemeData theme, ProfileViewModel viewModel) {
    return [
      _buildTextField(
        controller: _nameController,
        label: 'Full Name',
        icon: Icons.person_outline,
        enabled: viewModel.isEditMode,
        theme: theme,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter your name';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      _buildTextField(
        controller: _emailController,
        label: 'Email Address',
        icon: Icons.email_outlined,
        enabled: viewModel.isEditMode,
        theme: theme,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter your email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      _buildTextField(
        controller: _phoneController,
        label: 'Phone Number',
        icon: Icons.phone_outlined,
        enabled: viewModel.isEditMode,
        keyboardType: TextInputType.phone,
        theme: theme,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter your phone number';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),
      _buildTextField(
        controller: _dobController,
        label: 'Date of Birth',
        icon: Icons.calendar_today_outlined,
        enabled: viewModel.isEditMode,
        theme: theme,
        readOnly: true,
        onTap: viewModel.isEditMode ? () => _selectDate(context) : null,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please select your date of birth';
          }
          return null;
        },
      ),
    ];
  }

  Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required bool enabled,
  required ThemeData theme,
  Widget? suffix,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  final purple = const Color(0xFF4E29AC);

  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    margin: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      color: enabled ? Colors.white : theme.cardColor.withValues(alpha:0.5),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: enabled
              ? purple.withValues(alpha:0.2)
              : Colors.black.withValues(alpha:0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled,
      style: TextStyle(
        color: enabled
            ? theme.textTheme.bodyLarge?.color
            : theme.disabledColor,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: enabled ? purple : theme.disabledColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: enabled ? purple : theme.disabledColor),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: purple.withValues(alpha:0.3), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: purple, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha:0.3)),
        ),
      ),
    ),
  );
}

  Widget _buildSaveButton(ProfileViewModel viewModel, ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            HapticFeedback.mediumImpact();
            viewModel.saveProfile(
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              dob: _dobController.text,
            );
            
            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: AppColorpallete.primaryColor.withAlpha(200),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline),
            const SizedBox(width: 8),
            Text(
              'Save Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}