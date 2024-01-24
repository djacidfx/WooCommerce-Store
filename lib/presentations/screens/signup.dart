import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/services/providers/social_login.dart';
import 'package:woocommerce/models/customer.dart';
import 'package:woocommerce/presentations/screens/login.dart';
import 'package:woocommerce/presentations/widgets/elevated_button.dart';
import 'package:woocommerce/presentations/widgets/snackbar.dart';
import 'package:woocommerce/utils/email_validator.dart';
import '../../services/providers/email_provider.dart';
import '../../services/woocommerce_api_service.dart';
import '../widgets/form_helper.dart';
import '../widgets/progress_indicator_modal.dart';
import 'privacy_policy.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final WooApiService _apiService = WooApiService();
  final CustomerModel _customerModel = CustomerModel();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  String? firstName;
  String? lastName;
  String? email;
  String? password;

  //progress HUD widget stack
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ProgressModal(
        child: Form(
          key: globalKey,
          child: _formUI(),
        ),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      ),
    );
  }

  //form UI
  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        //create an acct text
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'Create an account',
                style: TextStyle(fontFamily: 'baloo da 2', fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 25),
            //form
            Form(
                child: Column(children: [
              //firstname
              FormHelper.textInput(
                context,
                // _customerModel.firstName,
                "First Name",
                (value) => {
                  _customerModel.firstName = value,
                },
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return 'Please enter your first name.';
                  }
                  return null;
                },
                prefixIcon: const Icon(Icons.person), suffixIcon: const Icon(null),
                focusNode: focusNode1,
              ),
              const SizedBox(
                height: 10,
              ),

              //lastname
              FormHelper.textInput(
                context,
                // _customerModel.lastName,
                "Last Name",
                (value) => {
                  _customerModel.lastName = value,
                },
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
                prefixIcon: const Icon(Icons.person), suffixIcon: const Icon(null),
                focusNode: focusNode2,
              ),
              const SizedBox(
                height: 10,
              ),

              //email
              FormHelper.textInput(
                context,
                // _customerModel.email,
                "Email",
                (value) => {
                  _customerModel.email = value,
                },
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return 'Please enter Email Id';
                  }

                  if (value.isNotEmpty && value.toString().isValidEmail()) {
                    return 'Please enter valid Email Id';
                  }
                  return null;
                },
                prefixIcon: const Icon(Icons.email), suffixIcon: const Icon(null),
                focusNode: focusNode3,
              ),
              const SizedBox(
                height: 10,
              ),

              //password
              FormHelper.textInput(
                context,
                // _customerModel.password,
                "Password",
                (value) => {
                  _customerModel.password = value,
                },
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return 'Please enter Password.';
                  }
                  return null;
                },
                obscureText: hidePassword,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    }),
                focusNode: focusNode4,
              ),

              //have an acct
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: Row(
                      children: const [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontFamily: 'Baloo Da 2',
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 10),
                        FaIcon(FontAwesomeIcons.rightLong, color: Colors.red)
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              //submit button
              elevatedButton(icon: Icons.create, text: 'CREATE ACCOUNT', onPressed: submit)
            ])),

            //sign up with social media
            const SizedBox(height: 40),
            const Center(
              child: Text(
                '<<<   Or Sign up with   >>>',
                style: TextStyle(fontSize: 14, fontFamily: 'Baloo Da 2', fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            elevatedButton(
                icon: Icons.facebook, text: 'Facebook', onPressed: facebookSignIn, backgroundColor: Colors.blueAccent),
            const SizedBox(height: 10),
            elevatedButton(icon: CommunityMaterialIcons.google, text: 'Google', onPressed: googleSignIn),

            const SizedBox(height: 50),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Visit our ',
                    style: const TextStyle(
                        fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black),
                    children: [
                      TextSpan(
                          text: 'privacy policy',
                          style: const TextStyle(
                              fontFamily: 'baloo da 2', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacyPolicy()));
                            }),
                      const TextSpan(
                          text: ' page here',
                          style: TextStyle(
                              fontFamily: 'baloo da 2',
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.black)),
                    ])),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    focusNode1.unfocus();
    focusNode2.unfocus();
    focusNode3.unfocus();
    focusNode4.unfocus();
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void submit() {
    var emailProvider = Provider.of<EmailProvider>(context, listen: false);

    if (validateAndSave()) {
      debugPrint('${_customerModel.toJson()}');
      setState(() {
        isApiCallProcess = true;
      });

      _apiService.createCustomer(_customerModel).then((ret) {
        if (ret) {
          emailProvider.sendEmail(
            serviceId: '', 
            templateId: '', 
            userId: '',
            parameters: {
              'user_name': _customerModel.firstName! + ' ' + _customerModel.lastName!,
              'user_email': _customerModel.email,
            }, 
          );
          setState(() {
          isApiCallProcess = false;
        });
          snackbar(context, "✅✅✅ Account created successfully. Please login to continue.", Colors.white, Colors.green);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));          
        } else {
          setState(() {
        isApiCallProcess = false;
      });
          snackbar(context, "❌❌❌ Invalid or existing email id. Ensure there are no white spaces after your field texts",
              Colors.white, Colors.redAccent);
        }
      });
    }
  }

  void facebookSignIn() {
    setState(() {
      isApiCallProcess = true;
    });
    Provider.of<SocialLogin>(context, listen: false).fblogin(context).then((value) {
      setState(() {
        isApiCallProcess = false;
      });
    });
  }

  void googleSignIn() {
    setState(() {
      isApiCallProcess = true;
    });
    Provider.of<SocialLogin>(context, listen: false).googleLogin(context).then((value) {
      setState(() {
        isApiCallProcess = false;
      });
    });
  }
}
