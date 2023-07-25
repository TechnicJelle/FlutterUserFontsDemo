import "dart:async";
import "dart:convert";
import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:shared_preferences/shared_preferences.dart";

const String storageKeyFontBytes = "custom_font_bytes";
const String storageKeyFontScale = "custom_font_scale";

class FontProvider extends StatefulWidget {
  final Widget app;

  const FontProvider({required this.app, super.key});

  @override
  State<FontProvider> createState() => FontProviderState();
}

class FontProviderState extends State<FontProvider> {
  String? _fontFamily;
  double? _fontSizeFactor;

  Timer? _fontSizeTimer;

  static Future<ByteData> _loadFromBytes(Uint8List bytes) async {
    return ByteData.view(bytes.buffer);
  }

  Future<void> _changeFontFamily(String fontName, Uint8List bytes) async {
    FontLoader custom = FontLoader(fontName);
    custom.addFont(_loadFromBytes(bytes));
    await custom.load();

    setState(() {
      _fontFamily = fontName;
    });

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      return prefs.setString(storageKeyFontBytes, base64Encode(bytes));
    });
  }

  void _resetFont() {
    setState(() {
      _fontFamily = null;
      _fontSizeFactor = null;
    });
  }

  void changeFontSizeFactor(double newFontSizeFactor) {
    setState(() {
      _fontSizeFactor = newFontSizeFactor;
    });

    _fontSizeTimer?.cancel();
    _fontSizeTimer = Timer(const Duration(milliseconds: 500), () {
      SharedPreferences.getInstance().then((SharedPreferences prefs) {
        return prefs.setDouble(storageKeyFontScale, newFontSizeFactor);
      });
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

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String? fontString = prefs.getString(storageKeyFontBytes);
      if (fontString != null) {
        Uint8List bytes = base64Decode(fontString);
        _changeFontFamily("custom", bytes);
      }

      double? fontSizeFactor = prefs.getDouble(storageKeyFontScale);
      if (fontSizeFactor != null) {
        changeFontSizeFactor(fontSizeFactor);
      }
    });
  }
}

class FontSettings extends InheritedWidget {
  final String? _fontFamilyData;
  final double? _fontSizeFactorData;

  final FontProviderState _state;

  const FontSettings({
    required String? fontFamilyData,
    required double? fontSizeFactorData,
    required FontProviderState state,
    required super.child,
    super.key,
  })  : _state = state,
        _fontFamilyData = fontFamilyData,
        _fontSizeFactorData = fontSizeFactorData;

  String? get fontFamily => _fontFamilyData;

  double get fontSizeFactor => _fontSizeFactorData ?? 1.0;
  set fontSizeFactor(double num) => _state.changeFontSizeFactor(num);

  void fontSelectPopup() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["ttf", "otf"],
    );

    if (result == null) return; // Dialog was canceled

    String fontName = result.files.single.name;

    Uint8List bytes;
    if (kIsWeb) {
      bytes = result.files.single.bytes!;
    } else {
      File sourceFile = File(result.files.single.path!);
      bytes = await sourceFile.readAsBytes();
    }

    _state._changeFontFamily(fontName, bytes);
  }

  void reset() {
    _state._resetFont();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.remove(storageKeyFontBytes);
      prefs.remove(storageKeyFontScale);
    });
  }

  static FontSettings? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FontSettings>();
  }

  @override
  bool updateShouldNotify(FontSettings oldWidget) {
    return oldWidget._fontFamilyData != _fontFamilyData ||
        oldWidget._fontSizeFactorData != _fontSizeFactorData;
  }
}
