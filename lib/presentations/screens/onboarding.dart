import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _initSharedPrefs();
  }

  //init shared prefs
  _initSharedPrefs() async {
    _preferences = await SharedPreferences.getInstance();
  }

  _endIntroScreen(context) async {
    await _preferences.setBool('displayedIntroScreen', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
        showDoneButton: true,
        showNextButton: true,
        // showSkipButton: true,
        // skip: const Text(
          // 'Skip',
        //   style: TextStyle(
        //     fontFamily: 'baloo da 2',
        //     fontWeight: FontWeight.w500,
        //     fontSize: 17,
        //     color: Colors.red
        //   ),
        // ),
        next: const Text(
          'Next',
          style: TextStyle(
            fontFamily: 'baloo da 2',
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Colors.red
          ),
        ),
        done: const Text(
          'Sign Up',
          style: TextStyle(
            fontFamily: 'baloo da 2',
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Colors.red
          ),
        ),
        onDone: () {_endIntroScreen(context);},
        pages: [
          PageViewModel(
            title: 'FWOO Demo Store',
            body: 'Welcome to the FWOO Demo Store. This is a demo store that is used to showcase the functionality of the Flutter and Woocommerce. Some important info are in the next slides.',
            // image: Image.asset('assets/onboarding/card.jpg'),
            decoration: const PageDecoration(
              fullScreen: true,
              imageAlignment: Alignment.center,
              imagePadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              footerPadding: EdgeInsets.zero,
               ),
          ),

          PageViewModel(
            title: 'Demo credit cards creation',
            body: 'Since this is a demo app, we have created some credit cards for you to use. You can use them to test the functionality of the app. All the payment options are in test mode',
            image: Image.asset('assets/onboarding/card.jpg'),
            decoration: const PageDecoration(
              fullScreen: false,
              imageAlignment: Alignment.center,
              imagePadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              footerPadding: EdgeInsets.zero,
               ),
          ),

          PageViewModel(
            title: 'How to use cards',
            body: '''
1. The first card is for Paystack payment gateway.
2. The second and third cards are for Stripe payment gateway.
3. For Paypal, use the following sandbox credentials:
  - Email: sb-uqx5b8986025@personal.example.com
  - Password: ^kO026/+

  You should screenshot the credentials for later use.
''',
            image: Image.asset('assets/onboarding/checkout.jpg'),
            decoration: const PageDecoration(
              fullScreen: false,
               ),
          ),

          PageViewModel(
            title: 'WooCommerce Admin App',
            body: 'If you want to use the WooCommerce Admin App so you can manage your store from your mobile device, visit your app store and search for WooCommerce.',
            image: Image.asset('assets/onboarding/woocommerce_admin.PNG'),
            decoration: const PageDecoration(
              fullScreen: false,
               ),
          ),

        ],
      );
  }
}