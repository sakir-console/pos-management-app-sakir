import 'package:pos_by_sakir/controller/bottom_navbar_riverpod.dart';
import 'package:pos_by_sakir/controller/product_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final bottomNavbarRiverpod = ChangeNotifierProvider((_) => BottomNavbarRiverpod());

final productRiverpod = ChangeNotifierProvider((_) => ProductRiverpod());




