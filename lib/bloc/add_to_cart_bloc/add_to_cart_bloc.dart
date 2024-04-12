import 'package:ecommerce_app_bloc/bloc/add_to_cart_bloc/add_to_cart_event.dart';
import 'package:ecommerce_app_bloc/bloc/add_to_cart_bloc/add_to_cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/product.dart';

class CartBloc extends Bloc<CartEvent, CartState>{
  CartBloc() : super(CartState([])) {
    on<CartEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(
    CartEvent event, Emitter<CartState> emit) async {
      if(event is AddToCart){
        final updatedCart = List<Product>.from(state.cartItems)..add(event.product);
        emit(CartState(updatedCart));
      } else if(event is RemoveFromCart) {
        final updatedCart = List<Product>.from(state.cartItems)
        ..remove(event.product);
        emit(CartState(updatedCart));
      } else if(event is IncreaseQuantity) {
        final updatedCart = List<Product>.from(state.cartItems);
        updatedCart.firstWhere((item) => item.id == event.product.id).quantity++;
        emit(CartState(updatedCart));
      } else if(event is DecreaseQuantity) {
        final updatedCart = List<Product>.from(state.cartItems);
        updatedCart.firstWhere((item) => item.id == event.product.id).quantity--;
        if(updatedCart.firstWhere((item) => item.id == event.product.id).quantity == 0) {
          updatedCart.removeWhere((item) => item.id == event.product.id);
        }
        emit(CartState(updatedCart));
      }
    }
}

// import 'package:ecommerce_app_bloc/bloc/add_to_cart_bloc/add_to_cart_event.dart';
// import 'package:ecommerce_app_bloc/bloc/add_to_cart_bloc/add_to_cart_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../model/product.dart';

// class CartBloc extends Bloc<CartEvent, CartState>{
//   CartBloc() : super(CartState([])) {
//     on<CartEvent>(_mapEventToState);
//   }

//   Future<void> _mapEventToState(
//     CartEvent event, Emitter<CartState> emit) async {
//       if(event is AddToCart){
//         final updatedCart = List<Product>.from(state.cartItems)..add(event.product);
//         emit(CartState(updatedCart));
//       } else if(event is RemoveFromCart) {
//         final updatedCart = List<Product>.from(state.cartItems)
//         ..remove(event.product);
//         emit(CartState(updatedCart));
//       } 
//     }
// }