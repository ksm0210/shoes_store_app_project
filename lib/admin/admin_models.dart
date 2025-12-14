// lib/admin/admin_models.dart

// -----------------------------------------------------------
// 1. 관리자 역할 정의 (AdminRole)
// -----------------------------------------------------------
import 'package:get/get.dart';

enum AdminRole {
  none,
  headOffice, // 본사 직원 (사원)
  storeManager, // 대리점장
  executive, // 임원 (팀장, 이사)
}

// -----------------------------------------------------------
// 2. 재고/판매 아이템 모델 (InventoryItem)
// -----------------------------------------------------------
class InventoryItem {
  final String id;
  final String productName;
  final String storeId;
  final String storeName;
  final int stockCount; // 현재 재고 수량
  final int maxStock;   // 최대 재고 (발주 기준)
  final int soldCount;  // 이번 달 판매 수량
  final double unitPrice; // 단가

  InventoryItem({
    required this.id,
    required this.productName,
    required this.storeId,
    required this.storeName,
    required this.stockCount,
    required this.maxStock,
    required this.soldCount,
    required this.unitPrice,
  });

  // 재고 비율 계산
  double get stockRatio => stockCount / maxStock;

  // 재고 부족 여부 (60% 미만)
  bool get isLowStock => stockRatio < 0.6;
}

// -----------------------------------------------------------
// 3. 발주 품의서 모델 (PurchaseOrder)
// -----------------------------------------------------------
enum ApprovalStatus { pending, teamApproved, executiveApproved, rejected }

class PurchaseOrder {
  final String orderId;
  final String requesterName;
  final String productName;
  final int quantity;
  final String reason;
  final DateTime dateRequested;
  final Rx<ApprovalStatus> status; // GetX 상태로 결재 상태 관리

  PurchaseOrder({
    required this.orderId,
    required this.requesterName,
    required this.productName,
    required this.quantity,
    required this.reason,
    required this.dateRequested,
    ApprovalStatus initialStatus = ApprovalStatus.pending,
  }) : status = initialStatus.obs;

  String get statusText {
    switch (status.value) {
      case ApprovalStatus.pending:
        return '결재 대기 (팀장)';
      case ApprovalStatus.teamApproved:
        return '팀장 승인 (이사 대기)';
      case ApprovalStatus.executiveApproved:
        return '발주 완료';
      case ApprovalStatus.rejected:
        return '반려됨';
    }
  }
}

// -----------------------------------------------------------
// 4. 고객 반품 요청 모델 (ReturnRequest)
// -----------------------------------------------------------
class ReturnRequest {
  final String requestId;
  final String customerName;
  final String productName;
  final String storeName;
  final DateTime requestDate;
  final String reason;

  ReturnRequest({
    required this.requestId,
    required this.customerName,
    required this.productName,
    required this.storeName,
    required this.requestDate,
    required this.reason,
  });
}