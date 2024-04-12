// checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import '../bloc/add_to_cart_bloc/add_to_cart_bloc.dart';
import '../bloc/add_to_cart_bloc/add_to_cart_state.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartBloc = BlocProvider.of<CartBloc>(context);

    double totalAmount = cartBloc.state.cartItems.fold(
        0, (previousValue, element) => previousValue + (element.price * element.quantity));

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Checkout Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cartBloc.state.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartBloc.state.cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.name} x ${item.quantity}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total MRP',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Prepare checkout data
                List<Map<String, dynamic>> checkoutData = cartBloc.state.cartItems.map((item) => {
                  'productName': item.name,
                  'quantity': item.quantity,
                  'pricePerQuantity': item.price,
                  'totalPrice': item.price * item.quantity,
                }).toList();

                // Store data in Firebase Realtime Database
                databaseReference.child('checkout').set({
                  'totalProducts': cartBloc.state.cartItems.length,
                  'totalAmount': totalAmount,
                  'checkoutDetails': checkoutData,
                }).then((_) {
                  // Navigate to payment screen or show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Data stored successfully.'),
                    ),
                  );
                }).catchError((error) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to store data: $error'),
                    ),
                  );
                });
              },
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

// // checkout_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../bloc/add_to_cart_bloc/add_to_cart_bloc.dart';
// import '../bloc/add_to_cart_bloc/add_to_cart_state.dart';

// class CheckoutScreen extends StatelessWidget {
//   const CheckoutScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final cartBloc = BlocProvider.of<CartBloc>(context);

//     double totalAmount = cartBloc.state.cartItems.fold(
//         0, (previousValue, element) => previousValue + (element.price * element.quantity));

//     DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Checkout Details',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cartBloc.state.cartItems.length,
//                 itemBuilder: (context, index) {
//                   final item = cartBloc.state.cartItems[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${item.name} x ${item.quantity}',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         Text(
//                           '\$${item.price.toStringAsFixed(2)}',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         Text(
//                           '\$${(item.price * item.quantity).toStringAsFixed(2)}',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Divider(
//               thickness: 2,
//               color: Colors.grey,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Total MRP',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     '\$${totalAmount.toStringAsFixed(2)}',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Store data in Firebase Realtime Database
//                 databaseReference.child('checkout').set({
//                   'totalProducts': cartBloc.state.cartItems.length,
//                   'totalAmount': totalAmount,
//                 }).then((_) {
//                   // Navigate to payment screen or show success message
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Data stored successfully.'),
//                     ),
//                   );
//                 }).catchError((error) {
//                   // Show error message
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to store data: $error'),
//                     ),
//                   );
//                 });
//               },
//               child: Text('Proceed to Payment'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../bloc/add_to_cart_bloc/add_to_cart_bloc.dart';
// import '../bloc/add_to_cart_bloc/add_to_cart_state.dart';
// import '../../model/product.dart';

// class CheckoutScreen extends StatelessWidget {
//   const CheckoutScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final cartBloc = BlocProvider.of<CartBloc>(context);

//     int totalProducts = cartBloc.state.cartItems.length;
//     int totalQuantity = cartBloc.state.cartItems.fold(0, (prev, item) => prev + item.quantity);
//     double totalAmount = cartBloc.state.cartItems.fold(
//         0, (previousValue, element) => previousValue + (element.price * element.quantity));

//     DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Total Products: $totalProducts',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Total Quantity: $totalQuantity',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Store data in Firebase Realtime Database
//                 databaseReference.child('checkout').set({
//                   'totalProducts': totalProducts,
//                   'totalQuantity': totalQuantity,
//                   'totalAmount': totalAmount,
//                 }).then((_) {
//                   // Navigate to payment screen or show success message
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Data stored successfully.'),
//                     ),
//                   );
//                 }).catchError((error) {
//                   // Show error message
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to store data: $error'),
//                     ),
//                   );
//                 });
//               },
//               child: Text('Proceed to Payment'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// checkout_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../bloc/add_to_cart_bloc/add_to_cart_bloc.dart';
// import '../bloc/add_to_cart_bloc/add_to_cart_state.dart';

// class CheckoutScreen extends StatelessWidget {
//   const CheckoutScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final cartBloc = BlocProvider.of<CartBloc>(context);

//     int totalProducts = cartBloc.state.cartItems.length;
//     double totalAmount = cartBloc.state.cartItems.fold(
//         0, (previousValue, element) => previousValue + element.price);

//     DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Total Products: $totalProducts',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Store data in Firebase Realtime Database
//                 databaseReference.child('checkout').set({
//                   'totalProducts': totalProducts,
//                   'totalAmount': totalAmount,
//                 }).then((_) {
//                   // Navigate to payment screen or show success message
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Data stored successfully.'),
//                     ),
//                   );
//                 }).catchError((error) {
//                   // Show error message
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to store data: $error'),
//                     ),
//                   );
//                 });
//               },
//               child: Text('Proceed to Payment'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/add_to_cart_bloc/add_to_cart_bloc.dart';
// import '../bloc/add_to_cart_bloc/add_to_cart_state.dart';

// class CheckoutScreen extends StatelessWidget {
//   const CheckoutScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final cartBloc = BlocProvider.of<CartBloc>(context);

//     int totalProducts = cartBloc.state.cartItems.length;
//     double totalAmount = cartBloc.state.cartItems.fold(
//         0, (previousValue, element) => previousValue + element.price);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Total Products: $totalProducts',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement your checkout logic here
//                 // For example: navigate to payment screen
//               },
//               child: Text('Proceed to Payment'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
