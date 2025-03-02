import 'dart:io';
import 'package:flutter_batch_4_project/blocs/auth/profile_state.dart';
import 'package:flutter_batch_4_project/data/local_storage/auth_local_storage.dart';
import 'package:flutter_batch_4_project/data/remote_data/auth_remote_data.dart';
import 'package:flutter_batch_4_project/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthLocalStorage authLocalStorage;
  final AuthRemoteData authRemoteData;

  ProfileCubit(this.authLocalStorage, this.authRemoteData)
      : super(ProfileInitial());

  User? getCurrentUser() {
    return authLocalStorage.getUser();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? password,
    String? passwordConfirmation,
    File? photo,
  }) async {
    emit(ProfileUpdating());

    try {
      final updatedUser = await authRemoteData.updateProfile(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        photo: photo,
      );

      await authLocalStorage.setUser(updatedUser);

      emit(ProfileUpdateSuccess());
    } catch (e) {
      emit(ProfileUpdateError(e.toString()));
    }
  }
}
