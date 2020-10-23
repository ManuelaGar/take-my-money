import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'components.dart';
import 'upgrade.dart';

class ParentalGate extends StatefulWidget {
  @override
  _ParentalGateState createState() => _ParentalGateState();
}

class _ParentalGateState extends State<ParentalGate> {
  String answer;
  int firstNumber = 0;
  int secondNumber = 0;
  String solution;
  final myController = TextEditingController();

  void solvePuzzle() {
    firstNumber = generateRandomNumbers();
    secondNumber = generateRandomNumbers();
    solution = (firstNumber + secondNumber).toString();
    setState(() {});
  }

  generateRandomNumbers() {
    int min = 11;
    int max = 95;
    print('max is ' + max.toString());
    int randomNumber = min + (Random().nextInt(max - min));
    return randomNumber;
  }

  @override
  void initState() {
    firstNumber = generateRandomNumbers();
    secondNumber = generateRandomNumbers();
    solution = (firstNumber + secondNumber).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TopBarAgnosticNoIcon(
      text: 'Parental Gate',
      style: kSendButtonTextStyle,
      uniqueHeroTag: 'parental_gate',
      child: Scaffold(
        backgroundColor: kColorPrimary,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Hero(
                      tag: 'logo',
                      child: CircleAvatar(
                        backgroundColor: kColorPrimary,
                        radius: 50.0,
                        backgroundImage: AssetImage("assets/money.png"),
                      ),
                    ),
                  ),
                  Text(
                    'Ask parent/guarding for help',
                    textAlign: TextAlign.center,
                    style: kSendButtonTextStyle,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    'Please hand over the device to a parent or a guardian to continue.',
                    style: kSendButtonTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'How much is ${firstNumber.toString()} plus ${secondNumber.toString()}?',
                          textAlign: TextAlign.center,
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: kSendButtonTextStyle,
                    controller: myController,
                    autofocus: true,
                    onChanged: (value) {
                      answer = value;
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: RaisedButton(
                        color: kColorAccent,
                        textColor: kColorText,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Confirm',
                            style: kSendButtonTextStyle,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            myController.text = '';
                          });
                          if (answer == solution) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpgradeScreen(),
                                  settings:
                                      RouteSettings(name: 'Upgrade screen'),
                                ));
                          } else {
                            //try again
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
                                      'This is not correct. Please try again.',
                                      textAlign: TextAlign.center,
                                      style: kSendButtonTextStyle.copyWith(
                                          fontSize: 19, color: kColorText),
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
                                    solvePuzzle();
                                  },
                                  width: 127,
                                  color: kColorAccent,
                                  height: 52,
                                ),
                              ],
                            ).show();
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
