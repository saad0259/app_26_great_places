import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class InputImage extends StatefulWidget {
  final Function selectImage;

  const InputImage(this.selectImage);

  @override
  _InputImageState createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 600,
    );
    if(imageFile==null){
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(_storedImage!.path);
    final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
    widget.selectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
            child: _storedImage != null
                ? Image.file(
                    _storedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : const Text(
                    'No Image',
                    textAlign: TextAlign.center,
                  ),
            alignment: Alignment.center,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextButton.icon(
              icon: const Icon(Icons.camera),
              label: Text(
                'Take Picture',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: _takePicture,
            ),
          ),
        ],
      ),
    );
  }
}
