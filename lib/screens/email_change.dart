import 'package:flutter/material.dart';
import 'package:otodokekun_cource/providers/app.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:provider/provider.dart';

class EmailChangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント情報変更'),
      ),
      body: appProvider.isLoading
          ? LoadingWidget()
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              children: [
                CustomTextField(
                  controller: userProvider.name,
                  obscureText: false,
                  textInputType: TextInputType.name,
                  labelText: 'お名前',
                  prefixIconData: Icons.person,
                  suffixIconData: null,
                  onTap: null,
                ),
                SizedBox(height: 16.0),
                CustomTextField(
                  controller: userProvider.email,
                  obscureText: false,
                  textInputType: TextInputType.emailAddress,
                  labelText: 'メールアドレス',
                  prefixIconData: Icons.mail,
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
                    if (!await userProvider.updateEmail()) {
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
