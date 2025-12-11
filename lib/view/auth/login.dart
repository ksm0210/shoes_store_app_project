import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/view/auth/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Property
  late int value;         // customer text 투명도
  late bool manager2Visible; // Visible value
  late TextEditingController idController;  // customer id 적는 textfield
  late TextEditingController pwdController; // customer password 적는 textfield

  @override
  void initState() {
    super.initState();
    value = 20;
    manager2Visible = false;
    idController = TextEditingController();
    pwdController = TextEditingController();
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
                // 로고 부분
                Column(
                  children: [
                    const SizedBox(height: 40),
                    // 아이콘 또는 로고
                    Text(
                      "슈즈하우스",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "ShoesHouse",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),

                // 이메일 입력창
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    hintText: "이메일 주소",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 비밀번호 입력창
                TextField(
                  controller: pwdController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "비밀번호",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "로그인",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // 회원가입
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("계정이 없으신가요?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          Signup()
                        );
                      },
                      child: const Text(
                        "회원가입",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 관리자 전용
                Visibility(
                  visible: manager2Visible,
                  child: TextButton(
                    onPressed: () {
                      // 관리자 웹으로넘어가는곳
                    }, 
                    child: Text(
                      '관리자이신가요?',
                    style: TextStyle(
                      fontSize: 13,
                      decoration: TextDecoration.underline
                    ),
                    )
                  )
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onDoubleTap: () {
                    manager2Visible == false ? manager2Visible=true : manager2Visible=false;
                    setState(() {});
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(  // 이거 text누르면 관리자 text나옴
                      '...',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey.withAlpha(value)
                      ),
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}