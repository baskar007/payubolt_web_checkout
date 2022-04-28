import 'dart:math';
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
      debugShowCheckedModeBanner: false,
      title: 'PayUMoney WebCheckout',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PayU Web Checkout'),
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
  Map<String, dynamic>? response;

  @override
  void initState() {
    _payUWebCheckout = PayUWebCheckout();
    super.initState();

    _payUWebCheckout.on(
        PayUWebCheckout.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _payUWebCheckout.on(
        PayUWebCheckout.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _payUWebCheckout.clear();
    super.dispose();
  }

  void _pay() {
    _payUWebCheckout.doPayment(
        context: context,
        payuWebCheckoutModel: PayuWebCheckoutModel(
            key: "JPM7Fg",
            salt: "TuxqAugd",
            txnId: Random().nextInt(10000).toString(),
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
            successUrl: "https://payu.mayurpitroda.com/payu_success.php",
            failedUrl: "https://payu.mayurpitroda.com/payu_failed.php",
            baseUrl: "https://test.payu.in"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                        ),
                        onPressed: () {
                          _pay();
                        },
                        child: const Text('Pay'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                        ),
                        onPressed: () {
                          setState(() {
                            response = null;
                          });
                        },
                        child: const Text('Clear'),
                      ),
                    ),
                  ],
                ),
                response == null
                    ? Container()
                    : Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10.0),
                        child: Table(
                          columnWidths: const {0: FractionColumnWidth(.3)},
                          border: TableBorder.all(color: Colors.black),
                          children: response!.entries.map((e) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(e.key),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(e.value),
                                )
                              ],
                            );
                          }).toList(),
                        ),
                      )
              ],
            ),
          ),
        ));
  }

  void _handlePaymentSuccess(Map<String, dynamic> response) {
    setState(() {
      this.response = response;
    });
  }

  void _handlePaymentError(Map<String, dynamic> response) {
    setState(() {
      this.response = response;
    });
  }
}
