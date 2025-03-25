import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/providers/async_value.dart';
import 'package:week_3_blabla_project/ui/providers/ride_preferences_provider.dart';
import 'package:week_3_blabla_project/ui/widgets/errors/bla_error_screen.dart';

import '../../../model/ride/ride_pref.dart';
import '../../../utils/animations_util.dart';
// import '../../../service/ride_prefs_service.dart';
import '../../theme/theme.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///

class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access provider data
    final provider = context.watch<RidesPreferencesProvider>();
    final currentPreference = provider.currentPreference;
    final pastPreferences = provider.pastPreferences;
    final preferencesHistory = provider.preferencesHistory;
    print("RidePrefScreen build");
    onRidePrefSelected(RidePreference preference) {
      // 1 - Update the current preference
      // Reading the provider without triggering a rebuild
      context.read<RidesPreferencesProvider>().setCurrentPreference(preference);
      // 2 - Navigate to the rides screen (with a buttom to top animation)
      Navigator.of(context)
          .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
    }

    if (pastPreferences.state == AsyncValueState.loading) {
      return BlaError(message: "Loading past preferences...");
    } else if (pastPreferences.state == AsyncValueState.error) {
      return BlaError(message: "Error loading past preferences...");
    } else {
      return Stack(
        children: [
          // 1 - Background  Image
          BlaBackground(),

          // 2 - Foreground content
          Column(
            children: [
              SizedBox(height: BlaSpacings.m),
              Text(
                "Your pick of rides at low price",
                style: BlaTextStyles.heading.copyWith(color: Colors.white),
              ),
              SizedBox(height: 100),
              Container(
                margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2.1 Display the Form to input the ride preferences
                    // Display the form to input the ride preferences
                    RidePrefForm(
                      initialPreference: currentPreference,
                      onSubmit: (preference) {
                        context
                            .read<RidesPreferencesProvider>()
                            .setCurrentPreference(preference);
                        Navigator.of(context).push(
                            AnimationUtils.createBottomToTopRoute(
                                RidesScreen()));
                      },
                    ),
                    SizedBox(height: BlaSpacings.m),

                    // 2.2 Optionally display a list of past preferences
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: preferencesHistory.length,
                        itemBuilder: (context, index) => RidePrefHistoryTile(
                          ridePref: preferencesHistory[index],
                          onPressed: () =>
                              onRidePrefSelected(preferencesHistory[index]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
