import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/notice.dart';
import 'package:otodokekun_cource/screens/order.dart';
import 'package:otodokekun_cource/screens/product.dart';
import 'package:otodokekun_cource/screens/product_regular.dart';
import 'package:otodokekun_cource/screens/settings.dart';
import 'package:otodokekun_cource/screens/tmp.dart';
import 'package:otodokekun_cource/widgets/custom_app_title.dart';
import 'package:otodokekun_cource/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabsIndex = 1;

  @override
  Widget build(BuildContext context) {
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    ShopModel _shop = userProvider.shop;
    UserModel _user = userProvider.user;
    final List<Widget> _tabs = [
      ProductScreen(
        shopOrderProvider: shopOrderProvider,
        shop: _shop,
        user: _user,
      ),
      ProductRegularScreen(
          userProvider: userProvider, shop: _shop, user: _user),
      OrderScreen(
        shopOrderProvider: shopOrderProvider,
        shop: _shop,
        user: _user,
      ),
      SettingsScreen(userProvider: userProvider, shop: _shop, user: _user),
    ];
    final Stream<QuerySnapshot> streamNotice = FirebaseFirestore.instance
        .collection('user')
        .doc(_user?.id)
        .collection('notice')
        .where('read', isEqualTo: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomAppTitle(
          onTap: () {
            userProvider.shopId = _user?.shopId;
            overlayPage(context, TmpScreen());
          },
          title: _shop?.name ?? '店舗を選択してください',
        ),
        actions: [
          _shop != null
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => ShopDialog(shop: _shop),
                    );
                  },
                  icon: Icon(Icons.store_outlined),
                )
              : Container(),
          _shop != null
              ? IconButton(
                  onPressed: () => overlayPage(context, NoticeScreen()),
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
                )
              : Container(),
        ],
      ),
      body: _tabs[_tabsIndex],
      bottomNavigationBar: Container(
        decoration: kNavigationDecoration,
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() => _tabsIndex = index);
          },
          currentIndex: _tabsIndex,
          backgroundColor: Colors.white,
          fixedColor: Colors.blueAccent,
          type: BottomNavigationBarType.fixed,
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
      ),
    );
  }
}

class ShopDialog extends StatelessWidget {
  final ShopModel shop;

  ShopDialog({@required this.shop});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '店舗情報',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '店舗名',
            style: TextStyle(color: kSubColor, fontSize: 14.0),
          ),
          Text('${shop.name}'),
          SizedBox(height: 4.0),
          Text(
            '住所',
            style: TextStyle(color: kSubColor, fontSize: 14.0),
          ),
          Text('${shop.zip}'),
          Text('${shop.address}'),
          SizedBox(height: 4.0),
          Text(
            '電話番号',
            style: TextStyle(color: kSubColor, fontSize: 14.0),
          ),
          Text('${shop.tel}'),
          SizedBox(height: 4.0),
          Text(
            'メールアドレス',
            style: TextStyle(color: kSubColor, fontSize: 14.0),
          ),
          Text('${shop.email}'),
          SizedBox(height: 4.0),
          Text(
            '注文のキャンセル期限日',
            style: TextStyle(color: kSubColor, fontSize: 14.0),
          ),
          Text('${shop.cancelLimit}日前まで'),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: Colors.white),
          label: Text('閉じる', style: TextStyle(color: Colors.white)),
          style: TextButton.styleFrom(backgroundColor: Colors.grey),
        ),
      ],
    );
  }
}
