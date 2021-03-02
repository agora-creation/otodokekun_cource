import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_plan.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/widgets/custom_dialog.dart';
import 'package:otodokekun_cource/widgets/custom_plan_list_tile.dart';
import 'package:otodokekun_cource/widgets/label.dart';
import 'package:otodokekun_cource/widgets/remarks.dart';

class PlanScreen extends StatelessWidget {
  final HomeProvider homeProvider;
  final UserProvider userProvider;
  final ShopModel shop;
  final UserModel user;

  PlanScreen({
    @required this.homeProvider,
    @required this.userProvider,
    @required this.shop,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> streamPlan = FirebaseFirestore.instance
        .collection('shop')
        .doc(shop?.id)
        .collection('plan')
        .where('published', isEqualTo: true)
        .orderBy('deliveryAt', descending: true)
        .snapshots();

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      children: [
        RemarksWidget(remarks: shop?.remarks ?? ''),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelWidget(iconData: Icons.view_in_ar, labelText: '定期注文'),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return PlanDialog(
                      userProvider: userProvider,
                      shop: shop,
                      user: user,
                    );
                  },
                );
              },
              child: Text(
                user.fixed ? '契約解除' : '契約する',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor:
                    user.fixed ? Colors.redAccent : Colors.blueAccent,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.0),
        StreamBuilder<QuerySnapshot>(
          stream: streamPlan,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('読み込み中'));
            }
            List<ShopPlanModel> plans = [];
            for (DocumentSnapshot plan in snapshot.data.docs) {
              plans.add(ShopPlanModel.fromSnapshot(plan));
            }
            if (plans.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: plans.length,
                itemBuilder: (_, index) {
                  ShopPlanModel _plan = plans[index];
                  return CustomPlanListTile(
                    deliveryAt:
                        '${DateFormat('MM/dd').format(_plan.deliveryAt)}',
                    name: _plan.name,
                    image: _plan.image,
                    unit: _plan.unit,
                    price: _plan.price,
                    description: _plan.description,
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
        SizedBox(height: 24.0),
      ],
    );
  }
}

class PlanDialog extends StatelessWidget {
  final UserProvider userProvider;
  final ShopModel shop;
  final UserModel user;

  PlanDialog({
    @required this.userProvider,
    @required this.shop,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '定期注文',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '定期注文は、注文を自動的に行います。翌週以降からのスタートになります。${shop.cancelLimit}日前の注文であれば、その注文をキャンセルできます。',
            style: TextStyle(color: Colors.black54, fontSize: 15.0),
          ),
          Divider(),
          Text(
            '注文者名',
            style: TextStyle(color: kSubColor, fontSize: 14.0),
          ),
          Text('${user?.name}'),
          SizedBox(height: 4.0),
          Text(
            'お届け先',
            style: TextStyle(color: kSubColor, fontSize: 14.0),
          ),
          Text('〒${user?.zip}'),
          Text('${user?.address}'),
          Text('${user?.tel}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('閉じる'),
        ),
        TextButton(
          onPressed: () async {
            if (!await userProvider.updateFixed(fixed: !user.fixed)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('契約更新に失敗しました')),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('契約更新に成功しました')),
            );
            userProvider.clearController();
            userProvider.reloadUserModel();
            Navigator.pop(context);
          },
          child: Text(
            user.fixed ? '契約解除' : '契約する',
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
            backgroundColor: user.fixed ? Colors.redAccent : Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
