part of '../optimization_flutter.dart';

class OptimizationNavigationMethodChannel
    extends OptimizationNavigationPlatform {
  final MethodChannel _channel =
      OptNavigationMethodChannelsFactory.nbOptNavigationChannel;

  OptimizationNavigationMethodChannel() {
    _channel.setMethodCallHandler(handleMethodCall);
  }

  @visibleForTesting
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      default:
        throw MissingPluginException();
    }
  }
}
