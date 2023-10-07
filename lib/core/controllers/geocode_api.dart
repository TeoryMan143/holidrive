import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holidrive/core/controllers/network_repository.dart';

class GeocodingAPI {
  static const key = 'AIzaSyDHSWxm4omivlUUbMlLIFmEWHObSbf94Vk';

  static Future<Map<String, dynamic>?> getCurrentLocationAddress(
    LatLng coords,
  ) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      'maps/api/geocode/json',
      {
        'latlng': '${coords.latitude},${coords.longitude}',
        'key': key,
        'language': Localizations.localeOf(Get.context!) == const Locale('es')
            ? 'es'
            : 'en',
        'region': 'co',
      },
    );
    return await NetworkRepository.fetch(uri);
  }

  static Future<Map<String, dynamic>?> getLocationPlacesFromQuery(
    String query,
  ) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      'maps/api/place/textsearch/json',
      {
        'query': query,
        'radius': '50000',
        'key': key,
        'language': Localizations.localeOf(Get.context!) == const Locale('es')
            ? 'es'
            : 'en',
        'region': 'co',
      },
    );
    return await NetworkRepository.fetch(uri);
  }
}
