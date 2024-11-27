import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:my_app/googleMaps.dart';
import 'package:my_app/map.dart';

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final title = 'Home Page';
  Location location = new Location();
// Future locationPermission(context) async {
//   PermissionStatus status = await Permission.location.request();
//   if (status.isGranted == false) {
//     await Permission.location.request();
//   } else if (status.isGranted == true) {
//   } else if (status.isDenied == true) {
//     await Permission.location.request();
//   } else if (status.isPermanentlyDenied == true) {
//     openDialogSetting(context);
//   }
// }
  locationService() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  getLocation() async {
    LocationData _locationData;

    locationService();

    _locationData = await location.getLocation();
    latlong = _locationData;
    setState(() {});
  }

  var latlong;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getLocation();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    int index = 0;
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            try {
              getLocation();
            } catch (e) {
              print(e.toString());
            }
          },
        ),
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(title),
        ),
        bottomNavigationBar: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  // BoxShadow(
                  //   blurRadius: 2,
                  //   blurStyle: BlurStyle.inner,
                  //   // offset: Offset(1000, 20),
                  // )
                ]),
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 50),
                  painter: CurvedPainter(
                    color: Colors.black,
                  ),
                  // child: BottomNavigationBar(
                  //     selectedIconTheme: IconThemeData(color: Colors.amber),
                  //     elevation: 0,
                  //     backgroundColor: Colors.transparent,
                  //     currentIndex: 0,
                  //     onTap: (value) {
                  //       index = value;
                  //       print(index);
                  //       setState(() {});
                  //     },
                  //     type: BottomNavigationBarType.fixed,
                  //     items: [
                  //       BottomNavItem(),
                  //       BottomNavItem(),
                  //       BottomNavItem(),
                  //       BottomNavItem(),
                  //       BottomNavItem(),
                  //     ]),
                  // foregroundPainter: CurvedPainter(),
                ),
              ),
            ),
            // Container(
            //   height: 60,
            //   decoration: BoxDecoration(
            //       color: Colors.red,
            //       borderRadius: BorderRadius.only(
            //           topRight: Radius.circular(20),
            //           topLeft: Radius.circular(20))),
            // )
            // BottomNavigationBar(
            //     backgroundColor: Colors.transparent,
            //     currentIndex: index,
            //     onTap: (value) {
            //       index = value;
            //       print(index);
            //       setState(() {});
            //     },
            //     type: BottomNavigationBarType.fixed,
            //     items: [
            //       BottomNavItem(),
            //       BottomNavItem(),
            //       BottomNavItem(),
            //     ]),
          ],
        ),
        body: MyMap(
          lat: 27.7103,
          long: 85.3222,
        ));
  }

  BottomNavigationBarItem BottomNavItem() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.map),
      label: 'Map',
    );
  }
}

class CustomNotchedShape extends NotchedShape {
  @override
  Path getOuterPath(Rect host, Rect? guest) {
    final double notchRadius = 29.0;
    final Path path = Path()
      ..moveTo(host.left, host.top)
      ..lineTo(host.center.dx - notchRadius, host.top)
      ..quadraticBezierTo(
        host.center.dx,
        host.top - notchRadius,
        host.center.dx + notchRadius,
        host.top,
      )
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
    return path;
  }
}

class CurvedPainter extends CustomPainter {
  Color color;
  CurvedPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // final Path path = Path();
    // path.moveTo(0, 0); // Start point
    // // path.quadraticBezierTo(0, -25, size.width, 0);
    // // path.moveTo(0, size.height);
    // path.quadraticBezierTo(
    //     size.width * 0.5, -45, size.width, 0); // Create curve
    // path.lineTo(size.width, size.height); // Bottom-right corner
    // path.lineTo(0, size.height);
    final Path path = Path();

    // Start at the top-left corner with a rounded border
    const double cornerRadius = 40.0;
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.moveTo(cornerRadius - 10, 0);
    path.quadraticBezierTo(
        size.width * 0.5, -45, size.width - cornerRadius + 20, 0);
    // path.moveTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Add the top-middle curve

    // Add the top-right rounded corner

    // Right side (straight line down)
    path.lineTo(size.width, size.height);

    // Bottom edge (straight line)
    path.lineTo(0, size.height);

    // Left side (straight line up)
    path.lineTo(0, cornerRadius);

    path.close(); // Close path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
