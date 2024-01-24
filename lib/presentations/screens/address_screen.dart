import 'package:flutter/material.dart';
import '../widgets/billing_address.dart';
import '../widgets/shipping_address.dart';

class AddressScreen extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  const AddressScreen({Key? key, required this.email, required this.firstName, required this.lastName}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            toolbarHeight: 55,
            title: const Text(
              'Addresses',
              style:
                  TextStyle(fontFamily: 'baloo da 2', fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            bottom: const TabBar(
              indicatorColor: Colors.red,
              tabs: [
                Tab(
                  child: Text(
                    'Billing Address',
                    style: TextStyle(
                        fontFamily: 'baloo da 2', fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
                Tab(
                  child: Text(
                    'Shipping Address',
                    style: TextStyle(
                        fontFamily: 'baloo da 2', fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )),
        body: TabBarView(
          children: [
            BillingAddress(email_: widget.email, firstName_: widget.firstName, lastName_: widget.lastName),
            ShippingAddress(email_: widget.email, firstName_: widget.firstName, lastName_: widget.lastName),
          ],
        ),
      ),
    );
  }
}
