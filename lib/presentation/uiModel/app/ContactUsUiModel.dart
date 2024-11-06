import 'package:latlong2/latlong.dart';

class ContactUsUiModel {
  final String address, phone;
  LatLng? latLng;

  ContactUsUiModel({
    this.address = '',
    this.phone = '',
    this.latLng
  });
}
