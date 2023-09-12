// ignore_for_file: prefer_interpolation_to_compose_strings, library_private_types_in_public_api

import 'package:flacon_shop/presentation/screens/selected_product.dart';
import 'package:flacon_shop/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../data/db/db.dart';
import '../../data/model/product_model.dart';


class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> likedProducts = [];


  @override
  void initState() {
    super.initState();
    _fetchLikedProducts();
  }

  Future<void> _fetchLikedProducts() async {
    final products = await dbHelper.getLikedProducts();
    setState(() {
      likedProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.baseDark,
        title: const Text('Favourites'),
      ),
      body: likedProducts.isEmpty?
          const Center(
            child: Text('Any product has not been liked yet!'),
          ):
      GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemCount: likedProducts.length,
        itemBuilder: (context, index) {
          final product = likedProducts[index];
          return GridTile(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product['image'] != null)
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        child: ZoomTapAnimation(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(model: ProductModel.fromJson(product)),
                              ),
                            );
                          },
                          child: Center(
                            child: Image.network(
                              product['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'],
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            product['category'],
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.monetization_on_outlined),
                                  Text(
                                    " " + product['price'].toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              ZoomTapAnimation(
                                onTap: () async {
                                  final productId = product['productId'];
                                  await DatabaseHelper().deleteLikedProduct(productId);
                                  _fetchLikedProducts();
                                },
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
