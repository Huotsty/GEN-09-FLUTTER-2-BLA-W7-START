import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // For now past preferences are fetched only 1 time
    // Your code
    fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreference(RidePreference pref) {
    try {
      if (_currentPreference != pref) {
        _currentPreference = pref;
        _addPreference(pref);
        notifyListeners();
      }
    } catch (error) {
      // Log the error or display a message in the UI
      print("Error setting current preference: $error");
    }
  }

  void _addPreference(RidePreference preference) {
    // if (!_pastPreferences.contains(preference)) {
    //   _pastPreferences.add(preference);
    //   repository.addPreference(preference);
    //   notifyListeners();
    // }
    bool isDuplicate = _pastPreferences.any((p) => p == preference);

    if (!isDuplicate) {
      _pastPreferences.add(preference);
      repository.addPreference(preference);
      notifyListeners();
    }
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();

  void fetchPastPreferences() {
    _pastPreferences = repository.getPastPreferences();

    // ✅ Remove duplicates based on departure & arrival
    _pastPreferences = _pastPreferences.toSet().toList();
    notifyListeners();
  }
}
