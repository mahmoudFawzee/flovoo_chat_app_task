import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '/core/errors/exceptions.dart';
import '/core/errors/failures.dart';

typedef Method<T> = T Function();
typedef AsyncMethod<T> = Future<T> Function();
typedef StreamMethod<T> = Stream<T> Function();

//?here we will make a center method to catch errors
//? and convert them to failure
Future<Either<Failure, T>> futureExceptionWrapper<T>(
  AsyncMethod<T> method,
) async {
  try {
    return Right(await method());
  } on ServerException catch (e, stack) {
    log('$stack');
    return Left(ServerFailure(e.message));
  } on NetworkException catch (e, stack) {
    log('$stack');

    return Left(NetworkFailure(e.message));
  } on CacheException catch (e, stack) {
    log('$stack');

    return Left(CacheFailure(e.message));
  } on RequestException catch (e, stack) {
    log('$stack');

    return Left(RequestFailure(e.message));
  } on DioException catch (e, stack) {
    log('$stack');

    return Left(RequestFailure(e.message ?? 'Some Error Happened'));
  } catch (e, stackTrace) {
    log('$stackTrace');
    return Left(Failure(e.toString()));
  }
}

Either<Failure, Stream<T>> streamExceptionWrapper<T>(StreamMethod<T> method) {
  try {
    return Right(method());
  } on ServerException catch (e, stack) {
    log('$stack');
    return Left(ServerFailure(e.message));
  } on NetworkException catch (e, stack) {
    log('$stack');

    return Left(NetworkFailure(e.message));
  } on CacheException catch (e, stack) {
    log('$stack');

    return Left(CacheFailure(e.message));
  } on SocketException catch (e, stack) {
    log('$stack');

    return Left(SocketFailure(e.message));
  } on RequestException catch (e, stack) {
    log('$stack');

    return Left(RequestFailure(e.message));
  } on DioException catch (e, stack) {
    log('$stack');

    return Left(RequestFailure(e.message ?? 'Some Error Happened'));
  } catch (e, stackTrace) {
    log('$stackTrace');
    return Left(Failure(e.toString()));
  }
}

Either<Failure, T> exceptionWrapper<T>(Method<T> method) {
  try {
    return Right(method());
  } on CacheException catch (e, stack) {
    log('$stack');

    return Left(CacheFailure(e.message));
  } catch (e, stackTrace) {
    log('$stackTrace');
    return Left(Failure(e.toString()));
  }
}
