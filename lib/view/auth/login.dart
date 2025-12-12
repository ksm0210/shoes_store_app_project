import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/model/customer.dart';
import 'package:shoes_store_app_project/view/auth/signup.dart';
import 'package:shoes_store_app_project/view/home.dart';
import 'package:shoes_store_app_project/vm/customer_handler.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Property
  late bool obscurePassword;       // 비밀번호 숨김 여부
  late CustomerHandler handler;
  late int value; // customer text 투명도
  late bool manager2Visible; // Visible value
  late TextEditingController idController; // customer id 적는 textfield
  late TextEditingController pwdController; // customer password 적는 textfield

  @override
  void initState() {
    super.initState();
    obscurePassword = true;
    handler = CustomerHandler();
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
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    hintText: "비밀번호",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        obscurePassword = !obscurePassword;
                        setState(() {});
                      }, 
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      )
                    )
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
                    onPressed: () async {
                      int result = await handler.loginSelectQuery(
                        idController.text.trim(),
                        pwdController.text.trim(),
                      );
                      if (result == 1) {
                        // 여기가 로그인 들어왔을때
                        Get.snackbar(
                          "로그인 성공",
                          "환영합니다!",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        
                        // 로그인 성공 시 MainScreen으로 이동하며 이전 스택(로그인창)을 지웁니다.
                        Get.offAll(() => const Home()); 
                        


                      } else {
                        Get.snackbar(
                          "경고",
                          "아이디, 비밀번호가 틀립니다\n다시입력해주세요",
                          snackPosition: SnackPosition
                              .TOP, // snackbar 위치이동(TOP, BOTTOM)
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                          colorText: Colors.black, // snackbar는 bold가 기본이다.
                        );
                      }
                    },
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
                        Get.to(Signup());
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
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onDoubleTap: () {
                    manager2Visible == false
                        ? manager2Visible = true
                        : manager2Visible = false;
                    setState(() {});
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      // 이거 text누르면 관리자 text나옴
                      '...',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey.withAlpha(value),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } // build
} // class
