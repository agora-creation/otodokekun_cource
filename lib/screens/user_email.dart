import 'package:flutter/material.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:provider/provider.dart';

class UserEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント情報変更'),
      ),
      body: userProvider.isLoading
          ? LoadingWidget()
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              children: [
                CustomTextField(
                  controller: userProvider.name,
                  obscureText: false,
                  textInputType: TextInputType.name,
                  maxLines: 1,
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
                  maxLines: 1,
                  labelText: 'メールアドレス',
                  prefixIconData: Icons.email,
                  suffixIconData: null,
                  onTap: null,
                ),
                SizedBox(height: 24.0),
                FillRoundButton(
                  labelText: '変更内容を保存する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onPressed: () async {
                    userProvider.changeLoading();
                    if (!await userProvider.updateEmail()) {
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
