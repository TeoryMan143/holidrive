import 'package:get/get.dart';
import 'package:holidrive/core/lang/en.dart';
import 'package:holidrive/core/lang/es.dart';

class MainMessages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': En().messages,
        'es': Es().messages,
      };
}
