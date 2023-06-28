part of 'products_bloc.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsBusyState extends ProductsState {}

class ProductsSuccessState extends ProductsState {
  final List<ProductsResponse> response;

  ProductsSuccessState({required this.response});
}

class ProductsFailureState extends ProductsState {
  final String error;

  ProductsFailureState({required this.error});
}
