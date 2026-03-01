import 'package:flutter/services.dart' show rootBundle, Color;


Future<String> loadSvgAndChangeColors(String image, Color replaceColor) async {

  String svgString = await rootBundle.loadString(image);

  String primaryHex = '#${replaceColor.value.toRadixString(16).substring(2).toUpperCase()}';


  svgString = svgString.replaceAll('#00A08D', primaryHex);

  return svgString;
}