import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3/tampilan/menu/orderan_berjalan/map.dart';
import 'package:gocrane_v3/tampilan/tab/beranda.dart';
import 'package:gocrane_v3/tampilan/tab/geolocator.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/informasi.dart';
import 'package:gocrane_v3/tampilan/tab/profil/profil.dart';
import 'package:gocrane_v3/tampilan/tab/riwayat/riwayat.dart';
import 'package:gocrane_v3/tampilan/tab/schedule.dart';
import 'package:gocrane_v3/tampilan/tab/schedule/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Future GetToken(String token) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   var id_user = (prefs.get('usr_id'));
  //   await http.post(Uri.parse("http://101.50.2.211/api_gocrane/token_user.php"),
  //       body: {
  //         "id_usr": id_user ?? "",
  //         "token": token,
  //       });
  // }

  TabController? tb;
  @override
  void initState() {
    super.initState();
    tb = TabController(length: 4, vsync: this);
    tb?.addListener(_handleTabSelection);

//     FirebaseMessaging.instance.getToken().then((value) {
//       GetToken(value!);
//       print(value);
//     });

// //ketika notifikasi on terminet
//     FirebaseMessaging.instance.getInitialMessage().then((value) {
//       if (value != null) {
//         print(value.data);
//         print(value.notification);

//         var dataTran = value.data['data'];

//         Navigator.push(
//             context, SlidePageRoute(page: GoogleMapScreen(id_reg: dataTran)));
//       } else {}
//     });
// //ketika notifikasi backgroun
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {});

// //ketika botifikasi fourgroun
//     FirebaseMessaging.onMessage.listen((message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');

//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//         print(message.notification!.title);
//       }
//     });
  }

  void _handleTabSelection() {
    setState(() {});
  }

  // final theImage = Icon(icon);

  /// Did Change Dependencies
  // @override
  // void didChangeDependencies() {
  //   precacheImage(theImage.icone, context);
  //   super.didChangeDependencies();
  // }

  MediaQueryData? queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData!.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                //
                Expanded(
                  child: TabBarView(
                      controller: tb,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        berandaMap(),
                        riwayatAbsen(),
                        informasi(),

                        biodatapengguna(),
                        // absenmap(),
                        // MyTable(),
                        // // HomeScreen(),
                        // // ScheduleScreen(),
                        // // CommunityScreen(),
                        // // NotificationScreen(),
                        // ProfileScreen(),
                      ]),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 4,
            child: Container(
              height: 60,
              padding: EdgeInsets.only(left: 4),
              child: TabBar(
                  controller: tb,
                  labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  indicator: UnderlineTabIndicator(
                    borderSide:
                        BorderSide(width: 0.0, color: Colors.transparent),
                  ),
                  tabs: [
                    Tab(
                      child: tb!.index == 0
                          ? tabItem1(context, 0, Icons.home, 10, "Beranda")
                          : tabItem(0, Icons.home, 20),
                    ),
                    Tab(
                      child: tb!.index == 1
                          ? tabItem1(
                              context, 0, Icons.calendar_today, 10, "Schedule")
                          : tabItem(1, Icons.calendar_today, 20),
                    ),
                    Tab(
                      child: tb!.index == 2
                          ? tabItem1(context, 0, Icons.book, 10, "Pengajuan")
                          : tabItem(1, Icons.book, 20),
                    ),

                    // Tab(
                    //   child: tb.index == 3
                    //       ? tabItem1(
                    //           context, 0, "assets/icons/tab5.png", 10, "Pesan")
                    //       : tabItem(3, "assets/icons/ic_notification2.png", 20),
                    // ),
                    Tab(
                      child: tb?.index == 3
                          ? tabItem1(context, 0, Icons.person, 10, "Profil")
                          : tabItem(4, Icons.person_outlined, 18.0),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

Container tabItem1(context, int index, IconData icon, double sc, String title) {
  return Container(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.directional(
          top: 0,
          start: 0,
          end: 0,
          textDirection: Directionality.of(context),
          child: Container(
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: const Color.fromARGB(255, 14, 104, 17),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color.fromARGB(255, 14, 104, 17),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

//1
Container tabItem(int index, IconData icon, double sc) {
  return Container(
    child: Icon(
      icon,
      size: 26,
      color: Colors.grey,
    ),
  );
}
