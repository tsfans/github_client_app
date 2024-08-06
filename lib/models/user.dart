// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String login;
  String avatarUrl;
  String type;
  String? name;
  String? company;
  String? blog;
  String? location;
  String? email;
  bool? hireable;
  String? bio;
  num? publicRepos;
  num? followers;
  num? following;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? totalPrivateRepos;
  num? ownedPrivateRepos;

  User({
    required this.login,
    required this.avatarUrl,
    required this.type,
    this.name,
    this.company,
    this.blog,
    this.location,
    this.email,
    this.hireable,
    this.bio,
    this.publicRepos,
    this.followers,
    this.following,
    this.createdAt,
    this.updatedAt,
    this.totalPrivateRepos,
    this.ownedPrivateRepos,
  });

  static User empty(String name) {
    return User(
        login: name,
        avatarUrl: "",
        type: "",
        publicRepos: 0,
        followers: 0,
        following: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalPrivateRepos: 0,
        ownedPrivateRepos: 0);
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        login: json["login"],
        avatarUrl: json["avatar_url"],
        type: json["type"],
        name: json["name"],
        company: json["company"],
        blog: json["blog"],
        location: json["location"],
        email: json["email"],
        hireable: json["hireable"],
        bio: json["bio"],
        publicRepos: json["public_repos"],
        followers: json["followers"],
        following: json["following"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        totalPrivateRepos: json["total_private_repos"],
        ownedPrivateRepos: json["owned_private_repos"],
      );

  Map<String, dynamic> toJson() => {
        "login": login,
        "avatar_url": avatarUrl,
        "type": type,
        "name": name,
        "company": company,
        "blog": blog,
        "location": location,
        "email": email,
        "hireable": hireable,
        "bio": bio,
        "public_repos": publicRepos,
        "followers": followers,
        "following": following,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "total_private_repos": totalPrivateRepos,
        "owned_private_repos": ownedPrivateRepos,
      };
}
