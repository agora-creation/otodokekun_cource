import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/days.dart';
import 'package:otodokekun_cource/models/shop_course.dart';
import 'package:otodokekun_cource/models/shop_product.dart';
import 'package:otodokekun_cource/providers/app.dart';
import 'package:otodokekun_cource/providers/shop_course.dart';
import 'package:otodokekun_cource/providers/shop_product.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/order_course.dart';
import 'package:otodokekun_cource/widgets/course_days_list_tile.dart';
import 'package:otodokekun_cource/widgets/course_list_tile.dart';
import 'package:otodokekun_cource/widgets/product_list_tile.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  final AppProvider appProvider;
  final UserProvider userProvider;

  OrderScreen({@required this.appProvider, @required this.userProvider});

  @override
  Widget build(BuildContext context) {
    final shopCourseProvider = Provider.of<ShopCourseProvider>(context)
      ..getCourses(shopId: userProvider.user?.shopId);
    final shopProductProvider = Provider.of<ShopProductProvider>(context)
      ..getProducts(shopId: userProvider.user?.shopId);
    return shopProductProvider.products.length > 0
        ? ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            children: [
              shopCourseProvider.courses.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: shopCourseProvider.courses.length,
                      itemBuilder: (_, index) {
                        ShopCourseModel _courses =
                            shopCourseProvider.courses[index];
                        return CourseListTile(
                          openedAt: DateFormat('MM月dd日')
                              .format(_courses.openedAt)
                              .toString(),
                          closedAt: DateFormat('MM月dd日')
                              .format(_courses.closedAt)
                              .toString(),
                          name: _courses.name,
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              separatorBuilder: (_, index2) =>
                                  Divider(color: kSubColor),
                              itemCount: _courses.days.length,
                              itemBuilder: (_, index2) {
                                DaysModel _products = _courses.days[index2];
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
                          onPressed: () {
                            shopCourseProvider.clearQuantity();
                            nextPage(
                                context, OrderCourseScreen(course: _courses));
                          },
                        );
                      },
                    )
                  : Container(),
              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: shopProductProvider.products.length,
                itemBuilder: (_, index) {
                  ShopProductModel _product =
                      shopProductProvider.products[index];
                  var contain = shopProductProvider.cart
                      .where((e) => e.id == _product.id);
                  return ProductListTile(
                    image: _product.image,
                    name: _product.name,
                    price: _product.price,
                    unit: _product.unit,
                    value: contain.isNotEmpty,
                    onChanged: (value) {
                      shopProductProvider.checkCart(product: _product);
                    },
                  );
                },
              ),
              SizedBox(height: 32.0),
            ],
          )
        : Center(child: Text('商品の登録がありません'));
  }
}
