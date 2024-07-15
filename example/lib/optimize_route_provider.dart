import 'package:flutter/cupertino.dart';
import 'package:nb_optimization_navigation/optimization_flutter.dart';

class OptimizeRouteProvider extends ChangeNotifier {
  OptimizeRoute? _optimizeRoute;

  OptimizeRoute? get optimizeRoute => _optimizeRoute;

  set optimizeRoute(OptimizeRoute? value) {
    _optimizeRoute = value;
    notifyListeners();
  }
}
