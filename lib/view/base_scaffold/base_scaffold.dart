import 'package:pos_by_sakir/controller/riverpod_management.dart';
import 'package:pos_by_sakir/view/utilities/constants/constants.dart';
import 'package:pos_by_sakir/view/utilities/widgets/bottom_navbar.dart';
import 'package:pos_by_sakir/controller/bottom_navbar_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseScaffold extends ConsumerStatefulWidget {
  const BaseScaffold({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends ConsumerState<BaseScaffold> {
  @override
  void initState() {
   // ref.read(productRiverpod).init();
    super.initState();
  }
@override
  void setState(VoidCallback fn) {
     ref.read(productRiverpod).init();
    // TODO: implement setState
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(bottomNavbarRiverpod);
    return Scaffold(
      bottomNavigationBar: const BottomNavbar(),
      body: watch.body(),

    );
  }

  CupertinoNavigationBar appbarBuilder(BottomNavbarRiverpod watch) {
    return CupertinoNavigationBar(
      middle: Text(
        watch.appBarTitle(),
        style: const TextStyle(
          color: Constants.appColor,
          fontSize: 20.0,
        ),
      ),
    );
  }
}
