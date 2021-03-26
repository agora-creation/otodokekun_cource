import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otodokekun_cource/helpers/navigation.dart';
import 'package:otodokekun_cource/helpers/style.dart';
import 'package:otodokekun_cource/providers/user.dart';
import 'package:otodokekun_cource/providers/user_notice.dart';
import 'package:otodokekun_cource/screens/home.dart';
import 'package:otodokekun_cource/screens/registration.dart';
import 'package:otodokekun_cource/widgets/custom_dialog.dart';
import 'package:otodokekun_cource/widgets/custom_text_field.dart';
import 'package:otodokekun_cource/widgets/fill_round_button.dart';
import 'package:otodokekun_cource/widgets/link_button.dart';
import 'package:otodokekun_cource/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _init() async {
    final _pref = await SharedPreferences.getInstance();
    if (_pref.getBool('terms') != true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return TermsDialog();
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

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
                          ],
                        ),
                        SizedBox(height: 24.0),
                        FillRoundButton(
                          labelText: 'ログイン',
                          labelColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          onPressed: () async {
                            String _token = userNoticeProvider.token;
                            if (!await userProvider.signIn(token: _token)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('ログインに失敗しました')),
                              );
                              return;
                            }
                            userProvider.clearController();
                            changePage(context, HomeScreen());
                          },
                        ),
                        SizedBox(height: 24.0),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: LinkButton(
                            onTap: () {
                              nextPage(context, RegistrationScreen());
                            },
                            labelText: '初めての方はコチラ',
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

class TermsDialog extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '利用規約',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('以下の利用規約に同意してください'),
          SizedBox(height: 8.0),
          Divider(height: 0.0, color: Colors.black),
          Container(
            height: 250.0,
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: WebView(
                initialUrl: 'https://agora-c.com/otodokekun/terms_use.html',
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ),
          Divider(height: 0.0, color: Colors.black),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () async {
            final _pref = await SharedPreferences.getInstance();
            _pref.setBool('terms', true);
            Navigator.pop(context);
          },
          icon: Icon(Icons.check, color: Colors.white),
          label: Text('同意する', style: TextStyle(color: Colors.white)),
          style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
        ),
      ],
    );
  }
}
