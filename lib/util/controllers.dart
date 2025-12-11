// util/controllers.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 전역 앱 UI 및 네비게이션 관리 컨트롤러
class AppController extends GetxController {
  // 탭 인덱스 관리 (Bottom NavBar)
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}

// 전역 장바구니 데이터 및 로직 관리 컨트롤러
class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;

  void addToCart(String title, int price, String image, String size) {
    int existingIndex = cartItems.indexWhere((element) => element['title'] == title && element['size'] == size);
    
    if (existingIndex >= 0) {
      var item = cartItems[existingIndex];
      item['qty'] = item['qty'] + 1;
      cartItems[existingIndex] = item;
    } else {
      cartItems.add({
        "title": title,
        "price": price,
        "image": image,
        "size": size,
        "qty": 1,
      });
    }
    Get.snackbar("장바구니", "$title ($size)를 담았습니다.", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 1));
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  int get totalPrice => cartItems.fold(0, (sum, item) => sum + (item['price'] as int) * (item['qty'] as int));
}

// 상세 페이지(DetailView) 내 지역 상태 관리 컨트롤러
class DetailController extends GetxController {
  var currentImageIndex = 0.obs;
  var selectedColorIndex = 0.obs;
  var selectedSize = "250".obs;
  var isLiked = false.obs;
  
  final PageController pageController = PageController();

  void changeColor(int index) {
    selectedColorIndex.value = index;
    currentImageIndex.value = index;
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void updatePage(int index) {
    currentImageIndex.value = index;
    selectedColorIndex.value = index;
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}