import 'package:flutter/material.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:provider/provider.dart';

class UserPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('パスワード変更'),
      ),
      body: userProvider.isLoading
          ? LoadingWidget()
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              children: [
                CustomTextField(
                  controller: userProvider.password,
                  obscureText: userProvider.isHidden ? false : true,
                  textInputType: null,
                  maxLines: 1,
                  labelText: '新しいパスワード',
                  prefixIconData: Icons.lock,
                  suffixIconData: userProvider.isHidden
                      ? Icons.visibility
                      : Icons.visibility_off,
                  onTap: () {
                    userProvider.changeHidden();
                  },
                ),
                SizedBox(height: 16.0),
                CustomTextField(
                  controller: userProvider.cPassword,
                  obscureText: userProvider.isCHidden ? false : true,
                  textInputType: null,
                  maxLines: 1,
                  labelText: '新しいパスワードの再入力',
                  prefixIconData: Icons.lock_outlined,
                  suffixIconData: userProvider.isCHidden
                      ? Icons.visibility
                      : Icons.visibility_off,
                  onTap: () {
                    userProvider.changeCHidden();
                  },
                ),
                SizedBox(height: 24.0),
                FillRoundButton(
                  labelText: '変更内容を保存する',
                  labelColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  onPressed: () async {
                    userProvider.changeLoading();
                    if (!await userProvider.updatePassword()) {
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
