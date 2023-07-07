import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_me/logic/cubits/product_cubit/product_state.dart';

import '../../../data/models/product/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class ProductCubit extends Cubit<ProductState>{
  ProductCubit():super(ProductInitialState()){
    _initialize();
  }
  final _productRepository= ProductRepository();
  void _initialize() async{
    emit(ProductLoadingState(state.products));
    try{
      final products = await _productRepository.fetchAllProducts();
      emit(ProductLoadedState(products));
    }
    catch(ex){
      emit(ProductErrorState(state.products, ex.toString()));
    }
  }
}