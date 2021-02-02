import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/widgets/border_round_button.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/history_details_list_tile.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:otodokekun_cource/widgets/quantity_change_button.dart';
import 'package:provider/provider.dart';

class HistoryDetailsScreen extends StatelessWidget {
  final ShopOrderModel order;

  HistoryDetailsScreen({@required this.order});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<HomeProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          FlatButton(
            onPressed: null,
            child: order.shipping
                ? Text(
                    '配達完了',
                    style: TextStyle(color: Colors.grey),
                  )
                : Text(
                    '配達待ち',
                    style: TextStyle(color: Colors.red),
                  ),
          ),
        ],
      ),
      body: appProvider.isLoading
          ? LoadingWidget()
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              children: [
                Text(
                  '注文日時 : ${DateFormat('yyyy年MM月dd日 HH:mm').format(order.createdAt).toString()}',
                ),
                SizedBox(height: 8.0),
                Text('注文金額 : ¥ ${order.totalPrice}'),
                SizedBox(height: 8.0),
                Text('お届け先 : 〒${order.zip} ${order.address}'),
                SizedBox(height: 8.0),
                Text(
                  'お届け日 : ${DateFormat('yyyy年MM月dd日').format(order.deliveryAt).toString()}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text('備考 : ${order.remarks}'),
                SizedBox(height: 8.0),
                Divider(),
                SizedBox(height: 8.0),
                Text('注文商品'),
                SizedBox(height: 8.0),
                shopOrderProvider.cart.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: shopOrderProvider.cart.length,
                        itemBuilder: (_, index) {
                          CartModel _cart = shopOrderProvider.cart[index];
                          return HistoryDetailsListTile(
                            image: _cart.image,
                            name: _cart.name,
                            price: _cart.price,
                            unit: _cart.unit,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: QuantityChangeButton(
                                unit: _cart.unit,
                                quantity: _cart.quantity,
                                removeOnPressed: order.shipping
                                    ? null
                                    : () {
                                        shopOrderProvider.removeQuantity(
                                          cartModel: _cart,
                                        );
                                      },
                                addOnPressed: order.shipping
                                    ? null
                                    : () {
                                        shopOrderProvider.addQuantity(
                                          cartModel: _cart,
                                        );
                                      },
                              ),
                            ),
                          );
                        },
                      )
                    : Center(child: Text('注文商品がありません')),
                SizedBox(height: 8.0),
                Divider(),
                SizedBox(height: 8.0),
                order.shipping
                    ? Container()
                    : FillRoundButton(
                        labelText: '数量を変更',
                        labelColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        onPressed: () {
                          appProvider.changeLoading();
                          shopOrderProvider.updateQuantity(order: order);
                          appProvider.changeLoading();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('注文数量を変更しました')),
                          );
                          Navigator.pop(context, true);
                        },
                      ),
                order.shipping
                    ? Container()
                    : BorderRoundButton(
                        labelText: 'キャンセル',
                        labelColor: Colors.blueGrey,
                        borderColor: Colors.blueGrey,
                        onPressed: () {
                          appProvider.changeLoading();
                          shopOrderProvider.deleteOrder(order: order);
                          appProvider.changeLoading();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('注文をキャンセルしました')),
                          );
                          Navigator.pop(context, true);
                        },
                      ),
                SizedBox(height: 16.0),
              ],
            ),
    );
  }
}
