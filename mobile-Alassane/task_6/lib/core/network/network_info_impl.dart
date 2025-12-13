import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl({required this.connectionChecker});

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}