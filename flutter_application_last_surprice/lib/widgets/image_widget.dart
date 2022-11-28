import 'dart:io';

import 'package:flutter/material.dart';

class imageSee extends StatefulWidget {
  String? pathImage;
  imageSee({Key? key, this.pathImage}) : super(key: key);

  @override
  State<imageSee> createState() => _imageSeeState();
}

class _imageSeeState extends State<imageSee> {
  @override
  Widget build(BuildContext context) {
    if (widget.pathImage == '' || widget.pathImage == null) {
      return Placeholder();
    } else {
      return Image.file(File(widget.pathImage!));
    }
  }
}
