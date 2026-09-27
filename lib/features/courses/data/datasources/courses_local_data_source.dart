import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/course_model.dart';

abstract class CoursesLocalDataSource {
  Future<List<CourseModel>> getCourses();
}

class CoursesLocalDataSourceImpl implements CoursesLocalDataSource {
  static const String _assetPath = 'assets/data/courses.json';

  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException catch (e) {
      throw CacheException(
        message: 'Malformed courses JSON: ${e.message}',
      );
    } on Exception catch (e) {
      throw CacheException(
        message: 'Failed to load courses asset: $e',
      );
    }
  }
}

