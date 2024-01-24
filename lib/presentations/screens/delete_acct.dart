import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/services/providers/delete_acct_provider.dart';
import 'package:woocommerce/services/woocommerce_api_service.dart';
import '../../main.dart';
import '../../services/providers/email_provider.dart';
import '../widgets/elevated_button.dart';
import '../widgets/snackbar.dart';
import 'privacy_policy.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key, required this.email, required this.username}) : super(key: key);
  final String email;
  final String username;

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String? userReason;
  late WooApiService apiService;
  FocusNode focusNode = FocusNode();
  TextEditingController message = TextEditingController();

  @override
  void initState() {
    apiService = WooApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var emailProvider = Provider.of<EmailProvider>(context);
    var deleteAcctProvider = Provider.of<DeleteAccountProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            "Delete Account",
            style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),
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
                  "We're sorry to see you go. 😢 \n Kindly note that your details are safe with us. \n Please state why you want to delete your account below.",
                  style: TextStyle(
                      fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
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
                          return 'Please help us understand why you want to delete your account.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'I want to delete my account because...',
                        hintStyle: const TextStyle(
                            fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black54),
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
                    const SizedBox(height: 20),
                    const Text(
                      "Please note that you will not be able to recover your account once you delete it. \n Are you sure you want to delete your account?",
                      style: TextStyle(
                          fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    isApiCallProcess
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : elevatedButton(
                            icon: Icons.send,
                            text: 'Send & Delete',
                            onPressed: () {
                              if (globalKey.currentState!.validate()) {
                                focusNode.unfocus();
                                globalKey.currentState!.save();
                                setState(() {
                                  isApiCallProcess = true;
                                });
                                deleteAcctProvider.deleteAccount();
                                emailProvider.sendEmail(
                                    serviceId: '',
                                    templateId: '',
                                    userId: '',
                                    parameters: {
                                      'user_name': widget.username,
                                      'user_email': widget.email,
                                      'body': message.text,
                                    }).then((value) {
                                  setState(() {
                                    isApiCallProcess = false;
                                    message.clear();
                                  });
                                  snackbar(context, 'Your account has been deleted', Colors.white, Colors.green);
                                });
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyApp()));
                              }
                            }),
                    Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      // padding: const EdgeInsets.symmetric(horizontal: 5),
                      margin: const EdgeInsets.only(top: 60),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'Visit our ',
                              style: const TextStyle(
                                  fontFamily: 'baloo da 2',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.black),
                              children: [
                                TextSpan(
                                    text: 'privacy policy',
                                    style: const TextStyle(
                                        fontFamily: 'baloo da 2',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.red),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (_) => const PrivacyPolicy()));
                                      }),
                                const TextSpan(
                                    text: ' page to undertsand how we use your data',
                                    style: TextStyle(
                                        fontFamily: 'baloo da 2',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.black)),
                              ])),
                    ),
                  ]),
                ),
              ],
            ))));
  }
}
