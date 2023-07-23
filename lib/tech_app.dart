import "package:flutter/material.dart";

class TechApp extends StatelessWidget {
  final String title;
  final Color primary;
  final Color secondary;
  final ThemeMode themeMode;
  final String? fontFamily;
  final double? fontSizeFactor;
  final Widget home;
  const TechApp({
    required this.title,
    required this.primary,
    required this.secondary,
    required this.themeMode,
    this.fontFamily,
    this.fontSizeFactor,
    required this.home,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: primary,
          secondary: secondary,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: primary,
          secondary: secondary,
        ),
      ),
      themeMode: themeMode,
      home: Builder(
        builder: (themeContext) => Theme(
          data: Theme.of(themeContext).copyWith(
            useMaterial3: false,
            appBarTheme: AppBarTheme(color: primary),
            textTheme: Theme.of(themeContext).textTheme.apply(
                  fontSizeFactor: fontSizeFactor ?? 1.0,
                  fontFamily: fontFamily,
                ),
          ),
          child: home,
        ),
      ),
    );
  }
}
