import 'package:ascades/model/user_model.dart';
import 'package:flutter/material.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // padding: const EdgeInsets.all(7),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset:
                            const Offset(0, 4), // changes position of shadow
                      ),
                    ]),
                child: ListTile(
                  leading: GoogleUserCircleAvatar(identity: widget.identity),
                  title: Text(widget.identity.displayName!),
                  subtitle: Text(widget.identity.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
