import 'package:ascades/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserWidget extends StatefulWidget {
  final User user;
  final GoogleSignInAccount identity;

  const UserWidget({super.key, required this.user, required this.identity});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          ListTile(
            leading: GoogleUserCircleAvatar(identity: widget.identity),
            title: Text(widget.identity.displayName!),
            subtitle: Text(widget.identity.email),
          )
        ],
      ),
    );
  }
}
