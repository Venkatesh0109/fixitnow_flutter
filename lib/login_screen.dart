import 'dart:async';
import 'dart:io';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/bottom_navigation/bottomnavscreen.dart';
import 'package:auscurator/ip_setting_screen.dart';
import 'package:auscurator/login_screen/bloc/login_bloc.dart';
import 'package:auscurator/login_screen/event/login_btn_click_event.dart';
import 'package:auscurator/login_screen/state/login_api_state.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:auscurator/widgets/palette.dart';
import 'package:auscurator/widgets/space.dart';
import 'package:auscurator/widgets/text_field.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LoginScreenState();
  }
}

Future<void> storeLoginPref(
  BuildContext context,
  String companyId,
  String buId,
  String plantId,
  String departmentId,
  String userLoginId,
  String locationId,
  String employeeType,
  String employeeName,
  String token,
  String empImage,
) async {
  try {
    final sharedUtil = SharedUtil();
    await sharedUtil.setCompanyId(companyId);
    await sharedUtil.setBuId(buId);
    await sharedUtil.setPlantId(plantId);
    await sharedUtil.setDepartmentId(departmentId);
    await sharedUtil.setLoginId(userLoginId);
    await sharedUtil.setLocationId(locationId);
    await sharedUtil.setEmployeetype(employeeType);
    await sharedUtil.setEmployeename(employeeName);
    await sharedUtil.setToken(token);
    await sharedUtil.setEmpImage(empImage);
    await sharedUtil.setEmployeeName1(employeeName);
    await sharedUtil.setImage1(empImage);
    await sharedUtil.reloadPref();

    // Ensure the context is valid before navigating
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const BottomNavScreen()),
        (route) => false,
      );
    }
  } catch (e, stackTrace) {
    debugPrint('Error in storeLoginPref: $e\n$stackTrace');
  }
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  String version = "";
  final userName = TextEditingController();
  final userPassword = TextEditingController();
  bool isTextSecure = false;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    checkConnection(context);
    // _fetchDepartmentList();
    // initSplash();
    _getAppVersion();
    super.initState();
  }

  // Function to get the version of the app
  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  var isLoading = false;

  Future<void> supscripeTopic(BuildContext context) async {
    if (!kIsWeb) {
      if (Platform.isIOS) {
        await FirebaseMessaging.instance.getAPNSToken().then((value) {
          logger.i(value);
          BlocProvider.of<LoginBloc>(context).add(
            OnLoginButtonClicked(
              userName: userName.text,
              userPassword: userPassword.text,
              userToken: value.toString(),
            ),
          );
        });
      }

      if (Platform.isAndroid) {
        await FirebaseMessaging.instance.getToken().then((value) {
          BlocProvider.of<LoginBloc>(context).add(
            OnLoginButtonClicked(
              userName: userName.text,
              userPassword: userPassword.text,
              userToken: value.toString(),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (context) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Color.fromRGBO(30, 152, 165, 1),
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) {
                                return const IPSettingScreen();
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SafeArea(
                              child: Image.asset(
                                "images/settings.png",
                                width: 25,
                                height: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Center(
                            child: SizedBox(
                              width: 140,
                              height: 140,
                              child: Card(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(80),
                                // ),
                                // surfaceTintColor: Colors.transparent,
                                // elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    "images/fixitnow_logo1.png",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.7,
                    child: Card(
                      surfaceTintColor: Colors.white,
                      // color: Color.fromRGBO(30, 152, 165, 1),
                      margin: const EdgeInsets.all(0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: TextCustom(
                                    "Welcome",
                                    size: 28,
                                    color: Color.fromRGBO(30, 152, 165, 1),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: TextCustom(
                                      "Login to continue",
                                      size: 20,
                                      color: Colors.grey,
                                    )),
                                const SizedBox(height: 20),
                                TextFormFieldCustom(
                                    suffix: Icon(
                                      Icons.person_outlined,
                                      color: Colors.black,
                                    ),
                                    controller: userName,
                                    hint: "Username"),
                                // TextField(
                                //   controller: userName,
                                //   decoration: const InputDecoration(
                                //     label: Text(
                                //       "Username",
                                //       style: TextStyle(
                                //         color: Colors.grey,
                                //         fontFamily: "Mulish",
                                //       ),
                                //     ),
                                //     suffixIcon:
                                //   ),
                                //   maxLength: 50,
                                // ),
                                const SizedBox(height: 16),
                                TextFormFieldCustom(
                                  controller: userPassword,
                                  hint: "Password",
                                  obscured: true,
                                ),
                                // TextField(
                                //   controller: userPassword,
                                //   decoration: InputDecoration(
                                //     label: const Text(
                                //       "Password",
                                //       style: TextStyle(
                                //         color: Colors.grey,
                                //         fontFamily: "Mulish",
                                //       ),
                                //     ),
                                //     suffixIcon: IconButton(
                                //       onPressed: () {
                                //         setState(() {
                                //           isTextSecure = !isTextSecure;
                                //         });
                                //       },
                                //       icon: Icon(isTextSecure
                                //           ? Icons.visibility
                                //           : Icons.visibility_off),
                                //     ),
                                //   ),
                                //   maxLength: 50,
                                //   obscureText: isTextSecure,
                                // ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                BlocConsumer<LoginBloc, LoginApiState>(
                                  builder: (context, state) {
                                    if (state is LoginLoadingState) {
                                      return const SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return SizedBox(
                                      width: width * 0.5,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromRGBO(30, 152, 165, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () async {
                                          checkConnection(context);
                                          if (userName.text.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  "Kindly Enter the Username",
                                                ),
                                              ),
                                            );
                                          } else if (userPassword
                                              .text.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  "Kindly Enter the Password",
                                                ),
                                              ),
                                            );
                                          } else {
                                            supscripeTopic(context)
                                                .then((value) {
                                              setState(() {
                                                SharedUtil().getEmployeeName1;
                                                SharedUtil().getImage1;
                                              });
                                            });
                                            // BlocProvider.of<LoginBloc>(context).add(
                                            //   OnLoginButtonClicked(
                                            //     userName: userName.text,
                                            //     userPassword: userPassword.text,
                                            //     userToken: "",
                                            //   ),
                                            // );
                                          }
                                        },
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: "Mulish",
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  listener: (context, state) {
                                    if (state is LoginLoadedState) {
                                      // _fetchDepartmentList();
                                      print(state.message);
                                      final login = state.loginModel.data;
                                      if (login == null || login.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              "Username or Password is Incorrect",
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      if (login.isNotEmpty) {
                                        if (state.isError == false) {
                                          if (login[0].token != "") {
                                            FirebaseMessaging.instance
                                                .subscribeToTopic(
                                                    login[0].token.toString());
                                            print(
                                                'subscribeToTopic ${login[0].token}');
                                          }
                                          setState(() {
                                            storeLoginPref(
                                              context,
                                              login[0].companyId.toString(),
                                              login[0].buId.toString(),
                                              login[0].plantId.toString(),
                                              login[0].departmentId.toString(),
                                              login[0].loginId.toString(),
                                              login[0].locationId.toString(),
                                              login[0].employeeType.toString(),
                                              login[0].employeeName.toString(),
                                              login[0].token.toString(),
                                              login[0]
                                                  .employeeImageUrl
                                                  .toString(),
                                            );
                                            dashboardProvider.userDetails = {
                                              "userName": login[0]
                                                  .employeeName
                                                  .toString(),
                                              "empImage": login[0]
                                                  .employeeImageUrl
                                                  .toString()
                                            };
                                          });

                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomNavScreen(),
                                            ),
                                          );

                                          SharedUtil().setRememberUser("true");

                                          // Navigator.pushNamedAndRemoveUntil(
                                          //   context,
                                          //   bottomNavigationRoute,
                                          //   (route) => false,
                                          //   arguments: state.message,
                                          // );
                                        }
                                      }
                                      return;
                                    }
                                    if (state is LoginErrorState) {
                                      print(state.message);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: state.isError
                                              ? Colors.red
                                              : Colors.green,
                                          content: Text(
                                            state.message,
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextCustom("Powered By",
                                          color: Palette.grey),
                                      WidthHalf(),
                                      Image.asset(
                                        "images/ausweglogo.png",
                                        height: 52,
                                        width: 52,
                                        fit: BoxFit.fitWidth,
                                      )
                                    ]),
                                Text(
                                  "Version: ${version}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontFamily: "Mulish",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
