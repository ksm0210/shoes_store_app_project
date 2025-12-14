// login.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_screen.dart'; 
// 🚨 관리자 로그인 스크린 임포트 (경로를 맞게 수정하세요)
import '../admin/admin_login.dart'; 

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController idController;
  late TextEditingController pwdController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    pwdController = TextEditingController();
  }

  @override
  void dispose() {
    idController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  void _login() {
    String id = idController.text;
    String pw = pwdController.text;

    // 일반 사용자 로그인 로직
    if (id == "customer" && pw == "1234") {
      Get.snackbar(
        "로그인 성공",
        "환영합니다!",
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // 로그인 성공 시 MainScreen으로 이동하며 이전 스택(로그인창)을 지웁니다.
      Get.offAll(() => const MainScreen()); 
    } else {
      Get.snackbar(
        "로그인 실패",
        "아이디(customer)와 비밀번호(1234)를 확인하세요.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  // 🚨 관리자 로그인 페이지로 이동하는 함수
  void _goToAdminLogin() {
    // 관리자 로그인 화면으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  children: [
                    SizedBox(height: 40),
                    Text("슈즈하우스", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("ShoesHouse", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 50),
                  ],
                ),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    hintText: "아이디 (customer)",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: pwdController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "비밀번호 (1234)",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _login,
                    child: const Text("로그인", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 30),
                
                // 🚨 관리자 모드 이동 버튼 추가
                TextButton(
                  onPressed: _goToAdminLogin,
                  child: const Text(
                    "관리자이신가요?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}