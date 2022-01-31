library payu_web_checkout;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'payu_web_checkout_widget.dart';
import 'payu_web_checkout_model.dart';

class PayUWebCheckout {
  // Event names
  static const EVENT_PAYMENT_SUCCESS = 'payment.success';
  static const EVENT_PAYMENT_ERROR = 'payment.error';

  // EventEmitter instance used for communication
  late EventEmitter _eventEmitter;

  PayUWebCheckout() {
    _eventEmitter = EventEmitter();
  }

  /// Opens PayUMoney checkout
  Future doPayment(
      {required BuildContext context,
      required PayuWebCheckoutModel payuWebCheckoutModel}) async {
    payuWebCheckoutModel.payUhash = createHash(payuWebCheckoutModel);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PayuWebCheckoutWidget(
                  payuWebCheckoutModel: payuWebCheckoutModel,
                  onFailed: (response) {
                    _eventEmitter.emit(EVENT_PAYMENT_ERROR, null, response);
                  },
                  onSuccess: (response) {
                    _eventEmitter.emit(EVENT_PAYMENT_SUCCESS, null, response);
                  },
                )));
  }

  //Create hash and return hash string
  String createHash(PayuWebCheckoutModel payuWebCheckoutModel) {
    String? payhash = payuWebCheckoutModel.key +
        '|' +
        payuWebCheckoutModel.txnId +
        '|' +
        payuWebCheckoutModel.amount +
        '|' +
        payuWebCheckoutModel.productName +
        '|' +
        payuWebCheckoutModel.firstName +
        '|' +
        payuWebCheckoutModel.email +
        '|' +
        payuWebCheckoutModel.udf1 +
        '|' +
        payuWebCheckoutModel.udf2 +
        '|' +
        payuWebCheckoutModel.udf3 +
        '|' +
        payuWebCheckoutModel.udf4 +
        '|' +
        payuWebCheckoutModel.udf5 +
        '||||||' +
        payuWebCheckoutModel.salt;

    //Create hash
    var bytes = utf8.encode(payhash); // data being hashed
    var digest = sha512.convert(bytes);

    return digest.toString();
  }

  /// Registers event listeners for payment events
  void on(String event, Function handler) {
    // ignore: prefer_function_declarations_over_variables
    EventCallback cb = (event, cont) {
      handler(event.eventData);
    };
    _eventEmitter.on(event, null, cb);
  }

  /// Clears all event listeners
  void clear() {
    _eventEmitter.clear();
  }
}
