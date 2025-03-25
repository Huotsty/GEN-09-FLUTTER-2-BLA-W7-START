import 'package:week_3_blabla_project/model/location/locations.dart';

class LocationDto {
  static Map<String, dynamic> toJson(Location model) {
    return {
      'name': model.name,
      'country': model.country.name, // Store enum as string
    };
  }

  static Location fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      country: _countryFromString(json['country']),
    );
  }

  static Country _countryFromString(String value) {
    return Country.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Invalid country: $value'),
    );
  }
}
