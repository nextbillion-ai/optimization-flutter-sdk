part of '../optimization_flutter.dart';

class NextBillionOptimization {
  static String _accessKey = "";
  static const String _baseUri = "https://api.nextbillion.io";

  /// Initializes the SDK with the given access key.
  static void initialize(String accessKey) {
    _accessKey = accessKey;
  }

  /// Optimizes a route with multiple waypoints.
  ///
  /// [optimizeRequest] - The parameters for the optimization request.
  /// [retry] - The number of retry attempts for fetching the optimization result.
  /// [requestOptions] - Optional request options for the HTTP request.
  static Future<OptimizeRouteResultResponse?> optimizeRouteWithMultiWaypoints(
      OptimizeRequestParams optimizeRequest,
      {int retry = 5,
      Options? requestOptions}) async {
    var result = await getOptimizeRouteId(optimizeRequest,
        requestOptions: requestOptions);
    String? resultId = result.id;
    if (resultId?.isNotEmpty == true) {
      var optimizeResult = await getOptimizeResultWithId(resultId!,
          retry: retry, requestOptions: requestOptions);
      return optimizeResult;
    } else {
      return OptimizeRouteResultResponse(
          status: result.status, message: result.message);
    }
  }

  /// Optimizes a route with a custom request body.
  ///
  /// [requestBody] - The request body as a map.
  /// [retry] - The number of retry attempts for fetching the optimization result.
  /// [requestOptions] - Optional request options for the HTTP request.
  static Future<OptimizeRouteResultResponse?> optimizeRouteWithRequestBody(
      Map<String, dynamic> requestBody,
      {int retry = 5,
      Options? requestOptions}) async {
    var result = await getOptimizeRouteIdWithRequestBody(requestBody,
        requestOptions: requestOptions);
    String? resultId = result.id;
    if (resultId?.isNotEmpty == true) {
      var optimizeResult = await getOptimizeResultWithId(resultId!,
          retry: retry, requestOptions: requestOptions);
      return optimizeResult;
    } else {
      return OptimizeRouteResultResponse(
          status: result.status, message: result.message);
    }
  }

  /// Retrieves the optimization route ID using a custom request body.
  ///
  /// [requestBody] - The request body as a map.
  /// [requestOptions] - Optional request options for the HTTP request.
  static Future<OptimizeRouteResponse> getOptimizeRouteIdWithRequestBody(
      Map<String, dynamic> requestBody,
      {Options? requestOptions}) async {
    assert(_accessKey.isNotEmpty, "Access key is empty,Please initialize SDK.");
    String requestUrl = "$_baseUri/optimization/v2?key=$_accessKey";
    try {
      var response = await ApiService()
          .post(requestUrl, requestBody, options: requestOptions);
      var optimizeRouteResponse = OptimizeRouteResponse.fromJson(response.data);
      optimizeRouteResponse.status = response.statusCode.toString();
      return optimizeRouteResponse;
    } catch (error) {
      if (error is DioException) {
        var map = error.response?.data as Map?;
        String? statusCode = map?["status"]?.toString();
        String? message = map?["msg"] ?? map?["message"];
        return OptimizeRouteResponse(status: statusCode, message: message);
      }
      return OptimizeRouteResponse(
          status: "1004", message: "Failed to optimize route: $error");
    }
  }

  /// Retrieves the optimization route ID using a custom request body.
  ///
  /// [requestBody] - The request body as a map.
  /// [requestOptions] - Optional request options for the HTTP request.
  static Future<OptimizeRouteResponse> getOptimizeRouteId(
      OptimizeRequestParams optimizeRequest,
      {Options? requestOptions}) async {
    assert(_accessKey.isNotEmpty, "Access key is empty,Please initialize SDK.");

    String requestUrl = "$_baseUri/optimization/v2?key=$_accessKey";

    try {
      var response = await ApiService()
          .post(requestUrl, optimizeRequest.toJson(), options: requestOptions);
      var optimizeRouteResponse = OptimizeRouteResponse.fromJson(response.data);
      optimizeRouteResponse.status = response.statusCode.toString();
      return optimizeRouteResponse;
    } catch (error) {
      if (error is DioException) {
        var map = error.response?.data as Map?;
        String? statusCode = map?["status"]?.toString();
        String? message = map?["msg"] ?? map?["message"];
        return OptimizeRouteResponse(status: statusCode, message: message);
      }
      return OptimizeRouteResponse(
          status: "1003", message: "Failed to optimize route: $error");
    }
  }
  /// Retrieves the optimization route ID using request parameters.
  ///
  /// [optimizeRequest] - The parameters for the optimization request.
  /// [requestOptions] - Optional request options for the HTTP request.
  static Future<OptimizeRouteResultResponse> getOptimizeResultWithId(
      String resultId,
      {int retry = 5,
      Options? requestOptions}) async {

    assert(_accessKey.isNotEmpty, "Access key is empty,Please initialize SDK.");

    String requestUrl = "$_baseUri/optimization/v2/result?key=$_accessKey&id=$resultId";
    int attempt = 0;
    while (attempt <= retry) {
      attempt++;
      await Future.delayed(const Duration(seconds: 2));
      try {
        var response =
            await ApiService().get(requestUrl, options: requestOptions);

        var optResult = OptimizeRouteResultResponse.fromJson(response.data);
        if (optResult.result != null &&
            optResult.result?.routes?.isNotEmpty == true) {
          optResult.status = response.statusCode.toString();
          return optResult;
        } else {
          if (attempt > retry) {
            return OptimizeRouteResultResponse(
                status: "1005",
                message: "Optimize route is empty, please retry.");
          }
        }
      } catch (error) {
        if (error is DioException) {
          var map = error.response?.data as Map?;
          String? statusCode = map?["status"]?.toString();
          String? message = map?["msg"] ?? map?["message"];
          return OptimizeRouteResultResponse(
              status: statusCode, message: message);
        }
        return OptimizeRouteResultResponse(
            status: "1001", message: "Failed to optimize route: $error");
      }
    }
    return OptimizeRouteResultResponse(
        status: "1002", message: "Unknown error after $retry attempts");
  }
}
