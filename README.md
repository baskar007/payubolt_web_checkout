# PayU Web Checkout Flutter

Flutter plugin for PayU Web Checkout SDK.

[![pub package](https://img.shields.io/pub/v/payu_web_checkout)](https://pub.dev/packages/payu_web_checkout)

* [Getting Started](#getting-started)
* [Prerequisites](#prerequisites)
* [Installation](#installation)
* [Usage](#usage)
* [API](#api)
* [Example App](https://github.com/mayurpitroda96/payu_web_checkout/blob/master/example)

## Getting Started

This flutter plugin is a wrapper on PayU Hosted.

## Prerequisites

 - Learn about the <a href="https://developer.payumoney.com/" target="_blank">PayU Payment Flow</a>.
 - Sign up for a <a href="https://onboarding.payu.in/app/account/">PayU Account</a> and generate the <a href="https://developer.payumoney.com/test-mode/" target="_blank">API Keys</a> from the PayU Dashboard. Using the Test keys helps simulate a sandbox environment. No actual monetary transaction happens when using the Test keys. Use Live keys once you have thoroughly tested the application and are ready to go live.
 

## Installation

This plugin is available on Pub: [https://pub.dev/packages/payu_web_checkout](https://pub.dev/packages/payu_web_checkout)

Add this to `dependencies` in your app's `pubspec.yaml`

```yaml
payu_web_checkout: ^1.0.0
```

## Usage

Sample code to integrate can be found in [example/lib/main.dart](example/lib/main.dart).

#### Import package 

```dart
import 'package:payu_web_checkout/payu_web_checkout.dart';
```

#### Create PayUWebCheckout instance

```dart
_payUWebCheckout = PayUWebCheckout();
```

#### Attach event listeners

The plugin uses event-based communication, and emits events when payment fails or succeeds.

The event names are exposed via the constants `EVENT_PAYMENT_SUCCESS` and `EVENT_PAYMENT_ERROR` from the `PayUWebCheckout` class.

Use the `on(String event, Function handler)` method on the `PayUWebCheckout` instance to attach event listeners.

```dart
_payUWebCheckout.on(PayUWebCheckout.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
_payUWebCheckout.on(PayUWebCheckout.EVENT_PAYMENT_ERROR, _handlePaymentError);
```

The handlers would be defined somewhere as

```dart

void _handlePaymentSuccess(PaymentSuccessResponse response) {
  // Do something when payment succeeds
}

void _handlePaymentError(PaymentFailureResponse response) {
  // Do something when payment fails
}
```

To clear event listeners, use the `clear` method on the `PayUWebCheckout` instance.

```dart
_payUWebCheckout.clear(); // Removes all listeners
```

#### Setup options

```dart
  var payuWebCheckoutModel = PayuWebCheckoutModel(
    key: "<YOUR_KEY_HERE>",
    salt: "<YOUR_SALT_HERE>",
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
    successUrl: "<YOUR_SUCCESS_SERVER_URL_HERE>",
    failedUrl: "<YOUR_FAILED_SERVER_URL_HERE>",
    baseUrl: "https://test.payu.in"
  ); // Here PayU Production or Test BASE URL
```

A detailed list of options can be found [here](https://developer.payumoney.com/redirect/).

#### Open Checkout

```dart
_payUWebCheckout.doPayment(BuildContext context,PayuWebCheckoutModel payuWebCheckoutModel);
```

## API

### PayUWebCheckout

#### doPayment(BuildContext context,PayuWebCheckoutModel payuWebCheckoutModel)

DoPayment Funcation Open Payment Screen. 

The `BuildContext` and `PayuWebCheckoutModel` has a required property.

#### on(String eventName, Function listener)

Register event listeners for payment events.

- `eventName`: The name of the event.
- `listener`: The function to be called. The listener should accept a single argument of the following type:
  - [`PaymentSuccessResponse`](#paymentsuccessresponse) for `EVENT_PAYMENT_SUCCESS`
  - [`PaymentFailureResponse`](#paymentfailureresponse) for `EVENT_PAYMENT_FAILURE`

#### clear()

Clear all event listeners.


#### Event names

The event names have also been exposed as Strings by the `PayUWebCheckout` class.

| Event Name            | Description                      |
| --------------------- | -------------------------------- |
| EVENT_PAYMENT_SUCCESS | The payment was successful.      |
| EVENT_PAYMENT_ERROR   | The payment was not successful.  |

### PaymentSuccessResponse

| Type   | Description                   |
| ------ | ----------------------------- |
| Map    | It was the return map value.  |

### PaymentFailureResponse

| Type   | Description                     |
| ------ | ------------------------------- |
| Map    | It was the return map value.    |
