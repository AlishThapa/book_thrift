import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/core/router/app_router.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:book_thrift/core/storage/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../constants/api_url.dart';

class DioServices {
  final Dio _dio = Dio();

  DioServices() {
    _dio.options.baseUrl = ApiUrl.baseUrl;

    _dio.options.headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};
    _dio.options.validateStatus = (val) => true;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = getIt<StorageService>().getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (e, handler) {
          if (e.statusCode == 401) {
            _handleUnauthorized();
          }
          return handler.next(e);
        },
        onError: (e, handler) {
          if (e.response?.statusCode == 401) {
            _handleUnauthorized();
          }
          return handler.next(e);
        },
      ),
    );
  }

  void _handleUnauthorized() async {
    if (kDebugMode) {
      Logger().d("Unauthorized - Clearing session and redirecting to login");
    }
    await getIt<StorageService>().clearAccessToken();
    getIt<AppRouter>().replaceAll([const AuthEntryRoute()]);
  }

  Dio get dio => _dio;
}

DioServices get ds => getIt<DioServices>();
