import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../screens/order_details_screen.dart';

class OrderListCard extends StatelessWidget {
  final OrderModel orderModel;
  const OrderListCard({Key? key, required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${orderModel.orderId}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'baloo da 2',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  orderModel.orderDate.toString().split('.')[0],
                  style: const TextStyle(
                    fontFamily: 'baloo da 2',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tracking number',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'baloo da 2',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  orderModel.orderNumber!,
                  style: const TextStyle(
                    fontFamily: 'baloo da 2',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatus(status: orderModel.status!),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(
                              model: orderModel
                            )));
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 2, color: Colors.black)),
                    child: const Center(
                      child: Text(
                        "Details    >>>",
                        style: TextStyle(
                            fontFamily: 'Baloo Da 2',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
             
              ],
            ),
          ],
        ));
  }

  Widget _buildStatus({required String status}) {
    IconData icon;
    Color color;
    String text;

    switch (status) {
      case 'processing':
        icon = Icons.timer;
        color = Colors.orange;
        text = 'Processing';
        break;
      case 'on-hold':
        icon = Icons.local_shipping;
        color = Colors.yellow;
        text = 'Shipping';
        break;
      case 'completed':
        icon = Icons.check_circle;
        color = Colors.green;
        text = 'Delivered';
        break;
      case 'cancelled':
        icon = Icons.cancel;
        color = Colors.red;
        text = 'Cancelled';
        break;
      default:
        icon = Icons.timer;
        color = Colors.orange;
        text = 'Processing';
    }

    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'baloo da 2',
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}