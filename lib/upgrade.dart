import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'components.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

PurchaserInfo _purchaserInfo;

class UpgradeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  Offerings _offerings;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
    } on PlatformException catch (e) {
      print(e);
    }

    Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _purchaserInfo = purchaserInfo;
      _offerings = offerings;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_purchaserInfo == null) {
      return TopBarAgnosticNoIcon(
        text: "Upgrade Screen",
        style: kSendButtonTextStyle,
        uniqueHeroTag: 'upgrade_screen',
        child: Scaffold(
            backgroundColor: kColorPrimary,
            body: Center(
                child: Text(
              "Loading...",
            ))),
      );
    } else {
      if (_purchaserInfo.entitlements.all.isNotEmpty &&
          _purchaserInfo.entitlements.all['Premium'].isActive != null) {
        appData.isPro = _purchaserInfo.entitlements.all['Premium'].isActive;
      } else {
        appData.isPro = false;
      }
      if (appData.isPro) {
        return ProScreen();
      } else {
        return UpsellScreen(
          offerings: _offerings,
        );
      }
    }
  }
}

class UpsellScreen extends StatefulWidget {
  final Offerings offerings;

  UpsellScreen({Key key, @required this.offerings}) : super(key: key);

  @override
  _UpsellScreenState createState() => _UpsellScreenState();
}

class _UpsellScreenState extends State<UpsellScreen> {
  _launchURLWebsite(String zz) async {
    if (await canLaunch(zz)) {
      await launch(zz);
    } else {
      throw 'Could not launch $zz';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.offerings != null) {
      print('offeringS is not null');
      print(widget.offerings.current.toString());
      print('--');
      print(widget.offerings.toString());
      final offering = widget.offerings.current;
      if (offering != null) {
        final monthly = offering.monthly;
        if (monthly != null) {
          return TopBarAgnosticNoIcon(
            text: "Upgrade Screen",
            style: kSendButtonTextStyle,
            uniqueHeroTag: 'purchase_screen',
            child: Scaffold(
                backgroundColor: kColorPrimary,
                body: Center(
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Thanks for your interest in our app!',
                        textAlign: TextAlign.center,
                        style: kSendButtonTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: CircleAvatar(
                          backgroundColor: kColorPrimary,
                          radius: 45.0,
                          backgroundImage: AssetImage("assets/money.png"),
                        ),
                      ),
                      Text(
                        'Choose one of the plan to continue to get access to all the app content.\n',
                        textAlign: TextAlign.center,
                        style: kSendButtonTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PurchaseButton(package: monthly),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              color: kColorPrimaryDark,
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                'Restore Purchase',
                                style: kSendButtonTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            try {
                              print('now trying to restore');
                              PurchaserInfo restoredInfo =
                                  await Purchases.restoreTransactions();
                              print('restore completed');
                              print(restoredInfo.toString());

                              appData.isPro = restoredInfo
                                  .entitlements.all["Premium"].isActive;

                              print('is user pro? ${appData.isPro}');

                              if (appData.isPro) {
                                Alert(
                                  context: context,
                                  style: kWelcomeAlertStyle,
                                  image: Image.asset(
                                    "assets/money.png",
                                    height: 150,
                                  ),
                                  title: "Congratulation",
                                  content: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0,
                                            right: 8.0,
                                            left: 8.0,
                                            bottom: 20.0),
                                        child: Text(
                                          'Your purchase has been restored!',
                                          textAlign: TextAlign.center,
                                          style: kSendButtonTextStyle,
                                        ),
                                      )
                                    ],
                                  ),
                                  buttons: [
                                    DialogButton(
                                      radius: BorderRadius.circular(10),
                                      child: Text(
                                        "COOL",
                                        style: kSendButtonTextStyle,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      width: 127,
                                      color: kColorAccent,
                                      height: 52,
                                    ),
                                  ],
                                ).show();
                              } else {
                                Alert(
                                  context: context,
                                  style: kWelcomeAlertStyle,
                                  image: Image.asset(
                                    "assets/money.png",
                                    height: 150,
                                  ),
                                  title: "Error",
                                  content: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0,
                                            right: 8.0,
                                            left: 8.0,
                                            bottom: 20.0),
                                        child: Text(
                                          'There was an error. Please try again later',
                                          textAlign: TextAlign.center,
                                          style: kSendButtonTextStyle,
                                        ),
                                      )
                                    ],
                                  ),
                                  buttons: [
                                    DialogButton(
                                      radius: BorderRadius.circular(10),
                                      child: Text(
                                        "COOL",
                                        style: kSendButtonTextStyle,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      width: 127,
                                      color: kColorAccent,
                                      height: 52,
                                    ),
                                  ],
                                ).show();
                              }
                            } on PlatformException catch (e) {
                              print('----xx-----');
                              var errorCode =
                                  PurchasesErrorHelper.getErrorCode(e);
                              if (errorCode ==
                                  PurchasesErrorCode.purchaseCancelledError) {
                                print("User cancelled");
                              } else if (errorCode ==
                                  PurchasesErrorCode.purchaseNotAllowedError) {
                                print("User not allowed to purchase");
                              }
                              Alert(
                                context: context,
                                style: kWelcomeAlertStyle,
                                image: Image.asset(
                                  "assets/money.png",
                                  height: 150,
                                ),
                                title: "Error",
                                content: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0,
                                          right: 8.0,
                                          left: 8.0,
                                          bottom: 20.0),
                                      child: Text(
                                        'There was an error. Please try again later',
                                        textAlign: TextAlign.center,
                                        style: kSendButtonTextStyle,
                                      ),
                                    )
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    radius: BorderRadius.circular(10),
                                    child: Text(
                                      "COOL",
                                      style: kSendButtonTextStyle,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    width: 127,
                                    color: kColorAccent,
                                    height: 52,
                                  ),
                                ],
                              ).show();
                            }
                            return UpgradeScreen();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: GestureDetector(
                          onTap: () {
                            _launchURLWebsite('https://google.com');
                          },
                          child: Text(
                            'Privacy Policy (click to read)',
                            style: kSendButtonTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: GestureDetector(
                          onTap: () {
                            _launchURLWebsite('https://yahoo.com');
                          },
                          child: Text(
                            'Term of Use (click to read)',
                            style: kSendButtonTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                )),
          );
        }
      }
    }
    return TopBarAgnosticNoIcon(
      text: "Upgrade Screen",
      style: kSendButtonTextStyle,
      uniqueHeroTag: 'upgrade_screen1',
      child: Scaffold(
          backgroundColor: kColorPrimary,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Icon(
                    Icons.error,
                    color: kColorText,
                    size: 44.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "There was an error. Please check that your device is allowed to make purchases and try again. Please contact us at xxx@xxx.com if the problem persists.",
                    textAlign: TextAlign.center,
                    style: kSendButtonTextStyle,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class PurchaseButton extends StatefulWidget {
  final Package package;

  PurchaseButton({Key key, @required this.package}) : super(key: key);

  @override
  _PurchaseButtonState createState() => _PurchaseButtonState();
}

class _PurchaseButtonState extends State<PurchaseButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        color: kColorPrimaryLight,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: RaisedButton(
                onPressed: () async {
                  try {
                    print('now trying to purchase');
                    _purchaserInfo =
                        await Purchases.purchasePackage(widget.package);
                    print('purchase completed');

                    appData.isPro =
                        _purchaserInfo.entitlements.all["Premium"].isActive;

                    print('is user pro? ${appData.isPro}');

                    if (appData.isPro) {
                      Alert(
                        context: context,
                        style: kWelcomeAlertStyle,
                        image: Image.asset(
                          "assets/money.png",
                          height: 150,
                        ),
                        title: "Congratulation",
                        content: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0,
                                  right: 8.0,
                                  left: 8.0,
                                  bottom: 20.0),
                              child: Text(
                                'Well done, you now have full access to the app',
                                textAlign: TextAlign.center,
                                style: kSendButtonTextStyle,
                              ),
                            )
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            radius: BorderRadius.circular(10),
                            child: Text(
                              "COOL",
                              style: kSendButtonTextStyle,
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            width: 127,
                            color: kColorAccent,
                            height: 52,
                          ),
                        ],
                      ).show();
                    } else {
                      Alert(
                        context: context,
                        style: kWelcomeAlertStyle,
                        image: Image.asset(
                          "assets/money.png",
                          height: 150,
                        ),
                        title: "Error",
                        content: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0,
                                  right: 8.0,
                                  left: 8.0,
                                  bottom: 20.0),
                              child: Text(
                                'There was an error. Please try again later',
                                textAlign: TextAlign.center,
                                style: kSendButtonTextStyle,
                              ),
                            )
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            radius: BorderRadius.circular(10),
                            child: Text(
                              "COOL",
                              style: kSendButtonTextStyle,
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            width: 127,
                            color: kColorAccent,
                            height: 52,
                          ),
                        ],
                      ).show();
                    }
                  } on PlatformException catch (e) {
                    print('----xx-----');
                    var errorCode = PurchasesErrorHelper.getErrorCode(e);
                    if (errorCode ==
                        PurchasesErrorCode.purchaseCancelledError) {
                      print("User cancelled");
                    } else if (errorCode ==
                        PurchasesErrorCode.purchaseNotAllowedError) {
                      print("User not allowed to purchase");
                    }
                    Alert(
                      context: context,
                      style: kWelcomeAlertStyle,
                      image: Image.asset(
                        "assets/money.png",
                        height: 150,
                      ),
                      title: "Error",
                      content: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 8.0, left: 8.0, bottom: 20.0),
                            child: Text(
                              'There was an error. Please try again later',
                              textAlign: TextAlign.center,
                              style: kSendButtonTextStyle,
                            ),
                          )
                        ],
                      ),
                      buttons: [
                        DialogButton(
                          radius: BorderRadius.circular(10),
                          child: Text(
                            "COOL",
                            style: kSendButtonTextStyle,
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          width: 127,
                          color: kColorAccent,
                          height: 52,
                        ),
                      ],
                    ).show();
                  }
                  return UpgradeScreen();
                },
                textColor: kColorText,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Buy ${widget.package.product.title}\n${widget.package.product.priceString}',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
              child: Text(
                '${widget.package.product.description}',
                textAlign: TextAlign.center,
                style: kSendButtonTextStyle.copyWith(
                    fontSize: 16, fontWeight: FontWeight.normal),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TopBarAgnosticNoIcon(
      text: "Upgrade Screen",
      style: kSendButtonTextStyle,
      uniqueHeroTag: 'pro_screen',
      child: Scaffold(
          backgroundColor: kColorPrimary,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Icon(
                    Icons.star,
                    color: kColorText,
                    size: 44.0,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "You are a Pro user.\n\nYou can use the app in all its functionality.\nPlease contact us at xxx@xxx.com if you have any problem",
                      textAlign: TextAlign.center,
                      style: kSendButtonTextStyle,
                    )),
              ],
            ),
          )),
    );
  }
}
