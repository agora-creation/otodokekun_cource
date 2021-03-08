import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/notice.dart';
import 'package:otodokekun_cource/screens/order.dart';
import 'package:otodokekun_cource/screens/plan.dart';
import 'package:otodokekun_cource/screens/product.dart';
import 'package:otodokekun_cource/screens/settings.dart';
import 'package:otodokekun_cource/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    ShopModel _shop = userProvider.shop;
    UserModel _user = userProvider.user;
    final List<Widget> _tabs = [
      ProductScreen(
        homeProvider: homeProvider,
        shop: _shop,
        user: _user,
      ),
      PlanScreen(
        homeProvider: homeProvider,
        userProvider: userProvider,
        shop: _shop,
        user: _user,
      ),
      OrderScreen(
        shop: _shop,
        user: _user,
        shopOrderProvider: shopOrderProvider,
      ),
      SettingsScreen(
        homeProvider: homeProvider,
        userProvider: userProvider,
        shop: _shop,
        user: _user,
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
            label: '個別注文',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_in_ar),
            label: '定期注文',
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
      title: '${shop?.name}',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '住所',
            style: TextStyle(color: kSubColor, fontSize: 14.0),
          ),
          Text('〒${shop?.zip}'),
          Text('${shop?.address}'),
          Text('${shop?.tel}'),
          SizedBox(height: 4.0),
          Text(
            '担当者',
            style: TextStyle(color: kSubColor, fontSize: 14.0),
          ),
          Text('${user?.staff}'),
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
