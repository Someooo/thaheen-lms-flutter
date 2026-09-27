import 'package:get/get.dart';

class LocalizedContent {
  final String ar;
  final String en;

  const LocalizedContent({
    required this.ar,
    required this.en,
  });

  factory LocalizedContent.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return LocalizedContent(
        ar: json['ar'] as String? ?? '',
        en: json['en'] as String? ?? '',
      );
    }
    if (json is String) {
      return LocalizedContent(ar: json, en: json);
    }
    return const LocalizedContent(ar: '', en: '');
  }

  String get value {
    final isEn = Get.locale?.languageCode == 'en';
    if (isEn && en.isNotEmpty) {
      return en;
    }
    return ar.isNotEmpty ? ar : en;
  }

  @override
  String toString() => value;
}
