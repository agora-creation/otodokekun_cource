import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/address_change.dart';
import 'package:otodokekun_cource/widgets/address_list_tile.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/delivery_list_tile.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:otodokekun_cource/widgets/product_order_list_tile.dart';
import 'package:otodokekun_cource/widgets/quantity_change_button.dart';
import 'package:provider/provider.dart';

class OrderProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    UserModel _user = userProvider.user;
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('注文確認'),
      ),
      body: homeProvider.isLoading
          ? LoadingWidget()
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              children: [
                Text('注文内容'),
                SizedBox(height: 8.0),
                homeProvider.cart.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: homeProvider.cart.length,
                        itemBuilder: (_, index) {
                          CartModel _cart = homeProvider.cart[index];
                          return ProductOrderListTile(
                            name: _cart.name,
                            image: _cart.image,
                            unit: _cart.unit,
                            price: _cart.price,
                            onTap: () {
                              homeProvider.deleteCart(cartModel: _cart);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: QuantityChangeButton(
                                unit: _cart.unit,
                                quantity: _cart.quantity,
                                removeOnPressed: () {
                                  homeProvider.removeQuantity(cartModel: _cart);
                                },
                                addOnPressed: () {
                                  homeProvider.addQuantity(cartModel: _cart);
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : Center(child: Text('商品を選択してください')),
                SizedBox(height: 8.0),
                Divider(),
                SizedBox(height: 8.0),
                Text('注文者名'),
                SizedBox(height: 8.0),
                Center(child: Text(_user?.name ?? '')),
                SizedBox(height: 8.0),
                Text('お届け先'),
                SizedBox(height: 8.0),
                AddressListTile(
                  zip: _user?.zip ?? '',
                  address: _user?.address ?? '',
                  tel: _user?.tel ?? '',
                  onTap: () {
                    userProvider.clearController();
                    userProvider.zip.text = _user?.zip;
                    userProvider.address.text = _user?.address;
                    userProvider.tel.text = _user?.tel;
                    nextPage(context, AddressChangeScreen());
                  },
                ),
                SizedBox(height: 8.0),
                Text('お届け指定日'),
                SizedBox(height: 8.0),
                DeliveryListTile(
                  deliveryAt: DateFormat('yyyy年MM月dd日')
                      .format(shopOrderProvider.deliveryAt)
                      .toString(),
                  onTap: () async {
                    final DateTime now = DateTime.now();
                    final DateTime dateTime = await showDatePicker(
                      locale: const Locale('ja'),
                      context: context,
                      initialDate: shopOrderProvider.deliveryAt,
                      firstDate: now.add(Duration(days: 3)),
                      lastDate: now.add(Duration(days: 14)),
                    );
                    if (dateTime != null) {
                      shopOrderProvider.setDeliveryAt(dateTime: dateTime);
                    }
                  },
                ),
                SizedBox(height: 8.0),
                Text('備考欄'),
                SizedBox(height: 8.0),
                CustomTextField(
                  controller: shopOrderProvider.remarks,
                  obscureText: false,
                  textInputType: TextInputType.multiline,
                  maxLines: null,
                  labelText: 'ご要望など',
                  prefixIconData: Icons.message,
                  suffixIconData: null,
                  onTap: null,
                ),
                SizedBox(height: 8.0),
                Divider(),
                SizedBox(height: 8.0),
                FillRoundButton(
                  labelText: '注文する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onPressed: () {
                    if (homeProvider.cart.length > 0) {
                      homeProvider.changeLoading();
                      shopOrderProvider.createOrder(
                        shopId: _user.shopId,
                        userId: _user.id,
                        name: _user.name,
                        zip: _user.zip,
                        address: _user.address,
                        tel: _user.tel,
                        cart: homeProvider.cart,
                      );
                      shopOrderProvider.clearController();
                      homeProvider.cart.clear();
                      homeProvider.changeLoading();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('注文が完了しました')),
                      );
                      Navigator.pop(context, true);
                    }
                  },
                ),
                SizedBox(height: 24.0),
              ],
            ),
    );
  }
}
