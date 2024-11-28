import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:my_app/customCurvedBottomNav.dart';
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

  List<Widget> body = [
    CustomContainer(),
  ];
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     try {
        //       getLocation();
        //     } catch (e) {
        //       print(e.toString());
        //     }
        //   },
        // ),
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(title),
        ),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          height: 80,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 70),
                  painter: CurvedPainter(
                      color: Colors.white,
                      shadowOffset: Offset(4, 4),
                      shadowBlur: 3),

                  // foregroundPainter: CurvedPainter(),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BottomNavItem(icon: Icons.home, label: 'Home'),
                      BottomNavItem(icon: Icons.home, label: 'Home'),
                      BottomNavItem(icon: Icons.fingerprint, label: 'Home'),
                      BottomNavItem(icon: Icons.home, label: 'Home'),
                      BottomNavItem(icon: Icons.home, label: 'Home'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        body: CustomContainer());
  }

  Widget BottomNavItem(
      {required IconData icon,
      required String label,
      Color color = Colors.grey}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        radius: 40, borderRadius: BorderRadius.circular(40),
        // splashColor: Colors.amber,
        onTap: () {
          print(label);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 30,
                color: color,
              ),
              Text(
                '$label',
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.amber,
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
  final Color color;
  final Color shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;
  final double cornerRadius, curve;

  CurvedPainter(
      {required this.color,
      this.shadowColor =
          const Color(0x55000000), // Default semi-transparent black
      this.shadowBlur = 10.0,
      this.shadowOffset = const Offset(4, 4),
      this.cornerRadius = 40,
      this.curve = 45});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

    final Path path = Path();

    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 10, cornerRadius, 0);
    path.quadraticBezierTo(
        size.width * 0.5, -curve, size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 10, size.width, cornerRadius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cornerRadius);
    path.close();

    // Draw the shadow (offset by shadowOffset)
    canvas.save();
    canvas.translate(shadowOffset.dx, shadowOffset.dy);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Draw the actual shape
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
