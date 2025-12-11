import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/model/customer.dart';
import 'package:shoes_store_app_project/vm/customer_handler.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  //Property
  late bool checkEmail; // 중복확인에 따라 바뀜
  late String checkDuplicate; // 중복확인에따라 text바뀜
  late CustomerHandler handler; // customer DB
  late bool pwdMatch; // 비밀번호 확인을 눌러서 확인받아야 회원가입넘어감
  late TextEditingController emailController; // 이메일 textfield
  late TextEditingController passwordController; // 비밀번호 textfield
  late TextEditingController reEnterpasswordController; // 비밀번호 재입력 textfield
  late TextEditingController nameController; // 이메일 textfield
  late bool agree;

  @override
  void initState() {
    super.initState();
    checkEmail = false;
    checkDuplicate = '중복확인';
    handler = CustomerHandler();
    pwdMatch = false;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    reEnterpasswordController = TextEditingController();
    nameController = TextEditingController();
    agree = false;
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0B1220); // 버튼 색 느낌

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // 제목 & 서브 타이틀
              const Center(
                child: Column(
                  children: [
                    Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'ShoesHouse의 멤버가 되어보세요.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // 이메일
              Row(
                children: [
                  const Text(
                    '이메일 주소',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: checkEmail
                        ? null
                        : () {
                            checkEmailDuplicate();
                          },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFF3E9FF), // 연보라색 배경
                      foregroundColor: const Color(0xFF7B4CFF), // 보라 텍스트
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999), // 동글동글 pill
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(checkDuplicate),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _BuildField(
                controller: emailController,
                hint: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    // 이메일이 바뀌면 다시 중복확인 해야 하니까 상태 리셋
                    checkEmail = false;
                    checkDuplicate = '중복확인';
                  });
                },
              ),

              const SizedBox(height: 20),

              // 비밀번호 & 비밀번호 확인 (2열)
              Row(
                children: [
                  Text(
                    '비밀번호',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      if (passwordController.text.trim().isNotEmpty &&
                          reEnterpasswordController.text.trim().isNotEmpty &&
                          passwordController.text.trim() ==
                              reEnterpasswordController.text.trim()) {
                        showpasswordMatchDialog(context);
                      } else {
                        showpasswordNotMatchDialog(context);
                      }
                    },
                    child: Text(
                      '비밀번호 확인',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _BuildField(
                      controller: passwordController,
                      hint: '비밀번호 입력',
                      obscure: true,
                      onChanged: (value) {
                        setState(() {
                          // 비밀번호가 바뀌면 다시 중복확인 해야 하니까 상태 리셋
                          pwdMatch = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _BuildField(
                      controller: reEnterpasswordController,
                      hint: '비밀번호 재입력',
                      obscure: true,
                      onChanged: (value) {
                        setState(() {
                          // 비밀번호가 바뀌면 다시 중복확인 해야 하니까 상태 리셋
                          pwdMatch = false;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 이름
              const Text(
                '이름',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _BuildField(controller: nameController, hint: '홍길동'),

              const SizedBox(height: 24),

              // 개인정보 동의
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => agree = !agree),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.grey.shade400),
                        color: agree ? navy : Colors.white,
                      ),
                      child: agree
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        children: const [
                          TextSpan(text: '개인정보 처리 방침'),
                          TextSpan(
                            text: '에 동의합니다.',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // 회원가입 버튼
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black.withAlpha(60),
                  ),
                  onPressed: agree
                      ? () {
                          if (emailController.text.trim().isEmpty ||
                              nameController.text.trim().isEmpty ||
                              passwordController.text.trim().isEmpty ||
                              reEnterpasswordController.text.trim().isEmpty ||
                              pwdMatch == false ||
                              checkEmail == false) {
                            Get.snackbar(
                              "회원가입이 불가능합니다.",
                              "입력 정보를 다시 확인해주세요.",
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                              colorText: Colors.black,
                            );
                          } else {
                            Get.defaultDialog(
                              title: "회원가입완료",
                              middleText: "ShoesHouse의 회원이 되신 걸 환영합니다!",
                              barrierDismissible: false,
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    insertSignUp();

                                    Get.back();
                                    Get.back();
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            );
                          }
                        }
                      : null, // 동의 안 했으면 비활성화
                  child: const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 이미 계정이 있으신가요? 로그인
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '이미 계정이 있으신가요? ',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back(); // 로그인 화면으로 돌아가기
                      },
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  } // build

  //-----functions-----

  // 이메일형식인지 아닌지 확인
  bool isEmailValid(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  // 중복체크완료 dialog
  showEmailCheckSuccessDialog() {
    Get.defaultDialog(
      title: "",
      barrierDismissible: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      radius: 20,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 초록 체크 아이콘
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.green,
              size: 38,
            ),
          ),

          const SizedBox(height: 18),

          // 제목
          const Text(
            "사용 가능한 이메일입니다",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 8),

          // 설명
          const Text(
            "회원가입을 계속 진행해주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),

          const SizedBox(height: 24),

          // 확인 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "확인",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 이메일 주소 중복확인부분
  checkEmailDuplicate() async {
    // 1) 비어있는지 먼저 체크
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "이메일을 입력해주세요",
        "중복확인을 하기 전에 이메일을 먼저 입력해주세요.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 2) 이메일 형식이 올바른지 체크
    if (!isEmailValid(emailController.text.trim())) {
      Get.snackbar(
        "올바르지 않은 이메일 형식",
        "이메일 주소 형식을 다시 확인해주세요.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    int result = await handler.queryCheckCustomerId(
      emailController.text.trim(),
    );
    if (result == 0) {
      showEmailCheckSuccessDialog();
      checkDuplicate = '중복확인완료';
      checkEmail = true;
      setState(() {});
    } else {
      Get.snackbar(
        "이미 사용 중인 이메일입니다",
        "다른 이메일 주소로 다시 시도해주세요 ",
        snackPosition: SnackPosition.BOTTOM, // snackbar 위치이동(TOP, BOTTOM)
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.black, // snackbar는 bold가 기본이다.
      );
      emailController.clear();
    }
  }

  // 회원가입할때 Insert부분
  insertSignUp() async {
    Customer user = Customer(
      customer_password: passwordController.text.trim(),
      customer_name: nameController.text.trim(),
      customer_email: emailController.text.trim(),
    );
    await handler.insert(user);
  }

  // password가 일치할때
  void showpasswordMatchDialog(BuildContext context) {
    Get.defaultDialog(
      title: "",
      barrierDismissible: false,
      backgroundColor: Colors.white,
      radius: 24,
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 보라 체크 아이콘
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE7FF), // 연보라 배경
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF673AB7), // 보라색 아이콘
              size: 40,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "비밀번호 확인 완료",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "비밀번호가 서로 일치합니다.\n회원가입을 계속 진행해 주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                pwdMatch = true;
                setState(() {});
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "확인",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // password가 일치하지않을때
  void showpasswordNotMatchDialog(BuildContext context) {
    Get.defaultDialog(
      title: "",
      barrierDismissible: false,
      backgroundColor: Colors.white,
      radius: 24,
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 빨간 X 아이콘
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE), // 옅은 빨강 배경
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close_rounded,
              color: Color(0xFFD32F2F), // 진한 빨강
              size: 40,
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "비밀번호가 일치하지 않습니다",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD32F2F),
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            "입력하신 비밀번호와 비밀번호 확인이 서로 다릅니다.\n"
            "다시 한 번 확인 후 입력해 주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                passwordController.clear();
                reEnterpasswordController.clear();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "다시 입력",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} // class

/// 공통 입력 필드 위젯 (회색 배경 + 둥근 모서리)
class _BuildField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const _BuildField({
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: const Color(0xFFF4F5F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
} // class
