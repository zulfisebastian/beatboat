import 'package:get/get.dart';
import '../../controllers/base/base_controller.dart';
import '../api/log_interceptor.dart' as log;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'api_interceptor.dart';

class DioModule with DioMixin implements Dio {
  DioModule._() {
    BaseController _controller = Get.find(tag: "BaseController");
    options = BaseOptions(
      contentType: 'application/json',
      connectTimeout: Duration(seconds: 30 * 1000),
      sendTimeout: Duration(seconds: 30 * 1000),
      receiveTimeout: Duration(seconds: 30 * 1000),
      followRedirects: true,
      receiveDataWhenStatusError: true,
      baseUrl: _controller.linkUrl.value + "api/",
    );

    interceptors
      ..add(ApiInterceptor())
      ..add(log.LogInterceptor());

    httpClientAdapter = IOHttpClientAdapter();
  }

  static Dio getInstance() => DioModule._();
}
