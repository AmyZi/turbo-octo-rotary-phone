

class MapBoundHelper {

  static double boundMapArea (double? circle){
    double zoomLevel = 16;
    if (circle != null) {
      double radius = circle + circle / 2;
      double scale = radius / 400;
      zoomLevel = (16 - scale / 2);
    }
    return zoomLevel;
  }

}