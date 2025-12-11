import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  //Property
  late bool pwdMatch;  // 비밀번호 확인을 눌러서 확인받아야 회원가입넘어감
  late TextEditingController emailController; // 이메일 textfield
  late TextEditingController passwordController; // 비밀번호 textfield
  late TextEditingController reEnterpasswordController; // 비밀번호 재입력 textfield
  late TextEditingController nameController; // 이메일 textfield
  late TextEditingController phoneController; // 휴대전화 textfield
  late bool agree;

  @override
  void initState() {
    super.initState();
    pwdMatch = false;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    reEnterpasswordController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // 이메일
              const Text(
                '이메일 주소',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _BuildField(
                controller: emailController,
                hint: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // 비밀번호 & 비밀번호 확인 (2열)
               Row(
                children: [
                  Text(
                    '비밀번호',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      if (passwordController.text.trim() == reEnterpasswordController.text.trim()
                      ) {
                        showpasswordMatchDialog(context);
                      }else{
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
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _BuildField(
                      controller: reEnterpasswordController,
                      hint: '비밀번호 재입력',
                      obscure: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 이름
              const Text(
                '이름',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
               _BuildField(
                controller: nameController,
                hint: '홍길동',
              ),

              const SizedBox(height: 20),

              // 휴대폰 번호
              const Text(
                '휴대폰 번호',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _BuildField(
                controller: phoneController,
                hint: '010-0000-0000',
                keyboardType: TextInputType.phone,
              ),

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
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
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
                    backgroundColor: navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black.withAlpha(60),
                  ),
                  onPressed: agree
                      ? () {
                          if (emailController.text.trim().isEmpty ||
                              passwordController.text.trim().isEmpty||
                              reEnterpasswordController.text.trim().isEmpty||
                              nameController.text.trim().isEmpty||
                              phoneController.text.trim().isEmpty||
                              pwdMatch == false) {
                                // showdialog
                          }
                        }
                      : null, // 동의 안 했으면 비활성화
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
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

  // password가 일치할때
showpasswordMatchDialog(BuildContext context){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "비밀번호 확인 완료",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          "비밀번호가 서로 일치합니다.\n회원가입을 계속 진행해 주세요.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              pwdMatch = true;
              Get.back();
            },
            child: const Text("확인"),
          ),
        ],
      );
    },
  );
}
// password가 일치하지않을때
showpasswordNotMatchDialog(BuildContext context){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "비밀번호가 일치하지 않습니다",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.redAccent,
          ),
        ),
        content: const Text(
          "입력하신 비밀번호와 비밀번호 확인이 서로 다릅니다.\n"
          "다시 한 번 확인 후 입력해 주세요.",
          style: TextStyle(
            fontSize: 12
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              passwordController.clear();
              reEnterpasswordController.clear();
              Get.back();
              // TODO: 필요하면 여기에서 비밀번호 확인 필드에 포커스 이동
            },
            child: const Text("다시 입력"),
          ),
        ],
      );
    },
  );
}

} // class





/// 공통 입력 필드 위젯 (회색 배경 + 둥근 모서리)
class _BuildField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController controller;

  const _BuildField({
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
        ),
        filled: true,
        fillColor: const Color(0xFFF4F5F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
} // class