import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payu_web_checkout/payu_web_checkout.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class PayuWebCheckoutWidget extends StatefulWidget {
  PayuWebCheckoutModel payuWebCheckoutModel;
  Function(Map<String, dynamic>) onSuccess;
  Function(Map<String, dynamic>) onFailed;

  PayuWebCheckoutWidget(
      {Key? key,
      required this.payuWebCheckoutModel,
      required this.onSuccess,
      required this.onFailed})
      : super(key: key);

  @override
  _PayuWebCheckoutWidgetState createState() => _PayuWebCheckoutWidgetState();
}

class _PayuWebCheckoutWidgetState extends State<PayuWebCheckoutWidget> {
  late WebViewController _controller;
  bool isLoading = true;
  final _key = UniqueKey();

  String webViewClientPost() {
    var buf = StringBuffer();
    buf.write("<html><head></head>");
    buf.write("<body>");
    buf.write(
        '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>');
    if (widget.payuWebCheckoutModel.env == 'live') {
      buf.write("<script id='bolt' "
          "src='https://checkout-static.citruspay.com/bolt/run/bolt.min.js' "
          "bolt-color='e34524'  "
          "bolt-logo='http://boltiswatching.com/wp-content/uploads/2015/09/Bolt-Logo-e14421724859591.png'>"
          "</script>");
    } else {
      buf.write("<script id='bolt' "
          "src='https://sboxcheckout-static.citruspay.com/bolt/run/bolt.min.js' "
          "bolt-color='e34524' "
          "bolt-logo='http://boltiswatching.com/wp-content/uploads/2015/09/Bolt-Logo-e14421724859591.png'>"
          "</script>");
    }

    buf.write('''<script>
					var meta = document.createElement('meta');
					meta.name = 'viewport';
					meta.content = 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no';
					document.getElementsByTagName('head')[0].appendChild(meta);
				
						function launchBOLT()
						{
							if(typeof bolt == 'undefined'){
								alert('BOLT not loaded yet...');
								return false;
							}

						bolt.launch({
						key: '${widget.payuWebCheckoutModel.key}',
						txnid: '${widget.payuWebCheckoutModel.txnId}', 
						hash: '${widget.payuWebCheckoutModel.payUhash}',
						amount: '${widget.payuWebCheckoutModel.amount}',
						firstname: '${widget.payuWebCheckoutModel.firstName}',
						email: '${widget.payuWebCheckoutModel.email}',
						phone: '${widget.payuWebCheckoutModel.phone}',
						productinfo: '${widget.payuWebCheckoutModel.productName}',
						udf5: '${widget.payuWebCheckoutModel.udf5}',
						surl : '${widget.payuWebCheckoutModel.successUrl}',
						furl: '${widget.payuWebCheckoutModel.failedUrl}'
						},{ responseHandler: function(BOLT){
								console.log( BOLT.response.txnStatus );		
								if(BOLT.response.txnStatus != 'CANCEL')
								{
								var fr = '<form action=\"${widget.payuWebCheckoutModel.successUrl}\" method=\"post\">' +
                    '<input type=\"hidden\" name=\"key\" value=\"'+BOLT.response.key+'\" />' +
                    '<input type=\"hidden\" name=\"txnid\" value=\"'+BOLT.response.txnid+'\" />' +
                    '<input type=\"hidden\" name=\"amount\" value=\"'+BOLT.response.amount+'\" />' +
                    '<input type=\"hidden\" name=\"productinfo\" value=\"'+BOLT.response.productinfo+'\" />' +
                    '<input type=\"hidden\" name=\"firstname\" value=\"'+BOLT.response.firstname+'\" />' +
                    '<input type=\"hidden\" name=\"email\" value=\"'+BOLT.response.email+'\" />' +
                    '<input type=\"hidden\" name=\"udf5\" value=\"'+BOLT.response.udf5+'\" />' +
                    '<input type=\"hidden\" name=\"mihpayid\" value=\"'+BOLT.response.mihpayid+'\" />' +
                    '<input type=\"hidden\" name=\"status\" value=\"'+BOLT.response.status+'\" />' +
                    '<input type=\"hidden\" name=\"hash\" value=\"'+BOLT.response.hash+'\" />' +
  								'</form>';
								var form = jQuery(fr);
								jQuery('body').append(form);								
								form.submit();
								}
							},
							catchException: function(BOLT){
								alert( BOLT.message );
							}
						});
						}
						setTimeout(launchBOLT, 2500);

					</script>''');

    // buf.write(
    //     "<form id='form1' action='${widget.payuWebCheckoutModel.baseUrl}/_payment' method='POST'>");

    // widget.payuWebCheckoutModel.webParameter().forEach((key, value) {
    //   buf.write("<input name='$key' type='hidden' value='$value' />");
    // });
    // buf.write("</form></body></html>");
    buf.write("</body></html>");
    return buf.toString();
  }

  String webViewClientPostOLD() {
    var buffer = StringBuffer();
    buffer.write("<html><head></head>");
    buffer.write("<body onload='form1.submit()'>");
    buffer.write(
        "<form id='form1' action='${widget.payuWebCheckoutModel.baseUrl}/_payment' method='POST'>");

    widget.payuWebCheckoutModel.webParameter().forEach((key, value) {
      buffer.write("<input name='$key' type='hidden' value='$value' />");
    });
    buffer.write("</form></body></html>");
    return buffer.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  showPaymentCancelDialog(BuildContext context) {
    // set up the button
    Widget yesButton = TextButton(
      child: const Text("YES"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        widget.onFailed({
          "status": "failure",
          "error_message": "User canceled the payment"
        });
      },
    );

    Widget noButton = TextButton(
      child: const Text("NO"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: const [
          Text("Exiting payment"),
        ],
      ),
      content: const Text("Are you sure you want to exit payment?"),
      actions: [noButton, yesButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showPaymentCancelDialog(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0.0,
          title: Text("Order #${widget.payuWebCheckoutModel.txnId}",
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          actions: [
            Center(
              child: Text(
                "₹ ${widget.payuWebCheckoutModel.amount}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Stack(
          children: [
            WebView(
              key: _key,
              initialUrl: "about:blank",
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
                _loadHtmlFromUrl();
              },
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (value) async {
                await Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    isLoading = false;
                  });
                });
                if (value == widget.payuWebCheckoutModel.successUrl) {
                  Map<String, dynamic> parameter = {};
                  String pTagLagth =
                      await _controller.runJavascriptReturningResult(
                          'window.document.getElementsByTagName("p").length;');
                  for (int i = 0; i < int.parse(pTagLagth); i++) {
                    String keyValue =
                        await _controller.runJavascriptReturningResult(
                            'window.document.getElementsByTagName("p")[$i].innerHTML;');

                    parameter[keyValue.replaceAll("\"", "").split(":")[0]] =
                        keyValue.replaceAll("\"", "").split(":")[1];
                  }
                  widget.onSuccess(parameter);
                  Navigator.pop(context);
                } else if (value == widget.payuWebCheckoutModel.failedUrl) {
                  Map<String, dynamic> parameter = {};

                  String pTagLagth =
                      await _controller.runJavascriptReturningResult(
                          'window.document.getElementsByTagName("p").length;');

                  for (int i = 0; i < int.parse(pTagLagth); i++) {
                    String keyValue =
                        await _controller.runJavascriptReturningResult(
                            'window.document.getElementsByTagName("p")[$i].innerHTML;');

                    parameter[keyValue.replaceAll("\"", "").split(":")[0]] =
                        keyValue.replaceAll("\"", "").split(":")[1];
                  }
                  widget.onFailed(parameter);
                  Navigator.pop(context);
                }
              },
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(),
          ],
        ),
      ),
    );
  }

  _loadHtmlFromUrl() async {
    String html = webViewClientPost();
    _controller.loadUrl(Uri.dataFromString(html,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
