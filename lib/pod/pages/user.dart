import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/provider.dart';

final response = FutureProvider((ref) async {
  final ApiService = ref.watch(apiServiceProvider);
  return ApiService.getCategory();
});


class ItemCategory extends ConsumerWidget {

  itemss() {
    return FutureProvider((ref) async {
      final ApiService = ref.watch(apiServiceProvider);
      ApiService.getCategoryItems(2);
    });
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responseProvider = ref.watch(response);


    return Scaffold(
      appBar: AppBar(
        title: const Text("Users "),
      ),
      body: Center(
        child: responseProvider.when(data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    data[index].name,
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    data[index].vendorId.toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                  leading: Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      data[index].id.toString(),
                    ),
                  ),
                ),
              );
            },
          );
        }, error: ((error, stackTrace) {
          return Text(error.toString());
        }), loading: () {
          return const CircularProgressIndicator();
        }),
      ),
    );
  }
}
