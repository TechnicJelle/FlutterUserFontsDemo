import "package:flutter/material.dart";

class FontProvider extends StatefulWidget {
  final Widget child;

  const FontProvider({required this.child, super.key});

  @override
  State<FontProvider> createState() => FontProviderState();
}

class FontProviderState extends State<FontProvider> {
  String? _fontFamily;
  double? _fontSizeFactor;

  void changeFontFamily(String newFontFamily) {
    setState(() {
      _fontFamily = newFontFamily;
    });
  }

  void changeFontSizeFactor(double newFontSizeFactor) {
    setState(() {
      _fontSizeFactor = newFontSizeFactor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FontSettings(
      fontFamilyData: _fontFamily,
      fontSizeFactorData: _fontSizeFactor,
      state: this,
      child: widget.child,
    );
  }
}

class FontSettings extends InheritedWidget {
  final String? _fontFamilyData;
  final double? _fontSizeFactorData;
  final FontProviderState state;

  const FontSettings({
    required fontFamilyData,
    required fontSizeFactorData,
    required this.state,
    required super.child,
    super.key,
  })  : _fontFamilyData = fontFamilyData,
        _fontSizeFactorData = fontSizeFactorData;

  String? get fontFamilyData => _fontFamilyData;
  double get fontSizeFactorData => _fontSizeFactorData ?? 1.0;

  static FontSettings? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FontSettings>();
  }

  @override
  bool updateShouldNotify(FontSettings oldWidget) {
    return oldWidget._fontFamilyData != _fontFamilyData ||
        oldWidget._fontSizeFactorData != _fontSizeFactorData;
  }
}
