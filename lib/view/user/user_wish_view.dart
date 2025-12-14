import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/util/global_login_data.dart';
import 'package:shoes_store_app_project/view/product/product_detail.dart';
import 'package:shoes_store_app_project/vm/wish_handler.dart';

class UserWishView extends StatefulWidget {
  const UserWishView({super.key});

  @override
  State<UserWishView> createState() => _UserWishViewState();
}

class _UserWishViewState extends State<UserWishView> {
  // Property
  late List wishlist; // DB or GetX에서 가져온 위시리스트
  late WishHandler wishHandler;

  @override
  void initState() {
    super.initState();
    wishHandler = WishHandler();
    wishlist = [];
    getData();
  }

  getData() async {
    wishlist = await wishHandler.selectProductQuery(
      GlobalLoginData.customer_id,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '위시리스트',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: wishlist.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    '위시리스트가 비어있어요',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '마음에 드는 상품을 추가해보세요',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: wishlist.length, // 위시리스트 개수
              itemBuilder: (context, index) {
                return _wishlistCard(index);
              },
            ),
    );
  } // build

  Widget _wishlistCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 + 하트
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  wishlist[index]['mainImageUrl'],
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.favorite, color: Colors.red),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wishlist[index]['product_name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '₩${wishlist[index]['product_price']}',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () => Get.to(
                      ProductDetail(),
                      arguments: wishlist[index]['product_id'],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('구매하기', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} // class
