// EXAMPLE 04 — Forms, TextEditingController, DatePicker
//
// Key concepts:
//   - TextEditingController: connects a TextField to your code
//   - initState / dispose: lifecycle methods for setup and cleanup
//   - Form + GlobalKey<FormState>: built-in validation support
//   - showDatePicker: the system date picker dialog
//   - ScaffoldMessenger.showSnackBar: brief feedback messages

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FormDemoScreen(),
    );
  }
}

class FormDemoScreen extends StatefulWidget {
  const FormDemoScreen({super.key});

  @override
  State<FormDemoScreen> createState() => _FormDemoScreenState();
}

class _FormDemoScreenState extends State<FormDemoScreen> {
  // A GlobalKey lets us call validate() on the form from outside the Form widget.
  final _formKey = GlobalKey<FormState>();

  // Controllers give us access to the text the user typed.
  // Create them here; dispose them in dispose().
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    // ALWAYS dispose controllers — this frees memory when the widget is removed.
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    // validate() calls all the validator functions in the form.
    // Returns true if all pass, false if any fail.
    if (_formKey.currentState!.validate()) {
      // All fields are valid — show a summary
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Saved: ${_nameController.text} | '
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,  // The date shown when the picker opens
      firstDate: DateTime(2020),   // Earliest selectable date
      lastDate: DateTime.now(),    // Latest selectable date (today)
    );
    // picked is null if the user dismissed the dialog without selecting
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forms Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Text field with validation ─────────────────────────────
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
                // validator: called when _formKey.currentState!.validate() runs.
                // Return null = valid. Return a String = error message to show.
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null; // valid
                },
              ),
              const SizedBox(height: 16),

              // ── Multi-line text field (no validation — optional field) ──
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true, // Aligns label to top for multi-line
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // ── Date picker ────────────────────────────────────────────
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
              ),
              const SizedBox(height: 24),

              // ── Submit button ──────────────────────────────────────────
              SizedBox(
                width: double.infinity, // Full-width button
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Save'),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              // ── Live preview ───────────────────────────────────────────
              // This updates as you type because we listen to the controllers.
              // (In this demo we use a StreamBuilder trick — in the real app
              // we call setState, which is simpler.)
              ValueListenableBuilder(
                valueListenable: _nameController,
                builder: (_, __, ___) {
                  return Text(
                    'Preview: "${_nameController.text}"',
                    style: const TextStyle(color: Colors.grey),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
