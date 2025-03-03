import 'package:flutter/material.dart';
import 'package:flutter_batch_4_project/data/remote_data/trouble_report_remote_data.dart';
import 'package:flutter_batch_4_project/helpers/snackbar_helper.dart';
import 'package:flutter_batch_4_project/models/trouble_report_model.dart';
import 'package:flutter_batch_4_project/helpers/injector.dart';
import 'package:flutter_batch_4_project/data/local_storage/auth_local_storage.dart';

class UpdateReportPage extends StatefulWidget {
  final TroubleReport report;

  const UpdateReportPage({super.key, required this.report});

  @override
  State<UpdateReportPage> createState() => _UpdateReportPageState();
}

class _UpdateReportPageState extends State<UpdateReportPage> {
  final TextEditingController technician2Controller = TextEditingController();
  final TextEditingController technician3Controller = TextEditingController();
  final TextEditingController technician4Controller = TextEditingController();

  String selectedStatus = 'pending';

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.report.status;
  }

  Future<void> _submitUpdate() async {
    final user = getIt.get<AuthLocalStorage>().getUser();

    if (user == null) {
      SnackBarHelper.showError(context, 'User not found, please re-login.');
      return;
    }

    final updateData = {
      'technician1': user.id.toString(), // Logged-in technician
      'technician2': technician2Controller.text.isEmpty
          ? null
          : technician2Controller.text,
      'technician3': technician3Controller.text.isEmpty
          ? null
          : technician3Controller.text,
      'technician4': technician4Controller.text.isEmpty
          ? null
          : technician4Controller.text,
      'status': selectedStatus,
    };

    print('📤 Sending update request with data: $updateData');

    try {
      final troubleReportRemoteData = getIt.get<TroubleReportRemoteData>();

      await troubleReportRemoteData.updateReport(
        reportId: widget.report.id.toString(),
        data: updateData,
      );

      SnackBarHelper.showSuccess(context, 'Report updated successfully!');
      Navigator.pop(context, true); // Return success
    } catch (e) {
      print('❌ Update Failed: $e');
      SnackBarHelper.showError(context, 'Failed to update report: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt.get<AuthLocalStorage>().getUser();
    final isTechnician = user?.unitId == 20;

    return Scaffold(
      appBar: AppBar(title: Text('Update Report - ${widget.report.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isTechnician) ...[
              Text('Technician 1 (You): ${user?.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
            ],

            // Dummy fields for technician 2-4
            TextField(
              controller: technician2Controller,
              decoration:
                  const InputDecoration(labelText: 'Technician 2 (optional)'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: technician3Controller,
              decoration:
                  const InputDecoration(labelText: 'Technician 3 (optional)'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: technician4Controller,
              decoration:
                  const InputDecoration(labelText: 'Technician 4 (optional)'),
            ),
            const SizedBox(height: 16),

            // Status Dropdown
            const Text('Update Status:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedStatus,
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(
                    value: 'in_progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'solved', child: Text('Solved')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value ?? 'pending';
                });
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitUpdate,
                child: const Text('Update Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
