import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
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
    final homeProvider = Provider.of<HomeProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: order.shipping ? Text('配達完了') : Text('配達待ち'),
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
                              removeOnPressed: () {
                                shopOrderProvider.removeQuantity(
                                    cartModel: _cart);
                              },
                              addOnPressed: () {
                                shopOrderProvider.addQuantity(cartModel: _cart);
                              },
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
                SizedBox(height: 16.0),
                Divider(height: 0.0),
                SizedBox(height: 16.0),
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
                SizedBox(height: 8.0),
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
                SizedBox(height: 40.0),
              ],
            ),
    );
  }
}
