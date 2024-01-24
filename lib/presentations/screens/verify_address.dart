import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/presentations/screens/address_screen.dart';
import 'package:woocommerce/presentations/screens/payment_screen.dart';
import 'package:woocommerce/presentations/widgets/snackbar.dart';
import '../../models/customer.dart';
import '../../models/login_response.dart';
import '../../services/providers/customer_details_provider.dart';
import '../../utils/checkout_base.dart';
import '../../utils/shared_prefs.dart';
import '../widgets/elevated_button.dart';

class VerifyAddress extends CheckoutBase {
  const VerifyAddress(
      {Key? key})
      : super(key: key);


  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends CheckoutBaseState<VerifyAddress> {

  @override
  void initState() {
    super.initState();
    currentPage = 0;
  }

  @override
  Widget pageUI() {
    var _customerDetailsProvider = context.watch<CustomerDetailsProvider>();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FutureBuilder(
        future: SharedService.loginDetails(),
        builder: (BuildContext context, AsyncSnapshot<LoginResponseModel?> loginModel) {
          if (!loginModel.hasData) {
            return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
          } else {
            return FutureBuilder(
            future: _customerDetailsProvider.getCustomerDetails(),
            builder: (BuildContext context, AsyncSnapshot<CustomerModel?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              } else {
                if (snapshot.data!.shipping!.firstName!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      const Center(
                        child: Text(
                          'You have not set your shipping address yet. Please set your shipping address to continue.',
                          style: TextStyle(
                              fontFamily: 'baloo da 2', fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      elevatedButton(
                          icon: Icons.local_shipping_outlined,  text: 'Add Shipping Address', onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddressScreen(
                              email: loginModel.data!.data!.email!,
                            firstName: loginModel.data!.data!.firstName!,
                            lastName: loginModel.data!.data!.lastName!,
                            )));
                          })
                    ],
                  );
                } else {
                  var shipping = snapshot.data!.shipping;
                  var billing = snapshot.data!.billing;

                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        detailRow(label: 'Name:', value: shipping!.firstName! + ' ' + shipping.lastName!),
                        detailRow(label: 'Company:', value: shipping.company!),
                        detailRow(label: 'Address:', value: shipping.address1!),
                        detailRow(label: 'Address 2:', value: shipping.address2!),
                        detailRow(label: 'City:', value: shipping.city!),
                        detailRow(label: 'State:', value: shipping.state!),
                        detailRow(label: 'Country:', value: shipping.country!),
                        detailRow(label: 'Zip/Postal Code:', value: shipping.postcode!),
                        const SizedBox(height: 50),
                        elevatedButton(
                            icon: Icons.local_shipping_outlined, 
                            backgroundColor: Colors.black54,
                            text: 'Change Shipping Address', 
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddressScreen(
                              email: loginModel.data!.data!.email!,
                            firstName: loginModel.data!.data!.firstName!,
                            lastName: loginModel.data!.data!.lastName!,
                            )));
                            }),
                            const SizedBox(height: 10),
                        elevatedButton(
                          icon: Icons.payment, 
                          text: 'Proceed to Payment', 
                          onPressed: () {
                            if (billing!.firstName!.isEmpty && billing.email!.isEmpty) {
                              snackbar(
                                context, 
                                'You have not set a billing address', 
                                Colors.white, 
                                Colors.red
                              );
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentScreen(billing: billing, shipping: shipping)));
                            }
                            }),
                      ],
                    ),
                  );
                }
              }
            },
          );
        
          }
        }
      ),
    );
  }

  Widget detailRow({required String label, required String value}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'baloo da 2',
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'baloo da 2',
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
