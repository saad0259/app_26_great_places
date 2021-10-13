import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class InputLocation extends StatefulWidget {
  final Function selectPlace;

  InputLocation(this.selectPlace);

  @override
  _InputLocationState createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  String? _previewImageUrl;

  Future<void> _getCurrentLocation() async {
    final locData = await Location().getLocation();
    if (locData.latitude != null && locData.longitude != null) {
      final staticMapImageUrl = LocationHelper.generateLocationPreview(
        latitude: locData.latitude!,
        longitude: locData.longitude!,
      );
      setState(() {
        _previewImageUrl = staticMapImageUrl;
      });
      widget.selectPlace(locData.latitude, locData.longitude);
    }
  }

  Future<void> _selectMapLocation() async {
    final selectedPlace =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => MapScreen(
                  isSelecting: true,
                )));
    if (selectedPlace == null) {
      return;
    }
    widget.selectPlace(selectedPlace.latitude, selectedPlace.longitude);

    print(selectedPlace);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          height: 150,
          width: double.infinity,
          child: _previewImageUrl == null
              ? Text(
                  'No Location Selected',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on),
              label: Text(
                'Current Location',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text(
                'Select on map',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: _selectMapLocation,
            ),
          ],
        )
      ],
    );
  }
}
