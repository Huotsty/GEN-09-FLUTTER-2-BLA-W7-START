
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'location_dto.dart';

class RidePreferenceDto {
  final String departureName;
  final String departureDate;
  final String arrivalName;
  final int requestedSeats;
  final String arrivalCountry;
  final String departureCountry;

  const RidePreferenceDto({
    required this.departureName,
    required this.departureDate,
    required this.arrivalName,
    required this.requestedSeats,
    required this.arrivalCountry,
    required this.departureCountry,
  });

  // ✅ Convert DTO to Model
  RidePreference toModel() {
    return RidePreference(
      departure: LocationDto.fromJson({'name': departureName, 'country': departureCountry}),
      departureDate: DateTime.parse(departureDate),
      arrival: LocationDto.fromJson({'name': arrivalName, 'country': arrivalCountry}),
      requestedSeats: requestedSeats,
    );
  }

  // ✅ Convert Model to DTO
  static RidePreferenceDto fromModel(RidePreference model) {
    return RidePreferenceDto(
      departureName: model.departure.name,
      departureDate: model.departureDate.toIso8601String(),
      arrivalName: model.arrival.name,
      requestedSeats: model.requestedSeats,
      arrivalCountry: model.arrival.country.name,
      departureCountry: model.departure.country.name,
    );
  }

  // ✅ Convert DTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'departureName': departureName,
      'departureDate': departureDate,
      'arrivalName': arrivalName,
      'requestedSeats': requestedSeats,
      'arrivalCountry': arrivalCountry,
      'departureCountry': departureCountry,
    };
  }

  // ✅ Convert JSON to DTO
  factory RidePreferenceDto.fromJson(Map<String, dynamic> json) {
    return RidePreferenceDto(
      departureName: json['departureName'],
      departureDate: json['departureDate'],
      arrivalName: json['arrivalName'],
      requestedSeats: json['requestedSeats'],
      arrivalCountry: json['arrivalCountry'],
      departureCountry: json['departureCountry'],
    );
  }
}
