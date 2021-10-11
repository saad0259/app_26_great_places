import 'dart:io';

class PlaceLocation {
  final double? latitude, longitude;
  final String? address;

  PlaceLocation({
    this.latitude,
    this.longitude,
    this.address,
  });
}

class Place {
  String id, title;
  final PlaceLocation? location;
  final File image;

  Place(
      {required this.id,
      required this.title,
      required this.location,
      required this.image});
}
