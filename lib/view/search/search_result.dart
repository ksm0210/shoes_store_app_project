// search_result.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/model/product.dart';
import 'package:shoes_store_app_project/view/product/product_detail.dart';
import 'package:shoes_store_app_project/vm/product_handler.dart';

class SearchResultPage extends StatelessWidget {
  final String query;

  const SearchResultPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    // Property
    final ProductHandler productHandler = ProductHandler();

    return Scaffold(
      appBar: AppBar(
        title: Text('검색 결과: "$query"'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: productHandler.searchProducts(query),
        builder: (context, snapshot) {
          if (query.trim().isEmpty) {
            return const Scaffold(body: Center(child: Text("검색어를 입력해주세요.")));
          }

          // 로딩
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 에러
          if (snapshot.hasError) {
            return Center(child: Text("오류: ${snapshot.error}"));
          }

          final results = snapshot.data ?? [];

          // 결과 없음
          if (results.isEmpty) {
            return const Center(
              child: Text("검색 결과가 없습니다.", style: TextStyle(color: Colors.grey)),
            );
          }

          // 결과 있음 → Grid
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];

              final String name = (item.product_name ?? '').toString();
              final int price =
                  int.tryParse(item.product_price.toString() ?? '0') ?? 0;

              // 이미지 컬럼이 없거나 null일 수 있으니 방어
              final String? imageUrl = item.mainImageUrl.toString();

              final priceFormatted = price.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (m) => '${m[1]},',
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.grey[100],
                        child: (imageUrl != null && imageUrl.isNotEmpty)
                            ? GestureDetector(
                              onTap: ()=>Get.to(()=>ProductDetail(),arguments: results[index].product_id ),
                              child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                            )
                            : const Center(
                                child: Icon(Icons.image, color: Colors.grey),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₩$priceFormatted",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
