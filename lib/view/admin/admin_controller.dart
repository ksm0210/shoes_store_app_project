// lib/admin/admin_controller.dart

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shoes_store_app_project/model/admin.dart';

class AdminController extends GetxController {
  // -----------------------------------------------------------
  // 상태 변수
  // -----------------------------------------------------------
  // 현재 로그인된 관리자 역할
  var currentRole = AdminRole.none.obs;

  // 모든 매장 및 제품의 재고 목록 (InventoryItem)
  // DB 연동 없이 더미 데이터를 바로 초기화
  var allInventory = <InventoryItem>[
    // 강남 매장
    InventoryItem(
      id: 'P101-S001',
      productName: '에어 포스 1 (흰/검)',
      storeId: 'S001',
      storeName: '강남점',
      stockCount: 45,
      maxStock: 100,
      soldCount: 55,
      unitPrice: 129000,
    ),
    InventoryItem(
      id: 'P102-S001',
      productName: '나이키 덩크 로우 (범고래)',
      storeId: 'S001',
      storeName: '강남점',
      stockCount: 15,
      maxStock: 50,
      soldCount: 35,
      unitPrice: 139000,
    ),
    InventoryItem(
      id: 'P103-S001',
      productName: '리액트 플라이',
      storeId: 'S001',
      storeName: '강남점',
      stockCount: 80,
      maxStock: 100,
      soldCount: 20,
      unitPrice: 159000,
    ),
    // 홍대 매장
    InventoryItem(
      id: 'P101-S002',
      productName: '에어 포스 1 (흰/검)',
      storeId: 'S002',
      storeName: '홍대점',
      stockCount: 25,
      maxStock: 80,
      soldCount: 55,
      unitPrice: 129000,
    ),
    InventoryItem(
      id: 'P104-S002',
      productName: '조던 1 미드',
      storeId: 'S002',
      storeName: '홍대점',
      stockCount: 10,
      maxStock: 40,
      soldCount: 30,
      unitPrice: 179000,
    ),
  ].obs;

  // 발주 요청 목록
  var purchaseOrders = <PurchaseOrder>[
    PurchaseOrder(
      orderId: 'PO001',
      requesterName: '김사원',
      productName: '나이키 덩크 로우 (범고래)',
      quantity: 100,
      reason: '재고 부족 예측 및 인기 상품 확보',
      dateRequested: DateTime(2023, 11, 1),
      initialStatus: ApprovalStatus.teamApproved, // 임원 대기 중
    ),
    PurchaseOrder(
      orderId: 'PO002',
      requesterName: '이사원',
      productName: '리액트 플라이',
      quantity: 50,
      reason: '신규 매장 오픈 준비 물량',
      dateRequested: DateTime(2023, 11, 10),
    ),
  ].obs;

  // 반품 요청 목록
  var returnRequests = <ReturnRequest>[
    ReturnRequest(
      requestId: 'R001',
      customerName: '이민준',
      productName: '에어 포스 1',
      storeName: '강남점',
      requestDate: DateTime(2023, 11, 15),
      reason: '사이즈 오차',
    ),
    ReturnRequest(
      requestId: 'R002',
      customerName: '박지수',
      productName: '조던 1 미드',
      storeName: '홍대점',
      requestDate: DateTime(2023, 11, 16),
      reason: '색상 불만',
    ),
  ].obs;

  // -----------------------------------------------------------
  // Computed (계산된 속성)
  // -----------------------------------------------------------

  // 8번: 본사 임원용 - 전체 판매 현황 (일자별, 제품별)
  List<Map<String, dynamic>> get salesStatus {
    // 더미 데이터를 기반으로 집계 시뮬레이션
    Map<String, int> productSales = {};
    Map<String, double> productRevenue = {};

    for (var item in allInventory) {
      productSales.update(
        item.productName,
        (value) => value + item.soldCount,
        ifAbsent: () => item.soldCount,
      );
      productRevenue.update(
        item.productName,
        (value) => value + (item.soldCount * item.unitPrice),
        ifAbsent: () => item.soldCount * item.unitPrice,
      );
    }

    return productSales.keys.map((productName) {
      return {
        'productName': productName,
        'totalSold': productSales[productName],
        'totalRevenue': productRevenue[productName],
        'lowStockStores': allInventory
            .where((i) => i.productName == productName && i.isLowStock)
            .length,
      };
    }).toList();
  }

  // 10번: 재고 부족 품목 (60% 미만)
  List<InventoryItem> get lowStockItems =>
      allInventory.where((item) => item.isLowStock).toList();

  // -----------------------------------------------------------
  // 메서드 (로직)
  // -----------------------------------------------------------

  // 관리자 로그인/역할 변경
  void login(AdminRole role) {
    currentRole.value = role;
  }

  // 10번: 발주 품의 결재 처리 (팀장 또는 이사)
  void processApproval(String orderId, bool approve) {
    final order = purchaseOrders.firstWhereOrNull((o) => o.orderId == orderId);
    if (order == null) return;

    // 현재 로그인된 역할 확인
    final role = currentRole.value;

    if (!approve) {
      order.status.value = ApprovalStatus.rejected;
      Get.snackbar(
        "알림",
        "${order.productName} 발주가 반려되었습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (role == AdminRole.executive) {
      if (order.status.value == ApprovalStatus.pending) {
        // 임원(이사)이 팀장 결재를 대신 처리할 수 있다고 가정
        order.status.value = ApprovalStatus.teamApproved;
        Get.snackbar(
          "승인",
          "팀장 결재가 완료되었습니다. 이사 승인 대기 중.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (order.status.value == ApprovalStatus.teamApproved) {
        // 최종 결재 (이사 승인)
        order.status.value = ApprovalStatus.executiveApproved;
        // 발주 완료 시 재고 업데이트 시뮬레이션
        _simulateStockUpdate(order.productName, order.quantity);
        Get.snackbar(
          "발주 완료",
          "${order.productName} ${order.quantity}개가 최종 승인되어 발주되었습니다.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } else if (role == AdminRole.headOffice) {
      // 본사 직원(사원)은 팀장 결재만 처리 가능하다고 가정 (실제 팀장 역할을 시뮬레이션)
      if (order.status.value == ApprovalStatus.pending) {
        order.status.value = ApprovalStatus.teamApproved;
        Get.snackbar(
          "승인",
          "팀장 결재가 완료되었습니다. 이사 승인 대기 중.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // 발주 완료 시 재고 증가 시뮬레이션
  void _simulateStockUpdate(String productName, int quantity) {
    // 모든 매장 재고가 아닌, 본사 창고 재고 증가 시뮬레이션 (현재 모델에서는 생략)
    // 간단히 재고 부족 매장의 재고를 채워주는 것으로 시뮬레이션:
    final lowStockItemsForProduct = allInventory
        .where((i) => i.productName == productName && i.isLowStock)
        .toList();
    if (lowStockItemsForProduct.isNotEmpty) {
      // 가장 재고가 적은 매장의 재고를 채워줍니다.
      lowStockItemsForProduct.sort(
        (a, b) => a.stockCount.compareTo(b.stockCount),
      );
      final item = lowStockItemsForProduct.first;
      item.stockCount + quantity > item.maxStock
          ? item.maxStock
          : item.stockCount + quantity;
      allInventory.refresh();
    }
  }

  // 10번: 발주 품의서 제출 (사원 시뮬레이션)
  void submitPurchaseOrder(
    String productName,
    int quantity,
    String reason,
    String requesterName,
  ) {
    final newOrder = PurchaseOrder(
      orderId: 'PO${(purchaseOrders.length + 1).toString().padLeft(3, '0')}',
      requesterName: requesterName,
      productName: productName,
      quantity: quantity,
      reason: reason,
      dateRequested: DateTime.now(),
    );
    purchaseOrders.add(newOrder);
    Get.snackbar(
      "품의 제출",
      "발주 품의서가 성공적으로 제출되었습니다.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
