import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/user.dart';
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

class ProductOrderScreen extends StatefulWidget {
  @override
  _ProductOrderScreenState createState() => _ProductOrderScreenState();
}

class _ProductOrderScreenState extends State<ProductOrderScreen> {
  bool _isTerms = false;

  @override
  Widget build(BuildContext context) {
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    ShopModel _shop = userProvider.shop;
    UserModel _user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('注文確認'),
      ),
      body: shopOrderProvider.isLoading
          ? LoadingWidget()
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                            onTap: () => shopOrderProvider.deleteCart(_cart),
                            child: QuantityButton(
                              unit: _cart.unit,
                              quantity: _cart.quantity,
                              removeOnPressed: () =>
                                  shopOrderProvider.removeQuantity(_cart),
                              addOnPressed: () =>
                                  shopOrderProvider.addQuantity(_cart),
                            ),
                          );
                        },
                      )
                    : Container(),
                SizedBox(height: 8.0),
                Text('注文者名', style: TextStyle(color: kSubColor)),
                Text(_user?.name ?? ''),
                SizedBox(height: 8.0),
                Text('お届け先', style: TextStyle(color: kSubColor)),
                AddressWidget(
                  zip: _user?.zip ?? '',
                  address: _user?.address ?? '',
                  tel: _user?.tel ?? '',
                  onTap: () {
                    userProvider.clearController();
                    userProvider.zip.text = _user?.zip;
                    userProvider.address.text = _user?.address;
                    userProvider.tel.text = _user?.tel;
                    nextPage(context, UserAddressScreen());
                  },
                ),
                SizedBox(height: 8.0),
                Text('お届け日', style: TextStyle(color: kSubColor)),
                DeliveryWidget(
                  deliveryAt:
                      '${DateFormat('yyyy年MM月dd日').format(shopOrderProvider.deliveryAt)}',
                  onTap: () async {
                    var selected = await showDatePicker(
                      locale: const Locale('ja'),
                      context: context,
                      initialDate: shopOrderProvider.deliveryAt,
                      firstDate:
                          DateTime.now().add(Duration(days: _shop.cancelLimit)),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (selected != null) {
                      shopOrderProvider.setDeliveryAt(selected);
                    }
                  },
                ),
                SizedBox(height: 8.0),
                Text('備考', style: TextStyle(color: kSubColor)),
                CustomTextField(
                  controller: shopOrderProvider.remarks,
                  obscureText: false,
                  textInputType: TextInputType.multiline,
                  maxLines: null,
                  labelText: 'ご要望など',
                  prefixIconData: Icons.short_text,
                  suffixIconData: null,
                  onTap: null,
                ),
                SizedBox(height: 24.0),
                Divider(height: 0.0, color: Colors.black),
                Container(
                  height: 200.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text('${_shop?.terms}'),
                  ),
                ),
                Divider(height: 0.0, color: Colors.black),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: Colors.blueAccent,
                      value: _isTerms,
                      onChanged: (value) {
                        setState(() => _isTerms = value);
                      },
                    ),
                    Text(
                      '利用規約に同意する',
                      style: TextStyle(color: Colors.black54, fontSize: 16.0),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Divider(height: 0.0),
                SizedBox(height: 16.0),
                FillRoundButton(
                  labelText: '注文する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onPressed: () {
                    if (!_isTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('利用規約に同意してください')),
                      );
                      return;
                    }
                    if (shopOrderProvider.cart.length > 0) {
                      shopOrderProvider.changeLoading();
                      shopOrderProvider.create(
                        user: _user,
                        cart: shopOrderProvider.cart,
                      );
                      shopOrderProvider.clearController();
                      shopOrderProvider.cart.clear();
                      shopOrderProvider.changeLoading();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('注文が完了しました')),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
                SizedBox(height: 40.0),
              ],
            ),
    );
  }
}
