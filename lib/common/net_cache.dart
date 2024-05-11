import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:github_client_app/common/global.dart';

class NetCache extends Interceptor {
  LinkedHashMap cache = LinkedHashMap<String, CacheObject>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!Global.profile.cache!.enable) {
      return handler.next(options);
    }

    bool refresh = options.extra["refresh"] == true;
    // need remove cache when refreshing
    if (refresh) {
      if (options.extra["list"] == true) {
        cache.removeWhere((key, value) => key.contains(options.path));
      } else {
        cache.remove(options.uri.toString());
      }
      return handler.next(options);
    }

    bool noCache = options.extra["noCache"] == true;
    if (noCache || options.method.toLowerCase() != "get") {
      return handler.next(options);
    }

    String cacheKey = options.extra["cacheKey"] ?? options.uri.toString();
    var cacheValue = cache[cacheKey];
    if (cacheValue != null) {
      if ((DateTime.now().millisecondsSinceEpoch - cacheValue.timeStamp) /
              1000 <
          Global.profile.cache!.maxAge) {
        return handler.resolve(cacheValue.response);
      } else {
        cache.remove(cacheKey);
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (Global.profile.cache!.enable) {
      _cacheResponse(response);
    }
    handler.next(response);
  }

  _cacheResponse(Response response) {
    RequestOptions opts = response.requestOptions;
    bool noCache = opts.extra["noCache"] == true;
    if (noCache || opts.method.toLowerCase() != "get") {
      return;
    }
    if (cache.length > Global.profile.cache!.maxCount) {
      cache.remove(cache.keys.first);
    }
    String cacheKey = opts.extra["cacheKey"] ?? opts.uri.toString();
    cache[cacheKey] = CacheObject(response);
  }

  void delete(String cacheKey) {
    cache.remove(cacheKey);
  }

  void clear() {
    cache.clear();
  }
}

class CacheObject {
  CacheObject(this.response)
      : timeStamp = DateTime.now().millisecondsSinceEpoch;
  Response response;
  int timeStamp;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}
