import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/shop_invoice.dart';
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
  List<ShopInvoiceModel> _invoices = [];
  void _init() async {
    await widget.shopOrderProvider
        .selectListInvoice(shopId: widget.shop?.id)
        .then((value) {
      _invoices = value;
      DateTime _now = DateTime.now();
      for (ShopInvoiceModel _invoice in _invoices) {
        if (_now.isAfter(_invoice.openedAt) &&
            _now.isBefore(_invoice.closedAt)) {
          widget.shopOrderProvider.searchOpenedAt = _invoice.openedAt;
          widget.shopOrderProvider.searchClosedAt = _invoice.closedAt;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final _startAt = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.parse(widget.shopOrderProvider.searchClosedAt.toString())
            .millisecondsSinceEpoch);
    final _endAt = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.parse(widget.shopOrderProvider.searchOpenedAt.toString())
            .millisecondsSinceEpoch);
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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return SearchInvoiceDialog(
                      shopOrderProvider: widget.shopOrderProvider,
                      invoices: _invoices,
                    );
                  },
                );
              },
              icon: Icon(Icons.calendar_today, color: Colors.white),
              label: Text(
                  '${DateFormat('yyyy/MM/dd').format(widget.shopOrderProvider.searchOpenedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(widget.shopOrderProvider.searchClosedAt)}',
                  style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(backgroundColor: Colors.lightBlue),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            TextButton(
              onPressed: () async {
                int _totalPrice =
                    await widget.shopOrderProvider.selectTotalPrice(
                  shopId: widget.shop?.id,
                  userId: widget.user?.id,
                  startAt: _startAt,
                  endAt: _endAt,
                );
                showDialog(
                  context: context,
                  builder: (_) {
                    return TotalPriceDialog(
                      searchOpenedAt: widget.shopOrderProvider.searchOpenedAt,
                      searchClosedAt: widget.shopOrderProvider.searchClosedAt,
                      totalPrice: _totalPrice,
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

class SearchInvoiceDialog extends StatefulWidget {
  final ShopOrderProvider shopOrderProvider;
  final List<ShopInvoiceModel> invoices;

  SearchInvoiceDialog({
    @required this.shopOrderProvider,
    @required this.invoices,
  });

  @override
  _SearchInvoiceDialogState createState() => _SearchInvoiceDialogState();
}

class _SearchInvoiceDialogState extends State<SearchInvoiceDialog> {
  final ScrollController _scrollController = ScrollController();
  ShopInvoiceModel _selected;

  @override
  void initState() {
    super.initState();
    for (ShopInvoiceModel _invoice in widget.invoices) {
      if (widget.shopOrderProvider.searchOpenedAt
              .isAtSameMomentAs(_invoice.openedAt) &&
          widget.shopOrderProvider.searchClosedAt
              .isAtSameMomentAs(_invoice.closedAt)) {
        _selected = _invoice;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '締め日で検索',
      content: Container(
        width: 300.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 250.0,
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  controller: _scrollController,
                  itemCount: widget.invoices.length,
                  itemBuilder: (context, index) {
                    ShopInvoiceModel _invoice = widget.invoices[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      child: RadioListTile(
                        title: Text(
                            '${DateFormat('yyyy/MM/dd').format(_invoice.openedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(_invoice.closedAt)}'),
                        value: _invoice,
                        groupValue: _selected,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          setState(() {
                            _selected = value;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Divider(height: 0.0),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('閉じる'),
        ),
        TextButton.icon(
          onPressed: () {
            widget.shopOrderProvider
                .changeSelectDateRage(_selected.openedAt, _selected.closedAt);
            Navigator.pop(context);
          },
          icon: Icon(Icons.search, color: Colors.white),
          label: Text('検索する', style: TextStyle(color: Colors.white)),
          style: TextButton.styleFrom(backgroundColor: Colors.lightBlue),
        ),
      ],
    );
  }
}

class TotalPriceDialog extends StatelessWidget {
  final DateTime searchOpenedAt;
  final DateTime searchClosedAt;
  final int totalPrice;

  TotalPriceDialog({
    @required this.searchOpenedAt,
    @required this.searchClosedAt,
    @required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title:
          '${DateFormat('yyyy/MM/dd').format(searchOpenedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(searchClosedAt)}',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('注文金額'),
              Text('¥ $totalPrice'),
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
