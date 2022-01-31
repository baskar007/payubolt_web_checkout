class PayuWebCheckoutModel {
  //TEST KEY : JPM7Fg
  //TEST SALT : TuxqAugd
  late String key;
  late String salt;
  late String txnId;
  late String amount;
  late String productName;
  late String firstName;
  late String email;
  late String udf1;
  late String udf2;
  late String udf3;
  late String udf4;
  late String udf5;
  late String payUhash;
  late String baseUrl; //https://test.payu.in
  late String successUrl;
  late String failedUrl;
  late String phone;

  PayuWebCheckoutModel(
      {required String key,
      required String salt,
      required String txnId,
      required String amount,
      required String productName,
      required String phone,
      required String firstName,
      required String email,
      required String udf1,
      required String udf2,
      required String udf3,
      required String udf4,
      required String udf5,
      required String successUrl,
      required String failedUrl,
      required String baseUrl}) {
    this.key = key;
    this.salt = salt;
    this.txnId = txnId;
    this.amount = amount;
    this.productName = productName;
    this.phone = phone;
    this.firstName = firstName;
    this.email = email;
    this.udf1 = udf1;
    this.udf2 = udf2;
    this.udf3 = udf3;
    this.udf4 = udf4;
    this.udf5 = udf5;
    this.successUrl = successUrl;
    this.failedUrl = failedUrl;
    this.baseUrl = baseUrl;
  }

  Map<String, dynamic> webParameter() {
    return {
      "key": key,
      "txnid": txnId,
      "amount": amount,
      "productinfo": productName,
      "firstname": firstName,
      "email": email,
      'phone': phone,
      "surl": successUrl,
      "furl": failedUrl,
      "hash": payUhash
    };
  }
}
