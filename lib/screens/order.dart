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
  final ShopOrderProvider shopOrderProvider;
  final ShopModel shop;
  final UserModel user;

  OrderScreen({
    @required this.shopOrderProvider,
    @required this.shop,
    @required this.user,
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
    String _opened =
        '${DateFormat('yyyy-MM-dd').format(widget.shopOrderProvider.searchOpenedAt)} 00:00:00.000';
    String _closed =
        '${DateFormat('yyyy-MM-dd').format(widget.shopOrderProvider.searchClosedAt)} 23:59:59.999';
    final _startAt = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.parse(_closed).millisecondsSinceEpoch);
    final _endAt = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.parse(_opened).millisecondsSinceEpoch);
    final Stream<QuerySnapshot> streamOrder = FirebaseFirestore.instance
        .collection('shop')
        .doc(widget.shop?.id)
        .collection('order')
        .where('userId', isEqualTo: widget.user?.id)
        .orderBy('deliveryAt', descending: true)
        .startAt([_startAt]).endAt([_endAt]).snapshots();
    List<ShopOrderModel> orders = [];
    int _totalPrice = 0;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            children: [
              RemarksWidget(remarks: widget.shop?.remarks ?? null),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LabelWidget(iconData: Icons.list_alt, labelText: '注文履歴'),
                  widget.shop != null
                      ? TextButton.icon(
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
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.lightBlue),
                        )
                      : Container(),
                ],
              ),
              SizedBox(height: 4.0),
              widget.shop != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: streamOrder,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('読み込み中'));
                        }
                        orders.clear();
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
                              _totalPrice = _totalPrice + _order.totalPrice;
                              return CustomOrderListTile(
                                deliveryAt: DateFormat('MM/dd')
                                    .format(_order.deliveryAt),
                                name: _order.products[0].name,
                                shipping: _order.shipping,
                                onTap: () {
                                  widget.shopOrderProvider.products =
                                      _order.products;
                                  nextPage(context,
                                      OrderDetailsScreen(order: _order));
                                },
                              );
                            },
                          );
                        } else {
                          return Center(child: Text('注文がありません'));
                        }
                      },
                    )
                  : Center(child: Text('注文がありません')),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) {
                return TotalPriceDialog(
                  title:
                      '${DateFormat('yyyy/MM/dd').format(widget.shopOrderProvider.searchOpenedAt)} 〜 ${DateFormat('yyyy/MM/dd').format(widget.shopOrderProvider.searchClosedAt)}',
                  totalPrice: _totalPrice,
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: ListTile(
              title: Text('注文金額の合計を表示'),
              trailing: Icon(Icons.arrow_drop_up),
            ),
          ),
        ),
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
      title: '締め日で表示',
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
          label: Text('表示する', style: TextStyle(color: Colors.white)),
          style: TextButton.styleFrom(backgroundColor: Colors.lightBlue),
        ),
      ],
    );
  }
}

class TotalPriceDialog extends StatelessWidget {
  final String title;
  final int totalPrice;

  TotalPriceDialog({
    @required this.title,
    @required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
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
