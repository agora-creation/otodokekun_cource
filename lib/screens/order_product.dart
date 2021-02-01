import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/providers/app.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/providers/shop_product.dart';
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
    final appProvider = Provider.of<AppProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final shopProductProvider = Provider.of<ShopProductProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('注文確認'),
      ),
      body: appProvider.isLoading
          ? LoadingWidget()
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              children: [
                Text('選択した商品'),
                SizedBox(height: 8.0),
                shopProductProvider.cart.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: shopProductProvider.cart.length,
                        itemBuilder: (_, index) {
                          CartModel _cart = shopProductProvider.cart[index];
                          return ProductOrderListTile(
                            image: _cart.image,
                            name: _cart.name,
                            price: _cart.price,
                            unit: _cart.unit,
                            onTap: () {
                              shopProductProvider.deleteCart(cartModel: _cart);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: QuantityChangeButton(
                                unit: _cart.unit,
                                quantity: _cart.quantity,
                                removeOnPressed: () {
                                  shopProductProvider.removeQuantity(
                                    cartModel: _cart,
                                  );
                                },
                                addOnPressed: () {
                                  shopProductProvider.addQuantity(
                                    cartModel: _cart,
                                  );
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
                Center(child: Text(userProvider.user?.name ?? '')),
                SizedBox(height: 8.0),
                Text('お届け先'),
                SizedBox(height: 8.0),
                AddressListTile(
                  zip: userProvider.user?.zip ?? '',
                  address: userProvider.user?.address ?? '',
                  tel: userProvider.user?.tel ?? '',
                  onTap: () {
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
                  controller: null,
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
                    if (shopProductProvider.cart.length > 0) {
                      appProvider.changeLoading();
                      shopOrderProvider.createOrder(
                        shopId: userProvider.user.shopId,
                        userId: userProvider.user.id,
                        name: userProvider.user.name,
                        zip: userProvider.user.zip,
                        address: userProvider.user.address,
                        tel: userProvider.user.tel,
                        cart: shopProductProvider.cart,
                      );
                      shopOrderProvider.remarks = '';
                      shopProductProvider.cart.clear();
                      appProvider.changeLoading();
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
