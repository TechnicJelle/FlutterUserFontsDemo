import "package:flutter/material.dart";
import "package:input_slider/input_slider.dart";

import "font.dart";
import "tech_app.dart";

void main() {
  runApp(const FontProvider(app: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TechApp(
      title: "Flutter User Font Test",
      primary: Colors.deepPurple,
      secondary: Colors.deepPurpleAccent,
      // themeMode: ThemeMode.light,
      themeMode: ThemeMode.dark,
      fontFamily: FontSettings.of(context)!.fontFamily,
      fontSizeFactor: FontSettings.of(context)!.fontSizeFactor,
      home: const MyHomePage(title: "Flutter User Font Test"),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Click to change the app's font:",
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => FontProvider.fontSelectPopup(context),
                child: const Text("Upload Font"),
              ),
              const SizedBox(height: 20),
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
                  FontSettings.of(context)!.state.changeFontSizeFactor(num);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
