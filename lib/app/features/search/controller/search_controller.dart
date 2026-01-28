import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


enum SearchStatus{ideal,isSearching,notFound,dataFound}

class SearchController extends GetxController{

  TextEditingController searchEditTextController=TextEditingController();
  SearchStatus searchStatus=SearchStatus.ideal;




  startSearching()async{

    searchStatus=SearchStatus.isSearching;
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