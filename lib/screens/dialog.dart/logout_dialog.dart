import 'package:auscurator/login_screen.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/loaders.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

final token = SharedUtil().getToken;

class _LogoutDialogState extends State<LogoutDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      TextCustom(
        "Logout",
        fontWeight: FontWeight.bold,
        color: Palette.primary,
        size: 18,
      ),
      HeightFull(),
      Center(child: TextCustom("Are you sure you want to Logout?", size: 14)),
      HeightFull(),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          isLoading
              ? Loader()
              : TextButton(
                  onPressed: () async {
                    {
                      setState(() {
                        isLoading = true;
                      });
                      if (token != "") {
                        await FirebaseMessaging.instance
                            .unsubscribeFromTopic(token.toString());
                      }
                      ;
                      await FirebaseMessaging.instance.deleteToken();

                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => LoginScreen()))
                      SharedUtil().clearSpecificKeys();
                      setState(() {
                        isLoading = false;
                      });

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                      setState(() {});
                    }
                    ;
                  },
                  child: const Text('Logout'),
                ),
        ],
      )
    ]);
  }
}
