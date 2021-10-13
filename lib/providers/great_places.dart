import 'dart:io';

import 'package:flutter/foundation.dart';

import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((element) => id == element.id);
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation pickedLocation,
  ) async {
    print('inside model function');
    String _address = 'Some place';
    try {
      _address = await LocationHelper.getPlaceAddress(
          pickedLocation.latitude!, pickedLocation.longitude!);
    } catch (error) {
      print('could not get address because $error');
    }

    print('Address is $_address');
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: _address);
    print('updated Location $updatedLocation');

    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: updatedLocation,
      image: image,
    );
    print('new place $newPlace');
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location!.latitude!,
      'loc_lng': newPlace.location!.longitude!,
      'address': newPlace.location!.address!,
    });
    print('saved in db');
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_lng'],
                address: item['address'],
              ),
            ))
        .toList();
    print(_items);
    notifyListeners();
  }
}
