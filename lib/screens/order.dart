import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_order.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/shop_order.dart';
import 'package:otodokekun_cource/screens/order_details.dart';
import 'package:otodokekun_cource/widgets/custom_dialog.dart';
import 'package:otodokekun_cource/widgets/custom_order_list_tile.dart';
import 'package:otodokekun_cource/widgets/label.dart';
import 'package:otodokekun_cource/widgets/remarks.dart';

class OrderScreen extends StatefulWidget {
  final ShopModel shop;
  final UserModel user;
  final ShopOrderProvider shopOrderProvider;

  OrderScreen({
    @required this.shop,
    @required this.user,
    @required this.shopOrderProvider,
  });

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    widget.shopOrderProvider.selectOpenedAt = widget.shop.openedAt;
    widget.shopOrderProvider.selectClosedAt = widget.shop.closedAt;
  }

  @override
  Widget build(BuildContext context) {
    final _startAt = Timestamp.fromMillisecondsSinceEpoch(
        widget.shopOrderProvider.selectClosedAt.millisecondsSinceEpoch);
    final _endAt = Timestamp.fromMillisecondsSinceEpoch(
        widget.shopOrderProvider.selectOpenedAt.millisecondsSinceEpoch);
    final Stream<QuerySnapshot> streamOrder = FirebaseFirestore.instance
        .collection('shop')
        .doc(widget.shop?.id)
        .collection('order')
        .where('userId', isEqualTo: widget.user?.id)
        .orderBy('deliveryAt', descending: true)
        .startAt([_startAt]).endAt([_endAt]).snapshots();

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      children: [
        RemarksWidget(remarks: widget.shop?.remarks ?? ''),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelWidget(iconData: Icons.list_alt, labelText: '注文履歴'),
            TextButton.icon(
              onPressed: () async {
                final List<DateTime> selected =
                    await DateRagePicker.showDatePicker(
                  context: context,
                  initialFirstDate: widget.shopOrderProvider.selectOpenedAt,
                  initialLastDate: widget.shopOrderProvider.selectClosedAt,
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (selected != null && selected.length == 2) {
                  setState(() {
                    widget.shopOrderProvider.selectOpenedAt = selected.first;
                    widget.shopOrderProvider.selectClosedAt = selected.last;
                  });
                }
              },
              icon: Icon(Icons.calendar_today, color: Colors.white),
              label: Text(
                  '${DateFormat('yyyy/MM/dd').format(widget.shopOrderProvider.selectOpenedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(widget.shopOrderProvider.selectClosedAt)}',
                  style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            TextButton(
              onPressed: () async {
                int invoicePrice = await widget.shopOrderProvider.selectInvoice(
                  shopId: widget.shop?.id,
                  userId: widget.user?.id,
                  startAt: _startAt,
                  endAt: _endAt,
                );
                showDialog(
                  context: context,
                  builder: (_) {
                    return InvoiceDialog(
                      selectOpenedAt: widget.shopOrderProvider.selectOpenedAt,
                      selectClosedAt: widget.shopOrderProvider.selectClosedAt,
                      invoicePrice: invoicePrice,
                    );
                  },
                );
              },
              child: Text('注文金額を確認', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
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
                      widget.shopOrderProvider.cart = _order.cart;
                      nextPage(
                        context,
                        OrderDetailsScreen(shop: widget.shop, order: _order),
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
  final DateTime selectOpenedAt;
  final DateTime selectClosedAt;
  final int invoicePrice;

  InvoiceDialog({
    @required this.selectOpenedAt,
    @required this.selectClosedAt,
    @required this.invoicePrice,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title:
          '${DateFormat('yyyy/MM/dd').format(selectOpenedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(selectClosedAt)}',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('注文金額'),
              Text('¥ $invoicePrice'),
            ],
          ),
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
