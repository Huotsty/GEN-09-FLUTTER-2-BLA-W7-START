import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

import 'async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];

  final RidePreferencesRepository repository;

  late AsyncValue<List<RidePreference>> pastPreferences;

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

  Future<void> _addPreference(RidePreference preference) async {
    // if (!_pastPreferences.contains(preference)) {
    //   _pastPreferences.add(preference);
    //   repository.addPreference(preference);
    //   notifyListeners();
    // }
    await repository.addPreference(preference);
    // ✅ Ensure no duplicates before adding to cache
    // if (!_pastPreferences.contains(preference)) {
    //   _pastPreferences.add(preference);
    //   notifyListeners();
    // Remove the preference if it already exists
    _pastPreferences.remove(preference);

    // Add the preference to the front of the list
    _pastPreferences.insert(0, preference);

    notifyListeners();
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory => _pastPreferences.toList();

  Future<void> fetchPastPreferences() async {
    // 1-  Handle loading
    pastPreferences = AsyncValue.loading();
    notifyListeners();
    try {
      // 2   Fetch data
      _pastPreferences = await repository.getPastPreferences();
      // ✅ Remove duplicates based on departure & arrival
      _pastPreferences = _pastPreferences.toSet().toList();
      // 3  Handle success
      pastPreferences = AsyncValue.success(_pastPreferences);
      // 4  Handle error
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
    // _pastPreferences = await repository.getPastPreferences();

    // // ✅ Remove duplicates based on departure & arrival
    // _pastPreferences = _pastPreferences.toSet().toList();
    // notifyListeners();
  }
}


// choose the second bcuz we give the database to add the past preferences and we set to the provider the past preferences no need to fetch the data again but we have to check the duplicates before adding the new preference to the past preferences list