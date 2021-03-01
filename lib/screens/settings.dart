import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/models/shop.dart';
import 'package:otodokekun_cource/models/user.dart';
import 'package:otodokekun_cource/providers/home.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/company.dart';
import 'package:otodokekun_cource/screens/login.dart';
import 'package:otodokekun_cource/screens/privacy_policy.dart';
import 'package:otodokekun_cource/screens/terms_use.dart';
import 'package:otodokekun_cource/screens/tokushoho.dart';
import 'package:otodokekun_cource/screens/user_address.dart';
import 'package:otodokekun_cource/screens/user_email.dart';
import 'package:otodokekun_cource/screens/user_password.dart';
import 'package:otodokekun_cource/widgets/border_round_button.dart';
import 'package:otodokekun_cource/widgets/custom_icon_list_tile.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:otodokekun_cource/widgets/remarks.dart';

class SettingsScreen extends StatelessWidget {
  final HomeProvider homeProvider;
  final UserProvider userProvider;
  final ShopModel shop;
  final UserModel user;

  SettingsScreen({
    @required this.homeProvider,
    @required this.userProvider,
    @required this.shop,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return homeProvider.isLoading
        ? LoadingWidget()
        : ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            children: [
              RemarksWidget(remarks: shop?.remarks ?? ''),
              Text(
                'アカウント情報',
                style: TextStyle(color: kSubColor),
              ),
              SizedBox(height: 8.0),
              Divider(height: 0.0, color: Colors.grey),
              CustomIconListTile(
                iconData: Icons.person,
                title: 'アカウント情報変更',
                onTap: () {
                  userProvider.clearController();
                  userProvider.name.text = user.name;
                  userProvider.email.text = user.email;
                  nextPage(context, UserEmailScreen());
                },
              ),
              SizedBox(height: 8.0),
              CustomIconListTile(
                iconData: Icons.lock,
                title: 'パスワード変更',
                onTap: () {
                  userProvider.clearController();
                  nextPage(context, UserPasswordScreen());
                },
              ),
              SizedBox(height: 8.0),
              CustomIconListTile(
                iconData: Icons.location_pin,
                title: 'お届け先情報変更',
                onTap: () {
                  userProvider.clearController();
                  userProvider.zip.text = user.zip;
                  userProvider.address.text = user.address;
                  userProvider.tel.text = user.tel;
                  nextPage(context, UserAddressScreen());
                },
              ),
              SizedBox(height: 24.0),
              Text('サポート情報'),
              SizedBox(height: 8.0),
              Divider(height: 0.0, color: Colors.grey),
              CustomIconListTile(
                iconData: Icons.business_outlined,
                title: '運営会社',
                onTap: () => nextPage(context, CompanyScreen()),
              ),
              SizedBox(height: 8.0),
              CustomIconListTile(
                iconData: Icons.description_outlined,
                title: '利用規約',
                onTap: () => nextPage(context, TermsUseScreen()),
              ),
              SizedBox(height: 8.0),
              CustomIconListTile(
                iconData: Icons.info_outline,
                title: '特定商取引法に関する方針',
                onTap: () => nextPage(context, TokushohoScreen()),
              ),
              SizedBox(height: 8.0),
              CustomIconListTile(
                iconData: Icons.lock_outline,
                title: 'プライバシーポリシー',
                onTap: () => nextPage(context, PrivacyPolicyScreen()),
              ),
              SizedBox(height: 24.0),
              BorderRoundButton(
                labelText: 'ログアウト',
                labelColor: Colors.redAccent,
                borderColor: Colors.redAccent,
                onPressed: () {
                  homeProvider.changeLoading();
                  userProvider.signOut();
                  homeProvider.changeLoading();
                  changePage(context, LoginScreen());
                },
              ),
              SizedBox(height: 40.0),
            ],
          );
  }
}
