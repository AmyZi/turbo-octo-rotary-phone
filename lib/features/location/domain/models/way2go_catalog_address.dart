/// Predefined area from `GET /api/addresses` (no Google Places billing).
class Way2GoCatalogAddress {
  final String address;
  final double lat;
  final double lng;

  const Way2GoCatalogAddress({
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory Way2GoCatalogAddress.fromJson(Map<String, dynamic> json) {
    final lat = _readDouble(json['lat']);
    final lng = _readDouble(json['long'] ?? json['lng']);
    return Way2GoCatalogAddress(
      address: json['address']?.toString() ?? '',
      lat: lat,
      lng: lng,
    );
  }

  static double _readDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  bool get isValid =>
      address.isNotEmpty && lat != 0 && lng != 0;
}
