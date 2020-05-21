import 'package:flutter/material.dart';
import 'package:seagate_fast_qr_track/screens/setting.dart';
import 'package:seagate_fast_qr_track/screens/scan.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '6356256B89C1B8B880CC117F91EA2CC5';
 


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
  bool _validate = false;

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario','Harddisk','shopping'],
  );

 BannerAd _bannerAd;

 InterstitialAd _interstitialAd;

//Banner Ads
  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: 'ca-app-pub-9270904807323248/3706437107',
      //Change BannerAd adUnitId with Admob ID
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }
//Interstitial Ads
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: 'ca-app-pub-9270904807323248/2676550170',
      //Change Interstitial AdUnitId with Admob ID
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
        });
  }
  Future<Null>  getGID() async { 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    gid = (prefs.getString('GID')??'');
     setState(() {
      _controller = new TextEditingController(text: gid);
     });

     if(gid!=""&&gid!=null){
       scanAndWeb();
     }
 
  }

  //Method //
  @override
  void initState() {
    super.initState(); 
    gid = '';
    getGID(); 
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-9270904807323248~4089580483');
    _bannerAd = createBannerAd()..load()..show();

  }
 
 
  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  void saveGID() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('GID', gid); 
  }



  Widget showLogo() {
    return Container(
        width: 150.0, height: 150.0, child: Image.asset('images/logo.png'));
  }

  Widget showAppName() {
    return Text(
      'Seagate Fast QR Tracking',
      style: TextStyle(
          fontSize: 30.0,
          color: Colors.blue.shade400,
          fontWeight: FontWeight.normal,
          fontFamily: 'bangers'),
    );
  }

  Widget enterGID() {
    var firstField = FocusNode();
    return Container(
      width: 250,
      height: 80,
      child: TextFormField(
        focusNode: firstField,
        keyboardType: TextInputType.number, 
        controller: _controller, 
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
          helperText: 'type in your GID',
          errorText: _validate ? 'Value Can\'t Be Empty' : null,
        ),

        validator: (String value) {
          if (value.isEmpty) {
            return 'Please check your GID';
          } else {
            return null;
          }
        },
        onChanged: (String value) {
          gid = value.trim();
          print('you enter gid: $gid');
          saveGID();
        },
      ),
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
  Widget scanButton2() {
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
            if(gid.isNotEmpty){
// goto scan and web.....
              scanAndWeb();
          //----------------------------
            }
            else{
              setState(() {
                  _controller.text.isEmpty ? _validate = true : _validate = false;
                });
            
            }
            
          },
        ),
      ],
    );
  }

void scanAndWeb() async {
  // -----------------------------------------
              String results = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scan(),
                ),
              );
              if (results != null && results !="") {
                setState(() {
                  result = results; 
                });
                String url = '$result&g=$gid';
                print('opening... $url');
                _launchURL(url);
              }
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
          //scanButton(),
          SizedBox(height: 8.0),
          gowebButton(),
          settingButton(),
          scanButton2(),
        ],
      ),
    );
  }

  Widget getText(text) {
    return Text(text);
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
      appBar: AppBar(),
      drawer:Drawer(
      child: ListView(children: <Widget>[
        ListTile(
          
          onTap: (){
                  showAboutDialog(
                    context: context,
                    applicationIcon:  Container(width: 100.0, height: 100.0, child: Image.asset('images/logo.png')),
                    applicationLegalese: 'Developed by by iTum Studio',
                );
                
                },
                title: Text('Show about Page')
              ),
      ],)
      ),
      
        
      
      
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
                scanButton2(),
                //showButton(),
                SizedBox(height: 30.0), 
                RaisedButton(
                  
                          child: Text('Sponsor my by click this button '),
                          onPressed: () {
                            createInterstitialAd()
                              ..load()
                              ..show();
                          },
                        )
                //  getText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
