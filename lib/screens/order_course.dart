import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/days.dart';
import 'package:otodokekun_cource/models/shop_course.dart';
import 'package:otodokekun_cource/providers/app.dart';
import 'package:otodokekun_cource/providers/shop_course.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/address_change.dart';
import 'package:otodokekun_cource/widgets/address_list_tile.dart';
import 'package:otodokekun_cource/widgets/course_days_list_tile.dart';
import 'package:otodokekun_cource/widgets/course_order_list_tile.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:otodokekun_cource/widgets/quantity_change_button.dart';
import 'package:provider/provider.dart';

class OrderCourseScreen extends StatelessWidget {
  final ShopCourseModel course;

  OrderCourseScreen({@required this.course});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final shopCourseProvider = Provider.of<ShopCourseProvider>(context);
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
                Text('注文コース'),
                SizedBox(height: 8.0),
                CourseOrderListTile(
                  openedAt:
                      DateFormat('MM月dd日').format(course.openedAt).toString(),
                  closedAt:
                      DateFormat('MM月dd日').format(course.closedAt).toString(),
                  name: course.name,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      separatorBuilder: (_, index) => Divider(color: kSubColor),
                      itemCount: course.days.length,
                      itemBuilder: (_, index) {
                        DaysModel _products = course.days[index];
                        return CourseDaysListTile(
                          deliveryAt: DateFormat('MM/dd')
                              .format(_products.deliveryAt)
                              .toString(),
                          image: _products.image,
                          name: _products.name,
                        );
                      },
                    ),
                  ],
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: QuantityChangeButton(
                      unit: 'セット',
                      quantity: shopCourseProvider.courseQuantity,
                      removeOnPressed: () {
                        shopCourseProvider.removeQuantity();
                      },
                      addOnPressed: () {
                        shopCourseProvider.addQuantity();
                      },
                    ),
                  ),
                ),
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
                    appProvider.changeLoading();
                    for (DaysModel product in course.days) {
                      List<CartModel> _cart = [];
                      Map _cartProduct = {
                        'id': product.id,
                        'name': product.name,
                        'image': product.image,
                        'unit': product.unit,
                        'price': product.price,
                        'quantity': shopCourseProvider.courseQuantity,
                        'totalPrice':
                            product.price * shopCourseProvider.courseQuantity,
                      };
                      CartModel _cartModel = CartModel.fromMap(_cartProduct);
                      _cart.add(_cartModel);
                      shopOrderProvider.createOrderCourse(
                        shopId: userProvider.user.shopId,
                        userId: userProvider.user.id,
                        name: userProvider.user.name,
                        zip: userProvider.user.zip,
                        address: userProvider.user.address,
                        tel: userProvider.user.tel,
                        cart: _cart,
                        deliveryAt: product.deliveryAt,
                        remarks: shopOrderProvider.remarks,
                      );
                    }
                    shopOrderProvider.remarks = '';
                    shopCourseProvider.clearQuantity();
                    appProvider.changeLoading();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('注文が完了しました')),
                    );
                    Navigator.pop(context, true);
                  },
                ),
                SizedBox(height: 24.0),
              ],
            ),
    );
  }
}
