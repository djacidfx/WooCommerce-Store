import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/presentations/widgets/order_list_card.dart';
import '../../models/order.dart';
import '../../services/providers/order_provider.dart';

class ProcessingOrders extends StatefulWidget {
  const ProcessingOrders({Key? key}) : super(key: key);

  @override
  _ProcessingOrdersState createState() => _ProcessingOrdersState();
}

class _ProcessingOrdersState extends State<ProcessingOrders> {
  @override
  Widget build(BuildContext context) {
    var orderProvider = context.watch<OrderProvider>();

    return FutureBuilder(
      future: orderProvider.getProcessingOrders(),
      builder: (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        } else {
          if (snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 0),
              child: const Text(
                'You have no processing orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Baloo Da 2',
                ),
              ),
            );
          } else {
            var orders = snapshot.data;

            return ListView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: orders!.length,
              itemBuilder: (BuildContext context, int index) {
                OrderModel orderModel = orders[index];
                return OrderListCard(orderModel: orderModel);
              },
            );
          }
        }
      },
    );
  }
}
