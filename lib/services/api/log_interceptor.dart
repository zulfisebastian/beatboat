import 'dart:async';
import 'package:dio/dio.dart';

class LogInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    logPrint('*** API Request - Start ***');

    printKV('URI', options.uri);
    printKV('METHOD', options.method);
    logPrint('HEADERS:');
    options.headers.forEach((key, v) => printKV(' - $key', v));
    logPrint('BODY:');
    // log(options.data ?? "");
    printAll(options.data ?? '');

    logPrint('*** API Request - End ***');

    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logPrint('*** Api Error - Start ***:');

    logPrint('URI: ${err.requestOptions.uri}');
    if (err.response != null) {
      // if (err.response!.statusCode == 401) {
      //   SharedPreff().clearSharedPref();
      //   Get.offAll(const Login(
      //     language: "ID",
      //   ));
      // }
      logPrint('STATUS CODE: ${err.response?.statusCode?.toString()}');
    }
    logPrint('$err');
    if (err.response != null) {
      printKV('REDIRECT', err.response?.realUri ?? '');
      logPrint('BODY:');
      printAll(err.response?.data.toString());
    }

    logPrint('*** Api Error - End ***:');
    return handler.next(err);
  }

  @override
  Future onResponse(response, ResponseInterceptorHandler handler) async {
    logPrint('*** Api Response - Start ***');

    printKV('URI', response.requestOptions.uri);
    printKV('STATUS CODE', response.statusCode ?? '');
    printKV('REDIRECT', response.isRedirect);
    logPrint('BODY:');
    printAll(response.data ?? '');

    logPrint('*** Api Response - End ***');

    return handler.next(response);
  }

  void printKV(String key, Object v) {
    logPrint('$key: $v');
  }

  void printAll(msg) {
    msg.toString().split('\n').forEach(logPrint);
  }

  void logPrint(String s) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(s).forEach((match) => print(match.group(0)));
    // print(s);
  }
}
