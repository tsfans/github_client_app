// To parse this JSON data, do
//
//     final cacheConfig = cacheConfigFromJson(jsonString);

import 'dart:convert';

CacheConfig cacheConfigFromJson(String str) => CacheConfig.fromJson(json.decode(str));

String cacheConfigToJson(CacheConfig data) => json.encode(data.toJson());

class CacheConfig {
    bool enable;
    int maxAge;
    int maxCount;

    CacheConfig({
        required this.enable,
        required this.maxAge,
        required this.maxCount,
    });

    factory CacheConfig.fromJson(Map<String, dynamic> json) => CacheConfig(
        enable: json["enable"],
        maxAge: json["maxAge"],
        maxCount: json["maxCount"],
    );

    Map<String, dynamic> toJson() => {
        "enable": enable,
        "maxAge": maxAge,
        "maxCount": maxCount,
    };
}
