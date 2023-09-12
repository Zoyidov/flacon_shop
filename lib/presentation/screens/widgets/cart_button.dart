import 'package:flutter/material.dart';
import '../../../data/db/cart_db.dart';
import '../../../data/model/product_model.dart';

class CartButton extends StatefulWidget {
  final ProductModel product;
  final void Function(ProductModel, bool) onPressed;

  CartButton({
    Key? key,
    required this.product,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CartButtonState createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isInCart = false;

  @override
  void initState() {
    super.initState();
    _loadCartStatus();
  }

  Future<void> _loadCartStatus() async {
    final isInCart = await CartDatabaseHelper().isProductInCart(widget.product.id);

    setState(() {
      _isInCart = isInCart;
    });
  }

  Future<void> _saveCartStatus(bool isCarted) async {
    setState(() {
      _isInCart = isCarted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
        size: 40,
        color: _isInCart ? Colors.black : Colors.grey,
      ),
      onPressed: () async {
        final isCarted = !_isInCart;
        _saveCartStatus(isCarted);
        widget.onPressed(widget.product, isCarted);
      },
    );
  }
}
