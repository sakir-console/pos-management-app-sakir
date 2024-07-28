import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pos_by_sakir/model/product_model.dart';
import 'package:pos_by_sakir/models/items_model.dart';
import 'package:pos_by_sakir/utils/constants.dart';
import 'package:pos_by_sakir/view/utilities/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';

import '../../../controller/product_riverpod.dart';

class ProductWidget extends StatelessWidget {
  ItemModel productModel;
  Function setFav;
  Function setBasket;
  Function decrementQty;
  Function removeItem;
  ProductRiverpod? productRiverpod;
  String? vndId;

  ProductWidget({
    Key? key,
    required this.productModel,
    required this.setFav,
    required this.setBasket,
    required this.decrementQty,
    required this.removeItem,
    this.productRiverpod,
    required this.vndId, // Wrap in curly braces to make it optional
  }) : super(key: key);

  void _showQuantityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Quantity'),
          content: SingleChildScrollView(
            child: Column(
              children: productModel.qtys.map((quantity) {
                return ListTile(
                  title: Text(quantity.qty),
                  subtitle: Row(
                    children: [
                      const Text('Price: '),
                      quantity.discountPrice == null
                          ? Text('${quantity.price}')
                          : Text('${quantity.discountPrice}'),
                      quantity.discountPrice != null
                          ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${quantity.price}',
                          style: const TextStyle(color: Colors.red,
                              decoration: TextDecoration.lineThrough),
                        ),
                      )
                          : const Text(''),
                    ],
                  ),
                  onTap: () {
                    setBasket(quantity); // Set the selected quantity
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showRemoveQuantityDialog(
      BuildContext context, ProductRiverpod productRiverpod) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Item'),
          content: SingleChildScrollView(
            child: Column(
              children: productModel.qtys
                  .where((quantity) => productRiverpod.itemsX.any((item) =>
              item['id'] == productModel.id &&
                  item['size'] == quantity.qty &&
                  item['qty'] >
                      0)) // Filter out quantities with qty 0 in itemsX
                  .map((quantity) {
                // Find the number of items for the current size
                int itemCount = productRiverpod.itemsX
                    .where((item) =>
                item['id'] == productModel.id &&
                    item['size'] == quantity.qty)
                    .fold<int>(
                    0,
                        (previousValue, element) =>
                    previousValue + (element['qty'] as int));

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.red[200],
                  ),
                  child: ListTile(
                    title: Text(
                      '${quantity.qty} ($itemCount)',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    subtitle: Text(
                      'Price: ${quantity.discountPrice ?? quantity.price}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () {
                      decrementQty(quantity); // Remove the selected quantity
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (productModel.qtys.length == 1) {
          setBasket(productModel
              .qtys.first); // Directly set the only available quantity
        } else {
          _showQuantityDialog(
              context); // Show the dialog if multiple quantities are available
        }
      },
      child: Stack(
        children: [
          Card(
            color: productModel.qty == 0 ? Colors.orange : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: 10.allBR),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepOrange.shade50,
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: productModel.qty != 0
                          ? const ColorFilter.mode(
                          Colors.black26, BlendMode.dstATop)
                          : null,
                      image: NetworkImage(
                          "${API.HOST}uploads/images/vendors/${vndId.toString()}/items/${productModel.imgs[0]}"))),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    BorderedText(
                      strokeWidth: 4.0,
                      strokeColor: Colors.white,
                      child: Text(
                        productModel.qty.toString(),
                        style: TextStyle(
                          color: productModel.qty == 0
                              ? Colors.black
                              : Colors.blue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.0),
                    BorderedText(
                      strokeWidth: 3.0,
                      strokeColor:
                      productModel.qty == 0 ? Colors.black : Colors.indigo,
                      child: Text(
                        productModel.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    BorderedText(
                      strokeWidth: 3.0,
                      strokeColor: Colors.black,
                      child: Text(
                        '${ productModel.priceDiscounted??productModel.price.toString()} /-',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          productModel.qty != 0
              ? Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: GrockContainer(
                onTap: () => removeItem(),
                padding: 3.allP,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border:
                  Border.all(color: Colors.grey.shade300, width: 0.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                    )
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.xmark_circle,
                  color: Colors.redAccent,
                ),
              ),
            ),
          )
              : const Text(''),
          productModel.qty != 0
              ? Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: GrockContainer(
                onTap: () {
                  if (productModel.qtys.length == 1) {
                    decrementQty(productModel.qtys
                        .first); // Directly set the only available quantity
                  } else {
                    _showRemoveQuantityDialog(context,
                        productRiverpod!); // Show the dialog if multiple quantities are available
                  }
                },
                padding: 3.allP,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border:
                  Border.all(color: Colors.grey.shade300, width: 0.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                    )
                  ],
                ),
                child: Icon(
                  CupertinoIcons.minus_circle,
                  color: productModel.isFav
                      ? Colors.redAccent
                      : Colors.black,
                ),
              ),
            ),
          )
              : const Text(''),
        ],
      ),
    );
  }
}
