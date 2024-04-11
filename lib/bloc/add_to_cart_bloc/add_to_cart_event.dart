import 'package:equatable/equatable.dart';
import '../../model/product.dart';

abstract class CartEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent{
  final Product product;
  AddToCart(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveFromCart extends CartEvent{
  final Product product;

  RemoveFromCart(this.product);

  @override
  List<Object> get props => [product];
}