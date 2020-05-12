import 'package:flutter/material.dart';
import 'package:seagate_fast_qr_track/screens/setting.dart';
import 'package:super_qr_reader/super_qr_reader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String result = '';
  TextEditingController _controller;
  String gid, emailString, passwordString;
  SharedPreferences prefs;
  //Method //
  @override
  void initState() {
    super.initState();
    gid = '';
    getGID();
  }

  void saveGID() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('GID', gid);
    gid = prefs.getString('GID');
  }

  Future<Null> getGID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    gid = prefs.getString('GID');
    setState(() {
      _controller = new TextEditingController(text: gid);
    });
  }

  Widget showLogo() {
    return Container(
        width: 150.0, height: 150.0, child: Image.asset('images/logo.png'));
  }

  Widget showAppName() {
    return Text(
      'Test My APP',
      style: TextStyle(
          fontSize: 30.0,
          color: Colors.blue.shade400,
          fontWeight: FontWeight.normal,
          fontFamily: 'bangers'),
    );
  }

  Widget enterGID() {
    return Container(
      width: 250,
      height: 80,
      child: TextFormField(
        keyboardType: TextInputType.number,
        //initialValue: gid,
        controller: _controller,
        //controller: _gidcontroller,
        style: TextStyle(color: Colors.blue),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          //labelText: 'GID:',
          labelStyle: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
          alignLabelWithHint: true,
          // contentPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          helperText: 'xxxxtype in your GID',
        ),
//test XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please check your GID';
          } else {
            return null;
          }
        },
        onFieldSubmitted: (String value) {
          gid = value.trim();
          print('you enter gid: $gid');
          saveGID();
        },
      ),
    );
  }

  Widget scanButton() {
    return Column(
      children: <Widget>[
        RaisedButton(
          color: Colors.blue.shade700,
          child: Text(
            'Scan QR',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            print('you press scan button');
            String results = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScanView(),
              ),
            );
            if (results != null) {
              setState(() {
                result = results;
                print(results);
              });
              String url = '$result&g=$gid';
              print('opening... $url');
              _launchURL(url);
            }
          },
        ),
      ],
    );
  }

  Widget settingButton() {
    return RaisedButton(
      color: Colors.blue.shade700,
      child: Text(
        'Setting',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        print('you click setting button');
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Setting());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget gowebButton() {
    return RaisedButton(
      color: Colors.blue.shade700,
      child: Text(
        'OpenWeb',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        print('you wanna open google');
        _launchURL('https://www.google.com');
        Text('Show Flutter homepage');
      },
    );
  }

  Widget showButton() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          scanButton(),
          SizedBox(height: 8.0),
          gowebButton(),
          //settingButton(),
        ],
      ),
    );
  }

  Widget getText() {
    return Text(gid);
  }

  _launchURL(String url) async {
    // const url ='https://www.google.com';
    print(url);
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, Colors.blue.shade300],
              radius: 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showLogo(),

                SizedBox(height: 8.0),
                showAppName(),
                SizedBox(height: 8.0),
                enterGID(),
                //scanButton(),
                showButton(),
                //  getText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
