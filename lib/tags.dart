class MetadataTag {
  static final altitude = 'GPSAltitude';
  static final altitudeRef = 'GPSAltitudeRef';
  static final latitude = 'GPSLatitude';
  static final latitudeRef = 'GPSLatitudeRef';
  static final longitude = 'GPSLongitude';
  static final longitudeRef = 'GPSLongitudeRef';
  static final dateTimeOriginal = 'DateTimeOriginal';
  static final userComment = 'UserComment';
}

class Metadata {
  Metadata({
    this.altitude,
    this.altitudeRef,
    this.latitude,
    this.longitude,
    this.userComment,
    this.dateTimeOriginal,
  });

  final double altitude;
  final double altitudeRef;
  final double latitude;
  final double longitude;
  final String userComment;
  final DateTime dateTimeOriginal;

  Map<String, String> getLatitude() {
    return {
      MetadataTag.latitude: latitude.abs().toString(),
      MetadataTag.latitudeRef: getLatitudeRef(latitude),
    };
  }

  Map<String, String> getLongitude() {
    return {
      MetadataTag.longitude: longitude.abs().toString(),
      MetadataTag.longitudeRef: getLongitudeRef(longitude),
    };
  }

  Map<String, String> getAltitude() {
    return {
      MetadataTag.altitude: altitude.abs().toString(),
      MetadataTag.altitudeRef: altitudeRef ?? getAltitudeRef(altitude),
    };
  }

  Map<String, String> getDateTimeOriginal() {
    // Ex:. 2004:08:11 16:45:32
    final addZero = (int value) {
      return value > 9 ? value.toString() : '0$value';
    };

    final year = dateTimeOriginal.year;
    final month = addZero(dateTimeOriginal.month);
    final day = addZero(dateTimeOriginal.day);

    final hour = addZero(dateTimeOriginal.hour);
    final minute = addZero(dateTimeOriginal.minute);
    final second = addZero(dateTimeOriginal.second);

    return {
      MetadataTag.dateTimeOriginal: '$year:$month:$day $hour:$minute:$second'
    };
  }

  Map<String, String> toNative() {
    Map<String, String> response = {};

    if (latitude != null) response.addAll(getLatitude());
    if (longitude != null) response.addAll(getLongitude());
    if (userComment != null)
      response.addAll({MetadataTag.userComment: userComment});
    if (dateTimeOriginal != null) response.addAll(getDateTimeOriginal());
    if (altitude != null) response.addAll(getAltitude());

    return response;
  }
}

String getLongitudeRef(double longitude) {
  return longitude < 0 ? 'W' : 'E';
}

String getLatitudeRef(double latitude) {
  return latitude < 0 ? 'S' : 'N';
}

String getAltitudeRef(double altitude) {
  return altitude < 0 ? '1' : '0';
}
