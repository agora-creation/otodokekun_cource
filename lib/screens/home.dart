import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/history.dart';
import 'package:otodokekun_cource/screens/notice.dart';
import 'package:otodokekun_cource/screens/order.dart';
import 'package:otodokekun_cource/screens/order_product.dart';
import 'package:otodokekun_cource/screens/settings.dart';
import 'package:otodokekun_cource/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    ShopModel _shop = userProvider.shop;
    UserModel _user = userProvider.user;
    final List<Widget> _tabs = [
      OrderScreen(homeProvider: homeProvider, shop: _shop),
      HistoryScreen(homeProvider: homeProvider, shop: _shop, user: _user),
      SettingsScreen(homeProvider: homeProvider, userProvider: userProvider),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) {
                return CustomDialog(
                  title: _shop?.name ?? '',
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('〒${_shop?.zip}'),
                      Text('${_shop?.address}'),
                      Text('${_shop?.tel}'),
                      Text('担当者名 : ${_shop?.staff}'),
                    ],
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('閉じる'),
                    ),
                  ],
                );
              },
            );
          },
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
            icon: StreamBuilder<Icon>(
              stream: homeProvider.getNoticeRead(userId: _user?.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return snapshot.data;
                }
                return Icon(Icons.notifications_none);
              },
            ),
          ),
        ],
      ),
      body: _tabs[homeProvider.tabsIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          homeProvider.changeTabs(index);
        },
        currentIndex: homeProvider.tabsIndex,
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
          homeProvider.tabsIndex == 0 && homeProvider.cart.length > 0
              ? FloatingActionButton.extended(
                  onPressed: () {
                    nextPage(context, OrderProductScreen());
                  },
                  icon: Icon(Icons.check),
                  label: Text('選択した商品を注文する'),
                  backgroundColor: Colors.blueAccent.withOpacity(0.8),
                  elevation: 0.0,
                )
              : homeProvider.tabsIndex == 1
                  ? FloatingActionButton.extended(
                      onPressed: null,
                      icon: null,
                      label: Text(
                          '請求金額 : ¥ ${NumberFormat('#,###').format(homeProvider.totalPrice)}'),
                      backgroundColor: Colors.redAccent.withOpacity(0.8),
                      elevation: 0.0,
                    )
                  : Container(),
    );
  }
}
