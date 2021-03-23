import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/providers/user_notice.dart';
import 'package:otodokekun_cource/screens/home.dart';
import 'package:otodokekun_cource/widgets/border_round_button.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/link_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userNoticeProvider = Provider.of<UserNoticeProvider>(context);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            child: userProvider.status == Status.Authenticating
                ? LoadingWidget()
                : SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 100.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('お届けくん', style: kTitleTextStyle),
                            SizedBox(height: 8.0),
                            Text('BtoCサービス'),
                          ],
                        ),
                        SizedBox(height: 24.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            SizedBox(height: 16.0),
                            CustomTextField(
                              controller: userProvider.password,
                              obscureText: userProvider.isHidden ? false : true,
                              textInputType: null,
                              maxLines: 1,
                              labelText: 'パスワード',
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
                              obscureText:
                                  userProvider.isCHidden ? false : true,
                              textInputType: null,
                              maxLines: 1,
                              labelText: 'パスワードの再入力',
                              prefixIconData: Icons.lock_outline,
                              suffixIconData: userProvider.isCHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              onTap: () {
                                userProvider.changeCHidden();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 24.0),
                        BorderRoundButton(
                          labelText: '登録',
                          labelColor: Colors.blueAccent,
                          borderColor: Colors.blueAccent,
                          onPressed: () async {
                            String _token = userNoticeProvider.token;
                            if (!await userProvider.signUp(token: _token)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('登録に失敗しました')),
                              );
                              return;
                            }
                            userProvider.clearController();
                            changePage(context, HomeScreen());
                          },
                        ),
                        SizedBox(height: 24.0),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: LinkButton(
                            onTap: () => Navigator.pop(context),
                            labelText: '登録済みの方はコチラ',
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
