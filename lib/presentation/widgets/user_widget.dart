import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserWidget extends StatefulWidget {
  final GoogleSignInAccount user;

  const UserWidget({super.key, required this.user});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  bool hasImageSelected = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
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
                  leading: GoogleUserCircleAvatar(identity: widget.user),
                  title: Text(widget.user.displayName!),
                  subtitle: Text(widget.user.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 160,
                              child: Column(children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                MaterialButton(
                                  minWidth: width,
                                  height: 48,
                                  onPressed: () {},
                                  child: const Text('Home'),
                                ),
                                MaterialButton(
                                  minWidth: width,
                                  height: 48,
                                  onPressed: () {},
                                  child: const Text('About'),
                                ),
                                MaterialButton(
                                  minWidth: width,
                                  height: 48,
                                  onPressed: () {},
                                  child: const Text('Sign out'),
                                ),
                              ]),
                            );
                          });
                    },
                    color: Colors.brown,
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
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
                  child: hasImageSelected
                      ? SizedBox(
                          width: width,
                          height: width,
                          child: Center(child: Image.asset('assets/logo.png')))
                      : SizedBox(
                          width: width,
                          height: width,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_rounded,
                                size: 100,
                                color: Colors.brown.shade100,
                              ),
                              const Text(
                                'No Image is selected',
                                style: TextStyle(fontSize: 21),
                              ),
                            ],
                          )))),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width / 2.3,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ))),
                          child: const Text('Select from gallery'),
                          onPressed: () {}),
                    ),
                    SizedBox(
                      width: width / 2.3,
                      height: 50,
                      child: OutlinedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ))),
                          child: const Text('Reset'),
                          onPressed: () {}),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
