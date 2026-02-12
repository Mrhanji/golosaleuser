import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../home/service/home_service.dart';
import '/app/features/search/model/products_model.dart';


enum SearchStatus{ideal,isSearching,notFound,dataFound}

class ProductSearchController extends GetxController{

  TextEditingController searchEditTextController=TextEditingController();
  SearchStatus searchStatus=SearchStatus.ideal;
  ProductsModel productsModel=ProductsModel();



  startSearching(v)async{
    print(v);
    searchStatus=SearchStatus.isSearching;
    // add search functionality on key press cancel last request and send new one after 5ms delay
    update();

    productsModel=await HomeServices().searchProduct(searchEditTextController.text);
    if(productsModel.data!.isEmpty){
      searchStatus=SearchStatus.notFound;
    }else{
      searchStatus=SearchStatus.dataFound;
    }
    update();

  }










  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchEditTextController.dispose();
    searchStatus=SearchStatus.ideal;
  }










}