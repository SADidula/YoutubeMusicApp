import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class CustomPaletteGenerator {
  static Future<PaletteGenerator> getDominantPalette(String url) async {
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.network(url).image,
    );
    return paletteGenerator;
  }
}
