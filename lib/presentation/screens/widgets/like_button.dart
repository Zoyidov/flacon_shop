import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/db/db.dart';
import '../../../data/model/product_model.dart';

class LikedButton extends StatefulWidget {
  final ProductModel product;
  final void Function(ProductModel, bool) onPressed;

  LikedButton({
    Key? key,
    required this.product,
    required this.onPressed,
  }) : super(key: key);

  @override
  _LikedButtonState createState() => _LikedButtonState();
}

class _LikedButtonState extends State<LikedButton> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadLikedStatus();
  }

  Future<void> _loadLikedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'liked_${widget.product.id}';
    final likedInDatabase = await DatabaseHelper().isProductLiked(widget.product.id);
    setState(() {
      _isLiked = prefs.getBool(key) ?? likedInDatabase;
    });
  }

  Future<void> _saveLikedStatus(bool isLiked) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'liked_${widget.product.id}';
    prefs.setBool(key, isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () async {
        final newLikedStatus = !_isLiked;
        setState(() {
          _isLiked = newLikedStatus;
          widget.onPressed(widget.product, _isLiked);
        });
        _saveLikedStatus(newLikedStatus);
      },
      child: Icon(
        Icons.favorite,
        color: _isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}
