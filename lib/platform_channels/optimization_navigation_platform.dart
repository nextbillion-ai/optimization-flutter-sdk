part of '../optimization_flutter.dart';

abstract class OptimizationNavigationPlatform {
  static final OptimizationNavigationPlatform _instance =
      OptimizationNavigationMethodChannel();

  static OptimizationNavigationPlatform get instance => _instance;
}
