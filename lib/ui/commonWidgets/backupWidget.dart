import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';
import '../screens/secretRecoveryPhrase2.dart';
import '../screens/verifyPassword.dart';

class BackupReminderWidget extends StatefulWidget {
  @override
  _BackupReminderWidgetState createState() => _BackupReminderWidgetState();
}

class _BackupReminderWidgetState extends State<BackupReminderWidget> {
  late Future<bool> _backReminderFuture;
  final appController = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    _backReminderFuture = _getBackReminderStatus();
  }

  Future<bool> _getBackReminderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('backReminder') ?? false;
  }

  Future<void> _setReminderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('backReminder', false);
    setState(() {
      _backReminderFuture = Future.value(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _backReminderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(); // or any placeholder while waiting
        } else if (snapshot.hasData && snapshot.data == true) {
          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await _setReminderStatus();
                  if (appController.enabledBiometric.value == true) {
                    Get.to(VerifyPassword(fromPage: 'send'))!.then((value) {
                      if (value == 'verified') {
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: Duration(milliseconds: 100),
                            type: PageTransitionType.topToBottom,
                            child: SecretRecoveryPharase2(),
                          ),
                        );
                      }
                    });
                  } else {
                    Navigator.push(
                      context,
                      PageTransition(
                        duration: Duration(milliseconds: 100),
                        type: PageTransitionType.topToBottom,
                        child: SecretRecoveryPharase2(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Color(0xFF16141C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffD1FF84),
                            ),
                            child: SvgPicture.asset(
                              'assets/svg/notification-bing.svg',
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Backup Reminder!',
                                style: TextStyle(
                                  color: lightTextColor.value,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Please backup your seed phrase.',
                                style: TextStyle(
                                  color: labelColorPrimaryShade.value,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _setReminderStatus();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Icon(
                            Icons.close,
                            color: lightTextColor.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          );
        } else {
          return SizedBox.shrink(); // Return an empty widget if backReminder is false
        }
      },
    );
  }
}
