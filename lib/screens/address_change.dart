import 'package:flutter/material.dart';
import 'package:otodokekun_cource/providers/app.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:provider/provider.dart';

class AddressChangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('お届け先情報変更'),
      ),
      body: appProvider.isLoading
          ? LoadingWidget()
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              children: [
                CustomTextField(
                  controller: userProvider.zip,
                  obscureText: false,
                  textInputType: null,
                  labelText: '郵便番号',
                  prefixIconData: Icons.location_pin,
                  suffixIconData: null,
                  onTap: null,
                ),
                SizedBox(height: 16.0),
                CustomTextField(
                  controller: userProvider.address,
                  obscureText: false,
                  textInputType: null,
                  labelText: '住所',
                  prefixIconData: Icons.location_city,
                  suffixIconData: null,
                  onTap: null,
                ),
                SizedBox(height: 16.0),
                CustomTextField(
                  controller: userProvider.tel,
                  obscureText: false,
                  textInputType: TextInputType.phone,
                  labelText: '電話番号',
                  prefixIconData: Icons.phone,
                  suffixIconData: null,
                  onTap: null,
                ),
                SizedBox(height: 24.0),
                FillRoundButton(
                  labelText: '変更を保存',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onPressed: () async {
                    appProvider.changeLoading();
                    if (!await userProvider.updateAddress()) {
                      appProvider.changeLoading();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('保存失敗')),
                      );
                      return;
                    }
                    userProvider.clearController();
                    userProvider.reloadUserModel();
                    appProvider.changeLoading();
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
    );
  }
}
