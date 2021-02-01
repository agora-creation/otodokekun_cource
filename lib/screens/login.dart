import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/screens/home.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
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
                            Text('期間配達サービス'),
                          ],
                        ),
                        SizedBox(height: 32.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                            CustomTextField(
                              controller: userProvider.password,
                              obscureText: userProvider.isHidden ? false : true,
                              textInputType: null,
                              labelText: 'パスワード',
                              prefixIconData: Icons.lock,
                              suffixIconData: userProvider.isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              onTap: () {
                                userProvider.changeHidden();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 24.0),
                        FillRoundButton(
                          labelText: 'ログイン',
                          labelColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onPressed: () async {
                            if (!await userProvider.signIn()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('ログイン失敗')),
                              );
                              return;
                            }
                            userProvider.clearController();
                            changePage(context, HomeScreen());
                          },
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
