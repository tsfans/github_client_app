// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

import 'package:github_client_app/models/cacheConfig.dart';
import 'package:github_client_app/models/user.dart';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  User? user;
  String? token;
  int theme;
  CacheConfig? cache;
  String? lastLogin;
  String? locale;

  Profile({
    this.user,
    this.token,
    required this.theme,
    this.cache,
    this.lastLogin,
    this.locale,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        user: User.fromJson(json["user"]),
        token: json["token"],
        theme: json["theme"],
        cache: CacheConfig.fromJson(json["cache"]),
        lastLogin: json["lastLogin"],
        locale: json["locale"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "token": token,
        "theme": theme,
        "cache": cache?.toJson(),
        "lastLogin": lastLogin,
        "locale": locale,
      };
}
