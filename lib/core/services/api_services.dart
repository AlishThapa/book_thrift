import 'dart:developer';

import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/core/storage/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'package:book_thrift/constants/api_url.dart';
import '../../constants/widgets/toast_message.dart';
import 'dio_services.dart';
import 'package:dio/dio.dart';

class ApiServices {
  final bool useToken;
  ApiServices({this.useToken = true});
  static final instance = ApiServices();

  Future<Map<String, dynamic>> postData({required String url, dynamic data, Map<String, dynamic>? queryParameters, String? token, bool? isFileUpload = false, bool? useToken}) async {
    final dio = ds.dio;
    Map<String, dynamic> headers = {};

    final authToken = token ?? getIt<StorageService>().getAccessToken();
    Logger().d("Auth Token: $authToken");

    if ((useToken ?? this.useToken) && authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    if (isFileUpload!) {
      headers['Content-Type'] = 'multipart/form-data';
    }

    Map<String, dynamic> queryParams = {...?queryParameters};
    Logger().d('Request URL: $url\nData: $data\nHeaders: $headers');

    try {
      final response = await dio.post(
        url,
        data: isFileUpload ? FormData.fromMap(data) : data,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      if (kDebugMode) {
        Logger().d('Response status code: ${response.statusCode}\nResponse data: ${response.data}');
      }

      final resJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (resJson is Map<String, dynamic>) {
          return resJson;
        } else {
          throw 'Unexpected response format';
        }
      } else {
        String errorMessage = 'Unknown error occurred';
        if (resJson is Map<String, dynamic>) {
          errorMessage = resJson['detail'] ?? resJson['details'] ?? resJson['message'] ?? errorMessage;
        } else if (resJson is String && resJson.isNotEmpty) {
          errorMessage = resJson;
        }
        throw errorMessage;
      }
    } catch (e) {
      if (kDebugMode) {
        Logger().e('Error during API call: $e');
      }
      if (e is DioException) {
        toastMessage(message: 'Error connecting to the internet');
        // Handle specific DioException errors
      } else {
        await toastMessage(message: 'Error: $e');
        rethrow;
      }
      rethrow;
    }
  }

  Future<dynamic> getData({required String url, Map<String, dynamic>? queryParameters, String? token, bool? useToken}) async {
    final dio = ds.dio;
    Map<String, dynamic> headers = {};

    final authToken = token ?? getIt<StorageService>().getAccessToken();
    Logger().d("Auth Token: $authToken");
    if ((useToken ?? this.useToken) && authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    Map<String, dynamic> queryParams = {...?queryParameters};
    try {
      Logger().d('Request URL: $url\nHeaders: $headers\nQuery Params: $queryParams');

      final response = await dio.get(
        url,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      if (kDebugMode) {
        log('Response status code: ${response.statusCode}\nResponse data: ${response.data}');
      }

      final resJson = response.data;

      if (response.statusCode == 200) {
        return resJson;
      } else if (response.statusCode == 400) {
        toastMessage(message: 'Session expired. Please log in again to continue');
        throw 'Session expired';
      } else {
        String errorMessage = 'Unknown error occurred';
        if (resJson is Map<String, dynamic>) {
          if (resJson['message'] is List && resJson['message'].isNotEmpty) {
            errorMessage = resJson['message'][0]['message'] ?? errorMessage;
          } else {
            errorMessage = resJson['message'] ?? resJson['detail'] ?? resJson['details'] ?? errorMessage;
          }
        }
        toastMessage(message: errorMessage);
        throw errorMessage;
      }
    } catch (e) {
      if (kDebugMode) {
        Logger().e('Error during API call: $e');
      }
      if (e is DioException) {
        // await toastMessage(message: 'Error: No internet connection');
        print('Error: $e');
      } else {
        await toastMessage(message: '');
        rethrow;
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> putData({required String url, dynamic data, Map<String, dynamic>? queryParameters, String? token, bool? useToken}) async {
    final dio = ds.dio;
    Map<String, dynamic> headers = {};

    final authToken = token ?? getIt<StorageService>().getAccessToken();
    Logger().d("Auth Token: $authToken");

    if ((useToken ?? this.useToken) && authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    Map<String, dynamic> queryParams = {...?queryParameters};
    Logger().d('Request URL: $url\nData: $data\nHeaders: $headers');
    try {
      final response = await dio.put(
        url,
        data: data,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      if (kDebugMode) {
        Logger().d('Response status code: ${response.statusCode}\nResponse data: ${response.data}');
      }

      final resJson = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (resJson is Map<String, dynamic>) {
          return resJson;
        } else {
          throw 'Unexpected response format';
        }
      } else {
        String errorMessage = 'Unknown error occurred';
        if (resJson is Map<String, dynamic>) {
          errorMessage = resJson['detail'] ?? resJson['details'] ?? resJson['message'] ?? errorMessage;
        } else if (resJson is String && resJson.isNotEmpty) {
          errorMessage = resJson;
        }
        throw errorMessage;
      }
    } catch (e) {
      if (kDebugMode) {
        Logger().e('Error during API call: $e');
      }
      if (e is DioException) {
        toastMessage(message: 'Error connecting to the internet');
      } else {
        await toastMessage(message: 'Error: $e');
        rethrow;
      }
      rethrow;
    }
  }
}

ApiServices get apiInstance => ApiServices.instance;
