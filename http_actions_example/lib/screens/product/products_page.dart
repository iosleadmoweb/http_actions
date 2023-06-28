import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_actions_example/http_instance.dart';
import 'package:http_actions_example/screens/product/bloc/products_bloc.dart';
import 'package:http_actions_example/screens/product/models/products_response.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: BlocProvider(
        create: (context) => ProductsBloc(
          httpActions: HttpInstance.getInstance(),
        )..add(LoadAllProductsEvent()),
        child: BlocConsumer<ProductsBloc, ProductsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ProductsBusyState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ProductsSuccessState) {
              return ProductsList(
                products: state.response,
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class ProductsList extends StatelessWidget {
  final List<ProductsResponse> products;
  const ProductsList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        ProductsResponse response = products[index];
        return Text(response.title ?? "");
      },
    );
  }
}
