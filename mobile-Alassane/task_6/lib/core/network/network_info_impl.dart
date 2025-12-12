import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  bool connected;
  NetworkInfoImpl({this.connected = true});

  @override
  Future<bool> get isConnected async => connected;
}