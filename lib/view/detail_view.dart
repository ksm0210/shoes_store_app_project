import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/model/product_model.dart'; 

// ------------------------------------------------------------------
// 주의: 아래 import 경로는 실제 프로젝트 구조에 맞게 수정해야 합니다.
// ------------------------------------------------------------------
import 'package:shoes_store_app_project/view/shopping_cart.dart'; // ShoppingCart 위젯 경로
import 'package:shoes_store_app_project/view/order.dart'; // OrderScreen 위젯 경로 (임시 경로, 실제 경로로 수정 필요)
import '../util/controllers.dart'; // CartController 파일 경로
// import '../models/product_model.dart'; // ProductModel 파일 경로
// ------------------------------------------------------------------

class DetailScreen extends StatefulWidget {
  // main_screen에서 넘겨주는 데이터들
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;
  final String description; // 이건 선택사항 (기본값 있음)

  const DetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    this.description = "이 제품은 뛰어난 쿠셔닝과 세련된 디자인을 자랑합니다. 일상 생활과 스포츠 활동 모두에 적합하며, 편안한 착화감을 제공합니다.",
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // GetX: CartController 인스턴스화 및 주입
  final CartController cartController = Get.put(CartController());
  
  late final PageController _pageController;

  // 상태 관리 변수들
  int _currentImageIndex = 0;
  int _selectedColorIndex = 0;
  bool _isLiked = false;

  // A1: 선택 가능한 사이즈 목록 (220부터 290까지 5단위)
  final List<String> _availableSizes = [
    for (int size = 220; size <= 290; size += 5) size.toString()
  ];
  // A1: 현재 선택된 사이즈
  String? _selectedSize;

  // 더미 데이터: 이미지 리스트
  late final List<String> _productImages;

  @override
  void initState() {
    super.initState();
    
    _pageController = PageController();

    _productImages = [
      widget.imageUrl, // main_screen에서 넘겨받은 이미지
      "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/b1bcbca4-e853-4df7-b329-5be3c61ee057/air-force-1-07-mens-shoes-jBrhBr.png", 
      "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/fc4622c4-2769-4665-aa6e-a2c06d316662/air-force-1-07-mens-shoes-jBrhBr.png", 
      "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/aa503541-c9d3-455b-9285-a77d70428d02/air-force-1-07-mens-shoes-jBrhBr.png", 
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 이미지 캐러셀
            _buildImageCarousel(),

            // 2. 색상 선택 썸네일
            _buildColorSelector(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3. 상품 정보 (타이틀, 가격)
                  const SizedBox(height: 20),
                  Text(
                    widget.title, 
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle, 
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.price, 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
                  ),

                  // 4. 사이즈 선택 버튼
                  const SizedBox(height: 30),
                  _buildSizeSelector(),

                  // 5. 메인 액션 버튼들 (구매하기, 장바구니, 위시)
                  const SizedBox(height: 20),
                  _buildActionButtons(),

                  // 6. 안내 박스
                  const SizedBox(height: 30),
                  _buildInfoBox(),
                  
                  // 제품 설명 추가 (description 활용)
                  const SizedBox(height: 20),
                  const Text(
                    "제품 설명",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description, 
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                  ),
                  const Divider(height: 60, thickness: 1, color: Color(0xFFEEEEEE)),

                  // 7. 함께 본 상품
                  const Text("함께 본 상품", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildRecommendations(),

                  const Divider(height: 60, thickness: 1, color: Color(0xFFEEEEEE)),

                  // 8. 리뷰 섹션
                  _buildReviewSection(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 앱바
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.title, 
        style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  // 이미지 슬라이더 (A2: PageController 연동)
  Widget _buildImageCarousel() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: 1.1, 
          child: PageView.builder(
            controller: _pageController, 
            itemCount: _productImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
                _selectedColorIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                color: const Color(0xFFF5F5F5), 
                child: Image.network(
                  _productImages[index],
                  fit: BoxFit.cover, 
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_productImages.length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index ? Colors.black : Colors.grey.withOpacity(0.5),
                ),
              );
            }),
          ),
        )
      ],
    );
  }

  // 색상 선택 리스트 (A2: PageController 연동)
  Widget _buildColorSelector() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_productImages.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColorIndex = index;
              });
              
              _pageController.animateToPage(
                index, 
                duration: const Duration(milliseconds: 300), 
                curve: Curves.easeInOut
              );
            },
            child: Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _selectedColorIndex == index ? Colors.black : Colors.transparent,
                  width: 2,
                ),
                image: DecorationImage(
                  image: NetworkImage(_productImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // 사이즈 선택 버튼 (A1: 가로 스크롤 선택 버튼)
  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            _selectedSize == null 
              ? "사이즈를 선택해주세요" 
              : "선택된 사이즈: ${_selectedSize!}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        
        SizedBox(
          height: 50, 
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _availableSizes.map((size) {
                final isSelected = _selectedSize == size;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSize = isSelected ? null : size;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // 장바구니/구매/위시 버튼 (구매 로직 수정됨)
  Widget _buildActionButtons() {
    final bool isSizeSelected = _selectedSize != null;
    
    // 장바구니 기능 추가 함수
    void _handleAddToCart() {
      if (!isSizeSelected) {
        Get.snackbar("알림", "사이즈를 선택해주세요.",
            snackPosition: SnackPosition.BOTTOM, 
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white
        );
        return;
      }
      
      final selectedProduct = ProductModel(
        title: widget.title,
        price: widget.price,
        imageUrl: widget.imageUrl,
        selectedSize: _selectedSize!,
        selectedColorImageUrl: _productImages[_selectedColorIndex],
      );
      
      // 장바구니에 추가 (Map 형태로 변환하여 Controller에 전달)
      cartController.addToCart({
        'title': selectedProduct.title,
        'price': selectedProduct.price,
        'selectedSize': selectedProduct.selectedSize,
        'selectedColorImageUrl': selectedProduct.selectedColorImageUrl,
      });

      // 장바구니 화면으로 이동 (Navigator.push 사용)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShoppingCart()), 
      );
    }
    
    // 구매하기 기능 추가 함수 (수정됨: 구매 전에 아이템을 장바구니에 추가)
    void _handlePurchase() {
      if (!isSizeSelected) {
        Get.snackbar("알림", "사이즈를 선택해주세요.",
            snackPosition: SnackPosition.BOTTOM, 
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white
        );
        return;
      }

      final selectedProduct = ProductModel(
        title: widget.title,
        price: widget.price,
        imageUrl: widget.imageUrl,
        selectedSize: _selectedSize!,
        selectedColorImageUrl: _productImages[_selectedColorIndex],
      );
      
      // 🚨 핵심 수정: 구매 페이지가 장바구니 마지막 아이템을 참조하므로, 
      // 구매 전에 장바구니에 아이템을 추가해야 합니다.
      cartController.addToCart({
        'title': selectedProduct.title,
        'price': selectedProduct.price,
        'selectedSize': selectedProduct.selectedSize,
        'selectedColorImageUrl': selectedProduct.selectedColorImageUrl,
      });
      
      // 구매 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderScreen()), 
      );
    }


    return Column(
      children: [
        // 1. 구매하기 (검정색 버튼)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _handlePurchase,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: const Text(
              "구매하기",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 2. 장바구니 & 위시리스트
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: _handleAddToCart,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    "장바구니",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 56,
              height: 56, 
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
                ),
                child: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.black,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  // 안내 박스 (변화 없음)
  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "무료 반품 안내",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "제품 수령일로부터 14일 동안 제공되는 무료 반품 서비스를 만나보세요.",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
          ),
          const SizedBox(height: 8),
          const Text(
            "자세히 보기",
            style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }

  // 추천 상품 가로 스크롤 (변화 없음)
  Widget _buildRecommendations() {
    final List<Map<String, String>> recItems = [
      {"name": "리액트 인피니티 런", "price": "₩149,000", "img": "https://lh3.googleusercontent.com/aida-public/AB6AXuDDt5iFoapJl0uzAcARC3gJPbzvQs0B0DGYyikn9yhKPgDeNRWgFMpXnUr543Jf4vgND33BjX-omWHAi_KpAfShPPreEqkRffjXiHpq4nuP46eaRhAJrRbkCQTShID2ZjvPBDcqYFgNvBMkEl0Yy0gmNapTPTtY_lTtCthFAUQb1I0nC0ax0XTWspGWB2C-B2ZIbCk_D0UyTT5LSGL9FaYpKUZtWw1kiUIdax1g9HeSS2rMxpuKfjysexwCzB34HLV7i7PwWTC1qOHKFegVJM410ROXXHIDW1zLnKNx0ECBq3RGRfzUGJfJi9Csg2LrBVlsiKDxMnR4"},
      {"name": "에어 조던 1", "price": "₩179,000", "img": "https://lh3.googleusercontent.com/aida-public/AB6AXuAWT5XtZPPiASQ8v75AKCbnfIgfTjhgk5Dj_gZr9bzaJQKrKplCfMVmgOgJtbWv4j-r7MrvNRUHqIPXGKxCvdfeAcW-08p1c3rOzAnacZFQ6f9b12Tv2f6p2rVGF3zee4uGNrau6nuOEuMEdeqMnPdhDFXGGkJu5qZhCiV4v2WnB1nLp_8rkPfnBewikUnse8MFk4Uo06qfh8-sq_Rvly7PPKRpL3vB5wu4dwzd_aVDZANNvo0slxuaHN9brDT6P0XM01CiHxmTgaU"},
      {"name": "블레이저 미드", "price": "₩119,000", "img": "https://lh3.googleusercontent.com/aida-public/AB6AXuD8O5geREbmF5TU6MkgwBpw0ieMgKWydv4cI5ZSnCemRtcRLp5rRZju_Z2p2oLDWssRPeVgtdPYCT_C15rpkGw3ZGSfiYLg7VjnXhyoxBbc4v9n662fb_ngeeHMUm3qtfoO2ftxhX2xtDbwjk8BvGHNScYdtUviV7zr3nTgIEC6sK5AySg3v3Hg1o9mj2hp7UNrk5crwQl1fZxgPS3JWiScylvPXldbBryeBx_4Kzn-c1rE0XV7OBm9h2AYTQhPF3VCYAfi7tYhe2A"},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: recItems.map((item) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(item['img']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['name']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  item['price']!,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 리뷰 섹션 (변화 없음)
  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text("4.6", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, height: 1.0)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) => const Icon(Icons.star, size: 18, color: Colors.black)),
                ),
                const SizedBox(height: 4),
                const Text("1,234 reviews", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildRatingBar(5, 0.5),
        _buildRatingBar(4, 0.3),
        _buildRatingBar(3, 0.1),
        _buildRatingBar(2, 0.05),
        _buildRatingBar(1, 0.05),

        const SizedBox(height: 30),
        const Text("리뷰 (1,234)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildReviewItem("지우", "2023년 10월 26일", 5, "정말 편하고 디자인도 예뻐요! 매일 신고 다닙니다."),
        _buildReviewItem("민준", "2023년 10월 20일", 4, "사이즈가 조금 크게 나온 것 같아요. 그래도 만족합니다."),
      ],
    );
  }

  Widget _buildRatingBar(int star, double pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(width: 12, child: Text("$star", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.grey.shade200,
              color: Colors.black,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 30, child: Text("${(pct * 100).toInt()}%", style: const TextStyle(fontSize: 12, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String date, int stars, String comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFEEEEEE),
                child: Icon(Icons.person, color: Colors.grey, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < stars ? Icons.star : Icons.star_border,
                size: 16,
                color: Colors.black,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(comment, style: const TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text("${(stars * 2) + 3}", style: const TextStyle(fontSize: 12, color: Colors.grey)), 
              const SizedBox(width: 16),
              const Icon(Icons.thumb_down_alt_outlined, size: 16, color: Colors.grey),
            ],
          )
        ],
      ),
    );
  }
}