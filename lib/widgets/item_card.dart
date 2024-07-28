import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pos_by_sakir/values/values.dart';

import 'card_tags.dart';


class ItemCard extends StatefulWidget {
  final String imagePath;
  final String itemName;
  final String itemSize;
  final String price;
  final Widget ratingBar;
  final Widget currentRate;
  final TextEditingController indvItemContrlr;
  final GestureTapCallback onTap;

  final double tagRadius;
  final double width;
  final double cardHeight;
  final double imageHeight;
  final double cardElevation;
  final double ratingsAndStatusCardElevation;
  final List<String> followersImagePath;

  ItemCard({
    required this.imagePath,
    required this.itemName,
    required this.itemSize,
    required this.price,
    required this.ratingBar,
    required this.currentRate,
    required this.indvItemContrlr,
    this.width = 340.0,
    this.cardHeight = 208.0,
    this.imageHeight = 100.0,
    this.tagRadius = 58.0,
    required this.onTap,
    this.cardElevation = 4.0,
    this.ratingsAndStatusCardElevation = 8.0,
    required this.followersImagePath,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  double rate = 0;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 1.04,
        // height: cardHeight,

        child: Card(
          surfaceTintColor: Colors.white,
          elevation: 7,
         // elevation: widget.cardElevation,
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
                      borderRadius: BorderRadius.circular(10),
                      child:CachedNetworkImage(
                        imageUrl: widget.imagePath,
                        width: MediaQuery.of(context).size.width/3.8,
                        height: widget.imageHeight,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Center(
                            child: Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey,
                                ))),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 6),
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 31.2,
                            child: Text(
                              widget.itemName,
                              textAlign: TextAlign.left,
                              style: Styles.customTitleTextStyle(
                                color: AppColors.headingText,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          widget.ratingBar,
                          widget.currentRate,
                          Row(
                            children: <Widget>[
                              CardTags(
                                title: widget.itemSize,
                                decoration: BoxDecoration(
                                  gradient: Gradients.indianGradient,
                                  boxShadow: [
                                    Shadows.secondaryShadow,
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(widget.tagRadius),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              CardTags(
                                title: widget.price,
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(widget.tagRadius)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Sizes.MARGIN_14,
                  vertical: Sizes.MARGIN_0,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        //Text("-----------------------------"),
                        Expanded(
                          child: Divider(
                            color: Colors.grey[200],
                            thickness: 1.0,
                          ),
                        ),
                      ],
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
