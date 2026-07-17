import 'package:google_maps_flutter/google_maps_flutter.dart';

/// WGS84 bounds covering Lebanon. Used for map constraints and location validation.
abstract final class LebanonGeography {
  static const double southLat = 33.02;
  static const double northLat = 34.72;
  static const double westLng = 35.05;
  static const double eastLng = 36.65;

  static final LatLngBounds latLngBounds = LatLngBounds(
    southwest: const LatLng(southLat, westLng),
    northeast: const LatLng(northLat, eastLng),
  );

  static final CameraTargetBounds cameraTargetBounds =
      CameraTargetBounds(latLngBounds);

  /// Approximate visual center (Beirut area).
  static const LatLng defaultCenter = LatLng(33.8938, 35.5018);

  static bool contains(LatLng point) {
    final lat = point.latitude;
    final lng = point.longitude;
    return lat >= southLat &&
        lat <= northLat &&
        lng >= westLng &&
        lng <= eastLng;
  }
}
