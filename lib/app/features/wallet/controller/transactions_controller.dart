import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controller/home_controller.dart';
import '../model/wallet_transaction_model.dart';
import '../service/wallet_service.dart';

class TransactionsController extends GetxController {
  var transactions = <Transactions>[].obs;

  int page = 1;
  final int limit = 10;

  var isInitialLoading = true.obs;
  var isLoadingMore = false.obs;

  bool hasMore = true;
  int totalPages = 1;

  final scrollController = ScrollController();

  String userId = '';

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore.value &&
          hasMore) {
        loadMore();
      }
    });
  }

  Future<void> fetchTransactions() async {
    userId = Get.put(HomeController()).userModel.data!.userId!;

    try {
      isInitialLoading.value = true;

      final response =
      await WalletService().getTransactions(userId, page, limit);

      final data = response.data;

      if (data?.transactions != null) {
        transactions.addAll(data!.transactions!);
      }

      totalPages = data?.totalPages ?? 1;

      if (page >= totalPages) {
        hasMore = false;
      }
    } catch (e) {
      print(e);
    } finally {
      isInitialLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    try {
      if (page >= totalPages) {
        hasMore = false;
        return;
      }

      isLoadingMore.value = true;
      page++;

      final response =
      await WalletService().getTransactions(userId, page, limit);

      final data = response.data;

      if (data?.transactions != null) {
        transactions.addAll(data!.transactions!);
      }

      if (page >= (data?.totalPages ?? 1)) {
        hasMore = false;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingMore.value = false;
    }
  }
}