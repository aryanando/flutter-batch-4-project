import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_batch_4_project/data/remote_data/network_service/network_service.dart';
import 'package:flutter_batch_4_project/models/auth_response_model.dart';
import 'package:flutter_batch_4_project/models/user_model.dart';

abstract class AuthRemoteData {
  Future<AuthResponseModel> postLogin(String email, String password);
  Future<User> getProfile();
  Future<User> updateProfile({
    required String name,
    required String email,
    String? password,
    String? passwordConfirmation,
    File? photo,
  });
}

class AuthRemoteDataImpl implements AuthRemoteData {
  late final NetworkService networkService;

  AuthRemoteDataImpl(this.networkService);

  @override
  Future<User> getProfile() async {
    final response = await networkService.get(url: "/api/v1/me");
    return User.fromJson(response.data['data']);
  }

  @override
  Future<AuthResponseModel> postLogin(String email, String password) async {
    final response = await networkService.post(
        url: "/api/v1/login", data: {"email": email, "password": password});

    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<User> updateProfile({
    required String name,
    required String email,
    String? password,
    String? passwordConfirmation,
    File? photo,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      if (password != null && password.isNotEmpty) 'password': password,
      if (passwordConfirmation != null && passwordConfirmation.isNotEmpty)
        'password_confirmation': passwordConfirmation,
      if (photo != null)
        'photo': await MultipartFile.fromFile(photo.path,
            filename: photo.path.split('/').last),
    });

    final response = await networkService.postFormData(
      '/api/v1/user/update',
      formData,
    );

    return User.fromJson(response.data['data']);
  }
}
