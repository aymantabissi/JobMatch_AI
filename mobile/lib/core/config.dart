
import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConfig {
  static const _override = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;

    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';
    }

    return 'http://localhost:5000/api';
  }
}
