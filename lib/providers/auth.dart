import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_by_sakir/repositories/auth_repository.dart';

final authServiceProvider = Provider<AuthRepository>((ref) => AuthRepository());


final responseAuth = FutureProvider((ref) async {
  return ref.watch(authServiceProvider);
});

