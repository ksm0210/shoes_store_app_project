// lib/admin/admin_approval.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'admin_controller.dart';
import 'admin_models.dart';

class AdminApprovalScreen extends StatefulWidget {
  // true: 결재 승인 모드 (임원/팀장)
  // false: 품의서 작성 모드 (본사 직원)
  final bool isApprovalMode; 
  
  const AdminApprovalScreen({super.key, this.isApprovalMode = false});

  @override
  State<AdminApprovalScreen> createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  final AdminController controller = Get.find<AdminController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // 품의서 폼 상태
  String? _selectedProduct;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  // 품의 가능한 제품 목록 (재고 목록에서 유니크한 제품만 추출)
  late List<String> _availableProducts;
  
  @override
  void initState() {
    super.initState();
    // 중복 제거된 제품명 목록 생성
    _availableProducts = controller.allInventory.map((item) => item.productName).toSet().toList();
    _selectedProduct = _availableProducts.isNotEmpty ? _availableProducts.first : null;
  }
  
  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  // 품의서 제출 로직
  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      controller.submitPurchaseOrder(
        _selectedProduct!, 
        int.parse(_quantityController.text), 
        _reasonController.text, 
        "홍길동 사원" // 더미 요청자 이름
      );
      // 제출 후 폼 초기화
      _quantityController.clear();
      _reasonController.clear();
      Get.back(); // 제출 후 대시보드로 돌아가기
    }
  }

  // -----------------------------------------------------------
  // 10번: 품의서 작성 뷰 (본사 직원 역할)
  // -----------------------------------------------------------
  Widget _buildSubmissionView() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text("신발 발주 품의서 작성", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Text("사원: 홍길동 (본사 재고 관리팀)", style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 30),

          // 1. 재고 부족 알림 목록
          if (controller.lowStockItems.isNotEmpty) 
            _buildLowStockWarning(),
          
          const SizedBox(height: 20),

          // 2. 제품 선택
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "제품명 선택",
              border: OutlineInputBorder(),
            ),
            value: _selectedProduct,
            items: _availableProducts.map((name) {
              return DropdownMenuItem(value: name, child: Text(name));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedProduct = newValue;
              });
            },
            validator: (value) => value == null ? '제품을 선택해주세요.' : null,
          ),
          const SizedBox(height: 16),

          // 3. 수량 입력
          TextFormField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "발주 수량",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return '수량을 입력해주세요.';
              if (int.tryParse(value) == null) return '유효한 숫자를 입력해주세요.';
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // 4. 발주 사유 입력
          TextFormField(
            controller: _reasonController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: "발주 사유 (재고 부족 / 신규 확보 등)",
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.isEmpty ? '사유를 입력해주세요.' : null,
          ),
          const SizedBox(height: 40),

          // 5. 제출 버튼
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _submitOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("품의서 제출", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  // 재고 부족 경고 카드 (품의서 작성 시 참고용)
  Widget _buildLowStockWarning() {
    final lowStockCount = controller.lowStockItems.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.orange.shade800),
              const SizedBox(width: 8),
              Text("자동 발주 필요 품목 ${lowStockCount}개", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade800)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "재고 부족 현황을 참고하여 품의서를 작성해주세요. (재고 60% 미만 기준)",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
  
  // -----------------------------------------------------------
  // 10번: 결재 승인 뷰 (임원/팀장 역할)
  // -----------------------------------------------------------
  Widget _buildApprovalView() {
    // 임원(Executive)은 팀장 승인 상태(teamApproved)를 최종 결재합니다.
    // 본사 직원(HeadOffice)은 결재 대기 상태(pending)를 팀장 승인으로 바꿀 수 있습니다.
    
    final isExecutive = controller.currentRole.value == AdminRole.executive;

    // 결재 대상 목록 필터링
    final ordersToApprove = controller.purchaseOrders.where((order) {
      if (isExecutive) {
        // 임원은 팀장 승인 상태(executiveApproved 직전) 또는 결재 대기 상태를 결재할 수 있습니다.
        return order.status.value == ApprovalStatus.teamApproved || order.status.value == ApprovalStatus.pending;
      } else {
        // 팀장 역할 (본사 직원)은 결재 대기 상태(pending)만 승인 가능
        return order.status.value == ApprovalStatus.pending;
      }
    }).toList();
    
    final approvedOrders = controller.purchaseOrders.where((order) => order.status.value == ApprovalStatus.executiveApproved).toList();

    return Obx(() => ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          isExecutive ? "이사 최종 결재 대기" : "팀장 결재 대기",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 20),
        
        if (ordersToApprove.isEmpty)
          const Center(child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Text("현재 결재할 품의서가 없습니다."),
          ))
        else
          ...ordersToApprove.map((order) => _buildOrderApprovalTile(order, isExecutive)).toList(),
          
        
        const Divider(height: 50),
        
        const Text(
          "결재 완료 목록",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        ...approvedOrders.map(_buildApprovedOrderTile).toList(),
      ],
    ));
  }

  // 결재 대기 품의서 타일
  Widget _buildOrderApprovalTile(PurchaseOrder order, bool isExecutive) {
    final isFinalApproval = order.status.value == ApprovalStatus.teamApproved && isExecutive;
    final buttonText = isFinalApproval ? "최종 발주 승인" : "다음 단계 승인";

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("품의 ID: ${order.orderId} (${order.statusText})", style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(height: 15),
            Text("제품: ${order.productName}", style: const TextStyle(fontSize: 16)),
            Text("수량: ${order.quantity}개", style: const TextStyle(fontSize: 16)),
            Text("요청자: ${order.requesterName} (${DateFormat('MM/dd').format(order.dateRequested)})", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 10),
            Text("사유: ${order.reason}", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey.shade700)),
            const SizedBox(height: 15),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => controller.processApproval(order.orderId, false), // 반려
                  child: const Text("반려", style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => controller.processApproval(order.orderId, true), // 승인
                  style: ElevatedButton.styleFrom(backgroundColor: isFinalApproval ? Colors.black : Colors.green),
                  child: Text(buttonText, style: const TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  
  // 결재 완료 품의서 타일
  Widget _buildApprovedOrderTile(PurchaseOrder order) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.green),
      title: Text("${order.productName} (${order.quantity}개 발주 완료)"),
      subtitle: Text("요청일: ${DateFormat('MM/dd').format(order.dateRequested)} | 최종 승인 완료"),
      trailing: Text(order.orderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.isApprovalMode ? "발주 결재 시스템 (10번)" : "발주 품의 작성 (10번)",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: widget.isApprovalMode ? _buildApprovalView() : _buildSubmissionView(),
    );
  }
}