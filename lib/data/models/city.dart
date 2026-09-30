class City {
  const City({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.admin1,
    this.country,
    this.isCurrentLocation = false,
  });

  final String name;
  final String? admin1;
  final String? country;
  final double latitude;
  final double longitude;
  final bool isCurrentLocation;

  String get subtitle => [admin1, country]
      .whereType<String>()
      .where((part) => part.isNotEmpty)
      .join(', ');

  factory City.fromGeocoding(Map<String, dynamic> json) => City(
        name: json['name'] as String,
        admin1: json['admin1'] as String?,
        country: json['country'] as String?,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json['name'] as String,
        admin1: json['admin1'] as String?,
        country: json['country'] as String?,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        isCurrentLocation: json['isCurrentLocation'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'admin1': admin1,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'isCurrentLocation': isCurrentLocation,
      };
}
