import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nb_navigation_flutter/nb_navigation_flutter.dart';
import 'package:nb_optimization_navigation/optimization_flutter.dart';
import 'package:provider/provider.dart';
import 'optimize_route_provider.dart';

class FullNavigationExample extends StatefulWidget {
  static const String title = "Full Navigation Experience Example";

  const FullNavigationExample({super.key});

  @override
  FullNavigationExampleState createState() => FullNavigationExampleState();
}

class FullNavigationExampleState extends State<FullNavigationExample>
    with AutomaticKeepAliveClientMixin {
  NextbillionMapController? controller;
  List<DirectionsRoute> routes = [];
  late NavNextBillionMap navNextBillionMap;
  Symbol? mapMarkerSymbol;

  String locationTrackImage = "assets/location_on.png";
  UserLocation? currentLocation;
  List<LatLng> waypoints = [];
  bool loading = false;

  void _onMapCreated(NextbillionMapController controller) {
    this.controller = controller;
  }

  _onStyleLoadedCallback() {
    if (controller != null) {
      NavNextBillionMap.create(controller!).then((value) {
        navNextBillionMap = value;
        loadAssetImage();
        Fluttertoast.showToast(
            msg: "Long press to select a destination to fetch a route");
        if (currentLocation != null) {
          controller?.animateCamera(
              CameraUpdate.newLatLngZoom(currentLocation!.position, 14),
              duration: const Duration(milliseconds: 400));
        }
      });
    }
  }

  _onMapLongClick(Point<double> point, LatLng coordinates) {
    _fetchRoute(coordinates);
  }

  _onMapClick(Point<double> point, LatLng coordinates) {
    navNextBillionMap.addRouteSelectedListener(coordinates,
        (selectedRouteIndex) {
      if (routes.isNotEmpty && selectedRouteIndex != 0) {
        var selectedRoute = routes[selectedRouteIndex];
        routes.removeAt(selectedRouteIndex);
        routes.insert(0, selectedRoute);
        setState(() {
          routes = routes;
        });
        navNextBillionMap.drawRoute(routes);
      }
    });
  }

  _onUserLocationUpdate(UserLocation location) {
    currentLocation = location;
  }

  _onCameraTrackingChanged() {
    setState(() {
      locationTrackImage = 'assets/location_off.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        NBMap(
          onMapCreated: _onMapCreated,
          onStyleLoadedCallback: _onStyleLoadedCallback,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 14.0,
          ),
          trackCameraPosition: true,
          myLocationEnabled: true,
          myLocationTrackingMode: MyLocationTrackingMode.Tracking,
          onMapLongClick: _onMapLongClick,
          onUserLocationUpdated: _onUserLocationUpdate,
          onCameraTrackingDismissed: _onCameraTrackingChanged,
          onMapClick: _onMapClick,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    child: Image(
                      image: AssetImage(locationTrackImage),
                      width: 28,
                      height: 28,
                    ),
                    onTap: () {
                      controller?.updateMyLocationTrackingMode(
                          MyLocationTrackingMode.Tracking);
                      setState(() {
                        locationTrackImage = 'assets/location_on.png';
                      });
                    }),
              ),
              const Padding(padding: EdgeInsets.only(top: 35)),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              (waypoints.length >= 2 &&
                                      waypoints.length % 2 == 0)
                                  ? Colors.blueAccent
                                  : Colors.grey),
                          enableFeedback: routes.isNotEmpty),
                      onPressed: (waypoints.length >= 2 &&
                              waypoints.length % 2 == 0)
                          ? () async {
                              setState(() {
                                loading = true;
                              });
                              List<OptLatLng> locations = waypoints
                                  .map(
                                      (e) => OptLatLng(e.latitude, e.longitude))
                                  .toList();
                              locations.insert(
                                  0,
                                  OptLatLng(currentLocation!.position.latitude,
                                      currentLocation!.position.longitude));
                              Locations location =
                                  Locations(id: 1, locations: locations);
                              Vehicle vehicle = Vehicle(id: "vehicle 1");
                              List<Shipment> shipments = [];
                              for (int i = 1; i < waypoints.length; i += 2) {
                                var pickup = PickupDelivery(
                                    id: i.toString(),
                                    description: "Pickup $i",
                                    locationIndex: i);
                                var delivery = PickupDelivery(
                                    id: (i + 1).toString(),
                                    description: "Delivery ${i + 1}",
                                    locationIndex: i + 1);
                                shipments.add(Shipment(
                                    pickup: pickup, delivery: delivery));
                              }

                              OptimizeRequestParams request =
                                  OptimizeRequestParams(
                                      locations: location,
                                      vehicles: [vehicle],
                                      shipments: shipments);
                              var result = await NextBillionOptimization
                                  .optimizeRouteWithMultiWaypoints(request);
                              var optimizeResult = result?.result;

                              if (optimizeResult != null &&
                                  optimizeResult.routes?.isNotEmpty == true) {
                                var route = optimizeResult.routes?[0];
                                Provider.of<OptimizeRouteProvider>(context,
                                        listen: false)
                                    .optimizeRoute = route;

                                if (route != null &&
                                    route.steps?.isNotEmpty == true) {
                                  var reOrderedWaypoint = route.steps!
                                      .map((e) => LatLng(
                                          e.location![0], e.location![1]))
                                      .toList();
                                  waypoints = reOrderedWaypoint.sublist(
                                      1, reOrderedWaypoint.length - 1);
                                  _fetchRouteWithWaypoints(waypoints);
                                }
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                Fluttertoast.showToast(
                                    msg:
                                        "${result?.status ?? ""}: ${result?.message}");
                              }
                            }
                          : null,
                      child: const Text("Optimize Route")),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              routes.isEmpty ? Colors.grey : Colors.blueAccent),
                          enableFeedback: routes.isNotEmpty),
                      onPressed: routes.isEmpty
                          ? null
                          : () {
                              _startNavigation();
                            },
                      child: const Text("Start Navigation")),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              routes.isEmpty ? Colors.grey : Colors.blueAccent),
                          enableFeedback: routes.isNotEmpty),
                      onPressed: routes.isEmpty
                          ? null
                          : () {
                              clearRouteResult();
                              waypoints.clear();
                              Provider.of<OptimizeRouteProvider>(context,
                                      listen: false)
                                  .optimizeRoute = null;
                            },
                      child: const Text("Clear Routes")),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 48)),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: Text("route response: ${routeResult}"),
              // ),
            ],
          ),
        ),
        Center(child: loading ? const CircularProgressIndicator() : Container())
      ],
    );
  }

  void _fetchRoute(LatLng destination) async {
    if (currentLocation == null) {
      return;
    }
    waypoints.add(destination);
    _fetchRouteWithWaypoints(waypoints);
  }

  void _fetchRouteWithWaypoints(List<LatLng> waypoints) async {
    RouteRequestParams requestParams = RouteRequestParams(
      origin: currentLocation!.position,
      destination: waypoints.last,
      // overview: ValidOverview.simplified,
      // avoid: [SupportedAvoid.toll, SupportedAvoid.ferry],
      // option: SupportedOption.flexible,
      // truckSize: [200, 200, 600],
      // truckWeight: 100,
      // unit: SupportedUnits.imperial,
      alternatives: true,
      mode: ValidModes.car,
    );

    if (waypoints.length > 1) {
      requestParams.waypoints = waypoints.sublist(0, waypoints.length - 1);
    }

    DirectionsRouteResponse routeResponse =
        await NBNavigation.fetchRoute(requestParams);
    setState(() {
      loading = false;
    });
    if (routeResponse.directionsRoutes.isNotEmpty) {
      clearRouteResult();
      setState(() {
        routes = routeResponse.directionsRoutes;
      });
      drawRoutes(routes);
      fitCameraToBounds(routes);
      addImageFromAsset(waypoints.last);
    } else if (routeResponse.message != null) {
      if (kDebugMode) {
        print(
            "====error====${routeResponse.message}===${routeResponse.errorCode}");
      }
    }
  }

  Future<void> drawRoutes(List<DirectionsRoute> routes) async {
    navNextBillionMap.drawRoute(routes);
  }

  void fitCameraToBounds(List<DirectionsRoute> routes) {
    List<LatLng> multiPoints = [];
    for (var route in routes) {
      var routePoints =
          decode(route.geometry ?? '', _getDecodePrecision(route.routeOptions));
      multiPoints.addAll(routePoints);
    }
    if (multiPoints.isNotEmpty) {
      var latLngBounds = LatLngBounds.fromMultiLatLng(multiPoints);
      controller?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds,
          top: 50, left: 50, right: 50, bottom: 50));
    }
  }

  int _getDecodePrecision(RouteRequestParams? routeOptions) {
    return routeOptions?.geometry == SupportedGeometry.polyline
        ? precision
        : precision6;
  }

  void clearRouteResult() async {
    navNextBillionMap.clearRoute();
    controller?.clearSymbols();
    setState(() {
      routes.clear();
    });
  }

  void _startNavigation() {
    if (routes.isEmpty) return;
    NavigationLauncherConfig config =
        NavigationLauncherConfig(route: routes.first, routes: routes);
    config.locationLayerRenderMode = LocationLayerRenderMode.gps;
    config.shouldSimulateRoute = true;
    config.themeMode = NavigationThemeMode.system;
    config.useCustomNavigationStyle = false;
    NBNavigation.startNavigation(config);
  }

  Future<void> loadAssetImage() async {
    final ByteData bytes = await rootBundle.load("assets/map_marker_light.png");
    final Uint8List list = bytes.buffer.asUint8List();
    await controller?.addImage("ic_marker_destination", list);
  }

  Future<void> addImageFromAsset(LatLng coordinates) async {
    controller?.clearSymbols();
    var symbolOptions = SymbolOptions(
      geometry: coordinates,
      iconImage: "ic_marker_destination",
    );
    await controller?.addSymbol(symbolOptions);
    controller?.symbolManager?.setTextAllowOverlap(false);
  }

  @override
  bool get wantKeepAlive => true;
}
