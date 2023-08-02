import 'package:bloc/bloc.dart';
import 'package:http_actions/http_actions.dart';
import 'package:http_actions_example/screens/product/models/products_response.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final HttpActions httpActions;
  ProductsBloc({required this.httpActions}) : super(ProductsInitial()) {
    on<ProductsEvent>((event, emit) {});
    on<LoadAllProductsEvent>(_loadAllProducts);
  }

  _loadAllProducts(
      LoadAllProductsEvent event, Emitter<ProductsState> emit) async {
    emit(ProductsBusyState());

    final response = await httpActions.get("products");
    if (response.data is List) {
      emit(ProductsSuccessState(
          response: (response.data as List)
              .map((e) => ProductsResponse.fromJson(e))
              .toList()));
    } else {
      emit(ProductsFailureState(error: response.data.toString()));
    }
  }
}
