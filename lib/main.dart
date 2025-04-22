import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gocrane_v3/bloc/theme_change_bloc.dart';
// import 'package:gocrane_v3/bloc/theme_change_state.dart';
import 'package:gocrane_v3/tampilan/akun/SignIn.dart';
import 'package:gocrane_v3/tampilan/homeLama.dart';
import 'package:gocrane_v3/tampilan/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   print("BACKGROUND NOTIFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");

//   print(message.notification);
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  // print('User granted permission: ${settings.authorizationStatus}');
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //FirebaseMessaging.onBackgroundMessage(_fire     baseMessagingBackgroundHandler);
  runApp(MyApp());
}

bool StatusLokasi = true;
String? iduser;
bool isUser = false;
String? idDep;
String url = "http://103.157.97.152";
String urlSubAPI = "mycrm";
// String idDep = "01";

class MyApp extends StatelessWidget {

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RichzErp',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: _ambildata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              );
            } else {
              return isUser == false ? const SignIn() : HomePagePengguna();
            }
          }),
    );
  }
}
// Widget build(BuildContext context) {
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]);
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//     statusBarColor: Color(0xFFFFFFFF),
//     // Color for Android
//     statusBarBrightness: Brightness.dark,
//     // Dark == white status bar -- for IOS.
//     statusBarIconBrightness: Brightness.dark,
//     systemNavigationBarColor: Color(0xFFFFFFFF),
//     systemNavigationBarIconBrightness: Brightness.dark,
//   ));

//   // ignore: missing_required_param
//   return BlocProvider<ThemeChangeBloc>(
//     create: (_) => ThemeChangeBloc(),
//     child: BlocBuilder<ThemeChangeBloc, ThemeChangeState>(
//         builder: (context, state) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: "Gocrane Drever",
//         home:
//             //  iduser == null ? HomePage() : IntroducationScreen(),

//             FutureBuilder(
//                 future: _ambildata(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         backgroundColor: Colors.white,
//                       ),
//                     );
//                   } else {
//                     return iduser == null ? const SignIn() : const SignIn();
//                   }
//                 }),
//         themeMode: state.themeState.themeMode,
//       );
//     }),
//   );
// }
// }

Future<void> _ambildata() async {
  final prefs = await SharedPreferences.getInstance();

  iduser = (prefs.get('idUser')) as String?;
  isUser =  prefs.get('isUser') as bool? ?? false;
  idDep = (prefs.get('departemen_id')) as String?;

  if (iduser != null) {
    // FirebaseMessaging.onMessage.listen((message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //     print(message.notification!.title);
    //   }
    // });

    // await FirebaseMessaging.instance.subscribeToTopic('weather');
  } else {
    print(iduser);
  }

  print(iduser);
}
