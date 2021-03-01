import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/user_address.dart';
import 'package:otodokekun_cource/widgets/address.dart';
import 'package:otodokekun_cource/widgets/custom_cart_list_tile.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/delivery.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:otodokekun_cource/widgets/quantity_button.dart';
import 'package:provider/provider.dart';

class ProductCartScreen extends StatelessWidget {
  final ShopModel shop;
  final UserModel user;

  ProductCartScreen({
    @required this.shop,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('注文確認'),
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
                            onTap: () {
                              shopOrderProvider.deleteCart(cartModel: _cart);
                            },
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
                  '注文者名',
                  style: TextStyle(color: kSubColor),
                ),
                Text(shopOrderProvider.name),
                SizedBox(height: 8.0),
                Text(
                  'お届け先',
                  style: TextStyle(color: kSubColor),
                ),
                AddressWidget(
                  zip: shopOrderProvider.zip,
                  address: shopOrderProvider.address,
                  tel: shopOrderProvider.tel,
                  onTap: () {
                    userProvider.clearController();
                    userProvider.zip.text = user?.zip;
                    userProvider.address.text = user?.address;
                    userProvider.tel.text = user?.tel;
                    nextPage(context, UserAddressScreen());
                  },
                ),
                SizedBox(height: 8.0),
                Text(
                  'お届け指定日',
                  style: TextStyle(color: kSubColor),
                ),
                DeliveryWidget(
                  deliveryAt:
                      '${DateFormat('yyyy年MM月dd日').format(shopOrderProvider.deliveryAt)}',
                  onTap: () async {
                    var selected = await showDatePicker(
                      locale: const Locale('ja'),
                      context: context,
                      initialDate: shopOrderProvider.deliveryAt,
                      firstDate: DateTime.now().add(Duration(days: 3)),
                      lastDate: DateTime.now().add(Duration(days: 14)),
                    );
                    if (selected != null) {
                      shopOrderProvider.setDeliveryAt(selected);
                    }
                  },
                ),
                SizedBox(height: 8.0),
                Text(
                  '備考',
                  style: TextStyle(color: kSubColor),
                ),
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
                SizedBox(height: 16.0),
                Divider(height: 0.0),
                SizedBox(height: 16.0),
                FillRoundButton(
                  labelText: '注文する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onPressed: () {
                    if (shopOrderProvider.cart.length > 0) {
                      homeProvider.changeLoading();
                      shopOrderProvider.create(
                        shopId: user.shopId,
                        userId: user.id,
                      );
                      shopOrderProvider.clearController();
                      shopOrderProvider.cart.clear();
                      homeProvider.changeLoading();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('注文が完了しました')),
                      );
                      Navigator.pop(context, true);
                    }
                  },
                ),
                SizedBox(height: 40.0),
              ],
            ),
    );
  }
}
