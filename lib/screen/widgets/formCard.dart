import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const FormCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Colors.orange.shade50, // latar lembut
      shadowColor: Colors.orange.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16), // ✅ padding internal biar lega
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}