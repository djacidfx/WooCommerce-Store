import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/presentations/widgets/elevated_button.dart';
import 'package:woocommerce/presentations/widgets/snackbar.dart';
import '../../services/providers/email_provider.dart';

class OrderCancellattionScreen extends StatefulWidget {
  final String orderId;
  final String userEmail;
  final String userName;

  const OrderCancellattionScreen(
      {Key? key, required this.orderId, required this.userEmail, required this.userName})
      : super(key: key);

  @override
  State<OrderCancellattionScreen> createState() => _OrderCancellattionScreenState();
}

class _OrderCancellattionScreenState extends State<OrderCancellattionScreen> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String? userReason;
  FocusNode focusNode = FocusNode();
  bool isApiCallProcess = false;bool isLoading = false;
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var emailProvider = Provider.of<EmailProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            "Cancel Order",
            style: TextStyle(
                fontFamily: 'baloo da 2',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.black),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.chevron_left, color: Colors.black)),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Let us know why you are cancelling this order. Kindly note that orders cannot be cancelled after they are prepared for shipping",
                  style: TextStyle(
                      fontFamily: 'baloo da 2',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Form(
                  key: globalKey,
                  child: Column(children: <Widget>[
                    TextFormField(
                      maxLines: 3,
                      controller: message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'baloo da 2',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      cursorColor: Colors.red,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: focusNode,
                      onSaved: (value) {
                        userReason = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field is required.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter a valid reason here',
                        hintStyle: const TextStyle(
                            fontFamily: 'baloo da 2',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black54),
                        errorStyle: const TextStyle(
                          fontFamily: 'baloo da 2',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.red,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.all(6),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    isApiCallProcess
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : elevatedButton(
                            icon: Icons.send,
                            text: 'Send',
                            onPressed: () {
                              if (globalKey.currentState!.validate()) {
                                focusNode.unfocus();
                                globalKey.currentState!.save();
                                setState(() {
                                  isApiCallProcess = true;
                                });
                                emailProvider.sendEmail(
                                    serviceId: 'service_y7u4vu6',
                                    templateId: 'template_zebdu95',
                                    userId: 'rzOO7Q2LMKs_8SeqP',
                                    parameters: {
                                      'user_name': widget.userName,
                                      'user_email': widget.userEmail,
                                      'subject': 'Order Cancellation',
                                      'body': """
Order id: ${widget.orderId} \n
Order Cancellation Reason: ${message.text}
""",
                                    }).then((value) {
                                  setState(() {
                                    isApiCallProcess = false;
                                    message.clear();
                                  });
                                  snackbar(context, 'Message Sent', Colors.white, Colors.green);
                                });
                              }
                            }),
                  ]),
                ),
              ],
            ))));
  }
}
