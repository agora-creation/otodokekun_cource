import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/days.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_course.dart';
import 'package:otodokekun_cource/models/shop_product.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/screens/order_course.dart';
import 'package:otodokekun_cource/services/shop_course.dart';
import 'package:otodokekun_cource/services/shop_product.dart';
import 'package:otodokekun_cource/widgets/course_days_list_tile.dart';
import 'package:otodokekun_cource/widgets/course_list_tile.dart';
import 'package:otodokekun_cource/widgets/product_list_tile.dart';

class OrderScreen extends StatelessWidget {
  final HomeProvider homeProvider;
  final ShopModel shop;

  OrderScreen({
    @required this.homeProvider,
    @required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    final ShopCourseService shopCourseService = ShopCourseService();
    final ShopProductService shopProductService = ShopProductService();
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: shopCourseService.getCourses(shopId: shop?.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            List<ShopCourseModel> courses = [];
            for (DocumentSnapshot course in snapshot.data.docs) {
              courses.add(ShopCourseModel.fromSnapshot(course));
            }
            if (courses.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: courses.length,
                itemBuilder: (_, index) {
                  ShopCourseModel _courses = courses[index];
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
                      homeProvider.clearCourseQuantity();
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
        StreamBuilder<QuerySnapshot>(
          stream: shopProductService.getProducts(shopId: shop?.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('読み込み中'));
            }
            List<ShopProductModel> products = [];
            for (DocumentSnapshot product in snapshot.data.docs) {
              products.add(ShopProductModel.fromSnapshot(product));
            }
            if (products.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (_, index) {
                  ShopProductModel _product = products[index];
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
