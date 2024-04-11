import 'package:ecommerce_app_bloc/bloc/add_to_cart_bloc/add_to_cart_event.dart';
import 'package:ecommerce_app_bloc/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/add_to_cart_bloc/add_to_cart_bloc.dart';
import '../bloc/add_to_cart_bloc/add_to_cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
            if (state.cartItems.isEmpty) {
              return const Center(
                child: Text('Your Cart is empty'),
              );
            } else {
                return ListView.builder(
          itemCount: state.cartItems.length,
          itemBuilder: (context, index) {
            return ListTile(
               title: Text(state.cartItems[index].name),
              subtitle: Text('\$${state.cartItems[index].price}'),
              trailing: IconButton(
                onPressed: () {
                  final cartBloc = BlocProvider.of<CartBloc>(context);
                  cartBloc.add(RemoveFromCart(state.cartItems[index]));
                },
                icon: const Icon(Icons.remove_shopping_cart_outlined)),
      
            );
          },
        );
            }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen()));
        },
        child: const Icon(Icons.check_outlined),
        ),
    );
  }
}