import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flacon_shop/presentation/screens/widgets/cart_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../data/db/cart_db.dart';
import '../../data/model/product_model.dart';
import '../../utils/colors.dart';
import '../../widgets/circles.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.model}) : super(key: key);

  final ProductModel model;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late double defaultRating;

  @override
  void initState() {
    super.initState();
    final random = Random();
    defaultRating = 1.0 + random.nextDouble() * 4.0;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: AppColors.baseDark,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Container(
            height: 300,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: CachedNetworkImage(
              imageUrl: widget.model.image,
              fit: BoxFit.scaleDown,
              placeholder: (context, url) =>
              const CupertinoActivityIndicator(),
              errorWidget: (context, url, error) => const Icon(
                Icons.no_photography_rounded,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  const Circles(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.model.title,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          children: [
                            Column(
                              children: [
                                Text(
                                  widget.model.description,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 100,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '\$${widget.model.price}',
                                    style: const TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.baseDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: widget.model.rating
                                          .rate ==
                                          0
                                          ? defaultRating
                                          : widget.model.rating.rate
                                          .toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      itemBuilder: (context, _) => const SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    Text(
                                      widget.model.rating.rate == 0
                                          ? defaultRating
                                          .toStringAsFixed(1)
                                          : widget.model.rating.rate
                                          .toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(width: 30),
                                    CartButton(
                                      product: widget.model,
                                      onPressed: (product, isInCart) async {
                                        final dbHelper = CartDatabaseHelper();
                                        if (isInCart) {
                                          await dbHelper.insertToCart({
                                            'productId': product.id,
                                            'title': product.title,
                                            'price': product.price,
                                            'description': product.description,
                                            'category': product.category,
                                            'image': product.image,
                                          });
                                        } else {
                                          await dbHelper.removeFromCart(product.id);
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
