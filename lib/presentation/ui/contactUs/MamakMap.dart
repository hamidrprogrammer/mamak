import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MamakMapUi extends StatelessWidget {
  const MamakMapUi({Key? key, required this.controller, this.marker})
      : super(key: key);
  final MapController controller;
  final LatLng? marker;

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
