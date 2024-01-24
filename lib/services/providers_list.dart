import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:woocommerce/models/order.dart';
import 'package:woocommerce/presentations/screens/base/cart_screen.dart';
import 'package:woocommerce/presentations/screens/base/homescreen.dart';
import 'package:woocommerce/presentations/screens/base/shop_screen.dart';
import 'package:woocommerce/presentations/screens/delete_acct.dart';
import 'package:woocommerce/presentations/screens/login.dart';
import 'package:woocommerce/presentations/screens/order_cancellation_screen.dart';
import 'package:woocommerce/presentations/screens/order_details_screen.dart';
import 'package:woocommerce/presentations/screens/payment_screen.dart';
import 'package:woocommerce/presentations/screens/product_details.dart';
import 'package:woocommerce/presentations/screens/products_by_category.dart';
import 'package:woocommerce/presentations/screens/products_by_tag_id.dart';
import 'package:woocommerce/presentations/screens/saved_cards_screen.dart';
import 'package:woocommerce/presentations/screens/signup.dart';
import 'package:woocommerce/presentations/widgets/orders_cancelled.dart';
import 'package:woocommerce/presentations/widgets/orders_processing.dart';
import 'package:woocommerce/presentations/widgets/orders_shipping.dart';
import 'package:woocommerce/presentations/widgets/shipping_address.dart';
import 'package:woocommerce/services/providers/cards_provider.dart';
import 'package:woocommerce/services/providers/delete_acct_provider.dart';
import 'package:woocommerce/services/providers/order_provider.dart';
import 'package:woocommerce/services/providers/wishlistprovider.dart';
import '../presentations/screens/base/account_screen.dart';
import '../presentations/widgets/billing_address.dart';
import '../presentations/widgets/orders_delivered.dart';
import '../presentations/widgets/product_details_widget.dart';
import 'providers/cart_provider.dart';
import 'providers/customer_details_provider.dart';
import 'providers/email_provider.dart';
import 'providers/loader_provider.dart';
import 'providers/product_provider.dart';
import 'providers/social_login.dart';

List<SingleChildWidget> providers = [
  //social login provider
  ChangeNotifierProvider(
    create: (context) => SocialLogin(),
    child: const SignUpScreen(),
  ),
  ChangeNotifierProvider(
    create: (context) => SocialLogin(),
    child: const LoginScreen(),
  ),
  
  //product provider
  ChangeNotifierProvider(
    create: (context) => ProductProvider(),
    child: const HomeScreen(),
  ),
  ChangeNotifierProvider(
    create: (context) => ProductProvider(),
    child: const ProductsByTagId(),
  ),
  ChangeNotifierProvider(
    create: (context) => ProductProvider(),
    child: const ProductByCategoryScreen(categoryId: '', categoryName: '',),
  ),
  ChangeNotifierProvider(
    create: (context) => ProductProvider(),
    child: const ShopScreen(),
  ),
  ChangeNotifierProvider(
    create: (context) => ProductProvider(),
    child: OrderDetailsScreen(model: OrderModel(lineItems: []),),
  ),

  //cart provider
  ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: const HomeScreen(),
  ),
  ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: const CartScreen(),
  ),
  ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: const ProductDetails(),
  ),
  ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: const ProductDetailsWidget(),
  ),
  ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: const PaymentScreen(),
  ),

  //loader provider
  ChangeNotifierProvider(
    create: (context) => LoaderProvider(),
    child: const ProductDetails(),
  ),
  ChangeNotifierProvider(
    create: (context) => LoaderProvider(),
    child: const CartScreen(),
  ),
  
  //wishlist provider
  ChangeNotifierProvider(
    create: (context) => WishListProvider(),
    child: const ProductDetailsWidget(),
  ),

  //customer deatails provider
  ChangeNotifierProvider(
    create: (context) => CustomerDetailsProvider(),
    child: const AccountScreen(),
  ),
  ChangeNotifierProvider(
    create: (context) => CustomerDetailsProvider(),
    child: const BillingAddress(email_: '', firstName_: '', lastName_: '',),
  ),
  ChangeNotifierProvider(
    create: (context) => CustomerDetailsProvider(),
    child: const ShippingAddress(email_: '', firstName_: '', lastName_: '',),
  ),

  //credit card provider
  ChangeNotifierProvider(
    create: (context) => CardsProvider(),
    child: const SavedCardsScreen(),
  ),
  ChangeNotifierProvider(
    create: (context) => CardsProvider(),
    child: const PaymentScreen(),
  ),
  ChangeNotifierProvider(
    create: (context) => CardsProvider(),
    child: const LoginScreen(),
  ),

  //delete acct provider
  ChangeNotifierProvider(
    create: (context) => DeleteAccountProvider(),
    child: const DeleteAccount(email: '', username: '',),
  ),

  //order provider
  ChangeNotifierProvider(
    create: (context) => OrderProvider(),
    child: const ProcessingOrders(),
  ),
  ChangeNotifierProvider(
    create: (context) => OrderProvider(),
    child: const ShippingOrders(),
  ),
  ChangeNotifierProvider(
    create: (context) => OrderProvider(),
    child: const DeliveredOrders(),
  ),
  ChangeNotifierProvider(
    create: (context) => OrderProvider(),
    child: const CancelledOrders(),
  ),
  ChangeNotifierProvider(
    create: (context) => OrderProvider(),
    child: OrderDetailsScreen(model: OrderModel(lineItems: []),),
  ),

  //email provider
  ChangeNotifierProvider(
    create: (context) => EmailProvider(),
    child: const SignUpScreen()
  ),
  ChangeNotifierProvider(
    create: (context) => EmailProvider(),
    child: const PaymentScreen()
  ),
  ChangeNotifierProvider(
    create: (context) => EmailProvider(),
    child: const DeleteAccount(email: '', username: '',),
  ),
  ChangeNotifierProvider(
    create: (context) => EmailProvider(),
    child: const OrderCancellattionScreen(orderId: '', userEmail: '', userName: '',)
  ),

];
