import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class AppTranslations extends Translations {
  static final Map<String, Map<String, String>> _localizedValues = {};

  @override
  Map<String, Map<String, String>> get keys => _localizedValues;

  static Future<void> loadTranslations() async {
    Map<String, String> en = await _loadJson('assets/lang/en.json');
    Map<String, String> si = await _loadJson('assets/lang/si.json');
    Map<String, String> ta = await _loadJson('assets/lang/ta.json');

    _localizedValues['en_US'] = en;
    _localizedValues['si_LK'] = si;
    _localizedValues['ta_IN'] = ta;
  }

  static Future<Map<String, String>> _loadJson(String path) async {
    String jsonString = await rootBundle.loadString(path);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return _flattenJson(jsonMap);
  }

  static Map<String, String> _flattenJson(Map<String, dynamic> jsonMap, [String prefix = '']) {
    Map<String, String> result = {};
    jsonMap.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        result.addAll(_flattenJson(value, '$prefix$key.'));
      } else {
        result['$prefix$key'] = value.toString();
      }
    });
    return result;
  }
}

class AppTranslationsLoader {
  static Future<void> load() async {
    await AppTranslations.loadTranslations();
  }
}
