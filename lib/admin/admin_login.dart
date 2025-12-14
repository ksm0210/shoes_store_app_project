// lib/admin/admin_login.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 컨트롤러 및 모델 경로를 맞게 수정하세요.
import '../util/controllers.dart'; // AdminController를 이곳에서 등록한다고 가정합니다.
import 'admin_controller.dart';
import 'admin_models.dart';
import 'admin_dashboard.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  // 관리자 로그인 버튼 위젯 생성 함수
  Widget _buildLoginButton({
    required BuildContext context,
    required String title,
    required AdminRole role,
    required Color color,
  }) {
    final AdminController adminController = Get.find<AdminController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            adminController.login(role); // 역할 설정
            // 대시보드로 이동 (Navigator 사용)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🚨 중요: MainScreen이 아닌 AdminLoginScreen에서 AdminController를 주입합니다.
    // 만약 main.dart에서 주입하지 않았다면, 여기서 Get.put을 사용해야 합니다.
    // 여기서는 안전하게 Get.put을 사용하겠습니다.
    Get.put(AdminController()); 
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "관리자 로그인",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "역할 선택",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(
                "구동 영상 시뮬레이션을 위해 역할을 선택하세요.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 50),

              // 본사 직원 (사원 시뮬레이션)
              _buildLoginButton(
                context: context,
                title: "본사 직원 (재고 관리 및 품의 작성)",
                role: AdminRole.headOffice,
                color: Colors.black,
              ),

              // 대리점장
              _buildLoginButton(
                context: context,
                title: "대리점장 (재고 확인 및 반품 처리)",
                role: AdminRole.storeManager,
                color: Colors.grey.shade800,
              ),
              
              // 임원 (이사 시뮬레이션)
              _buildLoginButton(
                context: context,
                title: "임원 (최종 결재 및 현황 파악)",
                role: AdminRole.executive,
                color: Colors.blue.shade700,
              ),

              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  // 일반 사용자 로그인 화면으로 돌아가기 (임시)
                  Navigator.pop(context);
                },
                child: const Text(
                  "일반 사용자 화면으로 돌아가기",
                  style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}