import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      HistoryScreen(shop: _shop, user: _user),
      SettingsScreen(
        homeProvider: homeProvider,
        userProvider: userProvider,
        shop: _shop,
      ),
    ];
    final Stream<QuerySnapshot> streamNotice = FirebaseFirestore.instance
        .collection('user')
        .doc(_user?.id)
        .collection('notice')
        .where('read', isEqualTo: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) {
                return ShopDialog(shop: _shop, user: _user);
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
            icon: StreamBuilder<QuerySnapshot>(
              stream: streamNotice,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Icon(Icons.notifications_off_outlined);
                }
                List<DocumentSnapshot> docs = snapshot.data.docs;
                if (docs.length == 0) {
                  return Icon(Icons.notifications_none);
                } else {
                  return Icon(
                    Icons.notifications_active,
                    color: Colors.redAccent,
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: _tabs[homeProvider.tabsIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => homeProvider.changeTabs(index),
        currentIndex: homeProvider.tabsIndex,
        fixedColor: kMainColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_in_ar),
            label: '注文する',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: '注文履歴',
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
                  onPressed: () => nextPage(context, OrderProductScreen()),
                  icon: Icon(Icons.check),
                  label: Text('選択した商品を注文する'),
                  backgroundColor: Colors.blueAccent.withOpacity(0.8),
                  elevation: 0.0,
                )
              : homeProvider.tabsIndex == 1
                  ? FloatingActionButton.extended(
                      onPressed: null,
                      icon: null,
                      label: Text('請求金額を見る'),
                      backgroundColor: Colors.redAccent.withOpacity(0.8),
                      elevation: 0.0,
                    )
                  : Container(),
    );
  }
}

class ShopDialog extends StatelessWidget {
  final ShopModel shop;
  final UserModel user;

  ShopDialog({
    @required this.shop,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: shop?.name ?? '',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('〒${shop?.zip}'),
          Text('${shop?.address}'),
          Text('${shop?.tel}'),
          Text('担当者 : ${user?.staff}'),
          SizedBox(height: 8.0),
          Text('キャンセルは${shop?.cancelLimit}前まで'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('閉じる'),
        ),
      ],
    );
  }
}
