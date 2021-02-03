import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/home.dart';
import 'package:otodokekun_cource/widgets/border_round_button.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
                            Text(
                              'お届けくん',
                              style: kTitleTextStyle,
                            ),
                            SizedBox(height: 8.0),
                            Text('BtoCサービス'),
                          ],
                        ),
                        SizedBox(height: 32.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextField(
                              controller: null,
                              obscureText: false,
                              textInputType: null,
                              maxLines: 1,
                              labelText: ' 店舗ID',
                              prefixIconData: Icons.store,
                              suffixIconData: null,
                              onTap: null,
                            ),
                            SizedBox(height: 24.0),
                            CustomTextField(
                              controller: userProvider.name,
                              obscureText: false,
                              textInputType: null,
                              maxLines: 1,
                              labelText: 'お名前',
                              prefixIconData: Icons.person,
                              suffixIconData: null,
                              onTap: null,
                            ),
                            SizedBox(height: 24.0),
                            CustomTextField(
                              controller: userProvider.email,
                              obscureText: false,
                              textInputType: TextInputType.emailAddress,
                              maxLines: 1,
                              labelText: 'メールアドレス',
                              prefixIconData: Icons.mail,
                              suffixIconData: null,
                              onTap: null,
                            ),
                            SizedBox(height: 24.0),
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
                            SizedBox(height: 24.0),
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
                            if (!await userProvider.signUp()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('登録に失敗しました')),
                              );
                              return;
                            }
                            userProvider.clearController();
                            changePage(context, HomeScreen());
                          },
                        ),
                        SizedBox(height: 32.0),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context, true),
                            child: Text(
                              'ログインはコチラ',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
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
