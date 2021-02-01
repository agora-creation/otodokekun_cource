import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/days.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_course.dart';
import 'package:otodokekun_cource/models/shop_product.dart';
import 'package:otodokekun_cource/providers/shop_course.dart';
import 'package:otodokekun_cource/providers/shop_product.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/order_course.dart';
import 'package:otodokekun_cource/widgets/course_days_list_tile.dart';
import 'package:otodokekun_cource/widgets/course_list_tile.dart';
import 'package:otodokekun_cource/widgets/product_list_tile.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ShopModel _shop = userProvider.shop;
    final shopCourseProvider = Provider.of<ShopCourseProvider>(context);
    final shopProductProvider = Provider.of<ShopProductProvider>(context);
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      children: [
        FutureBuilder<List<ShopCourseModel>>(
          future: shopCourseProvider.getCourses(shopId: _shop?.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  ShopCourseModel _courses = snapshot.data[index];
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
                      nextPage(context, OrderCourseScreen(course: _courses));
                    },
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
        SizedBox(height: 8.0),
        FutureBuilder<List<ShopProductModel>>(
          future: shopProductProvider.getProducts(shopId: _shop?.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  ShopProductModel _product = snapshot.data[index];
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
              );
            } else {
              return Center(child: Text('商品の登録がありません'));
            }
          },
        ),
        SizedBox(height: 32.0),
      ],
    );
  }
}
