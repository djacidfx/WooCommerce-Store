import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:woocommerce/presentations/screens/login.dart';

class UnAuthWidget extends StatelessWidget {
  const UnAuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          height: 350,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 20, spreadRadius: 1)
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 175,
                color: Colors.red,
                child: const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              const Text(
                'You must sign in to access this page',
                style: TextStyle(
                  fontFamily: 'baloo da 2',
                  fontWeight: FontWeight.normal,
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    pushNewScreen(
                      context,
                      screen: const LoginScreen(),
                      withNavBar: false, 
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red), 
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 35)),
                  ),
                  child: Text(
                    'Login'.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'baloo da 2',
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ))
            ],
          ),
        ),    );
  }
}
