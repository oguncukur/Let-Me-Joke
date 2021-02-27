import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyApp> {
  Future<String> getData() async {
    http.Response response = await http.get(Uri.encodeFull(""));
    Map<String, dynamic> model = jsonDecode(response.body);
    var joke = model['content'];
    return joke;
  }

  showMaterialDialog(text, context) {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              content: new Text(text),
              actions: <Widget>[
                FlatButton(
                  child: Text('Again'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'], childDirected: false);

  BannerAd myBanner = BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("Reklam: $event");
    },
  );

  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: InterstitialAd.testAdUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("Geçiş Reklam: $event");
    },
  );

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: '');
    super.initState();
    myBanner..load();
    myInterstitial..load();
  }

  @override
  Widget build(BuildContext context) {
    myBanner..show(anchorType: AnchorType.top);
    return Scaffold(
      backgroundColor: Colors.white,
      body: HomePage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          child: Icon(
            Icons.new_releases,
          ),
          onPressed: () async {
            myInterstitial..show();
            var result = await getData();
            showMaterialDialog(result, context);
          },
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.green[200],
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.dstATop),
          image: AssetImage('assets/images/joke.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 250.0),
            child: Center(
              child: Icon(
                Icons.tag_faces_rounded,
                color: Colors.white,
                size: 40.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Let Me ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  "Joke",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
