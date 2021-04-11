import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/widgets/border_round_button.dart';
import 'package:otodokekun_cource/widgets/custom_cart_list_tile.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:otodokekun_cource/widgets/quantity_button.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final ShopOrderModel order;

  OrderDetailsScreen({@required this.order});

  @override
  Widget build(BuildContext context) {
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    ShopModel _shop = userProvider.shop;
    bool _cancelLimit = false;
    var diff = order.deliveryAt.difference(DateTime.now());
    if (diff.inDays < _shop.cancelLimit) {
      _cancelLimit = true;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: order.shipping
            ? Text('配達完了')
            : Text('配達待ち', style: TextStyle(color: Colors.redAccent)),
      ),
      body: shopOrderProvider.isLoading
          ? LoadingWidget()
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              children: [
                Text('注文商品', style: TextStyle(color: kSubColor)),
                shopOrderProvider.cart.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: shopOrderProvider.cart.length,
                        itemBuilder: (_, index) {
                          CartModel _cart = shopOrderProvider.cart[index];
                          return CustomCartListTile(
                            name: _cart.name,
                            image: _cart.image,
                            unit: _cart.unit,
                            price: _cart.price,
                            onTap: null,
                            child: QuantityButton(
                              unit: _cart.unit,
                              quantity: _cart.quantity,
                              removeOnPressed: order.shipping || _cancelLimit
                                  ? null
                                  : () =>
                                      shopOrderProvider.removeQuantity(_cart),
                              addOnPressed: order.shipping || _cancelLimit
                                  ? null
                                  : () => shopOrderProvider.addQuantity(_cart),
                            ),
                          );
                        },
                      )
                    : Container(),
                SizedBox(height: 8.0),
                Text('注文日時', style: TextStyle(color: kSubColor)),
                Text(
                    '${DateFormat('yyyy年MM月dd日 HH:mm').format(order.createdAt)}'),
                SizedBox(height: 8.0),
                Text('合計金額', style: TextStyle(color: kSubColor)),
                Text('¥ ${order.totalPrice}'),
                SizedBox(height: 8.0),
                Text('お届け先', style: TextStyle(color: kSubColor)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('〒${order.userZip}'),
                    Text('${order.userAddress}'),
                    Text('${order.userTel}'),
                  ],
                ),
                SizedBox(height: 8.0),
                Text('お届け日', style: TextStyle(color: kSubColor)),
                Text('${DateFormat('yyyy年MM月dd日').format(order.deliveryAt)}'),
                SizedBox(height: 8.0),
                Text('備考', style: TextStyle(color: kSubColor)),
                Text('${order.remarks}'),
                SizedBox(height: 16.0),
                Divider(height: 0.0),
                SizedBox(height: 16.0),
                order.shipping || _cancelLimit
                    ? Container()
                    : FillRoundButton(
                        labelText: '注文内容を変更',
                        labelColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        onPressed: () {
                          shopOrderProvider.changeLoading();
                          shopOrderProvider.updateQuantity(order: order);
                          shopOrderProvider.changeLoading();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('注文内容を変更しました')),
                          );
                          Navigator.pop(context);
                        },
                      ),
                SizedBox(height: 8.0),
                order.shipping || _cancelLimit
                    ? Container()
                    : BorderRoundButton(
                        labelText: 'キャンセル',
                        labelColor: Colors.blueGrey,
                        borderColor: Colors.blueGrey,
                        onPressed: () {
                          shopOrderProvider.changeLoading();
                          shopOrderProvider.delete(order: order);
                          shopOrderProvider.changeLoading();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('注文をキャンセルしました')),
                          );
                          Navigator.pop(context);
                        },
                      ),
                SizedBox(height: 40.0),
              ],
            ),
    );
  }
}
