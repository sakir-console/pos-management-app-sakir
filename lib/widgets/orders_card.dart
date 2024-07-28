import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pos_by_sakir/values/values.dart';
import 'package:pos_by_sakir/widgets/card_tags.dart';

class OrderListCard extends StatelessWidget {
  final String orderId;
  final String vndId;
  final String imagePath;
  final String vndName;
  final String division;
  final String orderTime;
  final String itemQty;
  final String itemsCost;

  final GestureTapCallback onTap;

  final double tagRadius;
  final double width;
  final double cardHeight;
  final double imageHeight;
  final double cardElevation;
  final double ratingsAndStatusCardElevation;

  OrderListCard(
      {required this.orderId,
      required this.vndId,
      required this.imagePath,
      required this.vndName,
      required this.division,
      required this.orderTime,
      required this.itemQty,
      required this.itemsCost,
      this.width = 340.0,
      this.cardHeight = 135.0,
      this.imageHeight = 110.0,
      this.tagRadius = 58.0,
      required this.onTap,
      this.cardElevation = 4.0,
      this.ratingsAndStatusCardElevation = 8.0});

  String formatTimestamp(String timestamp) {
    if (timestamp == 'null' || timestamp.isEmpty) {
      return 'No date';
    }
    // Parse the timestamp string into a DateTime object
    DateTime dateTime = DateTime.parse(timestamp);

    // Define the date format you want
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    // Format the DateTime object using the defined format
    String formattedDateTime = dateFormat.format(dateTime);

    return formattedDateTime;
  }

  String remainingTime(String timestamp) {
    if (timestamp == 'null' || timestamp.isEmpty) {
      return 'No date';
    }

    // Parse the timestamp string into a DateTime object
    DateTime orderDate = DateTime.parse(timestamp);

    // Calculate the order deadline (20 days after the order date)
    DateTime orderDeadline = orderDate.add(Duration(days: 20));

    // Calculate the difference between the order deadline and the current time
    Duration difference = orderDeadline.difference(DateTime.now());

    // If the difference is negative, it means the review time has expired
    if (difference.isNegative) {
      return 'Review time expired';
    }

    // Calculate remaining days, hours, and minutes
    int remainingDays = difference.inDays;
    int remainingHours = difference.inHours.remainder(24);
    int remainingMinutes = difference.inMinutes.remainder(60);

    // Construct the remaining time string
    if (remainingDays > 0) {
      return '$remainingDays days';
    } else if (remainingHours > 0) {
      return '$remainingHours hours';
    } else {
      return '$remainingMinutes minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 1.04,
        height: cardHeight,
        child: Card(
          surfaceTintColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Sizes.MARGIN_6,
                  vertical: Sizes.MARGIN_6,
                ),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image.network(
                        imagePath,
                        width: MediaQuery.of(context).size.width / 4,
                       // height: imageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 25.2,
                            child: Text(
                              vndName,
                              style: Styles.customTitleTextStyle(
                                color: AppColors.headingText,
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.pin_invoke_sharp, color: Colors.orange),
                              Text(
                                division,
                                style:
                                    TextStyle(color: Colors.orange, fontSize: 15),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 6),
                            child: Row(
                              children: <Widget>[
                                CardTags(
                                  title: 'Items:  ' + itemQty,
                                  decoration: BoxDecoration(
                                    gradient: Gradients.secondaryGradient,
                                    boxShadow: [
                                      Shadows.secondaryShadow,
                                    ],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(tagRadius),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                CardTags(
                                  title: 'Cost  : ৳ ' + itemsCost,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 132, 141, 255),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(tagRadius)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.add_alarm,
                                  size: 19,
                                ),
                                Flexible(
                                  child: Container(
                                    padding: new EdgeInsets.only(right: 2.0),
                                    child: Text(formatTimestamp(orderTime),
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.akronim(
                                            fontSize: 20, color: Colors.black)),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
  }
}
