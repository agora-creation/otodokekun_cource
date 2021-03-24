import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/products.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/user_address.dart';
import 'package:otodokekun_cource/widgets/address.dart';
import 'package:otodokekun_cource/widgets/custom_products_list_tile.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/delivery.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:otodokekun_cource/widgets/quantity_button.dart';
import 'package:provider/provider.dart';

class ProductOrderScreen extends StatelessWidget {
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
                shopOrderProvider.products.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: shopOrderProvider.products.length,
                        itemBuilder: (_, index) {
                          ProductsModel _products =
                              shopOrderProvider.products[index];
                          return CustomProductsListTile(
                            name: _products.name,
                            image: _products.image,
                            unit: _products.unit,
                            price: _products.price,
                            onTap: () {
                              shopOrderProvider.deleteProducts(_products);
                            },
                            child: QuantityButton(
                              unit: _products.unit,
                              quantity: _products.quantity,
                              removeOnPressed: () {
                                shopOrderProvider.removeQuantity(_products);
                              },
                              addOnPressed: () {
                                shopOrderProvider.addQuantity(_products);
                              },
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
                Text('お届け指定日', style: TextStyle(color: kSubColor)),
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
                    if (shopOrderProvider.products.length > 0) {
                      shopOrderProvider.changeLoading();
                      shopOrderProvider.create(
                        user: _user,
                        products: shopOrderProvider.products,
                      );
                      shopOrderProvider.clearController();
                      shopOrderProvider.products.clear();
                      shopOrderProvider.changeLoading();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('注文が完了しました')),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
    );
  }
}