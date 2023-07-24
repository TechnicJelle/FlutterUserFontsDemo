import "dart:math";

import "package:flutter/material.dart";
import "package:lorem_ipsum/lorem_ipsum.dart";

import "font.dart";
import "settings.dart";
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
      routes: {
        "/settings": (context) => const SettingsPage(),
      },
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
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: "/settings"),
                builder: (context) => const SettingsPage(),
              ),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Paragraph(),
          );
        },
      ),
    );
  }
}

class Paragraph extends StatelessWidget {
  const Paragraph({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loremIpsum(words: Random().nextInt(5) + 2, paragraphs: 1),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 2),
        Text(
          loremIpsum(
            paragraphs: Random().nextInt(3) + 1,
            words: Random().nextInt(300) + 100,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
