// my_page.dart

import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("마이페이지", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // 프로필 영역
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFF0F0F0),
                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  SizedBox(height: 12),
                  Text("Stitch User", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("user@stitch.com", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            const Divider(thickness: 8, color: Color(0xFFF8FAFC)),

            // 메뉴 리스트
            _buildMenuItem(Icons.shopping_bag_outlined, "주문 내역"),
            _buildMenuItem(Icons.favorite_border, "위시리스트"),
            _buildMenuItem(Icons.receipt_long_outlined, "구매내역"),
            
            const Divider(thickness: 8, color: Color(0xFFF8FAFC)),
            
            _buildMenuItem(Icons.location_on_outlined, "배송지 관리"),
            _buildMenuItem(Icons.credit_card, "결제 수단 관리"),
            
            const Divider(thickness: 8, color: Color(0xFFF8FAFC)),
            
            _buildMenuItem(Icons.settings_outlined, "설정"),
            _buildMenuItem(Icons.help_outline, "고객센터"),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: 24),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}