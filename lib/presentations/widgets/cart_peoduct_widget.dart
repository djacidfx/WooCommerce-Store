// //@dart=2.9
// import 'package:flutter/material.dart';
// import 'package:jumbocheap/models/cart_response_model.dart';
// import 'package:jumbocheap/provider/cart_provider.dart';
// import 'package:jumbocheap/provider/loader_provider.dart';
// import 'package:jumbocheap/utils/custom_stepper.dart';
// import 'package:jumbocheap/utils/delete_cart_item_dialog.dart';
// import 'package:provider/provider.dart';

// class CartProductWidget extends StatelessWidget {
//   const CartProductWidget({Key key, this.data}) : super(key: key);
//   final CartItem data;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2.0,
//       shadowColor: Colors.white,
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       child: Container(
//         height: 100,
//         decoration: const BoxDecoration(color: Colors.black87),
//         child: makeCartProductWidgetList(context)
//       )
//     );
//   } 
//   Widget makeCartProductWidgetList(BuildContext context) => Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               height: 80,
//               width: 80,
//               child: Image.network(
//                 data.thumbnail,
//                 fit: BoxFit.fill,
//               ),
//             ),

//             const SizedBox(width: 15),

//             Expanded(
//               child: Column(
//                 children:[
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         data.variationId == 0 ?
//                         data.productName :
//                         "${data.productName} (${data.attributeValue}${data.attribute})",
//                         style: const TextStyle(
//                           color: Colors.white, 
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18
//                         ),
//                         textAlign: TextAlign.center,
//                         maxLines: 2,
//                       ),
//                     ),
//                   ),
                  
//                   Expanded(
//                     child: Text(
//                       "₦${data.productSalePrice}",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18
//                       ),
//                     ),
//                   ),

//                   Expanded(
//                     child: CustomStepper(
//                       lowerLimit: 0,
//                       upperLimit: 20,
//                       stepValue: 1,
//                       value: data.qty,
//                       onChanged: (value) {
//                         Provider.of<CartProvider>(context, listen: false).updateQty(data.productId, value, variationId: data.variationId);
//                       },
//                     ),
//                   ),
//                 ]
//               ),
//             ),

//             IconButton(
//               onPressed: (){
//                 DeleteCartItemDialog.showMessage(
//                   context, 
//                   "JumboCheap", 
//                   "Do you want to delete this item?", 
//                   "Yes", 
//                   () {
//                     Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(true);
//                     Provider.of<CartProvider>(context, listen: false).removeCartItem(data.productId);
//                     Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(false);
//                     var cartProvider =
//                           Provider.of<CartProvider>(context, listen: false);
//                     cartProvider.updateCart((val) {
//                         Provider.of<LoaderProvider>(context, listen: false)
//                             .setLoadingStatus(false);
//                       });
                    
//                       Navigator.of(context).pop();
//                   },
//                   "No",
//                   () {Navigator.of(context).pop();}
//                 );
//               }, 
//               icon: const Icon(
//                 Icons.delete_outline,
//                 color: Colors.white,
//                 size: 25,
//               )
//             )
//           ],
//         )
//   );
// }