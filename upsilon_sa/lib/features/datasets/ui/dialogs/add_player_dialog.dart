// lib/features/datasets/ui/dialogs/add_player_dialog.dart

import 'package:flutter/material.dart';

class AddPlayerDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const AddPlayerDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  final nameController = TextEditingController();
  final positionController = TextEditingController();
  final ageController = TextEditingController();
  final experienceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ADD NEW PLAYER',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: nameController,
              label: 'Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: positionController,
              label: 'Position',
              icon: Icons.sports_basketball,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: ageController,
              label: 'Age',
              icon: Icons.calendar_today,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: experienceController,
              label: 'Experience',
              icon: Icons.timeline,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _handleAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('ADD'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  void _handleAdd() {
    final playerData = {
      "name": nameController.text,
      "position": positionController.text,
      "age": int.tryParse(ageController.text) ?? 0,
      "experience": int.tryParse(experienceController.text) ?? 0,
    };
    widget.onAdd(playerData);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    positionController.dispose();
    ageController.dispose();
    experienceController.dispose();
    super.dispose();
  }
}