import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/screens/history_details.dart';
import 'package:otodokekun_cource/widgets/history_list_tile.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  final HomeProvider homeProvider;
  final ShopModel shop;
  final UserModel user;

  HistoryScreen({
    @required this.homeProvider,
    @required this.shop,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      children: [
        StreamBuilder<List<ShopOrderModel>>(
          stream:
              shopOrderProvider.getOrders(shopId: shop?.id, userId: user?.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.data.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  ShopOrderModel _order = snapshot.data[index];
                  return HistoryListTile(
                    cart: _order.cart,
                    deliveryAt: DateFormat('yyyy年MM月dd日')
                        .format(_order.deliveryAt)
                        .toString(),
                    shipping: _order.shipping,
                    onTap: () {
                      shopOrderProvider.getCart(order: _order);
                      nextPage(
                        context,
                        HistoryDetailsScreen(order: _order),
                      );
                    },
                  );
                },
              );
            }
            return Center(child: Text('注文履歴はありません'));
          },
        ),
        SizedBox(height: 32.0),
      ],
    );
  }
}
