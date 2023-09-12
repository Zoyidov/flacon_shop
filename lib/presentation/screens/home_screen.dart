import 'package:cached_network_image/cached_network_image.dart';
import 'package:flacon_shop/presentation/screens/selected_product.dart';
import 'package:flacon_shop/presentation/screens/widgets/category_selector.dart';
import 'package:flacon_shop/presentation/screens/widgets/like_button.dart';
import 'package:flacon_shop/presentation/screens/widgets/shimmer.dart';
import 'package:flacon_shop/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../data/db/db.dart';
import '../../data/model/product_model.dart';
import '../../data/model/rating_model.dart';
import '../../data/repository/category_repo.dart';
import '../../data/repository/product_repository.dart';
import '../../widgets/circles.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.productRepo,
    required this.categoryRepo,
  }) : super(key: key);

  final ProductRepo productRepo;
  final CategoryRepo categoryRepo;


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedPopupMenuValue = 'All';
  String activeCategoryName = "";
  List<ProductModel> products = [];
  List<String> categories = [];
  TextEditingController limitController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _init();
  }

  _init() async {
    categories = await widget.categoryRepo.getAllCategories();
    _updateProducts();
  }

  _updateProducts() async {
    if(mounted){
      setState(() {
        isLoading = true;
      });
    }
    products =
        await widget.productRepo.getProductsByCategory(activeCategoryName);
    if(mounted){
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showLimitDialog() {
    showDialog(
      barrierColor: AppColors.baseDark,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Limit'),
          content: TextField(
            controller: limitController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter a limit',
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.baseDark),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _limitedData(limitController.text);
              },
            ),
          ],
        );
      },
    );
  }

  _limitedData(String limit) async {
    setState(() {
      isLoading = true;
    });
    products = await widget.productRepo.getProductsByLimit(int.parse(limit));
    setState(() {
      isLoading = false;
    });
  }

  _getSortAZ() async {
    setState(() {
      isLoading = true;
    });
    products = await widget.productRepo.getSortedProducts("ASC");
    setState(() {
      isLoading = false;
    });
  }

  _getSortZA() async {
    setState(() {
      isLoading = true;
    });
    products = await widget.productRepo.getSortedProducts("desc");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.baseDark,
        title: const Text("Products"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              size: 30,
            ),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  onTap: () {
                    setState(() {
                      _getSortAZ();
                    });
                  },
                  value: 'Sort',
                  child: const Text('Sort Up'),
                ),
                PopupMenuItem<String>(
                  onTap: () {
                    setState(() {
                      _getSortZA();
                    });
                  },
                  value: 'Sort',
                  child: const Text('Sort Down'),
                ),
                const PopupMenuItem<String>(
                  value: 'Limit',
                  child: Text('Give Limit to Products'),
                ),
              ];
            },
            onSelected: (value) {
              setState(() {
                selectedPopupMenuValue = value;
                if (value == 'Limit') {
                  _showLimitDialog();
                } else if (value == 'Sort') {
                  // Handle sorting
                }
              });
            },
          ),
        ],
      ),
      body: _buildBody(),
      backgroundColor: AppColors.baseDark,
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const ShimmerScreen();
    } else if (products.isEmpty) {
      return const Center(
        child: Text(
          'Data is empty!',
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return Stack(
        children: [
          const Circles(),
          Column(
            children: [
              _buildCategorySelector(),
              const SizedBox(height: 15),
              Expanded(
                child: _buildProductGrid(),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildCategorySelector() {
    return categories.isNotEmpty
        ? CategorySelector(
            categories: categories,
            onCategorySelected: (selectedCategory) {
              activeCategoryName = selectedCategory;
              _updateProducts();
            },
          )
        : const Center(
            child: CupertinoActivityIndicator(
              color: Colors.white,
            ),
          );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        ProductModel product = products[index];
        final item = product;
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: ZoomTapAnimation(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(model: item),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12.0),
                      ),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CupertinoActivityIndicator(
                            color: Colors.black,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.no_photography_rounded,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          product.category,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.monetization_on_outlined),
                                Text(
                                  " ${product.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            LikedButton(
                              product: ProductModel(
                                id: product.id,
                                title: product.title,
                                price: product.price,
                                description: product.description,
                                category: product.category,
                                image: product.image,
                                rating: RatingModel(rate: product.rating.rate, count: 765),
                              ),
                              onPressed: (product, isLiked) async {
                                final dbHelper = DatabaseHelper();
                                if (isLiked) {
                                  await dbHelper.insertLikedProduct({
                                    'productId': product.id,
                                    'title': product.title,
                                    'price': product.price,
                                    'description': product.description,
                                    'category': product.category,
                                    'image': product.image,
                                  });
                                } else {
                                  await dbHelper.deleteLikedProduct(product.id);
                                }
                              },
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
    );
  }
}
