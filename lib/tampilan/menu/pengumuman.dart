import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';

class beritaPage extends StatefulWidget {
  const beritaPage({
    this.list,
  });
  final list;

  @override
  _beritaPageState createState() => _beritaPageState();
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Tidak bisa membuka $url';
  }
}

class _beritaPageState extends State<beritaPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ListView(
            children: [
              //appbar
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
                    //title
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      top: 0,
                      bottom: 0,
                      start: 0,
                      end: 0,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Pengumuman",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'medium',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //
              if (widget.list['berita_foto'] != "")
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              NetworkImage(widget.list['berita_foto'] ?? ""))),
                ),
              //Social Section

              //Space
              // SizedBox(
              //   height: 30,
              // ),
              //Health
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        widget.list['berita_when_update'] ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "medium",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //COVID-19
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  widget.list['berita_judul'],
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "medium",
                  ),
                ),
              ),
              //Lorem ipsun dolor...
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  widget.list['berita_keterangan'],
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "medium",
                  ),
                ),
              ),
              if (widget.list['berita_link'] != null)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text.rich(
                    TextSpan(
                      text: 'Kunjungi link berikut ',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(
                          text: ' untuk informasi lebih lanjut.',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: widget.list['berita_link'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL(widget.list['berita_link']);
                              // Aksi saat tautan diklik
                              print('Tautan diklik!');
                              // Tambahkan logika untuk membuka tautan di browser
                            },
                        ),
                      ],
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
