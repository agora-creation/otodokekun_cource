import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/days.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_course.dart';
import 'package:otodokekun_cource/models/shop_product.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/shop_course.dart';
import 'package:otodokekun_cource/providers/shop_product.dart';
import 'package:otodokekun_cource/screens/order_course.dart';
import 'package:otodokekun_cource/widgets/course_days_list_tile.dart';
import 'package:otodokekun_cource/widgets/course_list_tile.dart';
import 'package:otodokekun_cource/widgets/product_list_tile.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  final HomeProvider homeProvider;
  final ShopModel shop;

  OrderScreen({
    @required this.homeProvider,
    @required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    final shopCourseProvider = Provider.of<ShopCourseProvider>(context);
    final shopProductProvider = Provider.of<ShopProductProvider>(context);
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      children: [
        StreamBuilder<List<ShopCourseModel>>(
          stream: shopCourseProvider.getCourses(shopId: shop?.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active &&
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
                          DaysModel _days = _courses.days[index2];
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
                    onPressed: () {
                      shopCourseProvider.clearQuantity();
                      nextPage(context, OrderCourseScreen(course: _courses));
                    },
                  );
                },
              );
            }
            return Container();
          },
        ),
        SizedBox(height: 8.0),
        StreamBuilder<List<ShopProductModel>>(
          stream: shopProductProvider.getProducts(shopId: shop?.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.data.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  ShopProductModel _product = snapshot.data[index];
                  var contain =
                      homeProvider.cart.where((e) => e.id == _product.id);
                  return ProductListTile(
                    name: _product.name,
                    image: _product.image,
                    unit: _product.unit,
                    price: _product.price,
                    value: contain.isNotEmpty,
                    onChanged: (value) {
                      homeProvider.checkCart(product: _product);
                    },
                  );
                },
              );
            }
            return Center(child: Text('商品の登録がありません'));
          },
        ),
        SizedBox(height: 32.0),
      ],
    );
  }
}
