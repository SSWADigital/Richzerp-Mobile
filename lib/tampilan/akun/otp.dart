import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/akun/SignIn.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gocrane_v3/tampilan/homeLama.dart';

String id = '';
String username = '';
String password = '';
String status = '';
String pasienid = '';
String pasiennama = '';
String pasienalamat = '';
String pasienno_hp = "";
String pasienfoto = '';
String pasientanggal_lahir = '';
String pasienemail = "";

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  Timer? _timer;
  int _start = 60;

  Future _loginotp() async {
    if (_controller1.text.isEmpty ||
        _controller2.text.isEmpty ||
        _controller3.text.isEmpty ||
        _controller4.text.isEmpty) {
      return showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Pembritahuan !!!",
              subTile: "Data tidak benar!",
            );
          });
    }

    final Response =
        await http.post(Uri.parse("${url}/swamedika/login/cek_otp"), body: {
      'otp': _controller1.text +
          _controller2.text +
          _controller3.text +
          _controller4.text,
      'pasien_no_hp': nowa,
      'kode_negara': "+62",
    });

    var datauser = jsonDecode(Response.body);
    print(datauser);
    if (datauser[0]['login_id'] == "") {
      return showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Pembritahuan !!!",
              subTile: "Akun anda Tidak Terdaftar!",
            );
          });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);

      id = datauser[0]['login_id'] ?? "";
      username = datauser[0]['login_username'] ?? "";
      password = datauser[0]['login_password'] ?? "";
      status = datauser[0]['login_status'] ?? "";
      pasienid = datauser[0]['pasien_id'] ?? "";
      pasiennama = datauser[0]['pasien_nama'] ?? "";
      pasienalamat = datauser[0]['pasien_alamat'] ?? "";
      pasienno_hp = datauser[0][' pasien_no_hp'] ?? "";
      pasienfoto = datauser[0]['pasien_foto'] ?? "";
      pasientanggal_lahir = datauser[0]['pasien_tanggal_lahir'] ?? "";
      pasienemail = datauser[0]['pasien_email'] ?? "";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setBool("isUser", true);
      prefs.setString("pasien_id", datauser[0]['pasien_id']);
      return datauser;
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

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
                //Appbar
                Container(
                  height: 50,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      //back btn
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        start: -4,
                        top: 0,
                        bottom: 0,
                        child: InkWell(
                          focusColor: Colors.transparent,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/icons/ic_back.png",
                              scale: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        //Space
                        SizedBox(
                          height: 35,
                        ),
                        //Verify your number
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          child: Text(
                            "Verifikasi Nomer WhatsApp Anda",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                fontFamily: "medium",
                                color: Colors.black),
                          ),
                        ),
                        //Space
                        SizedBox(
                          height: 12,
                        ),
                        //Enter the verify number that...
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: new TextSpan(
                              text:
                                  "Masukkan nomor verifikasi yang  sudah terkirim\nKenomer WhatsApp +62 $nowa",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "medium",
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        //Space
                        SizedBox(
                          height: 12,
                        ),
                        //Resend
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (_start == 0) {
                                      startTimer();
                                      _start = 29;
                                    }
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/icons/ic_resend.png",
                                        scale: 40,
                                        color: Colors.black,
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 5, bottom: 2),
                                        child: Text(
                                          _timer!.isActive
                                              ? "00 : " + _start.toString()
                                              : "Resend",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "medium",
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Space
                        SizedBox(
                          height: 42,
                        ),
                        //InPut fields
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //1st field
                              PinNumber(
                                textEditingController: _controller1,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              //2nd field
                              PinNumber(
                                textEditingController: _controller2,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              //3rd field
                              PinNumber(
                                textEditingController: _controller3,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              //4 field
                              PinNumber(
                                textEditingController: _controller4,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  height: 44,
                                  onPressed: () {
                                    // FocusScope.of(context)
                                    //     .requestFocus(FocusNode());
                                    // checkVal(context);
                                    // _login();
                                    _loginotp();
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  color: Colors.green[900],
                                  elevation: 0,
                                  highlightElevation: 0,
                                  child: Container(
                                    child: Text(
                                      "Masuk",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'medium'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PinNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  PinNumber({required this.textEditingController});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 50,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: textEditingController,
        maxLength: 1,
        cursorWidth: 0.0,
        keyboardType: TextInputType.number,
        onChanged: (_) {
          if (textEditingController.text.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10, right: 8, bottom: 17),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(width: 1, color: Color(0xFFe57373)),
            ),
            helperStyle: TextStyle(color: Colors.transparent)),
        style: TextStyle(
          fontSize: 23,
          fontFamily: 'medium',
          color: Colors.black,
        ),
      ),
    );
  }
}
