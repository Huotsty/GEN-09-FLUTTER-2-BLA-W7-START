import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/providers/ride_preferences_provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';



import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final currentPreference = context.watch<RidesPreferencesProvider>().currentPreference;
  // RidePreference get currentPreference =>
  //     RidePrefService.instance.currentPreference!;

  RideFilter currentFilter = RideFilter();

  // List<Ride> get matchingRides => RidesService.instance.getRidesFor(currentPreference!, currentFilter);
final matchingRides = RidesService.instance.getRidesFor(currentPreference!, currentFilter);

  void onBackPressed() {
    // 1 - Back to the previous view
    Navigator.of(context).pop();
  }

  onRidePrefSelected(RidePreference newPreference) async {}

  void onPreferencePressed() async {
    // Open a modal to edit the ride preferences
    RidePreference? newPreference = await Navigator.of(
      context,
    ).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // 1 - Update the current preference
      // RidePrefService.instance.setCurrentPreference(newPreference);
      context.read<RidesPreferencesProvider>().setCurrentPreference(newPreference);
      // 2 -   Update the state   -- TODO MAKE IT WITH STATE MANAGEMENT
      // setState(() {});
    }
  }

  void onFilterPressed() {}

// Use the `currentPreference` as needed in your screen

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: onBackPressed,
              onPreferencePressed: onPreferencePressed,
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}