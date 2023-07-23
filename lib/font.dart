import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class FontProvider extends StatefulWidget {
  final Widget app;

  const FontProvider({required this.app, super.key});

  @override
  State<FontProvider> createState() => FontProviderState();

  static Future<void> fontSelectPopup(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
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
  }

  static Future<ByteData> _loadFromBytes(Uint8List bytes) async {
    return ByteData.view(bytes.buffer);
  }

  static Future<ByteData> _loadFromPath(String path) async {
    File file = File(path);
    return file.readAsBytes().then(_loadFromBytes);
  }
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
      child: widget.app,
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

  String? get fontFamily => _fontFamilyData;
  double get fontSizeFactor => _fontSizeFactorData ?? 1.0;

  static FontSettings? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FontSettings>();
  }

  @override
  bool updateShouldNotify(FontSettings oldWidget) {
    return oldWidget._fontFamilyData != _fontFamilyData ||
        oldWidget._fontSizeFactorData != _fontSizeFactorData;
  }
}
