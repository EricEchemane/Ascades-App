import 'package:flutter/material.dart';

class SignInWidget extends StatelessWidget {
  final VoidCallback signIn;

  const SignInWidget({super.key, required this.signIn});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Image.asset('assets/logo.png'),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Text(
            'A Skin Cancer Detection Expert System',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        SizedBox(
            height: 56,
            width: width / 1.5,
            child: ElevatedButton(
              onPressed: signIn,
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
              ))),
              child: const Text(
                'Continue with Google',
                style: TextStyle(fontSize: 18),
              ),
            ))
      ],
    );
  }
}
