import 'user_model.dart';

class AuthResponseModel {
  final User? user;
  final String? accessToken;

  AuthResponseModel({
    this.user,
    this.accessToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        accessToken: json["token"]["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "access_token": accessToken,
      };
}
