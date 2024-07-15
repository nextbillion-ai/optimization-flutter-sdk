part of '../optimization_flutter.dart';

class OptimizeRequestParams {
  Locations locations;
  String? description;
  List<Vehicle> vehicles;
  List<Shipment> shipments;

  /// Constructs an [OptimizeRequestParams] object.
  ///
  /// [locations] - The locations object is used to define all the locations to be used during optimization.
  /// Read more about this attribute in the [Locations] Object section.
  /// [description] - An optional description of the optimization request.
  /// [vehicles] - The vehicles attribute describes the characteristics
  /// and constraints of the vehicles that will be used for fulfilling the tasks.
  /// [shipments] - The shipments object is used to collect the details of shipments
  /// that need to be completed as part of the optimization process.
  /// Each shipment should have a pickup and the corresponding delivery step.
  ///
  /// For more information, You can check it in the API document(https://docs.nextbillion.ai/docs/optimization/api/route-optimization-flexible).
  OptimizeRequestParams({
    required this.locations,
    this.description,
    required this.vehicles,
    required this.shipments,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['locations'] = locations.toJson();
    if (description != null) {
      data['description'] = description;
    }
    data['vehicles'] = vehicles.map((veh) => veh.toJson()).toList();
    data['shipments'] = shipments.map((ship) => ship.toJson()).toList();

    return data;
  }
}

class Locations {
  int id;
  List<OptLatLng> locations;

  /// Constructs an [Locations] object.
  ///
  /// [id] - A unique ID for the set of locations. It should be a positive integer.
  /// [locations] - Indicate all the location coordinates that will be used during optimization.
  /// The coordinates should be specified in the format latitude, longitude.
  /// It is recommended to avoid adding duplicate location coordinates to this array.
  /// In case there are multiple tasks at the same location,
  /// users can repeat the index of the location while configuring all such tasks.
  Locations({
    required this.id,
    required this.locations,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location':
          locations.map((loc) => "${loc.latitude},${loc.longitude}").toList(),
    };
  }
}

class Vehicle {
  String id;
  String? description;
  List<int>? capacity;

  /// Constructs an [Vehicle] object.
  ///
  /// [id] - Specify a unique ID for the vehicle. If multiple vehicles share the same ID,
  /// API would return an error. The IDs are case-sensitive.
  /// Please note that this field is mandatory and providing an empty string will result in an error.
  ///  Note: We have modified the data type of this field.
  ///  However, the latest change is backward compatible and an integer type vehicle ID is also valid.
  ///  [capacity] - The capacity attribute is used to describe the multidimensional quantities of capacity for each vehicle.
  /// It is recommended to keep the dimensions of capacity and pickup or delivery in jobs and amount in shipments consistent.
  /// Read more about the behavior of this attribute in the Capacity Restrictions(https://docs.nextbillion.ai/docs/optimization/api/route-optimization-fast#capacity-restrictions) section.
  /// [description] - An optional description of the vehicle.

  Vehicle({
    required this.id,
    this.capacity,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['start_index'] = 0;
    if (capacity != null) {
      data['capacity'] = capacity;
    }
    if (description != null) {
      data['description'] = description;
    }

    return data;
  }
}

class PickupDelivery {
  String id;
  String? description;
  int locationIndex;
  int? service;

  /// Constructs an [PickupDelivery] object.
  ///
  /// [id] - Indicate the ID of this shipment pickup step.
  /// An error will be reported if there are duplicate IDs for multiple shipment pick-ups.
  /// The IDs are case-sensitive. Please note id is mandatory when using the shipments attribute.
  /// [locationIndex] - Indicate the index of location for this shipment delivery.
  /// The index references the locations present in the location array.
  /// The valid range of value is [0, length of location array)
  /// [description] - An optional description of the pickup or delivery step.
  /// [service] - Provide the time duration, in seconds,
  /// needed to complete the shipment delivery. Default value is 0.
  PickupDelivery({
    required this.id,
    required this.locationIndex,
    this.description,
    this.service,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    if (description != null) {
      data['description'] = description;
    }
    if (service != null) {
      data['service'] = service;
    }
    data['location_index'] = locationIndex;

    return data;
  }
}

class Shipment {
  PickupDelivery pickup;
  PickupDelivery delivery;
  List<int>? amount;
  List<int>? skills;
  int? priority;
  int? maxTimeInVehicle;

  /// Constructs an [Shipment] object.
  /// The shipments object is used to collect the details of shipments
  /// that need to be completed as part of the optimization process.
  /// Each shipment should have a pickup and the corresponding delivery step.
  /// [pickup] - Specify the details of the pickup step of the shipment.
  /// [delivery] - Specify the details of the delivery step of the shipment.
  /// [amount] - This parameter defines the quantity that needs to be shipped.
  /// This attribute supports multidimensional quantities,
  /// to support shipment of quantities of different units/dimensions.
  /// It is recommended to keep the dimensions of amount in shipments and that of capacity in vehicles consistent.
  /// Please note that the amount will be added to the assigned vehicle's initial load.
  /// [skills] - Define the skills needed to complete the shipment.
  /// This attribute supports multidimensional skills allowing users to add multiple skills for a shipment.
  /// [priority] - Specify the priority of this shipment.
  /// The valid values are in the range of [0, 100]. Default value is 0.
  /// Please note that setting a priority will only decide whether this shipment will be assigned or not,
  /// but has nothing to do with the sequence of fulfilling shipments.
  /// [maxTimeInVehicle] - Use this parameter to limit the drive time for which a shipment stays in the vehicle.
  /// The time-in-vehicle calculations start once the pickup leg of shipment is completed after serving any setup and service time that may have been configured for it.
  /// For the delivery leg, time-in-vehicle calculations wouldn't consider any setup and service time
  /// that needs to be served for completing the delivery.
  /// The service or setup times of other tasks performed in between will also be not accumulated against the time-in-vehicle limit.
  /// If the shipment is not delivered within the specified time, it will be considered as unassigned.
  Shipment({
    required this.pickup,
    required this.delivery,
    this.amount,
    this.skills,
    this.priority,
    this.maxTimeInVehicle,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['pickup'] = pickup.toJson();
    data['delivery'] = delivery.toJson();
    if (amount != null) {
      data['amount'] = amount;
    }
    if (skills != null) {
      data['skills'] = skills;
    }
    if (priority != null) {
      data['priority'] = priority;
    }
    if (maxTimeInVehicle != null) {
      data['max_time_in_vehicle'] = maxTimeInVehicle;
    }

    return data;
  }
}
