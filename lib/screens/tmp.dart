import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/tmp.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/widgets/custom_dialog.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class TmpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    UserModel _user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Container(),
        title: Text('店舗切替'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        children: [
          Text('店舗切替は、現在選択されている店舗の締日に自動で切り替わります。'),
          SizedBox(height: 4.0),
          _user.tmp.length > 0
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: _user.tmp.length,
                  itemBuilder: (_, index) {
                    return Container(
                      decoration: kBottomBorderDecoration,
                      child: RadioListTile(
                        title: Text(_user.tmp[index].name),
                        subtitle: _user.shopId == _user.tmp[index].id
                            ? Text('設定中')
                            : _user.tmp[index].target == true
                                ? Text(
                                    '切替予定',
                                    style: TextStyle(color: Colors.redAccent),
                                  )
                                : null,
                        value: _user.tmp[index].id,
                        groupValue: userProvider.shopId,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) => userProvider.changeShopId(value),
                      ),
                    );
                  },
                )
              : Center(child: Text('店舗を追加してください')),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () async {
                  if (!await userProvider.updateShopId(
                      shopIdDefault: _user.shopId, tmp: _user.tmp)) {
                    return;
                  }
                  userProvider.reloadUserModel();
                  Navigator.of(context, rootNavigator: true).pop();
                },
                icon: Icon(Icons.autorenew, color: Colors.white),
                label: Text('店舗切替', style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(backgroundColor: Colors.lightBlue),
              ),
              SizedBox(width: 8.0),
              TextButton.icon(
                onPressed: () {
                  userProvider.clearController();
                  showDialog(
                    context: context,
                    builder: (_) => AddTmpDialog(
                      userProvider: userProvider,
                      tmp: _user.tmp,
                    ),
                  );
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text('店舗追加', style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddTmpDialog extends StatelessWidget {
  final UserProvider userProvider;
  final List<TmpModel> tmp;

  AddTmpDialog({
    @required this.userProvider,
    @required this.tmp,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '店舗追加',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: userProvider.shopCode,
            obscureText: false,
            textInputType: null,
            maxLines: 1,
            labelText: '店舗コード',
            prefixIconData: Icons.store,
            suffixIconData: null,
            onTap: null,
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
            if (!await userProvider.addTmp(tmp: tmp)) {
              return;
            }
            userProvider.clearController();
            userProvider.reloadUserModel();
            Navigator.pop(context);
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text('追加する', style: TextStyle(color: Colors.white)),
          style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
        ),
      ],
    );
  }
}
