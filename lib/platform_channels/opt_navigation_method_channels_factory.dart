part of '../optimization_flutter.dart';

class OptNavigationMethodChannelsFactory {
  static const MethodChannel _nbOptNavigationChannel =
      MethodChannel("nb_optimization_navigation");

  static MethodChannel get nbOptNavigationChannel => _nbOptNavigationChannel;
}
