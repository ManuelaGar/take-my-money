import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:take_my_money/components.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'parental_gate.dart';
import 'upgrade.dart';
import 'components.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    appData.isPro = false;

    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("UcwsgaSyJjukqzwiuTIQaFqXQLhQeIlW");

    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
      print(purchaserInfo.toString());
      if (purchaserInfo.entitlements.all['all_features'] != null) {
        appData.isPro = purchaserInfo.entitlements.all['all_features'].isActive;
      } else {
        appData.isPro = false;
      }
    } on PlatformException catch (e) {
      print(e);
    }

    print('#### is user pro? ${appData.isPro}');
  }

  @override
  Widget build(BuildContext context) {
    return TopBarAgnosticNoIcon(
      text: 'Main Title',
      style: kSendButtonTextStyle,
      uniqueHeroTag: 'main',
      child: Scaffold(
        backgroundColor: kColorPrimary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Text(
                  'Welcome',
                  style: kSendButtonTextStyle.copyWith(fontSize: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RaisedButton(
                    color: kColorAccent,
                    textColor: kColorText,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Purchase a subscription',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                    onPressed: () {
                      if (appData.isPro) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpgradeScreen(),
                                settings:
                                    RouteSettings(name: 'Upgrade screen')));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParentalGate(),
                                settings:
                                    RouteSettings(name: 'Parental Gate')));
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
