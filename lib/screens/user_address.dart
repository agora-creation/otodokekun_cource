import 'package:flutter/material.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:provider/provider.dart';

class UserAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('お届け先情報変更'),
      ),
      body: userProvider.isLoading
          ? LoadingWidget()
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              children: [
                SizedBox(height: 8.0),
                CustomTextField(
                  controller: userProvider.zip,
                  obscureText: false,
                  textInputType: null,
                  maxLines: 1,
                  labelText: '郵便番号',
                  prefixIconData: Icons.location_pin,
                  suffixIconData: null,
                  onTap: null,
                ),
                SizedBox(height: 16.0),
                CustomTextField(
                  controller: userProvider.address,
                  obscureText: false,
                  textInputType: TextInputType.streetAddress,
                  maxLines: 1,
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
                  maxLines: 1,
                  labelText: '電話番号',
                  prefixIconData: Icons.phone,
                  suffixIconData: null,
                  onTap: null,
                ),
                SizedBox(height: 24.0),
                FillRoundButton(
                  labelText: '変更内容を保存',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onPressed: () async {
                    userProvider.changeLoading();
                    if (!await userProvider.updateAddress()) {
                      userProvider.changeLoading();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('変更に失敗しました')),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('変更に成功しました')),
                    );
                    userProvider.clearController();
                    userProvider.reloadUserModel();
                    userProvider.changeLoading();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
    );
  }
}
