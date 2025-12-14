// lib/admin/admin_inventory.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'admin_controller.dart';
import 'admin_models.dart';

class AdminInventoryScreen extends StatelessWidget {
  final AdminRole role; 
  const AdminInventoryScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // 💡 수정된 부분: build 메서드 내부에서 컨트롤러를 찾습니다. (안정성 보장)
    final AdminController controller = Get.find<AdminController>();
    
    String title = "재고/현황 분석";
    Widget bodyContent;

    // 역할에 따라 다른 뷰 제공
    if (role == AdminRole.storeManager) {
      title = "대리점 재고 현황 (7번)";
      bodyContent = _buildStoreInventoryView(controller); // 컨트롤러 전달
    } else {
      title = "본사 판매 및 재고 현황 (8번, 10번)";
      bodyContent = _buildHeadOfficeAnalytics(controller); // 컨트롤러 전달
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: bodyContent,
    );
  }
  
  // -----------------------------------------------------------
  // 7번: 대리점장 뷰 (자신의 매장 재고 파악) - 컨트롤러 인자 추가
  // -----------------------------------------------------------
  Widget _buildStoreInventoryView(AdminController controller) {
    // 임시로 강남점(S001)의 재고만 보여준다고 가정
    final String targetStoreId = 'S001'; 
    final storeInventory = controller.allInventory.where((item) => item.storeId == targetStoreId).toList();
    
    return Obx(() => ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          "강남점 (S001) 실시간 재고",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 20),
        
        // Obx로 감싸진 allInventory를 사용하므로, 데이터가 업데이트되면 UI가 자동으로 갱신됩니다.
        ...storeInventory.map((item) => _buildInventoryTile(item)).toList(),
      ],
    ));
  }
  
  // -----------------------------------------------------------
  // 8번/10번: 본사/임원 뷰 (전체 현황 및 부족 재고) - 컨트롤러 인자 추가
  // -----------------------------------------------------------
  Widget _buildHeadOfficeAnalytics(AdminController controller) {
    final lowStockItems = controller.lowStockItems;
    final salesData = controller.salesStatus;
    
    return Obx(() => ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          "전사 재고 부족 현황 (60% 미만)",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        if (lowStockItems.isEmpty)
          const Center(child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("현재 재고 부족 품목이 없습니다.", style: TextStyle(color: Colors.green)),
          ))
        else
          ...lowStockItems.map((item) => _buildLowStockTile(item)).toList(),

        const Divider(height: 40),

        const Text(
          "제품별 총 판매 현황 (8번)",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        _buildSalesStatusTable(salesData),
      ],
    ));
  }
  
  // 개별 재고 타일
  Widget _buildInventoryTile(InventoryItem item) {
    final progressColor = item.isLowStock ? Colors.red : Colors.green;
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.productName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("현재 재고: ${item.stockCount} / ${item.maxStock}"),
                Text("판매량: ${item.soldCount}개"),
              ],
            ),
            const SizedBox(height: 5),
            // 재고 시각화
            LinearProgressIndicator(
              value: item.stockRatio,
              backgroundColor: Colors.grey.shade200,
              color: progressColor,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            if (item.isLowStock)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "🚨 재고 부족! 발주가 필요합니다.",
                  style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // 부족 재고 타일 (본사/임원용)
  Widget _buildLowStockTile(InventoryItem item) {
     return Card(
      color: Colors.red.shade50,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.warning_amber, color: Colors.red),
        title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${item.storeName} | 재고 ${item.stockCount} / ${item.maxStock}"),
        trailing: Text(
          "${(item.stockRatio * 100).toStringAsFixed(0)}%",
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
  
  // 판매 현황 테이블 (8번)
  Widget _buildSalesStatusTable(List<Map<String, dynamic>> salesData) {
    final currencyFormatter = NumberFormat('#,###', 'ko_KR');

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DataTable(
        columnSpacing: 10,
        horizontalMargin: 10,
        columns: const [
          DataColumn(label: Text('제품명', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('판매량', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
          DataColumn(label: Text('총 매출', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
        ],
        rows: salesData.map((data) {
          final revenueFormatted = currencyFormatter.format(data['totalRevenue']);
          
          return DataRow(
            cells: [
              DataCell(Text(data['productName'] as String)),
              DataCell(Text((data['totalSold'] as int).toString())),
              DataCell(Text('₩$revenueFormatted', style: TextStyle(color: data['totalRevenue'] > 5000000 ? Colors.green.shade700 : Colors.black))),
            ],
          );
        }).toList(),
      ),
    );
  }
}