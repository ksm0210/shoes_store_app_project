import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/view/search/search_result.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final TextEditingController searchController = TextEditingController();
  
  // 임시 추천 검색어 (나중에 DB/서버로 교체)
  final List<String> suggestions = [
    "조던",
    "조던 1 로우",
    "조던1",
    "조던 로우",
    "에어 조던 1 브루클린 로우",
    "조던 브루클린",
    "조던4",
  ];

  @override
  void initState() {
    super.initState();
    searchController.text = "에어조던"; // 스샷처럼 기본 입력값 느낌
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void clearSearch() {
    searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const bg = Colors.white;
    final greyText = Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // 상단 검색바 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, size: 26),
                  ),

                  // 검색바
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey.shade700),
                          const SizedBox(width: 10),

                          // 텍스트필드
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: const TextStyle(fontSize: 16),
                              onChanged: (_) => setState(() {}),
                              onSubmitted: (value) {
                                final q = value.trim();
                                if (q.isEmpty) return;

                                Get.to(() => SearchResultPage(query: q));
                              },
                            ),
                          ),

                          // X 버튼 (검색어 있을 때만 표시)
                          if (searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: clearSearch,
                              child: const Icon(Icons.close, size: 22),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 추천 검색어 타이틀
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "추천 검색어",
                  style: TextStyle(
                    color: greyText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // 추천 검색어 리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final word = suggestions[index];
                  return InkWell(
                    onTap: () {
                      // 추천어 누르면 검색바에 채우고(또는 바로 검색)
                      searchController.text = word;
                      searchController.selection = TextSelection.fromPosition(
                        TextPosition(offset: searchController.text.length),
                      );
                      setState(() {});

                      final q = word.trim();
                      if (q.isEmpty) return;

                      Get.to(() => SearchResultPage(query: q));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        word,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 하단 네비는 지금 화면 디자인에만 맞춰서 "자리만" 잡은 거야.
      // 이미 너 프로젝트에 BottomNavigationBar가 있으면 그쪽 구조에 맞춰 붙이면 됨.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          // TODO: 네비 이동 연결
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "구매하기"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "위시리스트",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "장바구니",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "프로필",
          ),
        ],
      ),
    );
  }
}
