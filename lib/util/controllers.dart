// util/controllers.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ------------------------------------------------------------------
// 전역 앱 UI 및 네비게이션 관리 컨트롤러
// ------------------------------------------------------------------
class AppController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}

// ------------------------------------------------------------------
// 전역 장바구니 데이터 및 로직 관리 컨트롤러
// ------------------------------------------------------------------
class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;

  void addToCart(Map<String, dynamic> productData) {
    // DetailScreen에서 전달된 데이터에서 필요한 정보 추출
    String title = productData['title'] as String;
    String size = productData['selectedSize'] as String;
    String image = productData['selectedColorImageUrl'] as String;
    
    // 가격 문자열을 int로 변환 (CartController 내에서 처리하여 저장)
    int price = int.tryParse(productData['price'].replaceAll('₩', '').replaceAll(',', '').trim()) ?? 0;
    
    // 기존 아이템 찾기 (같은 상품, 같은 사이즈)
    int existingIndex = cartItems.indexWhere((element) => 
        element['title'] == title && element['size'] == size);
    
    if (existingIndex >= 0) {
      // 수량 증가
      var item = cartItems[existingIndex];
      item['qty'] = (item['qty'] as int) + 1;
      cartItems[existingIndex] = item;
      cartItems.refresh(); 
    } else {
      // 새 아이템 추가
      cartItems.add({
        "title": title,
        "price": price, 
        "image": image, 
        "size": size,
        "qty": 1,
      });
    }
    
    Get.snackbar("장바구니", "$title ($size)를 담았습니다.", 
      snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
    cartItems.refresh();
  }
  
  void decreaseQuantity(int index) {
     if (cartItems.isNotEmpty && index >= 0 && index < cartItems.length) {
      var item = cartItems[index];
      if ((item['qty'] as int) > 1) {
        item['qty'] = (item['qty'] as int) - 1;
        cartItems[index] = item;
        cartItems.refresh();
      } else {
        removeFromCart(index);
      }
    }
  }

  int get totalPrice => cartItems.fold(0, (sum, item) => sum + (item['price'] as int) * (item['qty'] as int));
}

// 기존 DetailController는 삭제되었습니다.