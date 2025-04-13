

import 'dart:convert';
import 'dart:developer';

import 'package:brandopedia/features/profile/model/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  static const String _profileKey = 'profile_data';
  
  Future<ProfileModel> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    log('Profile JSON: $profileJson');
    if (profileJson != null) {
      return ProfileModel.fromJson(Map<String, dynamic>.from(
        json.decode(profileJson),
      ));
    }
    return ProfileModel();
  }

  Future<void> saveProfile(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, json.encode(profile.toJson()));
  }
}