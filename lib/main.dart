import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:input_slider/input_slider.dart";

import "font.dart";
import "tech_app.dart";

void main() {
  runApp(const FontProvider(child: MyApp()));
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
      fontFamily: FontSettings.of(context)!.fontFamilyData,
      fontSizeFactor: FontSettings.of(context)!.fontSizeFactorData,
      home: MyHomePage(title: "Flutter User Font Test"),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({required this.title, super.key});

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
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ["ttf", "otf"],
                  );

                  if (result == null) return; // Dialog was canceled

                  String fontName = result.files.single.name;
                  FontLoader custom = FontLoader(fontName);
                  if (kIsWeb) {
                    custom.addFont(_loadFromBytes(result.files.single.bytes!));
                  } else {
                    custom.addFont(_loadFromPath(result.files.single.path!));
                  }

                  await custom.load().then((_) {
                    FontSettings.of(context)!.state.changeFontFamily(fontName);
                  });
                },
                child: const Text("Upload Font"),
              ),
              const SizedBox(height: 20),
              const Text(
                "Slide to change the app's font scale:",
              ),
              InputSlider(
                min: 0.5,
                max: 3.0,
                defaultValue: 1.0,
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

  Future<ByteData> _loadFromBytes(Uint8List bytes) async {
    return ByteData.view(bytes.buffer);
  }

  Future<ByteData> _loadFromPath(String path) async {
    File file = File(path);
    return file.readAsBytes().then(_loadFromBytes);
  }
}
