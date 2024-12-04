import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:my_app/customCurvedBottomNav.dart';
import 'package:my_app/googleMaps.dart';
import 'package:my_app/map.dart';
import 'package:my_app/place.dart';
import 'package:my_app/pod.dart';

class MyHomePage extends StatelessWidget {
  final title = 'Home Page';

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // ref.read(userLocationPod.notifier).getLocation();
        final location = ref.watch(userLocationPod);

        return location.lat != 0.0
            ? MyMap(
                long: location.long,
                lat: location.lat,
              )
            : Center(
                child: LinearProgressIndicator(),
              );
      },
    );
  }

  Widget BottomNavItem(
      {required IconData icon,
      required String label,
      required ontap,
      Color color = Colors.grey}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        radius: 40, borderRadius: BorderRadius.circular(40),
        // splashColor: Colors.amber,
        // onTap: ontap,
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
