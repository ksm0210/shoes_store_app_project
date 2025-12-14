import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  // Property
  final TextEditingController _search = TextEditingController();
  int _chipIndex = 0;

  // 탭(필터) 예시
  final List<String> _chips = ['전체', '남성', '여성', '키즈', '세일'];

  // 더미 카테고리(나중에 DB categories로 교체)
  final List<Map<String, dynamic>> _categories = [
    {'name': '러닝', 'icon': Icons.directions_run},
    {'name': '스니커즈', 'icon': CupertinoIcons.bag},
    {'name': '농구', 'icon': Icons.sports_baseball},
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _applyFilter();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '카테고리',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // 필요하면 검색창에 focus 주기
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildChips(),
          Expanded(
            child: filtered.isEmpty
                ? _buildEmpty()
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.35,
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryCard(filtered[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- UI: 검색바 ---
  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: TextField(
        controller: _search,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: '카테고리 검색',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFFF3F3F3),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // --- UI: 필터칩 ---
  Widget _buildChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_chips.length, (i) {
            final selected = i == _chipIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _chipIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? Colors.black : const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _chips[i],
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // --- UI: 카테고리 카드 ---
  Widget _buildCategoryCard(Map<String, dynamic> c) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        // TODO: 카테고리 상세/상품 리스트로 이동
        // Get.to(() => ProductListView(), arguments: c);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(c['icon'] as IconData, color: Colors.black, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                (c['name'] ?? '').toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // --- 필터/검색 ---
  List<Map<String, dynamic>> _applyFilter() {
    final keyword = _search.text.trim().toLowerCase();
    // 지금은 chip은 UI용(실제 필터는 나중에 카테고리/상품 성별 컬럼 붙이면 적용)
    return _categories.where((c) {
      if (keyword.isEmpty) return true;
      return (c['name'] ?? '').toString().toLowerCase().contains(keyword);
    }).toList();
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.grid_view_rounded, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              '카테고리가 없습니다',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              '검색어를 바꿔보세요.',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
