import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/cart.dart';
import 'package:otodokekun_cource/models/days.dart';
import 'package:otodokekun_cource/models/shop_course.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/home.dart';
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
                        DaysModel _days = course.days[index];
                        return CourseDaysListTile(
                          deliveryAt: DateFormat('MM/dd')
                              .format(_days.deliveryAt)
                              .toString(),
                          name: _days.name,
                          image: _days.image,
                        );
                      },
                    ),
                  ],
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: QuantityChangeButton(
                      unit: 'セット',
                      quantity: homeProvider.courseQuantity,
                      removeOnPressed: () {
                        homeProvider.removeCourseQuantity();
                      },
                      addOnPressed: () {
                        homeProvider.addCourseQuantity();
                      },
                    ),
                  ),
                ),
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
                    homeProvider.changeLoading();
                    for (DaysModel days in course.days) {
                      List<CartModel> _cart = [];
                      if (days.id != null) {
                        Map _cartProduct = {
                          'id': days.id,
                          'name': days.name,
                          'image': days.image,
                          'unit': days.unit,
                          'price': days.price,
                          'quantity': homeProvider.courseQuantity,
                          'totalPrice':
                              days.price * homeProvider.courseQuantity,
                        };
                        CartModel _cartModel = CartModel.fromMap(_cartProduct);
                        _cart.add(_cartModel);
                      }
                      shopOrderProvider.createOrderCourse(
                        shopId: _user.shopId,
                        userId: _user.id,
                        name: _user.name,
                        zip: _user.zip,
                        address: _user.address,
                        tel: _user.tel,
                        cart: _cart,
                        deliveryAt: days.deliveryAt,
                      );
                    }
                    shopOrderProvider.clearController();
                    homeProvider.clearCourseQuantity();
                    homeProvider.changeLoading();
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
