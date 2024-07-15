# optimization-flutter-sdk

The `optimization-flutter-sdk` SDK provides tools for optimizing routes using the NextBillion API. This SDK allows you to plan routes with multiple waypoints and optimize them efficiently.

## Table of Contents

- [Initialization](#initialization)
- [Usage](#usage)
    - [Optimize Route with Multiple Waypoints](#optimize-route-with-multiple-waypoints)
    - [Optimize Route with Request Body](#optimize-route-with-request-body)
    - [Error Handling](#error-handling)
- [Examples](#examples)
- [License](#license)

## Initialization

Before using the SDK, you need to initialize it with your NextBillion access key.

```
import 'package:nextbillion_optimization/nextbillion_optimization.dart';

void main() {
  NextBillionOptimization.initialize('YOUR_ACCESS_KEY');
}
```

### Usage
#### Optimize Route with Multiple Waypoints
To optimize a route with multiple waypoints, use the optimizeRouteWithMultiWaypoints method.
```
import 'package:nextbillion_optimization/nextbillion_optimization.dart';

OptimizeRequestParams optimizeRequest = OptimizeRequestParams(
  // Fill in with your request parameters
);

Future<void> getOptimizedRoute() async {
  OptimizeRouteResultResponse? response = await NextBillionOptimization.optimizeRouteWithMultiWaypoints(optimizeRequest);
  if (response != null) {
    print(response.result);
  } else {
    print('Failed to get optimized route');
  }
}
```

#### Optimize Route with Request Body
To optimize a route using a custom request body, use the optimizeRouteWithRequestBody method.
```
import 'package:nextbillion_optimization/nextbillion_optimization.dart';

Map<String, dynamic> requestBody = {
  // Fill in with your request body
};

Future<void> getOptimizedRoute() async {
  OptimizeRouteResultResponse? response = await NextBillionOptimization.optimizeRouteWithRequestBody(requestBody);
  if (response != null) {
    print(response.result);
  } else {
    print('Failed to get optimized route');
  }
}
```
#### Error Handling
The SDK handles errors using DioException. Ensure to catch and handle errors appropriately in your application.

```
try {
  OptimizeRouteResultResponse? response = await NextBillionOptimization.optimizeRouteWithMultiWaypoints(optimizeRequest);
  // Process response
} catch (e) {
  if (e is DioException) {
    print('Dio error: ${e.response?.data}');
  } else {
    print('Error: $e');
  }
}
```