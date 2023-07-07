import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_me/data/models/category/category_model.dart';
import 'package:shop_with_me/data/repositories/category_repository.dart';
import 'package:shop_with_me/logic/cubits/category_cubit/category_state.dart';

class CategoryCubit extends Cubit<CategoryState>{
  CategoryCubit():super(CategoryInitialState()){
    _initialize();
  }
  final _categoryRepository= CategoryRepository();
  void _initialize() async{
    emit(CategoryLoadingState(state.categories));
    try{
     List<CategoryModel> categories = await _categoryRepository.fetchAllCategories();
     emit(CategoryLoadedState(categories));
    }
    catch(ex){
      emit(CategoryErrorState(state.categories, ex.toString()));
    }
  }
}