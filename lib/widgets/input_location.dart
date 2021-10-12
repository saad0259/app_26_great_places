import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';

class InputLocation extends StatefulWidget {
  const InputLocation({Key? key}) : super(key: key);

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
    }
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
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }
}
