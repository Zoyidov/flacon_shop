
import 'package:flacon_shop/data/model/rating_model.dart';

class ProductModel {
  int id;
  String title;
  num price;
  String description;
  String category;
  String image;
  RatingModel rating;
  bool isLiked;
  bool isInCart;



  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    this.isLiked = false,
    this.isInCart = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModel(
        id: json["id"],
        title: json["title"] ?? '',
        price: json["price"]?.toDouble() ?? 0.0,
        description: json["description"] ?? '',
        category: json["category"] ?? '',
        image: json["image"] ?? '',
        rating: json["rating"] != null
            ? RatingModel.fromJson(json["rating"])
            : RatingModel(
          rate: 0,
          count: 0,
        ),
      );

  Map<String, dynamic> toJson() =>
      {
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": image,
      };
}