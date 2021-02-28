import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_product.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/widgets/product_list_tile.dart';
import 'package:otodokekun_cource/widgets/remarks.dart';

class OrderScreen extends StatelessWidget {
  final HomeProvider homeProvider;
  final ShopModel shop;

  OrderScreen({
    @required this.homeProvider,
    @required this.shop,
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
          children: [
            Icon(Icons.view_in_ar),
            SizedBox(width: 4.0),
            Text('注文する'),
          ],
        ),
        SizedBox(height: 8.0),
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
                  return ProductListTile(
                    name: _product.name,
                    image: _product.image,
                    unit: _product.unit,
                    price: _product.price,
                    value: contain.isNotEmpty,
                    onChanged: (value) {
                      homeProvider.checkCart(product: _product);
                    },
                  );
                },
              );
            } else {
              return Center(child: Text('商品の登録がありません'));
            }
          },
        ),
        SizedBox(height: 32.0),
      ],
    );
  }
}
