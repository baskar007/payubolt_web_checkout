import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:payu_web_checkout/payu_web_checkout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayUMoney WebCheckout',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PayUMoney'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PayUWebCheckout _payUWebCheckout;

  @override
  void initState() {
    _payUWebCheckout = PayUWebCheckout();
    super.initState();

    _payUWebCheckout.on(
        PayUWebCheckout.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _payUWebCheckout.on(
        PayUWebCheckout.EVENT_PAYMENT_SUCCESS, _handlePaymentError);
  }

  @override
  void dispose() {
    _payUWebCheckout.clear();
    super.dispose();
  }

  void _payment() {
    _payUWebCheckout.doPayment(
        context: context,
        payuWebCheckoutModel: PayuWebCheckoutModel(
            key: "JPM7Fg",
            salt: "TuxqAugd",
            txnId: DateTime.now().millisecondsSinceEpoch.toString(),
            phone: '9979999799',
            amount: "10.00",
            productName: "iPhone",
            firstName: "PayU User",
            email: "test@gmail.com",
            udf1: "",
            udf2: "",
            udf3: "",
            udf4: "",
            udf5: "",
            successUrl:
                "https://payu-lib-php.code.caprover.cf/payu_success.php",
            failedUrl: "https://payu-lib-php.code.caprover.cf/payu_failed.php",
            baseUrl: "https://test.payu.in"));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container());
  }

  void _handlePaymentSuccess(Map<String, dynamic> response) {
    if (kDebugMode) {
      print(response["status"]);
    }
  }

  void _handlePaymentError(Map<String, dynamic> response) {
    if (kDebugMode) {
      print(response["status"]);
    }
  }
}
