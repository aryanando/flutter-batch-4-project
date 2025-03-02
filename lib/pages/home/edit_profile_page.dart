import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/blocs/auth/profile_cubit.dart';
import 'package:flutter_batch_4_project/blocs/auth/profile_state.dart';
import 'package:flutter_batch_4_project/helpers/snackbar_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  File? _selectedPhoto;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileCubit>().getCurrentUser();
    _nameController.text = user?.name ?? '';
    _emailController.text = user?.email ?? '';
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedPhoto = File(pickedFile.path);
      });
    }
  }

  void _submitProfileUpdate() {
    context.read<ProfileCubit>().updateProfile(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          passwordConfirmation: _confirmPasswordController.text,
          photo: _selectedPhoto,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            SnackBarHelper.showSuccess(context, 'Profile updated successfully');
            Navigator.pop(context, true); // Return success
          } else if (state is ProfileUpdateError) {
            SnackBarHelper.showError(context, state.message);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _selectedPhoto != null
                        ? FileImage(_selectedPhoto!) as ImageProvider
                        : const AssetImage('assets/default_avatar.png'),
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration:
                      const InputDecoration(labelText: 'Password (optional)'),
                  obscureText: true,
                ),
                TextField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is ProfileUpdating
                            ? null
                            : _submitProfileUpdate,
                        child: state is ProfileUpdating
                            ? const CircularProgressIndicator()
                            : const Text('Save Changes'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
