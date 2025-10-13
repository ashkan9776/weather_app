// lib/core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';

/// پایه تمام UseCaseها
/// Type: نوع خروجی
/// Params: نوع ورودی
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// وقتی UseCase پارامتری نمیخواد
class NoParams {}
