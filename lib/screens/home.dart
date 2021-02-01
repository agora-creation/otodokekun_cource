import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/app.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/providers/shop_product.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/providers/user_notice.dart';
import 'package:otodokekun_cource/screens/history.dart';
import 'package:otodokekun_cource/screens/notice.dart';
import 'package:otodokekun_cource/screens/order.dart';
import 'package:otodokekun_cource/screens/order_product.dart';
import 'package:otodokekun_cource/screens/settings.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    ShopModel _shop = userProvider.shop;
    UserModel _user = userProvider.user;
    final userNoticeProvider = Provider.of<UserNoticeProvider>(context);
    final shopProductProvider = Provider.of<ShopProductProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    final List<Widget> _tabsList = [
      OrderScreen(),
      HistoryScreen(),
      SettingsScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: GestureDetector(
          onTap: () {},
          child: Text(_shop?.name ?? ''),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                expand: true,
                context: context,
                builder: (context) => NoticeScreen(),
              );
            },
            icon: FutureBuilder<Icon>(
              future: userNoticeProvider.getNoticeRead(userId: _user?.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data;
                } else {
                  return Icon(Icons.notifications_none);
                }
              },
            ),
          ),
        ],
      ),
      body: _tabsList[appProvider.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          appProvider.changeTabs(index);
        },
        currentIndex: appProvider.selectedIndex,
        fixedColor: kMainColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: '注文',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: '履歴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: _user?.name ?? '',
          ),
        ],
      ),
      floatingActionButton:
          appProvider.selectedIndex == 0 && shopProductProvider.cart.length > 0
              ? FloatingActionButton.extended(
                  onPressed: () {
                    nextPage(context, OrderProductScreen());
                  },
                  icon: Icon(Icons.check),
                  label: Text('選択した商品を注文する'),
                  backgroundColor: Colors.blueAccent.withOpacity(0.8),
                  elevation: 0.0,
                )
              : appProvider.selectedIndex == 1
                  ? FloatingActionButton.extended(
                      onPressed: null,
                      icon: null,
                      label: Text(
                          '請求金額 : ¥ ${NumberFormat('#,###').format(shopOrderProvider.totalPrice)}'),
                      backgroundColor: Colors.redAccent.withOpacity(0.8),
                      elevation: 0.0,
                    )
                  : Container(),
    );
  }
}
