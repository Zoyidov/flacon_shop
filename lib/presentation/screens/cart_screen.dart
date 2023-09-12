import 'package:flacon_shop/presentation/screens/widgets/total_price.dart';
import 'package:flacon_shop/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../data/db/cart_db.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final dbHelper = CartDatabaseHelper();
  List<Map<String, dynamic>> cartProducts = [];

  @override
  void initState() {
    super.initState();
    fetchCartProducts();
  }

  Future<void> fetchCartProducts() async {
    final products = await dbHelper.getCartProducts();
    setState(() {
      cartProducts = products;
    });
  }

  void _updateProductQuantity(int productId, int newQuantity) async {
    await dbHelper.updateProductQuantity(productId, newQuantity);
    fetchCartProducts();
  }

  double calculateTotalPrice(int quantity, double price) {
    return quantity * price;
  }

  double calculateTotalPriceForCart(List<Map<String, dynamic>> cartProducts) {
    double totalPrice = 0.0;

    for (final product in cartProducts) {
      final quantity = product['quantity'] as int;
      final price = product['price'] as double;
      totalPrice += quantity * price;
    }

    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.baseDark,
          title: const Text('Cart'),
        ),
        body: cartProducts.isEmpty
            ? const Center(
                child: Text('No products have been added to the cart yet!'),
              )
            : ListView.builder(
                itemCount: cartProducts.length,
                itemBuilder: (context, index) {
                  final product = cartProducts[index];
                  final productId = product['productId'] as int;
                  final quantity = product['quantity'] as int;
                  final totalprice =
                      calculateTotalPrice(quantity, product['price'] as double);
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 7),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: ListTile(
                        leading: Image.network(
                          product['image'] ?? '',
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          product['title'] ?? '',
                          maxLines: 2,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${totalprice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ZoomTapAnimation(
                                  onTap: () {
                                    _updateProductQuantity(
                                        productId, quantity + 1);
                                  },
                                  child: const Icon(
                                    Icons.add_circle_outline,
                                  ),
                                ),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                ZoomTapAnimation(
                                  onTap: () {
                                    if (quantity > 0) {
                                      _updateProductQuantity(
                                          productId, quantity - 1);
                                    }
                                    if (quantity == 1) {
                                      final productId =
                                          product['productId'] as int;
                                      dbHelper.removeFromCart(productId);
                                      fetchCartProducts();
                                    }
                                  },
                                  child: const Icon(
                                    Icons.remove_circle_outline,
                                  ),
                                ),
                                const SizedBox(width: 50),
                                ZoomTapAnimation(
                                  onTap: () {
                                    final productId =
                                        product['productId'] as int;
                                    dbHelper.removeFromCart(productId);
                                    fetchCartProducts();
                                  },
                                  child: const Icon(
                                    CupertinoIcons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartDocked,
        floatingActionButton: TotalPrice(
          totalPrice: '  \$${calculateTotalPriceForCart(cartProducts).toStringAsFixed(2)}',
        ),
    );
  }
}
