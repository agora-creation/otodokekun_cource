import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/providers/app.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/history_details.dart';
import 'package:otodokekun_cource/widgets/history_list_tile.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  final AppProvider appProvider;
  final UserProvider userProvider;

  HistoryScreen({@required this.appProvider, @required this.userProvider});

  @override
  Widget build(BuildContext context) {
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context)
      ..getOrders(
          shopId: userProvider.user?.shopId, userId: userProvider.user?.id);
    return shopOrderProvider.orders.length > 0
        ? ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: shopOrderProvider.orders.length,
                itemBuilder: (_, index) {
                  ShopOrderModel _order = shopOrderProvider.orders[index];
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
              ),
              SizedBox(height: 32.0),
            ],
          )
        : Center(child: Text('注文履歴はありません'));
  }
}
