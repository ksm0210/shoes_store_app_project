// util/controllers.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/util/global_login_data.dart';
import 'package:shoes_store_app_project/vm/shopcart_handler.dart';

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
  final ShopcartHandler _handler = ShopcartHandler();

  var cartItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCart(); // 앱 시작/화면 들어올 때 DB에서 불러오기
  }

  Future<void> loadCart() async {
    final customerId = GlobalLoginData.customer_id; // 너 프로젝트에 있는 로그인 값
    final rows = await _handler.selectByCustomer(customerId);

    cartItems.value = rows.map((r) {
      return {
        "cart_id": r["cart_id"],
        "customer_id": r["customer_id"],
        "product_id": r["product_id"],
        "title": r["title"],
        "price": r["price"],
        "image": r["image"] ?? "",
        "size": r["size"],
        "qty": r["qty"],
      };
    }).toList();
  }

  Future<void> addToCart({
    required int productId,
    required String title,
    required int price,
    required String image,
    required String size,
  }) async {
    final customerId = GlobalLoginData.customer_id;

    await _handler.upsertAddOne(
      customerId: customerId,
      productId: productId,
      title: title,
      price: price,
      image: image,
      size: size,
    );

    await loadCart(); // DB 반영 후 UI 갱신
    Get.snackbar(
      "장바구니",
      "$title ($size) 담김",
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  Future<void> removeFromCart(int index) async {
    final cartId = cartItems[index]["cart_id"] as int;
    await _handler.deleteByCartId(cartId);
    await loadCart();
  }

  int get totalPrice => cartItems.fold(
    0,
    (sum, item) => sum + (item['price'] as int) * (item['qty'] as int),
  );
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
