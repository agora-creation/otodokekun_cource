import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_product_regular.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/widgets/custom_dialog.dart';
import 'package:otodokekun_cource/widgets/custom_product_regular_list_tile.dart';
import 'package:otodokekun_cource/widgets/label.dart';
import 'package:otodokekun_cource/widgets/remarks.dart';

class ProductRegularScreen extends StatelessWidget {
  final UserProvider userProvider;
  final ShopModel shop;
  final UserModel user;

  ProductRegularScreen({
    @required this.userProvider,
    @required this.shop,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> streamPlan = FirebaseFirestore.instance
        .collection('shop')
        .doc(shop?.id)
        .collection('productRegular')
        .orderBy('deliveryAt', descending: false)
        .snapshots();
    List<ShopProductRegularModel> productRegulars = [];

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      children: [
        RemarksWidget(remarks: shop?.remarks ?? null),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelWidget(iconData: Icons.view_in_ar, labelText: '定期注文'),
            shop != null
                ? TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return ProductRegularDialog(
                            userProvider: userProvider,
                            shop: shop,
                            user: user,
                            productRegular: productRegulars,
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.cached, color: Colors.white),
                    label: Text(
                      user.regular ? '契約中' : '契約する',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          user.regular ? Colors.redAccent : Colors.blueAccent,
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
                  productRegulars.clear();
                  for (DocumentSnapshot productRegular in snapshot.data.docs) {
                    productRegulars.add(
                        ShopProductRegularModel.fromSnapshot(productRegular));
                  }
                  if (productRegulars.length > 0) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: productRegulars.length,
                      itemBuilder: (_, index) {
                        ShopProductRegularModel _productRegular =
                            productRegulars[index];
                        return CustomProductRegularListTile(
                          deliveryAt:
                              '${DateFormat('MM/dd').format(_productRegular.deliveryAt)}',
                          productName: _productRegular.productName,
                          productImage: _productRegular.productImage,
                          productUnit: _productRegular.productUnit,
                          productPrice: _productRegular.productPrice,
                          productDescription:
                              _productRegular.productDescription,
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('定期便がありません'));
                  }
                },
              )
            : Center(child: Text('定期便がありません')),
      ],
    );
  }
}

class ProductRegularDialog extends StatefulWidget {
  final UserProvider userProvider;
  final ShopModel shop;
  final UserModel user;
  final List<ShopProductRegularModel> productRegular;

  ProductRegularDialog({
    @required this.userProvider,
    @required this.shop,
    @required this.user,
    @required this.productRegular,
  });

  @override
  _ProductRegularDialogState createState() => _ProductRegularDialogState();
}

class _ProductRegularDialogState extends State<ProductRegularDialog> {
  bool _isRegular = false;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '定期注文',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(height: 16.0),
          Divider(height: 0.0, color: Colors.black),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text('${widget.shop.terms}'),
            ),
          ),
          Divider(height: 0.0, color: Colors.black),
          SizedBox(height: 8.0),
          widget.user.regular
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: Colors.blueAccent,
                      value: _isRegular,
                      onChanged: (value) {
                        setState(() => _isRegular = value);
                      },
                    ),
                    Text(
                      '利用規約に同意する',
                      style: TextStyle(color: Colors.black54, fontSize: 16.0),
                    ),
                  ],
                ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: Colors.white),
          label: Text('やめる', style: TextStyle(color: Colors.white)),
          style: TextButton.styleFrom(backgroundColor: Colors.grey),
        ),
        TextButton.icon(
          onPressed: () async {
            if (widget.user.regular) {
              if (!await widget.userProvider.updateRegularFalse()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('契約の解除に失敗しました')),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('契約を解除いたしました')),
              );
            } else {
              if (!_isRegular) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('利用規約に同意してください')),
                );
                return;
              }
              if (!await widget.userProvider
                  .updateRegularTrue(productRegulars: widget.productRegular)) {
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
          icon: Icon(Icons.cached, color: Colors.white),
          label: Text(
            widget.user.regular ? '契約解除' : '契約する',
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
            backgroundColor:
                widget.user.regular ? Colors.redAccent : Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
