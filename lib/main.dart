import 'dart:async';
import 'dart:io';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/bottom_navigation/cubit/bottom_navigation_cubit.dart';
import 'package:auscurator/db/sqlite.dart';
import 'package:auscurator/firebase_options.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/bloc/save_button_bloc.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:auscurator/model/notification_model.dart';
import 'package:provider/provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auscurator/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:restart_app/restart_app.dart';
import 'package:auscurator/splash_screen/splash_screen.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:upgrader/upgrader.dart';

import 'dart:async';
import 'dart:io';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/bottom_navigation/cubit/bottom_navigation_cubit.dart';
import 'package:auscurator/db/sqlite.dart';
import 'package:auscurator/firebase_options.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/bloc/save_button_bloc.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:auscurator/model/notification_model.dart';
import 'package:provider/provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auscurator/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:restart_app/restart_app.dart';
import 'package:auscurator/splash_screen/splash_screen.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:upgrader/upgrader.dart';

GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

// Create notification channel for Android
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('custom_sound'),
  playSound: true,
  showBadge: true,
  enableVibration: true,
);

// Flutter local notification plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Firebase background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.e(message.notification?.title);
  final dateTime = DateTime.now();
  final formatter = DateFormat("dd-MM-yyyy hh:mm:ss");
  final formattedDateTime = formatter.format(dateTime);

  Sqlite().createItem(
    NotificationModel(
      message.notification?.title ?? "",
      message.notification?.body ?? "",
      formattedDateTime,
    ),
  );

  RemoteNotification? notification = message.notification;
  if (notification != null) {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      color: Colors.blue,
      sound: RawResourceAndroidNotificationSound('custom_sound'),
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'custom_sound.caf',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }
}

Future<void> main() async {
  final widgetBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);

  // Initialize shared preferences
  await SharedUtil().init();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase is already initialized: $e");
  }

  // Request notification permissions
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // Create notification channel for Android
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  // Set foreground notification presentation options
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Initialize local notifications with Android & iOS settings
  const AndroidInitializationSettings androidSetting =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosInitializationSettings =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    // onDidReceiveLocalNotification:
    //     (int id, String? title, String? body, String? payload) async {
    //   // Handle iOS local notification
    // },
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidSetting,
    iOS: iosInitializationSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onSelectNotification: (String? payload) async {
    //   // Handle notification tap
    // },
  );
  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final dateTime = DateTime.now();
    final formatter = DateFormat("dd-MM-yyyy hh:mm:ss");
    final formattedDateTime = formatter.format(dateTime);

    Sqlite().createItem(
      NotificationModel(
        message.notification?.title ?? "",
        message.notification?.body ?? "",
        formattedDateTime,
      ),
    );

    RemoteNotification? notification = message.notification;
    if (notification != null) {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        channel.id,
        channel.name,
        color: Colors.blue,
        sound: RawResourceAndroidNotificationSound('custom_sound'),
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iosPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'custom_sound.caf',
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
      );
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SaveButtonBloc>(
            create: (context) => SaveButtonBloc(),
          ),
          BlocProvider<BottomNavigationCubit>(
            create: (context) => BottomNavigationCubit(),
          ),
        ],
        child: MultiProvider(
          providers: providersAll,
          child: MaterialApp(
            navigatorKey: navigationKey,
            debugShowCheckedModeBanner: false,
            key: mainKey,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(30, 152, 165, 1),
              ),
              textTheme: TextTheme(
                titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
            home: UpgradeAlert(
              showIgnore: true,
              showLater: true,
              child: const SplashScreen(),
            ),
          ),
        ),
      ),
    ),
  );

  FlutterNativeSplash.remove();
}

checkConnection(BuildContext context) async {
  await Connectivity().checkConnectivity().then((value) {
    if (value == ConnectivityResult.none) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/no_wifi.png',
                  width: 35,
                  height: 35,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Network issue",
                  style: TextStyle(
                    fontFamily: "Mulish",
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: const Text(
              "Activate network connectivity and initiate a device reboot for optimal functionality.",
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Restart.restartApp();
                },
                child: const Text("Restart!"),
              ),
            ],
          );
        },
      );
    }
  });
}
