import 'package:dio/dio.dart';
import '../../../models/base/base_result.dart';
import '../../services/api/dio_module.dart';

class BaseRepo {
  static Dio get _dio => DioModule.getInstance();

  static Future<BaseResult<T>> callApi<T>(Future<Response<T>> call) async {
    Response response;
    try {
      response = await call;

      if ((response.statusCode ?? 0) / 100 == 2) {
        return BaseResult.success(response.data);
      } else {
        return BaseResult.failed(message: response.data['message'].toString());
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        // network errors
        return BaseResult.timeout("Network Failure");
      } else {
        // response error
        try {
          Map<String, dynamic> error = e.response?.data;
          return BaseResult.failed(
              message: error['message'] ?? 'Invalid response');
        } catch (_) {
          return BaseResult.failed(
              message: e.response?.data ?? "Unknown Error");
        }
      }
    }
  }

  Future<BaseResult<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? type,
  }) async {
    return await callApi(
      _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  Future<BaseResult<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    dynamic body,
    String? type,
  }) async {
    return await callApi(
      _dio.post(
        endpoint,
        data: body,
        options: Options(headers: headers),
      ),
    );
  }

  Future<BaseResult<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    dynamic body,
    String? type,
  }) async {
    return await callApi(
      _dio.delete(
        endpoint,
        data: body,
        options: Options(headers: headers),
      ),
    );
  }

  Future<BaseResult<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    dynamic body,
    String? type,
  }) async {
    return await callApi(
      _dio.put(
        endpoint,
        data: body,
        options: Options(headers: headers),
      ),
    );
  }

  Future<BaseResult<T>> postMultipart<T>(
    String endpoint, {
    Map<String, String>? headers,
    FormData? body,
  }) async =>
      await callApi(
        _dio.post(
          endpoint,
          data: body,
          options: Options(headers: headers),
        ),
      );
}
