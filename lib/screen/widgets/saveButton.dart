import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onSave;

  const SaveButton({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onSave,
        icon: const Icon(Icons.save),
        label: const Text("Simpan"),
      ),
    );
  }
}