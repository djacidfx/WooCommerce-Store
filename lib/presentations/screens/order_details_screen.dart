import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/models/order.dart';
import 'package:woocommerce/models/product.dart';
import 'package:woocommerce/presentations/screens/order_cancellation_screen.dart';
import 'package:woocommerce/presentations/widgets/snackbar.dart';
import 'package:woocommerce/services/providers/product_provider.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:woocommerce/utils/print_to_console.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel model;
  const OrderDetailsScreen({Key? key, required this.model}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  //screenshot key
  final GlobalKey _key = GlobalKey();

  void _takeScreenshot() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    RenderRepaintBoundary boundary = _key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Saving the screenshot to the gallery
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes),
          quality: 100, name: 'Invoice - FWoo Demo Store - ${DateTime.now()}.png');
      printToConsole(result.toString());
      printToConsole('Invoice saved to gallery');
      snackbar(context, 'Invoice saved to gallery', Colors.white, Colors.green);
    } else {
      snackbar(context, 'Download failed! Please make sure storage permission setting is turned on', Colors.white, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Save Order',
                    style: TextStyle(
                      fontFamily: 'Baloo Da 2',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'Save invoice to device as a JPG file?',
                    style: TextStyle(
                      fontFamily: 'Baloo Da 2',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Baloo Da 2',
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontFamily: 'Baloo Da 2',
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _takeScreenshot();
                      },
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.download),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: widget.model.status == 'processing' ? false : true,
        title: const Text(
          'Orders Details',
          style: TextStyle(fontFamily: 'baloo da 2', fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        actions: [
          if (widget.model.status == 'processing')
            Center(
                child: TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => OrderCancellattionScreen(
                      orderId: widget.model.orderId.toString(),
                      userEmail: widget.model.billing!.email!,
                      userName: widget.model.billing!.firstName! + ' ' + widget.model.billing!.lastName!,
                    )));
              },
              child: const Text(
                'Request Cancellation',
                style:
                    TextStyle(fontFamily: 'baloo da 2', fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ))
        ],
      ),
      body: SingleChildScrollView(
        child: RepaintBoundary(
          key: _key,
          child: Container(
            color: Colors.grey[200],
      padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  //-------------------------------------//
                  title(text: 'Order ID'),
                  subtitle(text: '#${widget.model.orderId.toString()}'),
                  title(text: 'Tracking ID'),
                  subtitle(text: '${widget.model.orderNumber}'),
                  title(text: 'Order Date and Time'),
                  subtitle(text: widget.model.orderDate.toString().split('.')[0]),
                  title(text: 'Order Status'),
                  subtitle(text: widget.model.status!),
                  const SizedBox(height: 5),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(height: 5),

                  //-------------------------------------//
                  title(text: '${widget.model.lineItems.length.toString()} item(s)'),
                  _listOrderItems(),
                  const SizedBox(height: 5),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(height: 5),

                  //-------------------------------------//
                  title(text: 'Name'),
                  subtitle(text: widget.model.billing!.firstName! + ' ' + widget.model.billing!.lastName!),
                  title(text: 'Email'),
                  subtitle(text: widget.model.billing!.email!),
                  title(text: 'Shiiping Address'),
                  subtitle(text: '''
${widget.model.shipping!.address1} 
${widget.model.shipping!.address2}
${widget.model.shipping!.city}
${widget.model.shipping!.state}
${widget.model.shipping!.country}
${widget.model.shipping!.postcode}'''),
                  title(text: 'Payment Method'),
                  subtitle(text: widget.model.paymentMethodTitle!),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(height: 5),

                  //-------------------------------------//
                  title(text: 'Items Subtotal'),
                  subtitle(text: widget.model.itemTotalAmount!.toStringAsFixed(2)),
                  title(text: 'Shipping Total'),
                  subtitle(text: widget.model.shippingTotal!.toStringAsFixed(2)),
                  const Center(
                    child: Text(
                      'Total Paid',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18, fontFamily: 'baloo da 2'),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.model.itemTotalAmount!.toStringAsFixed(2),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18, fontFamily: 'baloo da 2'),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listOrderItems() {
    return ListView.builder(
        itemCount: widget.model.lineItems.length,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _productItems(widget.model.lineItems[index]);
        });
  }

  Widget _productItems(LineItems product) {
    var productProvider = Provider.of<ProductProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey[200]!, width: 1)),
        dense: true,
        contentPadding: const EdgeInsets.all(5),
        leading: FutureBuilder(
          future: productProvider.getProduct(product.productId!),
          builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: 50,
                height: 50,
                color: Colors.grey[200],
                child: const Center(
                  child: LinearProgressIndicator(color: Colors.red),
                ),
              );
            } else {
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(snapshot.data!.images![0].src!), fit: BoxFit.cover)),
              );
            }
          },
        ),
        title: Text(
          product.productName!,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black54, fontFamily: 'Baloo Da 2'),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(2),
          child: Text(
            "Qty: ${product.quantity}",
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black54, fontFamily: 'Baloo Da 2'),
          ),
        ),
        trailing: Text(
          "\$${product.totalAmount!.toStringAsFixed(2)}",
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black54, fontFamily: 'Baloo Da 2'),
        ),
      ),
    );
  }

  Widget title({required String text}) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style:
            const TextStyle(fontFamily: 'baloo da 2', fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget subtitle({required String text}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style:
            const TextStyle(fontFamily: 'baloo da 2', fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
      ),
    );
  }
}
