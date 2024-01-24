import 'package:flutter/foundation.dart';

printToConsole(String message) {
  if (kDebugMode) {
    print(message);
  }
}