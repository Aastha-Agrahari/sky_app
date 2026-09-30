import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_app/app.dart';
import 'package:sky_app/data/repositories/weather_repository.dart';
import 'package:sky_app/data/services/location_service.dart';
import 'package:sky_app/data/services/weather_api_service.dart';
import 'package:sky_app/data/services/weather_cache_service.dart';
void main() { testWidgets('Skycast app loads successfully',
        (WidgetTester tester) async {
  // Initialize SharedPreferences for testing.
          SharedPreferences.setMockInitialValues({});
          final prefs = await SharedPreferences.getInstance();
          // Create the repository required by SkycastApp.
          final repository = WeatherRepository(
            api: WeatherApiService(),
            location: LocationService(),
            cache: WeatherCacheService(prefs), );
          // Build the Skycast app.
          await tester.pumpWidget( SkycastApp(repository: repository), );
          // Allow the first frame to render.
          await tester.pump();
  // Verify that the app is loaded.
          expect(find.byType(SkycastApp), findsOneWidget);
}); }