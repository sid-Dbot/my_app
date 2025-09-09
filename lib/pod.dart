import 'package:location/location.dart';
import 'package:my_app/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationNotifier extends AsyncNotifier {
  LocationNotifier() : super() {
    getLocation();
  }

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

  Place latlong = Place(lat: 23423242, long: 23434.222);

  getLocation() async {
    LocationData _locationData;

    locationService();

    _locationData = await location.getLocation();
    return _locationData;
    // state = Place(
    //     lat: _locationData.latitude!.toDouble(),
    //     long: _locationData.longitude!);
    // print(state.lat);
  }

  @override
  build() async {
    // TODO: implement build
    return await getLocation();
    // return Place(lat: 00.0, long: 00.0);
  }
}

// final userLocationPod =
//     StateNotifierProvider<LocationNotifier, Place>((ref) => LocationNotifier());
