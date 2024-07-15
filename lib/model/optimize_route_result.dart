part of '../optimization_flutter.dart';

class OptimizeRouteResponse {
  String? id;
  String? message;
  String? status;

  OptimizeRouteResponse({this.id, this.message, this.status});

  factory OptimizeRouteResponse.fromJson(Map<String, dynamic> json) {
    return OptimizeRouteResponse(
      id: json['id'],
      message: json['message'],
      status: json['status'],
    );
  }
}

class OptimizeRouteResultResponse {
  OptimizeRouteResult? result;
  String? message;
  String? description;
  String? status;

  OptimizeRouteResultResponse({
    this.result,
    this.message,
    this.description,
    this.status,
  });

  factory OptimizeRouteResultResponse.fromJson(Map<String, dynamic> json) {
    return OptimizeRouteResultResponse(
      result: json['result'] != null
          ? OptimizeRouteResult.fromJson(json['result'])
          : null,
      message: json['message'],
      description: json['description'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result?.toJson(),
      'message': message,
      'description': description,
      'status': status,
    };
  }
}

class OptimizeRouteResult {
  int? code;
  Summary? summary;
  List<Unassigned>? unassigned;
  List<OptimizeRoute>? routes;
  String? error;

  OptimizeRouteResult({
    this.code,
    this.summary,
    this.unassigned,
    this.routes,
    this.error,
  });

  factory OptimizeRouteResult.fromJson(Map<String, dynamic> json) {
    return OptimizeRouteResult(
      code: json['code'],
      summary:
          json['summary'] != null ? Summary.fromJson(json['summary']) : null,
      unassigned: json['unassigned'] != null
          ? List<Unassigned>.from(
              json['unassigned'].map((x) => Unassigned.fromJson(x)))
          : null,
      routes: json['routes'] != null
          ? List<OptimizeRoute>.from(
              json['routes'].map((x) => OptimizeRoute.fromJson(x)))
          : null,
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'summary': summary?.toJson(),
      'unassigned': unassigned?.map((x) => x.toJson()).toList(),
      'routes': routes?.map((x) => x.toJson()).toList(),
      'error': error,
    };
  }
}

class OptimizeRoute {
  String? vehicle;
  int? cost;
  List<OptimizeRouteStep>? steps;
  String? description;
  int? distance;
  int? duration;
  String? geometry;
  List<int>? pickup;
  List<int>? delivery;
  int? priority;
  int? service;
  int? vehicleOvertime;
  int? waitingTime;
  int? setup;

  OptimizeRoute({
    this.vehicle,
    this.cost,
    this.steps,
    this.description,
    this.distance,
    this.duration,
    this.geometry,
    this.pickup,
    this.delivery,
    this.priority,
    this.service,
    this.vehicleOvertime,
    this.waitingTime,
    this.setup,
  });

  factory OptimizeRoute.fromJson(Map<String, dynamic> json) {
    return OptimizeRoute(
      vehicle: json['vehicle'],
      cost: json['cost'],
      steps: json['steps'] != null
          ? List<OptimizeRouteStep>.from(
              json['steps'].map((x) => OptimizeRouteStep.fromJson(x)))
          : null,
      description: json['description'],
      distance: json['distance'],
      duration: json['duration'],
      geometry: json['geometry'],
      pickup: json['pickup'] != null ? List<int>.from(json['pickup']) : null,
      delivery:
          json['delivery'] != null ? List<int>.from(json['delivery']) : null,
      priority: json['priority'],
      service: json['service'],
      vehicleOvertime: json['vehicle_overtime'],
      waitingTime: json['waiting_time'],
      setup: json['setup'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle': vehicle,
      'cost': cost,
      'steps': steps?.map((x) => x.toJson()).toList(),
      'description': description,
      'distance': distance,
      'duration': duration,
      'geometry': geometry,
      'pickup': pickup,
      'delivery': delivery,
      'priority': priority,
      'service': service,
      'vehicle_overtime': vehicleOvertime,
      'waiting_time': waitingTime,
      'setup': setup,
    };
  }
}

class Summary {
  int? cost;
  int? routes;
  int? unassigned;
  int? duration;
  int? distance;
  int? setup;
  int? service;
  int? waitingTime;
  int? priority;
  List<int>? delivery;
  List<int>? pickup;

  Summary({
    this.cost,
    this.routes,
    this.unassigned,
    this.duration,
    this.distance,
    this.setup,
    this.service,
    this.waitingTime,
    this.priority,
    this.delivery,
    this.pickup,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      cost: json['cost'],
      routes: json['routes'],
      unassigned: json['unassigned'],
      duration: json['duration'],
      distance: json['distance'],
      setup: json['setup'],
      service: json['service'],
      waitingTime: json['waiting_time'],
      priority: json['priority'],
      delivery:
          json['delivery'] != null ? List<int>.from(json['delivery']) : null,
      pickup: json['pickup'] != null ? List<int>.from(json['pickup']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cost': cost,
      'routes': routes,
      'unassigned': unassigned,
      'duration': duration,
      'distance': distance,
      'setup': setup,
      'service': service,
      'waiting_time': waitingTime,
      'priority': priority,
      'delivery': delivery,
      'pickup': pickup,
    };
  }
}

class OptimizeRouteStep {
  String? id;
  String? type;
  int? arrival;
  int? duration;
  List<double>? location;
  List<double>? projectedLocation;
  int? locationIndex;
  List<int>? load;
  int? service;
  int? waitingTime;
  int? setup;
  String? lateBy;
  String? description;
  int? distance;
  List<double>? snappedLocation;

  OptimizeRouteStep({
    this.id,
    this.type,
    this.arrival,
    this.duration,
    this.location,
    this.projectedLocation,
    this.locationIndex,
    this.load,
    this.service,
    this.waitingTime,
    this.setup,
    this.lateBy,
    this.description,
    this.distance,
    this.snappedLocation,
  });

  factory OptimizeRouteStep.fromJson(Map<String, dynamic> json) {
    return OptimizeRouteStep(
      id: json['id'],
      type: json['type'],
      arrival: json['arrival'],
      duration: json['duration'],
      location: json['location'] != null
          ? List<double>.from(json['location'].map((x) => x.toDouble()))
          : null,
      projectedLocation: json['projected_location'] != null
          ? List<double>.from(
              json['projected_location'].map((x) => x.toDouble()))
          : null,
      locationIndex: json['location_index'],
      load: json['load'] != null ? List<int>.from(json['load']) : null,
      service: json['service'],
      waitingTime: json['waiting_time'],
      setup: json['setup'],
      lateBy: json['late_by'],
      description: json['description'],
      distance: json['distance'],
      snappedLocation: json['snapped_location'] != null
          ? List<double>.from(json['snapped_location'].map((x) => x.toDouble()))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'arrival': arrival,
      'duration': duration,
      'location': location,
      'projected_location': projectedLocation,
      'location_index': locationIndex,
      'load': load,
      'service': service,
      'waiting_time': waitingTime,
      'setup': setup,
      'late_by': lateBy,
      'description': description,
      'distance': distance,
      'snapped_location': snappedLocation,
    };
  }
}

class Unassigned {
  String? id;
  String? type;
  List<double>? location;
  String? reason;

  Unassigned({
    this.id,
    this.type,
    this.location,
    this.reason,
  });

  factory Unassigned.fromJson(Map<String, dynamic> json) {
    return Unassigned(
      id: json['id'],
      type: json['type'],
      location: json['location'] != null
          ? List<double>.from(json['location'].map((x) => x.toDouble()))
          : null,
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'location': location,
      'reason': reason,
    };
  }
}
