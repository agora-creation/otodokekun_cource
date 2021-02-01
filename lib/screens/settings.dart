import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/app.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/address_change.dart';
import 'package:otodokekun_cource/screens/company.dart';
import 'package:otodokekun_cource/screens/email_change.dart';
import 'package:otodokekun_cource/screens/login.dart';
import 'package:otodokekun_cource/screens/password_change.dart';
import 'package:otodokekun_cource/screens/privacy_policy.dart';
import 'package:otodokekun_cource/screens/terms_use.dart';
import 'package:otodokekun_cource/screens/tokushoho.dart';
import 'package:otodokekun_cource/widgets/border_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:otodokekun_cource/widgets/setting_list_tile.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    UserModel _user = userProvider.user;
    return appProvider.isLoading
        ? LoadingWidget()
        : ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            children: [
              Text('アカウント情報'),
              SizedBox(height: 8.0),
              SettingListTile(
                iconData: Icons.person,
                title: 'アカウント情報変更',
                onTap: () {
                  userProvider.clearController();
                  userProvider.name.text = _user.name;
                  userProvider.email.text = _user.email;
                  nextPage(context, EmailChangeScreen());
                },
              ),
              SizedBox(height: 8.0),
              SettingListTile(
                iconData: Icons.lock,
                title: 'パスワード変更',
                onTap: () {
                  userProvider.clearController();
                  nextPage(context, PasswordChangeScreen());
                },
              ),
              SizedBox(height: 8.0),
              SettingListTile(
                iconData: Icons.location_pin,
                title: 'お届け先情報変更',
                onTap: () {
                  userProvider.clearController();
                  userProvider.zip.text = _user.zip;
                  userProvider.address.text = _user.address;
                  userProvider.tel.text = _user.tel;
                  nextPage(context, AddressChangeScreen());
                },
              ),
              SizedBox(height: 24.0),
              Text('サポート情報'),
              SizedBox(height: 8.0),
              SettingListTile(
                iconData: Icons.business_outlined,
                title: '運営会社',
                onTap: () {
                  nextPage(context, CompanyScreen());
                },
              ),
              SizedBox(height: 8.0),
              SettingListTile(
                iconData: Icons.description_outlined,
                title: '利用規約',
                onTap: () {
                  nextPage(context, TermsUseScreen());
                },
              ),
              SizedBox(height: 8.0),
              SettingListTile(
                iconData: Icons.info_outline,
                title: '特定商取引法に関する方針',
                onTap: () {
                  nextPage(context, TokushohoScreen());
                },
              ),
              SizedBox(height: 8.0),
              SettingListTile(
                iconData: Icons.lock_outline,
                title: 'プライバシーポリシー',
                onTap: () {
                  nextPage(context, PrivacyPolicyScreen());
                },
              ),
              SizedBox(height: 16.0),
              BorderRoundButton(
                labelText: 'ログアウト',
                labelColor: Colors.redAccent,
                borderColor: Colors.redAccent,
                onPressed: () {
                  appProvider.changeLoading();
                  userProvider.signOut();
                  appProvider.changeLoading();
                  changePage(context, LoginScreen());
                },
              ),
              SizedBox(height: 24.0),
            ],
          );
  }
}
