import "package:flutter/material.dart";
import "package:input_slider/input_slider.dart";

import "font.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                "Click to change the app's font:",
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => FontSettings.of(context)!.fontSelectPopup(),
                child: const Text("Upload Font"),
              ),
              const SizedBox(height: 40),
              const Text(
                "Slide to change the app's font scale:",
              ),
              InputSlider(
                min: 0.5,
                max: 3.0,
                defaultValue: FontSettings.of(context)!.fontSizeFactor,
                borderRadius: BorderRadius.circular(4),
                decimalPlaces: 2,
                textFieldSize: const Size(100, 50),
                onChange: (double num) {
                  FontSettings.of(context)!.fontSizeFactor = num;
                },
              ),
              const SizedBox(height: 40),
              const Text(
                "Click to reset to default:",
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  FontSettings.of(context)!.reset();
                  Navigator.pop(context);
                },
                child: const Text("Reset Font Settings"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
