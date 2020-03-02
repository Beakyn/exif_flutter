class MetadataTag {
  static final latitude = 'GPSLatitude';
  static final latitudeRef = 'GPSLatitudeRef';
  static final longitude = 'GPSLongitude';
  static final longitudeRef = 'GPSLongitudeRef';
  static final dateTimeOriginal = 'DateTimeOriginal';
  static final userComment = 'UserComment';
}

String getLatitudeRef(double latitude) {
  return latitude < 0 ? 'W' : 'E' ;
}

String getLongitudeRef(double longitude) {
  return longitude < 0 ? 'S' : 'N' ;
}
