import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/style.dart';
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
    final homeProvider = Provider.of<HomeProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(),
      ),
      body: homeProvider.isLoading
          ? LoadingWidget()
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              children: [
                Text(
                  '注文商品',
                  style: TextStyle(color: kSubColor),
                ),
                shopOrderProvider.tmpCart.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: shopOrderProvider.tmpCart.length,
                        itemBuilder: (_, index) {
                          CartModel _cart = shopOrderProvider.tmpCart[index];
                          return HistoryDetailsListTile(
                            name: _cart.name,
                            image: _cart.image,
                            unit: _cart.unit,
                            price: _cart.price,
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
                    : Container(),
                SizedBox(height: 8.0),
                Text(
                  '注文日時',
                  style: TextStyle(color: kSubColor),
                ),
                Text(
                  '${DateFormat('yyyy年MM月dd日 HH:mm').format(order.createdAt)}',
                ),
                SizedBox(height: 8.0),
                Text(
                  '合計金額',
                  style: TextStyle(color: kSubColor),
                ),
                Text('¥ ${order.totalPrice}'),
                SizedBox(height: 8.0),
                Text(
                  'お届け先',
                  style: TextStyle(color: kSubColor),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('〒 ${order.zip}'),
                    Text('${order.address}'),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  'お届け予定日',
                  style: TextStyle(color: kSubColor),
                ),
                Text(
                  '${DateFormat('yyyy年MM月dd日').format(order.deliveryAt)}',
                ),
                SizedBox(height: 8.0),
                Text(
                  '備考',
                  style: TextStyle(color: kSubColor),
                ),
                Text('${order.remarks}'),
                SizedBox(height: 8.0),
                Divider(),
                SizedBox(height: 8.0),
                order.shipping
                    ? Container()
                    : FillRoundButton(
                        labelText: '注文内容を変更',
                        labelColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        onPressed: () {
                          homeProvider.changeLoading();
                          shopOrderProvider.updateQuantity(order: order);
                          homeProvider.changeLoading();
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
                          homeProvider.changeLoading();
                          shopOrderProvider.delete(order: order);
                          homeProvider.changeLoading();
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
