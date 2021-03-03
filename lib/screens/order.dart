import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/time_machine_util.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/screens/order_details.dart';
import 'package:otodokekun_cource/widgets/custom_dialog.dart';
import 'package:otodokekun_cource/widgets/custom_order_list_tile.dart';
import 'package:otodokekun_cource/widgets/label.dart';
import 'package:otodokekun_cource/widgets/remarks.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  final ShopModel shop;
  final UserModel user;

  OrderScreen({
    @required this.shop,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final shopOrderProvider = Provider.of<ShopOrderProvider>(context);
    var monthMap =
        TimeMachineUtil.getMonthDate(shopOrderProvider.selectMonth, 0);
    final _startAt = Timestamp.fromMillisecondsSinceEpoch(
      DateTime.parse('${monthMap['endDate']}').millisecondsSinceEpoch,
    );
    final _endAt = Timestamp.fromMillisecondsSinceEpoch(
      DateTime.parse('${monthMap['startDate']}').millisecondsSinceEpoch,
    );
    final Stream<QuerySnapshot> streamOrder = FirebaseFirestore.instance
        .collection('shop')
        .doc(shop?.id)
        .collection('order')
        .where('userId', isEqualTo: user?.id)
        .orderBy('deliveryAt', descending: true)
        .startAt([_startAt]).endAt([_endAt]).snapshots();

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      children: [
        RemarksWidget(remarks: shop?.remarks ?? ''),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelWidget(iconData: Icons.list_alt, labelText: '注文履歴'),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () async {
                    var selected = await showMonthPicker(
                      context: context,
                      initialDate: shopOrderProvider.selectMonth,
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (selected == null) return;
                    shopOrderProvider.changeSelectMonth(selected);
                  },
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                      '${DateFormat('yyyy年MM月').format(shopOrderProvider.selectMonth)}',
                      style: TextStyle(color: Colors.white)),
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.blueAccent),
                ),
                SizedBox(width: 4.0),
                TextButton(
                  onPressed: () async {
                    int invoicePrice = await shopOrderProvider.selectInvoice(
                      shopId: shop?.id,
                      userId: user?.id,
                      startAt: _startAt,
                      endAt: _endAt,
                    );
                    showDialog(
                      context: context,
                      builder: (_) {
                        return InvoiceDialog(
                          selectMonth: shopOrderProvider.selectMonth,
                          invoicePrice: invoicePrice,
                        );
                      },
                    );
                  },
                  child: Text('注文金額を確認', style: TextStyle(color: Colors.white)),
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 4.0),
        StreamBuilder<QuerySnapshot>(
          stream: streamOrder,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('読み込み中'));
            }
            List<ShopOrderModel> orders = [];
            for (DocumentSnapshot order in snapshot.data.docs) {
              orders.add(ShopOrderModel.fromSnapshot(order));
            }
            if (orders.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (_, index) {
                  ShopOrderModel _order = orders[index];
                  return CustomOrderListTile(
                    deliveryAt: DateFormat('MM/dd').format(_order.deliveryAt),
                    name: _order.cart[0].name,
                    shipping: _order.shipping,
                    onTap: () {
                      shopOrderProvider.cart = _order.cart;
                      nextPage(
                        context,
                        OrderDetailsScreen(shop: shop, order: _order),
                      );
                    },
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

class InvoiceDialog extends StatelessWidget {
  final DateTime selectMonth;
  final int invoicePrice;

  InvoiceDialog({
    @required this.selectMonth,
    @required this.invoicePrice,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '${DateFormat('yyyy年MM月').format(selectMonth)}の注文金額',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text('¥ $invoicePrice')),
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
