import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../home/service/home_service.dart';
import '/app/features/search/model/products_model.dart';

enum SearchStatus { ideal, isSearching, notFound, dataFound }

class ProductSearchController extends GetxController {
  TextEditingController searchEditTextController = TextEditingController();
  SearchStatus searchStatus = SearchStatus.ideal;
  ProductsModel productsModel = ProductsModel();
  Timer? _debounceTimer;

  void onSearchTextChanged(String text) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    if (text.trim().isEmpty) {
      searchStatus = SearchStatus.ideal;
      update();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      startSearching(text);
    });
  }

  Future<void> startSearching(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      searchStatus = SearchStatus.ideal;
      update();
      return;
    }

    // Sync input field value if search was triggered from suggestion chip
    if (searchEditTextController.text != cleanQuery) {
      searchEditTextController.text = cleanQuery;
    }

    searchStatus = SearchStatus.isSearching;
    update();

    try {
      productsModel = await HomeServices().searchProduct(cleanQuery);
      if (productsModel.data == null || productsModel.data!.isEmpty) {
        searchStatus = SearchStatus.notFound;
      } else {
        searchStatus = SearchStatus.dataFound;
      }
    } catch (e) {
      print("Search error: $e");
      searchStatus = SearchStatus.notFound;
    }
    update();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchEditTextController.dispose();
    searchStatus = SearchStatus.ideal;
    super.dispose();
  }
}