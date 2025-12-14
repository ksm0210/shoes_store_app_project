// lib/admin/admin_dashboard.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/model/admin.dart';
import 'package:shoes_store_app_project/view/admin/admin_approval.dart';
import 'admin_controller.dart';
// import 'admin_models.dart';
import 'admin_inventory.dart'; // 재고/판매 현황 페이지 임포트 (다음 순서에 작성될 페이지)
// import 'admin_approval.dart'; // 발주/결재 페이지 임포트 (다음 순서에 작성될 페이지)
import 'admin_login.dart'; // 로그아웃 시 이동할 페이지

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  // 관리자 역할에 따른 메뉴 위젯 생성
  Widget _buildRoleSpecificMenu(
    BuildContext context,
    AdminRole role,
    AdminController controller,
  ) {
    switch (role) {
      case AdminRole.storeManager:
        return _buildStoreManagerMenu(context, controller);
      case AdminRole.headOffice:
        return _buildHeadOfficeMenu(context, controller);
      case AdminRole.executive:
        return _buildExecutiveMenu(context, controller);
      case AdminRole.none:
      default:
        return const Center(child: Text("로그인 정보가 없습니다."));
    }
  }

  // -----------------------------------------------------------
  // 대리점장 메뉴 (7번: 재고 파악, 9번: 반품 요청)
  // -----------------------------------------------------------
  Widget _buildStoreManagerMenu(
    BuildContext context,
    AdminController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDashboardCard(
          title: "오늘의 재고 현황 파악",
          subtitle: "현재 매장의 재고 수량을 확인하고 부족분을 파악합니다.",
          icon: Icons.inventory_2_outlined,
          onTap: () {
            // AdminInventoryScreen으로 이동하며 대리점장 모드임을 알림
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AdminInventoryScreen(role: AdminRole.storeManager),
              ),
            );
          },
        ),
        _buildDashboardCard(
          title: "고객 반품 요청 확인",
          subtitle: "고객이 방문 요청한 반품 목록을 확인하고 처리합니다. (9번)",
          icon: Icons.assignment_return_outlined,
          onTap: () {
            Get.to(() => _buildReturnRequestScreen(controller)); // 반품 목록 임시 표시
          },
        ),
        const SizedBox(height: 30),
        const Text(
          "오늘의 주요 활동",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.warning, color: Colors.orange),
          title: const Text("재고 부족 알림"),
          subtitle: Text(
            "재고가 60% 미만인 상품 ${controller.lowStockItems.length}개가 있습니다.",
          ),
        ),
      ],
    );
  }

  // -----------------------------------------------------------
  // 본사 직원 메뉴 (6번: 발송, 8번: 현황, 10번: 발주 품의)
  // -----------------------------------------------------------
  Widget _buildHeadOfficeMenu(
    BuildContext context,
    AdminController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDashboardCard(
          title: "제품 발송/배정 관리",
          subtitle: "고객 구매 신청 건을 확인하고 희망 대리점으로 발송 처리합니다. (6번)",
          icon: Icons.send_outlined,
          onTap: () {
            // 여기서는 6번 로직 시뮬레이션 (간단한 알림)
            Get.snackbar(
              "발송 관리",
              "금일 구매 신청 5건, 강남점으로 3건 발송 예정",
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
        _buildDashboardCard(
          title: "전체 재고/판매 현황 분석",
          subtitle: "제품별, 일자별 판매 및 재고 현황을 파악합니다. (8번)",
          icon: Icons.analytics_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AdminInventoryScreen(role: AdminRole.headOffice),
              ),
            );
          },
        ),
        _buildDashboardCard(
          title: "신발 발주 품의 시스템",
          subtitle: "재고 부족 품목을 확인하고 제조사에 발주 품의서를 작성합니다. (10번)",
          icon: Icons.request_page_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminApprovalScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  // -----------------------------------------------------------
  // 임원 메뉴 (8번: 현황, 10번: 결재)
  // -----------------------------------------------------------
  Widget _buildExecutiveMenu(BuildContext context, AdminController controller) {
    final pendingOrdersCount = controller.purchaseOrders
        .where((o) => o.status.value == ApprovalStatus.teamApproved)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDashboardCard(
          title: "결재 대기 품의서 확인",
          subtitle: "팀장 승인이 완료된 발주 품의서를 최종 결재합니다. (10번)",
          icon: Icons.check_circle_outline,
          color: pendingOrdersCount > 0 ? Colors.red.shade700 : Colors.blueGrey,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AdminApprovalScreen(isApprovalMode: true),
              ),
            );
          },
        ),
        _buildDashboardCard(
          title: "전사 판매 현황 보고서",
          subtitle: "제품별, 일자별 현황을 파악합니다. (8번)",
          icon: Icons.assessment_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AdminInventoryScreen(role: AdminRole.executive),
              ),
            );
          },
        ),
      ],
    );
  }

  // 공통 대시보드 카드 위젯
  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // 9번: 고객 반품 요청 목록 임시 화면
  Widget _buildReturnRequestScreen(AdminController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text("반품 요청 목록")),
      body: ListView.builder(
        itemCount: controller.returnRequests.length,
        itemBuilder: (context, index) {
          final req = controller.returnRequests[index];
          return ListTile(
            leading: const Icon(Icons.assignment_return),
            title: Text("${req.productName} (${req.customerName})"),
            subtitle: Text("매장: ${req.storeName} | 사유: ${req.reason}"),
            trailing: const Text("처리 대기", style: TextStyle(color: Colors.red)),
            onTap: () {
              Get.snackbar(
                "처리",
                "${req.requestId} 반품을 처리합니다.",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AdminController 인스턴스 가져오기 (admin_login에서 put했으므로 find 가능)
    final AdminController controller = Get.find<AdminController>();

    return Obx(() {
      final currentRole = controller.currentRole.value;
      final roleText = currentRole.toString().split('.').last;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "${roleText.toUpperCase()} 대시보드",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: () {
                controller.login(AdminRole.none); // 역할 초기화
                // AdminLoginScreen으로 돌아가기 (로그인 스택 제거)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "환영합니다, ${currentRole == AdminRole.executive
                    ? '이사'
                    : currentRole == AdminRole.storeManager
                    ? '대리점장'
                    : '사원'}님.",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 5),
              Text(
                "오늘의 주요 업무를 확인해주세요.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 30),

              // 역할별 메뉴 로드
              _buildRoleSpecificMenu(context, currentRole, controller),
            ],
          ),
        ),
      );
    });
  }
}
