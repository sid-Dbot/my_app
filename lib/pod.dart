import 'package:location/location.dart';
import 'package:my_app/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationNotifier extends StateNotifier<Place> {
  LocationNotifier() : super(Place(lat: 23423242, long: 23434.222));

  // LocationNotifier() : super() ;
  Location location = new Location();

  locationService() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
  }

  late Place latlong;

  getLocation() async {
    LocationData _locationData;

    locationService();

    _locationData = await location.getLocation();
    latlong = Place(
        lat: _locationData.latitude!.toDouble(),
        long: _locationData.longitude!);
  }
}

final userLocationPod =
    StateNotifierProvider<LocationNotifier, Place>((ref) => LocationNotifier());
