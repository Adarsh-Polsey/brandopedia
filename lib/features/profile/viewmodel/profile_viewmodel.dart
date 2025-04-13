import 'dart:developer';

import 'package:brandopedia/features/profile/model/profile_model.dart';
import 'package:brandopedia/features/profile/repository/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository=ProfileRepository();
  ProfileModel _profile = ProfileModel();
  bool _isEditMode = false;
  bool _isLoading = false;

  ProfileModel get profile => _profile;
  bool get isEditMode => _isEditMode;
  bool get isLoading => _isLoading;

  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _repository.loadProfile();
    } catch (e) {
      log('Error loading profile: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveProfile({
    required String name,
    required String email,
    required String phone,
    required String dob,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = ProfileModel(
        name: name,
        email: email,
        phone: phone,
        dob: dob,
        profileImagePath: _profile.profileImagePath,
      );
      
      await _repository.saveProfile(_profile);
      _isEditMode = false;
    } catch (e) {
      print('Error saving profile: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      _profile.profileImagePath = image.path;
      await _repository.saveProfile(_profile);
      notifyListeners();
    }
  }
}