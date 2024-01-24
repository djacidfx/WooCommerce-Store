import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/models/customer_detail.dart';
import 'package:woocommerce/presentations/widgets/elevated_button.dart';
import 'package:woocommerce/presentations/widgets/snackbar.dart';
import 'package:woocommerce/services/providers/customer_details_provider.dart';
import '../../models/customer.dart';

class ShippingAddress extends StatefulWidget {
  final String email_;
  final String firstName_;
  final String lastName_;

  const ShippingAddress({Key? key, required this.email_, required this.firstName_, required this.lastName_}) : super(key: key);

  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _addressController1 = TextEditingController();
  final TextEditingController _addressController2 = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  FocusNode focusNodeFirstName = FocusNode();
  FocusNode focusNodeLastName = FocusNode();
  FocusNode focusNodeCompany = FocusNode();
  FocusNode focusNodeAddress1 = FocusNode();
  FocusNode focusNodeAddress2 = FocusNode();
  FocusNode focusNodeCity = FocusNode();
  FocusNode focusNodeState = FocusNode();
  FocusNode focusNodeCountry = FocusNode();
  FocusNode focusNodeZip = FocusNode();

  String? validateFirstName;
  String? validateLastName;
  String? validateAddress1;
  String? validateCity;
  String? validateState;
  String? validateCountry;
  String? validateZip;

  @override
  Widget build(BuildContext context) {
    var _customerDetailsProvider = context.watch<CustomerDetailsProvider>();

    return Scaffold(
      body: FutureBuilder(
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
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    const Center(
                      child: Text(
                        'No data found. Click on the plus icon to add a shipping address',
                        style: TextStyle(
                            fontFamily: 'baloo da 2', fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    elevatedButton(
                        icon: Icons.add, text: 'Add Shipping Address', onPressed: () => showFormBottomSheet(true))
                  ],
                ),
              );
            } else {
              var details = snapshot.data!.shipping;

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      detailRow(label: 'Name:', value: details!.firstName! + ' ' + details.lastName!),
                      detailRow(label: 'Company:', value: details.company!),
                      detailRow(label: 'Address:', value: details.address1!),
                      detailRow(label: 'Address 2:', value: details.address2!),
                      detailRow(label: 'City:', value: details.city!),
                      detailRow(label: 'State:', value: details.state!),
                      detailRow(label: 'Country:', value: details.country!),
                      detailRow(label: 'Zip/Postal Code:', value: details.postcode!),
                      const SizedBox(height: 50),
                      elevatedButton(
                          icon: Icons.edit, text: 'Edit Shpping Address', onPressed: () => showFormBottomSheet(false, details: details)),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future showFormBottomSheet(bool isAdd, {Shipping? details
}) async {
        if (isAdd == false) {
        _firstNameController.text = details!.firstName!;
        _lastNameController.text = details.lastName!;
        _companyController.text = details.company!;
        _addressController1.text = details.address1!;
        _addressController2.text = details.address2!;
        _cityController.text = details.city!;
        _stateController.text = details.state!;
        _countryController.text = details.country!;
        _zipController.text = details.postcode!;
      }

    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isScrollControlled: true,
        enableDrag: true,
        builder: (_) {
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        isAdd ? 'Add Shpping Address' : 'Update Shpping Address',
                        style: const TextStyle(
                            fontFamily: 'baloo da 2', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    //name
                    Row(
                      children: [
                        Expanded(
                          child: textFormField(
                            _firstNameController,
                            focusNodeFirstName,
                            validator: validateFirstName,
                            isRequired: true,
                            hintText: 'First Name',
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: textFormField(
                            _lastNameController,
                            focusNodeLastName,
                            validator: validateLastName,
                            isRequired: true,
                            hintText: 'Last Name',
                          ),
                        ),
                      ],
                    ),
                    // company
                    textFormField(
                      _companyController,
                      focusNodeCompany,
                      isRequired: false,
                      hintText: 'Company',
                    ),
                    // address1
                    textFormField(
                      _addressController1,
                      focusNodeAddress1,
                      validator: validateAddress1,
                      isRequired: true,
                      hintText: 'Address 1',
                    ),
                    // address2
                    textFormField(
                      _addressController2,
                      focusNodeAddress2,
                      isRequired: false,
                      hintText: 'Address 2',
                    ),
                    // city
                    textFormField(
                      _cityController,
                      focusNodeCity,
                      validator: validateCity,
                      isRequired: true,
                      hintText: 'City',
                    ),
                    // state
                    textFormField(
                      _stateController,
                      focusNodeState,
                      validator: validateState,
                      isRequired: true,
                      hintText: 'State',
                    ),
                    // country
                    textFormField(
                      _countryController,
                      focusNodeCountry,
                      validator: validateCountry,
                      isRequired: true,
                      hintText: 'Country',
                    ),
                    // zip
                    textFormField(
                      _zipController,
                      focusNodeZip,
                      validator: validateZip,
                      isRequired: true,
                      hintText: 'Zip/Postal Code',
                    ),
                     const SizedBox(height: 20),
                    // save button
                    elevatedButton(
                        icon: Icons.save,
                        text:  'Save Address',
                        onPressed: () {
                          if (validateAndSave()) {
                            var _customerDetailsProvider = Provider.of<CustomerDetailsProvider>(context, listen: false);

                            _customerDetailsProvider
                                .updateShippingDetails(
                                  widget.firstName_,
                                  widget.lastName_,
                                  widget.email_,
                                  context,
                                    firstName: _firstNameController.text.trim(),
                                    lastName: _lastNameController.text.trim(),
                                    company: _companyController.text.trim(),
                                    address1: _addressController1.text.trim(),
                                    address2: _addressController2.text.trim(),
                                    city: _cityController.text.trim(),
                                    state: _stateController.text.trim(),
                                    country: _countryController.text,
                                    postcode: _zipController.text.trim(),)
                                .then((value) {
                              Navigator.pop(context);
                              setState(() {});
                              snackbar(
                                context,
                                'Billing details updated successfully',
                                Colors.white,
                                Colors.green,
                              );
                            });
                          }
                        }),

                    const SizedBox(height: 400),
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool validateAndSave() {
    focusNodeFirstName.unfocus();
    focusNodeLastName.unfocus();
    focusNodeCompany.unfocus();
    focusNodeAddress1.unfocus();
    focusNodeAddress2.unfocus();
    focusNodeCity.unfocus();
    focusNodeState.unfocus();
    focusNodeCountry.unfocus();
    focusNodeZip.unfocus();

    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget textFormField(TextEditingController? controller, FocusNode? focusNode,
      {String? validator, bool? isRequired, String? hintText}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        cursorColor: Colors.red,
        textInputAction: TextInputAction.next,
        onSaved: (input) => validator = input,
        validator: (input) => isRequired == true && input!.length < 2 ? 'required ' : null,
        focusNode: focusNode,
        style: const TextStyle(
            fontFamily: 'baloo da 2', fontWeight: FontWeight.normal, fontSize: 14.0, color: Colors.black),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'baloo da 2',
            color: Colors.black54,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black54,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black54),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
        ),
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
