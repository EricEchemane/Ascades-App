import 'package:ascades/presentation/widgets/sign_in_widget.dart';
import 'package:ascades/presentation/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleSignInAccount? _identity;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) async {
      _identity = account;
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  Future signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  signOut() {
    _googleSignIn.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return _identity != null
        ? UserWidget(user: _identity!)
        : Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark, // For iOS (dark icons)
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: SignInWidget(
              signIn: signIn,
            ));
  }
}
