import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:woocommerce/presentations/screens/base/cart_screen.dart';
import 'package:woocommerce/presentations/screens/base/homescreen.dart';
import 'package:woocommerce/presentations/screens/base/shop_screen.dart';
import 'package:woocommerce/presentations/screens/base/wishlist_screen.dart';
import 'package:woocommerce/presentations/screens/onboarding.dart';
import 'services/providers_list.dart';
import 'presentations/screens/base/account_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) Wakelock.enable();
  await Firebase.initializeApp();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: ConnectionNotifier(
        disconnectedContent: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                '😣 You are currently offline',
                style: TextStyle(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'baloo da 2'),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              alignment: Alignment.center,
              height: 20,
              width: 20,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          ],
        ),
        connectedContent: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '😃 Back Online',
              style:
                  TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'baloo da 2'),
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 5),
            Icon(Icons.check, color: Colors.white)
          ],
        ),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FWoo Demo Store',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.grey[200],
              primarySwatch: Colors.red,
              primaryColor: Colors.red,
              fontFamily: 'Baloo Da 2',
            ),
            home: const FirstScreen()),
        // LoginScreen())
      ),
    );
  }
}

//display intro screen on first time app launch

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  FirstScreenState createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen> with AfterLayoutMixin<FirstScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('displayedIntroScreen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Base()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const OnboardingScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(
        color: Colors.red,
      ),
    ));
  }
}

//bottom nav bar
class Base extends StatefulWidget {
  final int? index;
  const Base({Key? key, this.index}) : super(key: key);

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  PersistentTabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.index ?? 0);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: pages(),
      items: _navBarItems(),
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      stateManagement: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }

  List<Widget> pages() {
    return [
      const HomeScreen(),
      const ShopScreen(),
      const CartScreen(),
      const WishlistScreen(),
      const AccountScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontFamily: 'baloo da 2'),
        icon: const Icon(
          CupertinoIcons.home,
        ),
        title: ("Home"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontFamily: 'baloo da 2'),
        icon: const Icon(CommunityMaterialIcons.store_outline),
        title: ("Shop"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontFamily: 'baloo da 2'),
        icon: const Icon(CommunityMaterialIcons.cart_variant),
        title: ("Cart"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontFamily: 'baloo da 2'),
        icon: const Icon(CupertinoIcons.heart),
        title: ("Wishlist"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontFamily: 'baloo da 2'),
        icon: const Icon(CupertinoIcons.person),
        title: ("Account"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
