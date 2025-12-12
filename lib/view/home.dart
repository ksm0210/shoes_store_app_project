
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/model/product.dart';
import 'package:shoes_store_app_project/model/product_category.dart';
import 'package:shoes_store_app_project/util/global_login_data.dart';
import 'package:shoes_store_app_project/view/order/shopping_cart.dart';
import 'package:shoes_store_app_project/view/product/product_detail.dart';
import 'package:shoes_store_app_project/view/search/search_result.dart';
import 'package:shoes_store_app_project/view/user/user_info.dart';
import 'package:shoes_store_app_project/vm/product_handler.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  ProductHandler productHandler = ProductHandler();
  List<Product> productList = [];
  List<ProductCategory> categories = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {

    productList = await productHandler.selectQuery(0);
    
    print('====== ${productList.length}');
    setState(() {
      
    });
  }


  void _onItemTapped(int index) {
    if (index == 3) {
      // 마이페이지 (인덱스 3)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserInfo()),
      );
    } else if (index == 4) {
      // 장바구니 (인덱스 4)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ShoppingCart()),
      );
    } else if (index == 2) {
      // 검색 (인덱스 2)
      _showSearchBottomSheet();
    } else {
      // 다른 탭
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          // 키보드가 올라올 때 BottomSheet도 함께 올라오도록 Padding 설정
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                '검색',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSearchField(),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    TextEditingController controller = TextEditingController();
    return TextField(
      controller: controller,
      autofocus: true,
      textInputAction: TextInputAction.search,
      onSubmitted: (query) {
        if (query.isNotEmpty) {
          Navigator.pop(context); // BottomSheet 닫기
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultPage(query: query),
            ),
          );
        }
      },
      decoration: InputDecoration(
        hintText: '검색어를 입력하세요',
        filled: true,
        fillColor: Colors.grey[100],
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear, color: Colors.grey),
          onPressed: () {
            controller.clear();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  // 제품 상세 페이지로 이동하는 공통 함수
  // main_screen.dart 내 _MainScreenState
// 제품 상세 페이지로 이동하는 공통 함수 (수정됨)
   void _navigateToDetail(Map<String, String> product) {
    // DetailScreen의 생성자 인자에 맞게 Map 데이터를 분해하여 전달
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetail( // 클래스명을 DetailScreen으로 수정
          // title: product['title']!,
          // subtitle: product['subtitle']!,
          // imageUrl: product['image']!,
          // price: "₩139,000", // DetailScreen 더미 데이터에 맞춰 임의 가격 지정
          // description: 기본값 사용
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        leadingWidth: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo (SVG Path converted to CustomPaint)
            SizedBox(
              width: 50,
              height: 20,
              child: CustomPaint(painter: LogoPainter()),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
      body: productList.length==0? 
        const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHeroSection(),
            const SizedBox(height: 16),

            // Section 1: 최신제품 (Horizontal Scroll)
            const SectionTitle(title: "최신제품"),
            const SizedBox(height: 12),
            _buildNewArrivals(),
            const SizedBox(height: 16),

            // Section 2: 인기제품 (Grid)
            const SectionTitle(title: "인기제품"),
            const SizedBox(height: 12),
            _buildPopularProducts(),
            const SizedBox(height: 16),

            // Section 3: 전체제품 (Categories)
            const SectionTitle(title: "전체제품"),
            const SizedBox(height: 12),
            _buildAllProducts(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white.withOpacity(0.9),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: '카테고리'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이페이지'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: '장바구니'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      // Aspect ratio 4/5 approximation or fixed height
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(
              productList[0].mainImageUrl!
          ),//"https://lh3.googleusercontent.com/aida-public/AB6AXuDHi22KsHGy4wL-HzW9V2Qkn9-63YqqrkRffjXiHpq4nuP46eaRhAJrRbkCQTShID2ZjvPBDcqYFgNvBMkEl0Yy0gmNapTPTtY_lTtCthFAUQb1I0nC0ax0XTWspGWB2C-B2ZIbCk_D0UyTT5LSGL9FaYpKUZtWw1kiUIdax1g9HeSS2rMxpuKfjysexwCzB34HLV7i7PwWTC1qOHKFegVJM410ROXXHIDW1zLnKNx0ECBq3RGRfzUGJfJi9Csg2LrBVlsiKDxMnR4"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                stops: const [0.6, 1.0],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "최신 스니커즈 출시",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "최신 스타일을 만나보세요.",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: ()=> Get.to(()=>ProductDetail(),arguments: productList[0].product_id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(84, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child:
                   const Text(
                    "쇼핑 하기",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewArrivals() {
    final products = productList.map((data)=> {
        "title": data.product_name,
        "subtitle": data.gender != null? '${data.gender}신발': '신발',
        "image": data.mainImageUrl
        }).toList();

    
    
    //  [
    //   {
    //     "title": "에어 맥스 90",
    //     "subtitle": "남성 신발",
    //     "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDHdQ1ILK_dUdEh8XOt6ViOw16Hab9Oc0UaFIxMFrWsQMa78xaiFWexjQJV__ym7gr_q6ifzRDPkvgJafjCRXxYSBarIcfbmFUYzhf1YQzTdish8OTP7LTwHODxHRni5TUks-RD8A-thv73eLbEzCOOJxhsQzIKxevRYsVPuvUavNGsycBFNhpFEpFra4FrxuH-UfgMogp5rIAUdpVjqAJQtps74W5ND9msWtNiF-vAVscFG6yhHsU9Dh96OtnZR6tIsV5dZdt3ye4"
    //   },
    //   {
    //     "title": "에어 포스 1",
    //     "subtitle": "여성 신발",
    //     "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuA5TAFbKthcnj0ocsMMjbiUmYNKoCdlQcOFVqwqiC4J4N4ARFiealFz7uZ-9h683p_PcG3Tla2CmnavgRpHIw_2qEbY5bC20QsVzEk0lKov_X2eI9cM5dX-whZYKdEPkMXqRCGLD-yrLdTR52MftHTJXR4bphU-5uiwWT-FQBDvIeMT5VhnfhhxCYy-JKG7gVnAP015l9uPUSv-3Uxn-_yxTouAUjZM1_uDZ6O_QoTXCDIdof7tYvoaYSG5jO_jWymPcOPUQhJtCrk"
    //   },
    //   {
    //     "title": "에어 조던 1",
    //     "subtitle": "남성 신발",
    //     "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDpON7VqeimHWNLI8BpsZ9Y-hdvZG7u0bMyzKuJdc-peEtlDNEEFdDgJsYlG-0ff2exA6lqoBzSB6XSjwrgoLVsdx0626XQjp8N8rjDq5DDeVeH-1ycJKeHN3Nm1UMvhSJ-kImWboyzIZdbK4xX93L1xVQyr1dRmSC_7fHftIjE-Ia0sgQduae4idKGcvvQ4tsR0wdPGbWBz2TDMOvVI4AorfQXXH2XrStY8udjRoG7Ukvzv3Ifhf0jrvKhH9-r7gj7-UXzsIHI2_o"
    //   },
    //   {
    //     "title": "에어 맥스 270",
    //     "subtitle": "남성 신발",
    //     "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuAWT5XtZPPiASQ8v75AKCbnfIgfTjhgk5Dj_gZr9bzaJQKrKplCfMVmgOgJtbWv4j-r7MrvNRUHqIPXGKxCvdfeAcWnB1nLp_8rkPfnBewikUnse8MFk4Uo06qfh8-sq_Rvly7PPKRpL3vB5wu4dwzd_aVDZANNvo0slxuaHN9brDT6P0XM01CiHxmTgaU"
    //   }
    // ];

    return SizedBox(
      height: 160, // Image(aspect square) + Text height
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: productList.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = productList[index];
          return GestureDetector(
            onTap: () =>Get.to(()=>ProductDetail(),arguments: item.product_id),//=> _navigateToDetail(item),
            child: SizedBox(
              width: 110, // Approx 1/3 of screen width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                        image: DecorationImage(
                          image: NetworkImage(item.mainImageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.product_name!,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.gender!=null? '${item.gender}신발': '신발',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularProducts() {
    final products = [
      {
        "title": "에어 맥스 97",
        "subtitle": "남성 신발",
        "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDDt5iFoapJl0uzAcARC3gJPbzvQs0B0DGYyikn9yhKPgDeNRWgFMpXnUr543Jf4vgND33BjX-omWHAi_KpAfShPPreEqkR-yCUnKJky7U2aAQmce0EwmhHCpdCcoe97sMNXf47C-paUuhwWsWrvESOpXxkCknBejgTx2jGR5dPFZV9By4ISUZVn3ztQtLeovreJkxKQgA-_ejVKAy8CBbnG6yRp_dqSedQE7Ye-Mjk7jWUv2utjph7EKzhqKXkuJRpZia9Qa2XD1w"
      },
      {
        "title": "에어 맥스 720",
        "subtitle": "여성 신발",
        "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuD8O5geREbmF5TU6MkgwBpw0ieMgKWydv4cI5ZSnCemRtcRLp5rRZju_Z2p2oLDWssRPeVgtdPYCT_C15rpkGw3ZGSfiYLg7VjnXhyoxBbc4v9n662fb_ngeeHMUm8qtfoO2ftxhX2xtDbwjk8BvGHNScYdtUviV7zr3nTgIEC6sK5AySg3v3Hg1o9mj2hp7UNrk5crwQl1fZxgPS3JWiScylvPXldbBryeBx_4Kzn-c1rE0XV7OBm9h2AYTQhPF3VCYAfi7tYhe2A"
      },
    ];

    return Row(
      children: products.map((item) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: item == products.last ? 0 : 12),
            child: GestureDetector(
              onTap: () => _navigateToDetail(item),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                        image: DecorationImage(
                          image: NetworkImage(item['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title']!,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item['subtitle']!,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAllProducts() {
    final categories = GlobalLoginData.categories.map((data)=> {
        "title": data.category_name,
        "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDHdQ1ILK_dUdEh8XOt6ViOw16Hab9Oc0UaFIxMFrWsQMa78xaiFWexjQJV__ym7gr_q6ifzRDPkvgJafjCRXxYSBarIcfbmFUYzhf1YQzTdish8OTP7LTwHODxHRni5TUks-RD8A-thv73eLbEzCOOJxhsQzIKxevRYsVPuvUavNGsycBFNhpFEpFra4FrxuH-UfgMogp5rIAUdpVjqAJQtps74W5ND9msWtNiF-vAVscFG6yhHsU9Dh96OtnZR6tIsV5dZdt3ye4"
      }).toList();
    
    
    // [
    //   {
    //     "title": "라이프스타일",
    //     "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDHdQ1ILK_dUdEh8XOt6ViOw16Hab9Oc0UaFIxMFrWsQMa78xaiFWexjQJV__ym7gr_q6ifzRDPkvgJafjCRXxYSBarIcfbmFUYzhf1YQzTdish8OTP7LTwHODxHRni5TUks-RD8A-thv73eLbEzCOOJxhsQzIKxevRYsVPuvUavNGsycBFNhpFEpFra4FrxuH-UfgMogp5rIAUdpVjqAJQtps74W5ND9msWtNiF-vAVscFG6yhHsU9Dh96OtnZR6tIsV5dZdt3ye4"
    //   },
    //   {
    //     "title": "러닝",
    //     "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuA5TAFbKthcnj0ocsMMjbiUmYNKoCdlQcOFVqwqiC4J4N4ARFiealFz7uZ-9h683p_PcG3Tla2CmnavgRpHIw_2qEbY5bC20QsVzEk0lKov_X2eI9cM5dX-whZYKdEPkMXqRCGLD-yrLdTR52MftHTJXR4bphU-5uiwWT-FQBDvIeMT5VhnfhhxCYy-JKG7gVnAP015l9uPUSv-3Uxn-_yxTouAUjZM1_uDZ6O_QoTXCDIdof7tYvoaYSG5jO_jWymPcOPUQhJtCrk"
    //   },
    //   {
    //     "title": "농구",
    //     "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDpON7VqeimHWNLI8BpsZ9Y-hdvZG7u0bMyzKuJdc-peEtlDNEEFdDgJsYlG-0ff2exA6lqoBzSB6XSjwrgoLVsdx0626XQjp8N8rjDq5DDeVeH-1ycJKeHN3Nm1UMvhSJ-kImWboyzIZdbK4xX93L1xVQyr1dRmSC_7fHftIjE-Ia0sgQduae4idKGcvvQ4tsR0wdPGbWBz2TDMOvVI4AorfQXXH2XrStY8udjRoG7Ukvzv3Ifhf0jrvKhH9-r7gj7-UXzsIHI2_o"
    //   }
    // ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = categories[index];
          return RelativePositionedTile(
            title: item['title']!,
            image: item['image']!,
          );
        },
      ),
    );
  }
}

// SectionTitle, LogoPainter는 변경 없음
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class RelativePositionedTile extends StatelessWidget {
  final String title;
  final String image;

  const RelativePositionedTile({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    // 이 섹션 (전체제품)은 제품 상세 이동 로직이 없으므로 GestureDetector를 추가하지 않았습니다.
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5 - 24,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              image,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Viewbox 0 0 100 40 -> Scale to fit size
    final scaleX = size.width / 100;
    final scaleY = size.height / 40;
    canvas.scale(scaleX, scaleY);

    final path = Path();
    // Path d="M100 0L60 0L60 10L90 10L90 15L60 15L60 25L90 25L90 30L60 30L60 40L100 40ZM40 0L0 0L0 40L40 40L40 30L10 30L10 25L40 25L40 15L10 15L10 10L40 10Z"
    path.moveTo(100, 0);
    path.lineTo(60, 0);
    path.lineTo(60, 10);
    path.lineTo(90, 10);
    path.lineTo(90, 15);
    path.lineTo(60, 15);
    path.lineTo(60, 25);
    path.lineTo(90, 25);
    path.lineTo(90, 30);
    path.lineTo(60, 30);
    path.lineTo(60, 40);
    path.lineTo(100, 40);
    path.close();

    path.moveTo(40, 0);
    path.lineTo(0, 0);
    path.lineTo(0, 40);
    path.lineTo(40, 40);
    path.lineTo(40, 30);
    path.lineTo(10, 30);
    path.lineTo(10, 25);
    path.lineTo(40, 25);
    path.lineTo(40, 15);
    path.lineTo(10, 15);
    path.lineTo(10, 10);
    path.lineTo(40, 10);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}