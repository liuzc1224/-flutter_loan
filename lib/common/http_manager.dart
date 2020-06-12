import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'code.dart';
import 'logs_interceptor.dart';
import 'response_interceptor.dart';
import 'result_data.dart';
import 'address.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class HttpManager {
  static HttpManager _instance = HttpManager._internal();
  Dio _dio;

 static const CODE_SUCCESS = 200;
  static const CODE_TIME_OUT = -1;


  factory HttpManager() => _instance;

  ///通用全局单例，第一次使用时初始化
  HttpManager._internal({String baseUrl}) {
    if (null == _dio) {
      _dio = new Dio(new BaseOptions(
          baseUrl: Address.BASE_URL, connectTimeout: 40000));
      _dio.interceptors.add(new LogsInterceptors());
      _dio.interceptors.add(new ResponseInterceptors());
    }
  }

  static HttpManager getInstance({String baseUrl}) {
    if (baseUrl == null) {
      return _instance._normal();
    } else {
      return _instance._baseUrl(baseUrl);
    }
  }

  //用于指定特定域名，比如cdn和kline首次的http请求
  HttpManager _baseUrl(String baseUrl) {
    if (_dio != null) {
      _dio.options.baseUrl = baseUrl;
    }
    return this;
  }

  //一般请求，默认域名
  HttpManager _normal() {
    if (_dio != null) {
      if (_dio.options.baseUrl != Address.BASE_URL) {
        _dio.options.baseUrl = Address.BASE_URL;
      }
    }
    return this;
  }

  ///通用的GET请求
  get(api, params, {noTip = false}) async {
    Response response;
    print(params.toString());
    try {
      response = await _dio.get(api, queryParameters: params);
    } on DioError catch (e) {
      return resultError(e);
    }

    if (response.data is DioError) {
      return resultError(response.data['code']);
    }

    return response.data;
  }
  ///通用的GET请求
  delete(api, params, {noTip = false}) async {
    Response response;
    print(params.toString());
    try {
      response = await _dio.delete(api, queryParameters: params);
    } on DioError catch (e) {
      return resultError(e);
    }

    if (response.data is DioError) {
      return resultError(response.data['code']);
    }

    return response.data;
  }
  ///通用的POST请求
  post(api, params, {noTip = false}) async {
    Response response;
    ///定义请求参数
    print(jsonEncode(params));
    try {
      response = await _dio.post( api,data : jsonEncode(params));
    } on DioError catch (e) {
      return resultError(e);
    }

    if (response.data is DioError) {
      return resultError(response.data['code']);
    }

    return response.data;
  }
  ///通用的PUT请求
  put(api, params, {noTip = false}) async {
    Response response;
    ///定义请求参数
    print(jsonEncode(params));
    try {
      response = await _dio.put( api,data : jsonEncode(params));
    } on DioError catch (e) {
      return resultError(e);
    }

    if (response.data is DioError) {
      return resultError(response.data['code']);
    }

    return response.data;
  }
  ///通用的patch请求
  patch(api, params, {noTip = false}) async {
    Response response;
    ///定义请求参数
    print(jsonEncode(params));
    try {
      response = await _dio.patch( api,data : jsonEncode(params));
    } on DioError catch (e) {
      return resultError(e);
    }

    if (response.data is DioError) {
      return resultError(response.data['code']);
    }

    return response.data;
  }
  putFormData(api, params, {noTip = false}) async {
    Response response;
    ///定义请求参数
    try {
      response = await _dio.post( api,data: params);
    } on DioError catch (e) {
      return resultError(e);
    }

    if (response.data is DioError) {
      return resultError(response.data['code']);
    }

    return response.data;
  }
  //文件formData
  formData(api, params, {noTip = false}) async {
    Response response;
    ///定义请求参数
    try {
      response = await _dio.post( api,data: params);
    } on DioError catch (e) {
      return resultError(e);
    }

    if (response.data is DioError) {
      return resultError(response.data['code']);
    }

    return response.data;
  }
}

ResultData resultError(DioError e) {
  Response errorResponse;
  if (e.response != null) {
    errorResponse = e.response;
  } else {
    errorResponse = new Response(statusCode: 666);
  }
  if (e.type == DioErrorType.CONNECT_TIMEOUT ||
      e.type == DioErrorType.RECEIVE_TIMEOUT) {
    errorResponse.statusCode = Code.NETWORK_TIMEOUT;
  }
  return new ResultData(
      errorResponse.statusMessage, false, errorResponse.statusCode);
}