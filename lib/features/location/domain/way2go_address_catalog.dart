import 'dart:convert';

import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/location/domain/lebanon_geography.dart';
import 'package:ride_sharing_user_app/features/location/domain/models/prediction_model.dart';
import 'package:ride_sharing_user_app/features/location/domain/models/way2go_catalog_address.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Local search over Way2Go `/api/addresses` — avoids Places Autocomplete + Details.
class Way2GoAddressCatalog {
  static const String catalogPlaceIdPrefix = 'catalog:';
  static const Duration cacheTtl = Duration(hours: 24);
  static const int maxSuggestions = 12;

  static List<Way2GoCatalogAddress>? _cached;
  static DateTime? _cachedAt;

  static String placeIdFor(double lat, double lng) =>
      '$catalogPlaceIdPrefix$lat,$lng';

  static bool isCatalogPlaceId(String? placeId) =>
      placeId != null && placeId.startsWith(catalogPlaceIdPrefix);

  static LatLng? latLngFromPlaceId(String placeId) {
    if (!isCatalogPlaceId(placeId)) return null;
    final coords = placeId.substring(catalogPlaceIdPrefix.length).split(',');
    if (coords.length != 2) return null;
    final lat = double.tryParse(coords[0]);
    final lng = double.tryParse(coords[1]);
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }

  static Future<List<Way2GoCatalogAddress>> loadCatalog(ApiClient apiClient) async {
    if (_cached != null &&
        _cachedAt != null &&
        DateTime.now().difference(_cachedAt!) < cacheTtl) {
      return _cached!;
    }

    final response = await apiClient.getData(AppConstants.addressesCatalogUri);
    if (response.statusCode != 200 || response.body == null) {
      return _cached ?? [];
    }

    final List<dynamic> raw;
    if (response.body is List) {
      raw = response.body as List<dynamic>;
    } else if (response.body is String) {
      raw = jsonDecode(response.body as String) as List<dynamic>;
    } else {
      return _cached ?? [];
    }

    final list = raw
        .map((e) => Way2GoCatalogAddress.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .where((a) => a.isValid && LebanonGeography.contains(LatLng(a.lat, a.lng)))
        .toList();

    _cached = list;
    _cachedAt = DateTime.now();
    return list;
  }

  static List<Suggestions> search(List<Way2GoCatalogAddress> catalog, String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return [];

    final scored = <_ScoredAddress>[];
    for (final item in catalog) {
      final label = item.address.toLowerCase();
      final score = _matchScore(label, normalized);
      if (score > 0) {
        scored.add(_ScoredAddress(item, score));
      }
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored
        .take(maxSuggestions)
        .map((e) => _toSuggestion(e.address))
        .toList();
  }

  static int _matchScore(String label, String query) {
    if (label == query) return 100;
    if (label.startsWith(query)) return 80;
    if (label.contains(query)) return 50;
    final tokens = query.split(RegExp(r'\s+')).where((t) => t.length > 1);
    var matched = 0;
    for (final token in tokens) {
      if (label.contains(token)) matched++;
    }
    if (matched == 0) return 0;
    return 30 + matched * 10;
  }

  static Suggestions _toSuggestion(Way2GoCatalogAddress item) {
    return Suggestions(
      placePrediction: PlacePrediction(
        placeId: placeIdFor(item.lat, item.lng),
        text: Description(text: item.address),
      ),
    );
  }
}

class _ScoredAddress {
  final Way2GoCatalogAddress address;
  final int score;
  _ScoredAddress(this.address, this.score);
}
