import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// چک کردن اتصال اینترنت
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    final result = await connectionChecker.hasInternetAccess;
    return result;
  }
}
