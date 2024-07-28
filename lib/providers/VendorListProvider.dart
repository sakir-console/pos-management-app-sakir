import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_by_sakir/repositories/auth_repository.dart';
import 'package:pos_by_sakir/repositories/vendor_list_repository.dart';

final vendorServiceProvider = Provider<VendorRepository>((ref) => VendorRepository());


final responseVendors = FutureProvider((ref) async {
  return ref.watch(vendorServiceProvider).vendorList();
});

