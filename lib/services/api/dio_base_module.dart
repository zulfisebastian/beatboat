import '../../constants/endpoints.dart';
import '../api/log_interceptor.dart' as log;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'api_interceptor.dart';

class DioBaseModule with DioMixin implements Dio {
  DioBaseModule._() {
    options = BaseOptions(
      contentType: 'application/json',
      connectTimeout: Duration(seconds: 30 * 1000),
      sendTimeout: Duration(seconds: 30 * 1000),
      receiveTimeout: Duration(seconds: 30 * 1000),
      followRedirects: true,
      receiveDataWhenStatusError: true,
      baseUrl: Endpoint.baseUrl,
    );

    interceptors
      ..add(ApiInterceptor())
      ..add(log.LogInterceptor());

    httpClientAdapter = IOHttpClientAdapter();
  }

  static Dio getInstance() => DioBaseModule._();
}
