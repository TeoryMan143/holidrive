import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkRepository {
  static Future<Map<String, dynamic>?> fetch(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw HttpException('Places api error', uri: uri);
      }
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint(e.toString());
      return {'error': e.toString()};
    }
  }
}
