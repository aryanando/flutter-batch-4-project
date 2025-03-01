import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/data/local_storage/auth_local_storage.dart';
import 'package:flutter_batch_4_project/data/remote_data/trouble_report_remote_data.dart';
import 'package:flutter_batch_4_project/helpers/injector.dart';
import 'package:flutter_batch_4_project/helpers/snackbar_helper.dart';
import 'package:image_picker/image_picker.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<File> _photos = [];
  final List<File> _videos = [];

  final picker = ImagePicker();
  bool isSubmitting = false;

  Future<void> _pickMedia(bool isPhoto) async {
    final pickedFile = isPhoto
        ? await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
          )
        : await picker.pickVideo(
            source: ImageSource.gallery, // 🔥 Fix: Pick video instead of image
            maxDuration: const Duration(seconds: 60), // Limit to 60s
          );

    if (pickedFile != null) {
      setState(() {
        if (isPhoto) {
          _photos.add(File(pickedFile.path));
        } else {
          _videos.add(File(pickedFile.path));
        }
      });
    }
  }

  Future<void> _submitReport() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      SnackBarHelper.showError(context, 'Please fill all required fields');
      return;
    }

    setState(() => isSubmitting = true);

    final remoteData = getIt.get<TroubleReportRemoteData>();

    try {
      final user = getIt<AuthLocalStorage>().getUser();

      if (user?.unitId == null) {
        SnackBarHelper.showError(
            context, 'Failed to submit report: Missing unit information');
        return;
      }

      await remoteData.createTroubleReport(
        name: _nameController.text,
        description: _descriptionController.text,
        unitId: user!.unitId!,
        photos: _photos,
        videos: _videos,
      );

      SnackBarHelper.showSuccess(context, 'Report submitted successfully');
      Navigator.pop(context, true); // Return success
    } catch (e) {
      SnackBarHelper.showError(context, 'Failed to submit report: $e');
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Report Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              Text('Photos:', style: Theme.of(context).textTheme.titleMedium),
              Wrap(
                spacing: 8,
                children: [
                  ..._photos.map((file) => Image.file(file,
                      width: 100, height: 100, fit: BoxFit.cover)),
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate),
                    onPressed: () => _pickMedia(true),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text('Videos:', style: Theme.of(context).textTheme.titleMedium),
              Wrap(
                spacing: 8,
                children: [
                  ..._videos.map((file) => Text(file.path.split('/').last)),
                  IconButton(
                    icon: const Icon(Icons.video_library),
                    onPressed: () => _pickMedia(false), // ✅ Fix video picker
                  )
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submitReport,
                  child: isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Submit Report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
