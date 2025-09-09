import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:my_app/customCurvedBottomNav.dart';
import 'package:my_app/homeScreen.dart';
import 'package:my_app/map.dart';

class NewHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  final title = 'Home Page';

  List<IconData> icons = [
    Icons.home,
    Icons.abc,
    Icons.fingerprint,
    Icons.cabin,
    Icons.ac_unit
  ];
  List<Widget> body = [
    ListView.builder(
      itemBuilder: (context, index) => Card(
        child: Container(
          height: 50,
          width: double.infinity,
          child: Center(
            child: Text(
              '$index',
            ),
          ),
        ),
      ),
      itemCount: 22,
    ),
    MyHomePage(),
    CustomContainer(
      clor: Colors.deepPurple,
    ),
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the NewHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      bottomNavigationBar: CustomCurvedBottomNav(
        // cornerRadius: 0,
        items: [
          BottomNavItem(
              icon: Icons.home,
              label: 'Home',
              color: index == 0 ? Colors.blue : Colors.grey,
              ontap: () {
                setState(() {
                  index = 0;
                });
              }),
          BottomNavItem(
              icon: Icons.map_outlined,
              label: 'Map',
              bgcolor: index == 1 ? Colors.blue : Colors.transparent,
              color: index == 1 ? Colors.white : Colors.grey,
              ontap: () {
                setState(() {
                  index = 1;
                });
              }),
          BottomNavItem(
              icon: Icons.fingerprint,
              label: 'Home',
              color: index == 2 ? Colors.blue : Colors.grey,
              ontap: () {
                index = 2;
                setState(() {});
              }),
        ],
      ),
      body: body[index],
    );
  }

  Widget BottomNavItem(
      {required IconData icon,
      required String label,
      required ontap,
      Color color = Colors.grey,
      Color bgcolor = Colors.transparent,
      double paddingbot = 0.0}) {
    return Padding(
      padding: EdgeInsets.only(bottom: paddingbot),
      child: CircleAvatar(
        radius: 35,
        backgroundColor: bgcolor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            radius: 40, borderRadius: BorderRadius.circular(40),
            // splashColor: Colors.amber,
            onTap: ontap,
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
                    style: TextStyle(fontSize: 12, color: color),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
