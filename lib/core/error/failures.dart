// lib/core/error/failures.dart
import 'package:equatable/equatable.dart';

/// Failureها برای سطح Domain/Presentation
abstract class Failure extends Equatable {
  final String? message;
  
  const Failure({this.message});
  
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

class CityNotFoundFailure extends Failure {
  const CityNotFoundFailure({super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message});
}