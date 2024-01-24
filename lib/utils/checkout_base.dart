import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/presentations/widgets/progress_indicator_modal.dart';
import '../presentations/widgets/checkpoints_widgets.dart';
import '../services/providers/loader_provider.dart';

class CheckoutBase extends StatefulWidget {
  const CheckoutBase({Key? key}) : super(key: key);

  @override
  CheckoutBaseState createState() => CheckoutBaseState();
}

class CheckoutBaseState<T extends CheckoutBase> extends State<T> {
  int currentPage = 0;
  bool showBackButton = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Colors.grey[200],
          body: ProgressModal(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  CheckPoints(
                    checkedTill: currentPage,
                    checkPoints: const [
                      "Shipping",
                      "Payment",
                      "Order",
                    ],
                    checkPointFilledColor: Colors.red,
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  pageUI(),
                ],
              ),
            ),
            inAsyncCall: loaderModel.isApiCallProcess,
            opacity: 0.3,
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      title: const Text(
        'Checkout',
        style: TextStyle(
          fontFamily: 'Baloo Da 2',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.chevron_left,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget pageUI() {
    return Container();
  }
}
