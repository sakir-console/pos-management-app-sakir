import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:pos_by_sakir/main.dart';
import 'package:pos_by_sakir/pages/add_vendor.dart';
import 'package:pos_by_sakir/pages/auth_screen.dart';
import 'package:pos_by_sakir/utils/helpers/api.dart';
import 'package:pos_by_sakir/widgets/common_widgets.dart';

import '../view/base_scaffold/base_scaffold.dart';

class DashTest extends StatefulWidget {
  @override
  State<DashTest> createState() => _DashTestState();
}

class _DashTestState extends State<DashTest> {
  final double _borderRadius = 24;

  Color generateColor(int index) {
    List<int> colorCodes = [
      0xff6DC8F3,
      0xffFFB157,
      0xffFF5B95,
      0xffD76EF5,
      0xff42E695
    ];
    return Color(colorCodes[index % colorCodes.length]);
  }

  var items = [];

  bool isLoading = true;
//View my vendor list
  Future viewVendors() async {
    var data = await getApi("vendor-list");
    if (data['data'] != null) {
      if (data['result'] == true) {
        for (int i = 0; i < data['data'].length; i++) {
          var newColor = generateColor(items.length);
          var newVendorData = VendorItem(
              data['data'][i]['id'],
              data['data'][i]['name'],
              newColor,
              newColor,
              double.parse(data['data'][i]['rating'].toString()),
              data['data'][i]['address'],
              data['data'][i]['phone']);

          setState(() {
            items.add(newVendorData);
          });
        }
        setState(() {
          isLoading = false;
        });
      } else {
        Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Future logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
    Fluttertoast.showToast(
        msg: "প্রস্থান সফল হয়েছে",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AuthScreen(),
        ),
        (route) => true);
  }

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    viewVendors();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Vendors',
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text('DashTest App Bar'),
          ),
          body: ListView(
            children: [
              Center(
                child: Container(
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.amber,
                          backgroundColor:
                              Colors.black, // Text Color (Foreground color)
                        ),
                        child: Text('Add Vendor'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddVendor()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap:
                    true, //this property is must when you put List/Grid View inside SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences.setInt('vnd', items[index].id);
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BaseScaffold()),
                              (route) => false);
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(_borderRadius),
                                gradient: LinearGradient(
                                    colors: [
                                      items[index].startColor,
                                      items[index].endColor
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                boxShadow: [
                                  BoxShadow(
                                    color: items[index].endColor,
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              top: 0,
                              child: CustomPaint(
                                size: Size(100, 150),
                                painter: CustomCardShapePainter(
                                    _borderRadius,
                                    items[index].startColor,
                                    items[index].endColor),
                              ),
                            ),
                            Positioned.fill(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Image.asset(
                                      'assets/icon.png',
                                      height: 64,
                                      width: 64,
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          items[index].name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Avenir',
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          items[index].phone,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Flexible(
                                              child: Text(
                                                items[index].location,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Avenir',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          items[index].rating.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Avenir',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        RatingBar(
                                            rating: items[index].rating / 2),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.all(90),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Colors.teal,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  child: Text('Sign out'),
                  onPressed: () {
                    logOut(context);
                  },
                ),
              ),
            ],
          )),
    );
  }
}

class VendorItem {
  final int id;
  final String name;
  final String phone;
  final String location;
  final double rating;
  final Color startColor;
  final Color endColor;

  VendorItem(this.id, this.name, this.startColor, this.endColor, this.rating,
      this.location, this.phone);
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
