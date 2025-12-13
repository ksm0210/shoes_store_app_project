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
          ],
        ),
      ),
    );
  }
}
