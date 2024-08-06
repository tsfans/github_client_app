import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:github_client_app/common/global.dart';
import 'package:github_client_app/models/repo.dart';
import 'package:github_client_app/models/user.dart';

class Github {
  BuildContext? context;
  late Options _options;

  Github([this.context]) {
    _options = Options(extra: {"context": context});
  }

  static Dio dio = Dio(BaseOptions(baseUrl: "https://api.github.com", headers: {
    HttpHeaders.acceptHeader:
        "application/vnd.github.squirrel-girl-preview,application/vnd.github.symmetra-preview+json",
  }));

  static void init() {
    dio.interceptors.add(Global.netCache);
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;

    // debug mode disable https
    if (!Global.isRelease) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          // Don't trust any certificate just because their root cert is trusted.
          final HttpClient client =
              HttpClient(context: SecurityContext(withTrustedRoots: false));
          // You can test the intermediate / root cert here. We just ignore it.
          client.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return client;
        },
      );
    }
  }

  Future<User> login(String username, String pwd) async {
    String userIno = '$username:$pwd';
    String encodeUserInfo = base64.encode(utf8.encode(userIno));
    String basic = 'Basic $encodeUserInfo';
    var rpn = dio.get('/users/$username',
        options: _options.copyWith(
            headers: {HttpHeaders.authorizationHeader: basic},
            extra: {"noCache": true}));

    dio.options.headers[HttpHeaders.authorizationHeader] = basic;

    Global.netCache.clear();
    Global.profile.token = basic;
    return rpn.then((response) {
      if (response.statusCode != 200) {
        throw DioException(
            requestOptions: RequestOptions(), response: response);
      }
      return User.fromJson(response.data);
    });
  }

  Future<List<Repo>> queryRepoes(
      {Map<String, dynamic>? queryParameters, refresh = false}) async {
    if (refresh) {
      _options.extra!.addAll({"refresh": refresh, "list": true});
    }
    var rpn = dio.get<List>(
      "/user/repos",
      queryParameters: queryParameters,
      options: _options,
    );

    return rpn.then((response) {
      if (response.statusCode != 200) {
        throw DioException(
            requestOptions: RequestOptions(), response: response);
      }
      return response.data!.map((e) => Repo.fromJson(e)).toList();
    });
  }
}
