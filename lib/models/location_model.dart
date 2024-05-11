// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// Project: 	   muutsch
// File:    	   location_model
// Path:    	   lib/models/location_model.dart
// Author:       Ali Akbar
// Date:        10-05-24 18:27:50 -- Friday
// Description:

class UserLocationModel {
  final double latitude;
  final double longitude;
  final String? city;
  final String? country;
  final String? address;
  UserLocationModel({
    required this.latitude,
    required this.longitude,
    this.city,
    this.country,
    this.address,
  });

  UserLocationModel copyWith({
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    String? address,
  }) {
    return UserLocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
      'address': address,
    };
  }

  factory UserLocationModel.fromMap(Map<String, dynamic> map) {
    return UserLocationModel(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      city: map['city'] != null ? map['city'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLocationModel.fromJson(String source) =>
      UserLocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LocationModel(latitude: $latitude, longitude: $longitude, city: $city, country: $country, address: $address)';
  }

  @override
  bool operator ==(covariant UserLocationModel other) {
    if (identical(this, other)) return true;

    return other.latitude == latitude &&
        other.longitude == longitude &&
        other.city == city &&
        other.country == country &&
        other.address == address;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
        longitude.hashCode ^
        city.hashCode ^
        country.hashCode ^
        address.hashCode;
  }
}