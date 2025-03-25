import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';

import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import '../../dto/ride_pref_dto.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  @override
  Future<void> addPreference(RidePreference preference) async {
    final prefs = await SharedPreferences.getInstance();

    // 1 - Get past preferences
    final pastPreferences = await getPastPreferences();

    // 2 - Convert new preference to DTO
    final newPreferenceDto = RidePreferenceDto.fromModel(preference);

    // 3 - Append new preference and save list
    pastPreferences.add(preference);

    await prefs.setStringList(
      _preferencesKey,
      pastPreferences.map((pref) => jsonEncode(RidePreferenceDto.fromModel(pref).toJson())).toList(),
    );
  }

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];

    return prefsList.map((json) {
      final dto = RidePreferenceDto.fromJson(jsonDecode(json));
      return dto.toModel();
    }).toList();
  }
}
