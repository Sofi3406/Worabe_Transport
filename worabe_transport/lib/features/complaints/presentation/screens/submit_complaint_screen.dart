import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worabe_transport/core/errors/app_exception.dart';
import 'package:worabe_transport/features/complaints/domain/complaint_model.dart';
import 'package:worabe_transport/features/complaints/presentation/providers/complaint_providers.dart';
import 'package:worabe_transport/shared/widgets/error_message.dart';
import 'package:worabe_transport/shared/widgets/loading_button.dart';

class SubmitComplaintScreen extends ConsumerStatefulWidget {
  const SubmitComplaintScreen({super.key, this.rideId});

  final String? rideId;

  @override
  ConsumerState<SubmitComplaintScreen> createState() =>
      _SubmitComplaintScreenState();
}

class _SubmitComplaintScreenState extends ConsumerState<SubmitComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionCtrl = TextEditingController();
  String _category = complaintCategories.keys.first;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(complaintRepositoryProvider).submit(
            category: _category,
            description: _descriptionCtrl.text.trim(),
            rideId: widget.rideId,
          );
      await ref.read(myComplaintsProvider.notifier).refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complaint submitted.')),
        );
        context.pop();
      }
    } on AppException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Complaint')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.rideId != null)
                Text('Linked to ride: ${widget.rideId}',
                    style: Theme.of(context).textTheme.bodySmall),
              if (_error != null) ...[
                ErrorMessage(_error!),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: complaintCategories.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                maxLength: 2000,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Description is required.' : null,
              ),
              const SizedBox(height: 24),
              LoadingButton(
                label: 'Submit',
                loading: _loading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
