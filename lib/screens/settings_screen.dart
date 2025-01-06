import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameSettings {
  final int maxNumber;
  final int maxAttempts;

  GameSettings({required this.maxNumber, required this.maxAttempts});
}

class SettingsScreen extends StatefulWidget {
  final GameSettings initialSettings;

  const SettingsScreen({
    super.key,
    required this.initialSettings,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _maxNumberController;
  late TextEditingController _maxAttemptsController;

  @override
  void initState() {
    super.initState();
    _maxNumberController = TextEditingController(text: widget.initialSettings.maxNumber.toString());
    _maxAttemptsController = TextEditingController(text: widget.initialSettings.maxAttempts.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _maxNumberController,
              decoration: const InputDecoration(
                labelText: 'Maximum Number',
                border: OutlineInputBorder(),
                helperText: 'The highest number that can be generated',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _maxAttemptsController,
              decoration: const InputDecoration(
                labelText: 'Maximum Attempts',
                border: OutlineInputBorder(),
                helperText: 'Number of attempts allowed to guess',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final maxNumber = int.tryParse(_maxNumberController.text) ?? 100;
                final maxAttempts = int.tryParse(_maxAttemptsController.text) ?? 10;

                if (maxNumber < 10) {
                  _showError('Maximum number must be at least 10');
                  return;
                }

                if (maxAttempts < 1) {
                  _showError('Maximum attempts must be at least 1');
                  return;
                }

                Navigator.pop(
                  context,
                  GameSettings(
                    maxNumber: maxNumber,
                    maxAttempts: maxAttempts,
                  ),
                );
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _maxNumberController.dispose();
    _maxAttemptsController.dispose();
    super.dispose();
  }
}