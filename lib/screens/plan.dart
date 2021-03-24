import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_plan.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/terms_use.dart';
import 'package:otodokekun_cource/widgets/custom_dialog.dart';
import 'package:otodokekun_cource/widgets/custom_plan_list_tile.dart';
import 'package:otodokekun_cource/widgets/label.dart';
import 'package:otodokekun_cource/widgets/remarks.dart';

class PlanScreen extends StatelessWidget {
  final UserProvider userProvider;
  final ShopModel shop;
  final UserModel user;

  PlanScreen({
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
        .orderBy('deliveryAt', descending: false)
        .snapshots();
    List<ShopPlanModel> plans = [];

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      children: [
        RemarksWidget(remarks: shop?.remarks ?? null),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelWidget(iconData: Icons.view_in_ar, labelText: '定期注文'),
            shop != null
                ? TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return PlanDialog(
                            userProvider: userProvider,
                            shop: shop,
                            user: user,
                            plans: plans,
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
                  )
                : Container(),
          ],
        ),
        SizedBox(height: 4.0),
        shop != null
            ? StreamBuilder<QuerySnapshot>(
                stream: streamPlan,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('読み込み中'));
                  }
                  plans.clear();
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
                    return Center(child: Text('商品がありません'));
                  }
                },
              )
            : Center(child: Text('商品がありません')),
      ],
    );
  }
}

class PlanDialog extends StatefulWidget {
  final UserProvider userProvider;
  final ShopModel shop;
  final UserModel user;
  final List<ShopPlanModel> plans;

  PlanDialog({
    @required this.userProvider,
    @required this.shop,
    @required this.user,
    @required this.plans,
  });

  @override
  _PlanDialogState createState() => _PlanDialogState();
}

class _PlanDialogState extends State<PlanDialog> {
  bool _isFixed = false;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '定期注文',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('注文を定期的に行います。',
              style: TextStyle(color: Colors.black54, fontSize: 15.0)),
          Text(
            '契約開始後、注文が開始されます。',
            style: TextStyle(color: Colors.black54, fontSize: 15.0),
          ),
          Divider(),
          Text(
            '注文者名',
            style: TextStyle(color: kSubColor, fontSize: 14.0),
          ),
          Text('${widget.user?.name}'),
          SizedBox(height: 4.0),
          Text(
            'お届け先',
            style: TextStyle(color: kSubColor, fontSize: 14.0),
          ),
          Text('〒${widget.user?.zip}'),
          Text('${widget.user?.address}'),
          Text('${widget.user?.tel}'),
          SizedBox(height: 4.0),
          widget.user.fixed
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: Colors.blueAccent,
                      value: _isFixed,
                      onChanged: (value) {
                        setState(() {
                          _isFixed = value;
                        });
                      },
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '利用規約',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16.0,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextPage(context, TermsUseScreen());
                              },
                          ),
                          TextSpan(
                            text: 'に同意する',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('やめる', style: TextStyle(color: Colors.white)),
          style: TextButton.styleFrom(backgroundColor: Colors.grey),
        ),
        TextButton(
          onPressed: () async {
            if (widget.user.fixed) {
              if (!await widget.userProvider.updateFixedFalse()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('契約の解除に失敗しました')),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('契約を解除いたしました')),
              );
            } else {
              if (!_isFixed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('利用規約に同意してください')),
                );
                return;
              }
              if (!await widget.userProvider
                  .updateFixedTrue(plans: widget.plans)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('契約の開始に失敗しました')),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('契約を開始いたしました')),
              );
            }
            widget.userProvider.reloadUserModel();
            Navigator.pop(context);
          },
          child: Text(
            widget.user.fixed ? '契約解除' : '契約する',
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
            backgroundColor:
                widget.user.fixed ? Colors.redAccent : Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
