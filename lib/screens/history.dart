import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/screens/history_details.dart';
import 'package:otodokekun_cource/widgets/custom_order_list_tile.dart';
import 'package:otodokekun_cource/widgets/remarks.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  final ShopModel shop;
  final UserModel user;

  HistoryScreen({
    @required this.shop,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    final Stream<QuerySnapshot> streamOrder = FirebaseFirestore.instance
        .collection('shop')
        .doc(shop?.id)
        .collection('order')
        .where('userId', isEqualTo: user?.id)
        .orderBy('deliveryAt', descending: true)
        .snapshots();

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      children: [
        RemarksWidget(remarks: shop?.remarks ?? ''),
        Row(
          children: [
            Icon(Icons.list_alt),
            SizedBox(width: 4.0),
            Text('注文履歴'),
          ],
        ),
        SizedBox(height: 8.0),
        StreamBuilder<QuerySnapshot>(
          stream: streamOrder,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('読み込み中'));
            }
            List<ShopOrderModel> orders = [];
            for (DocumentSnapshot order in snapshot.data.docs) {
              orders.add(ShopOrderModel.fromSnapshot(order));
            }
            if (orders.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (_, index) {
                  ShopOrderModel _order = orders[index];
                  return CustomOrderListTile(
                    deliveryAt: DateFormat('MM/dd').format(_order.deliveryAt),
                    name: _order.cart[0].name,
                    shipping: _order.shipping,
                    onTap: () {
                      shopOrderProvider.setTmpCart(order: _order);
                      nextPage(context, HistoryDetailsScreen(order: _order));
                    },
                  );
                },
              );
            } else {
              return Center(child: Text('注文履歴はありません'));
            }
          },
        ),
        SizedBox(height: 32.0),
      ],
    );
  }
}
