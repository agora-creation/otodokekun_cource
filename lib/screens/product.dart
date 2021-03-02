import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_product.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/screens/product_cart.dart';
import 'package:otodokekun_cource/widgets/custom_product_list_tile.dart';
import 'package:otodokekun_cource/widgets/label.dart';
import 'package:otodokekun_cource/widgets/remarks.dart';

class ProductScreen extends StatelessWidget {
  final HomeProvider homeProvider;
  final ShopModel shop;
  final UserModel user;

  ProductScreen({
    @required this.homeProvider,
    @required this.shop,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> streamProduct = FirebaseFirestore.instance
        .collection('shop')
        .doc(shop?.id)
        .collection('product')
        .where('published', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      children: [
        RemarksWidget(remarks: shop?.remarks ?? ''),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelWidget(iconData: Icons.view_in_ar, labelText: '個別注文'),
            TextButton(
              onPressed: () {
                if (homeProvider.cart.length > 0) {
                  homeProvider.deliveryAt =
                      DateTime.now().add(Duration(days: shop.cancelLimit));
                  nextPage(context, ProductCartScreen(shop: shop, user: user));
                }
              },
              child: Text('注文する', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
          ],
        ),
        SizedBox(height: 4.0),
        StreamBuilder<QuerySnapshot>(
          stream: streamProduct,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('読み込み中'));
            }
            List<ShopProductModel> products = [];
            for (DocumentSnapshot product in snapshot.data.docs) {
              products.add(ShopProductModel.fromSnapshot(product));
            }
            if (products.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (_, index) {
                  ShopProductModel _product = products[index];
                  var contain =
                      homeProvider.cart.where((e) => e.id == _product.id);
                  return CustomProductListTile(
                    name: _product.name,
                    image: _product.image,
                    unit: _product.unit,
                    price: _product.price,
                    description: _product.description,
                    value: contain.isNotEmpty,
                    onChanged: (value) {
                      homeProvider.checkCart(product: _product);
                    },
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
        SizedBox(height: 40.0),
      ],
    );
  }
}
