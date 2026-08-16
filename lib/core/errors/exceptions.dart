import 'app_exception.dart';

class ServerException extends AppException {
  final String? message;
  final int? statusCode;

  ServerException({this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class CacheException extends AppException {
  final String? message;

  CacheException({this.message});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException extends AppException {
  final String? message;

  NetworkException({this.message});

  @override
  String toString() => 'NetworkException: $message';
}
