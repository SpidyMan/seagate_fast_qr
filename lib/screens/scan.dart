import 'package:flutter/material.dart'; 
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_admob/firebase_admob.dart';
const String testDevice = '6356256B89C1B8B880CC117F91EA2CC5';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class Scan extends StatefulWidget {
  const Scan({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');


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
  

  @override
  void initState() {
    super.initState();  
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-9270904807323248~4089580483');
    _bannerAd = createBannerAd()..load()..show();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Scanning QR...'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // bool _isFlashOn(String current) {
  //   return flashOn == current;
  // }

  // bool _isBackCamera(String current) {
  //   return backCamera == current;
  // }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        print('qrText = $qrText');
        Navigator.pop(context, qrText);
        
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }
 


}