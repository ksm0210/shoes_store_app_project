import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:shoes_store_app_project/view/my_page.dart';
import 'package:shoes_store_app_project/view/shopping_cart.dart';
import 'package:shoes_store_app_project/view/search_result.dart'; 
import 'package:shoes_store_app_project/view/detail_view.dart'; 
import 'package:shoes_store_app_project/util/controllers.dart'; // AppController, CartController 사용

// MainScreenState에서 사용할 AppController 인스턴스를 주입합니다.
final AppController appController = Get.put(AppController()); 
final CartController cartController = Get.find<CartController>(); // CartController도 Find합니다.


void main() {
  // main에서 GetMaterialApp 사용과 컨트롤러 주입을 가정합니다.
  // Get.put(AppController());
  // Get.put(CartController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX 스낵바를 사용하기 위해 GetMaterialApp 사용
    return GetMaterialApp( 
      debugShowCheckedModeBanner: false,
      title: 'Stitch Design',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Noto Sans KR', 
        useMaterial3: true,
        // AppBar 배경색 및 아이콘 색상 기본 설정
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    if (index == 3) {
      // 마이페이지 (인덱스 3)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyPage()),
      );
    } else if (index == 4) {
      // 장바구니 (인덱스 4)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ShoppingCart()),
      );
    } else if (index == 1) { 
      // 카테고리 (인덱스 1): Drawer 열기
      _scaffoldKey.currentState?.openDrawer();
    } else if (index == 2) {
      // 검색 (인덱스 2): 검색 모달 열기
      appController.changePage(index); 
      _showSearchBottomSheet();
    } 
    else {
      // 홈 (인덱스 0)
      appController.changePage(index);
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
    ).whenComplete(() {
      if (appController.currentIndex.value == 2) {
        appController.changePage(0);
      }
    });
  }
  
  // -----------------------------------------------------------
  // 알림 팝업창 (Get.dialog 사용)
  // -----------------------------------------------------------
  void _showNotificationDialog() {
    // 더미 알림 데이터
    final List<Map<String, dynamic>> notifications = [
      {'icon': Icons.store, 'title': '픽업 준비 완료', 'subtitle': '강남 플래그십 스토어에서 픽업 가능합니다.', 'date': '5분 전'},
      {'icon': Icons.credit_card, 'title': '결제 완료', 'subtitle': '에어 조던 1 외 1건, 결제가 완료되었습니다.', 'date': '1시간 전'},
      {'icon': Icons.inventory, 'title': '재고 입고 알림', 'subtitle': '위시리스트의 에어 포스 1 (250) 재고가 들어왔습니다!', 'date': '어제'},
    ];

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('알림', style: TextStyle(fontWeight: FontWeight.bold)),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 1, color: Colors.grey),
              if (notifications.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("새로운 알림이 없습니다."),
                )
              else
                ...notifications.map((notif) => Column(
                  children: [
                    ListTile(
                      leading: Icon(notif['icon'] as IconData, color: Colors.black),
                      title: Text(notif['title'] as String, style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(notif['subtitle'] as String),
                      trailing: Text(notif['date'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      onTap: () {
                        Get.back(); // 팝업 닫기
                        // 상세 알림 페이지로 이동 로직 추가
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFEEEEEE), indent: 16, endIndent: 16),
                  ],
                )).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('닫기', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
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
          Navigator.pop(context); 
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

  void _navigateToDetail(Map<String, String> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen( 
          title: product['title']!,
          subtitle: product['subtitle']!,
          imageUrl: product['image']!,
          price: "₩139,000", 
        ),
      ),
    );
  }
  
  // -----------------------------------------------------------
  // 🚨 카테고리 Drawer 디자인 개선
  // -----------------------------------------------------------
  Widget _buildDrawer(BuildContext context) {
    final List<String> shoeCategories = [
      '라이프스타일', '러닝화', '농구화', '트레이닝', '축구화', 
      '테니스화', '골프화', '샌들/슬리퍼', '부츠', '키즈', '악세사리', '의류'
    ];

    return Drawer(
      // 드로어 너비를 조금 줄여 콘텐츠에 집중
      width: MediaQuery.of(context).size.width * 0.75, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 드로어 헤더 (AppBar 스타일과 유사하게)
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16, 
              left: 16, 
              right: 16, 
              bottom: 16
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '카테고리',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          
          // 카테고리 목록
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: shoeCategories.length,
              separatorBuilder: (context, index) => const Divider(height: 1, thickness: 0.5, color: Color(0xFFF0F0F0)),
              itemBuilder: (context, index) {
                final category = shoeCategories[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context); 
                    Get.snackbar("탐색", "$category 카테고리를 검색합니다.", snackPosition: SnackPosition.BOTTOM);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(category, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      key: _scaffoldKey, 
      drawer: _buildDrawer(context), 
      
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true, 
        
        // 카테고리 버튼 (Drawer 열기)
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        
        // 로고 중앙 정렬
        title: SizedBox(
          width: 50,
          height: 20,
          child: CustomPaint(painter: LogoPainter()),
        ),
        
        actions: [
          // 🚨 알림 아이콘 (팝업 기능 추가)
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: _showNotificationDialog, // 알림 팝업 함수 연결
          ),
          // 장바구니 아이콘 (배지 기능 추가)
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ShoppingCart()));
                },
              ),
              // 🚨 장바구니 배지 추가
              Obx(() {
                if (cartController.cartItems.isEmpty) return const SizedBox.shrink();
                return Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartController.cartItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      
      body: IndexedStack(
        index: appController.currentIndex.value,
        children: [
          _buildHomeScreenContent(context), 
          Container(), 
          _buildSearchField(), 
          const MyPage(), 
          const ShoppingCart(), 
        ],
      ),
      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white.withOpacity(0.9),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: appController.currentIndex.value,
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
    ));
  }
  
  // -----------------------------------------------------------
  // 나머지 _buildXxx 메서드 (변경 없음)
  // -----------------------------------------------------------
  Widget _buildHomeScreenContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(),
          const SizedBox(height: 16),
          const SectionTitle(title: "최신제품"),
          const SizedBox(height: 12),
          _buildNewArrivals(),
          const SizedBox(height: 16),
          const SectionTitle(title: "인기제품"),
          const SizedBox(height: 12),
          _buildPopularProducts(),
          const SizedBox(height: 16),
          const SectionTitle(title: "전체제품"),
          const SizedBox(height: 12),
          _buildAllProducts(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    final heroProduct = {
      "title": "최신 스니커즈 출시 (한정판)",
      "subtitle": "프리미엄 컬렉션",
      "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDHi22KsHGy4wL-HzW9V2Qkn9-63YqqrkRffjXiHpq4nuP46eaRhAJrRbkCQTShID2ZjvPBDcqYFgNvBMkEl0Yy0gmNapTPTtY_lTtCthFAUQb1I0nC0ax0XTWspGWB2C-B2ZIbCk_D0UyTT5LSGL9FaYpKUZtWw1kiUIdax1g9HeSS2rMxpuKfjysexwCzB34HLV7i7PwWTC1qOHKFegVJM410ROXXHIDW1zLnKNx0ECBq3RGRfzUGJfJi9Csg2LrBVlsiKDxMnR4"
    };
    
    return Container(
      width: double.infinity,
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(heroProduct['image']!),
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
                Text(
                  heroProduct['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  heroProduct['subtitle']!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _navigateToDetail(heroProduct), 
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
                  child: const Text(
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
    final products = [
      {
        "title": "에어 맥스 90",
        "subtitle": "남성 신발",
        "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDHdQ1ILK_dUdEh8XOt6ViOw16Hab9Oc0UaFIxMFrWsQMa78xaiFWexjQJV__ym7gr_q6ifzRDPkvgJafjCRXxYSBarIcfbmFUYzhf1YQzTdish8OTP7LTwHODxHRni5TUks-RD8A-thv73eLbEzCOOJxhsQzIKxevRYsVPuvUavNGsycBFNhpFEpFra4FrxuH-UfgMogp5rIAUdpVjqAJQtps74W5ND9msWtNiF-vAVscFG6yhHsU9Dh96OtnZR6tIsV5dZdt3ye4"
      },
      {
        "title": "에어 포스 1",
        "subtitle": "여성 신발",
        "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuA5TAFbKthcnj0ocsMMjbiUmYNKoCdlQcOFVqwqiC4J4N4ARFiealFz7uZ-9h683p_PcG3Tla2CmnavgRpHIw_2qEbY5bC20QsVzEk0lKov_X2eI9cM5dX-whZYKdEPkMXqRCGLD-yrLdTR52MftHTJXR4bphU-5uiwWT-FQBDvIeMT5VhnfhhxCYy-JKG7gVnAP015l9uPUSv-3Uxn-_yxTouAUjZM1_uDZ6O_QoTXCDIdof7tYvoaYSG5jO_jWymPcOPUQhJtCrk"
      },
      {
        "title": "에어 조던 1",
        "subtitle": "남성 신발",
        "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDpON7VqeimHWNLI8BpsZ9Y-hdvZG7u0bMyzKuJdc-peEtlDNEEFdDgJsYlG-0ff2exA6lqoBzSB6XSjwrgoLVsdx0626XQjp8N8rjDq5DDeVeH-1ycJKeHN3Nm1UMvhSJ-kImWboyzIZdbK4xX93L1xVQyr1dRmSC_7fHftIjE-Ia0sgQduae4idKGcvvQ4tsR0wdPGbWBz2TDMOvVI4AorfQXXH2XrStY8udjRoG7Ukvzv3Ifhf0jrvKhH9-r7gj7-UXzsIHI2_o"
      },
      {
        "title": "에어 맥스 270",
        "subtitle": "남성 신발",
        "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuAWT5XtZPPiASQ8v75AKCbnfIgfTjhgk5Dj_gZr9bzaJQKrKplCfMVmgOgJtbWv4j-r7MrvNRUHqIPXGKxCvdfeAcWnB1nLp_8rkPfnBewikUnse8MFk4Uo06qfh8-sq_Rvly7PPKRpL3vB5wu4dwzd_aVDZANNvo0slxuaHN9brDT6P0XM01CiHxmTgaU"
      }
    ];

    return SizedBox(
      height: 160, 
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = products[index];
          return GestureDetector(
            onTap: () => _navigateToDetail(item),
            child: SizedBox(
              width: 110, 
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
    final categories = [
      {
        "title": "라이프스타일",
        "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDHdQ1ILK_dUdEh8XOt6ViOw16Hab9Oc0UaFIxMFrWsQMa78xaiFWexjQJV__ym7gr_q6ifzRDPkvgJafjCRXxYSBarIcfbmFUYzhf1YQzTdish8OTP7LTwHODxHRni5TUks-RD8A-thv73eLbEzCOOJxhsQzIKxevRYsVPuvUavNGsycBFNhpFEpFra4FrxuH-UfgMogp5rIAUdpVjqAJQtps74W5ND9msWtNiF-vAVscFG6yhHsU9Dh96OtnZR6tIsV5dZdt3ye4"
      },
      {
        "title": "러닝",
        "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuA5TAFbKthcnj0ocsMMjbiUmYNKoCdlQcOFVqwqiC4J4N4ARFiealFz7uZ-9h683p_PcG3Tla2CmnavgRpHIw_2qEbY5bC20QsVzEk0lKov_X2eI9cM5dX-whZYKdEPkMXqRCGLD-yrLdTR52MftHTJXR4bphU-5uiwWT-FQBDvIeMT5VhnfhhxCYy-JKG7gVnAP015l9uPUSv-3Uxn-_yxTouAUjZM1_uDZ6O_QoTXCDIdof7tYvoaYSG5jO_jWymPcOPUQhJtCrk"
      },
      {
        "title": "농구",
        "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDpON7VqeimHWNLI8BpsZ9Y-hdvZG7u0bMyzKuJdc-peEtlDNEEFdDgJsYlG-0ff2exA6lqoBzSB6XSjwrgoLVsdx0626XQjp8N8rjDq5DDeVeH-1ycJKeHN3Nm1UMvhSJ-kImWboyzIZdbK4xX93L1xVQyr1dRmSC_7fHftIjE-Ia0sgQduae4idKGcvvQ4tsR0wdPGbWBz2TDMOvVI4AorfQXXH2XrStY8udjRoG7Ukvzv3Ifhf0jrvKhH9-r7gj7-UXzsIHI2_o"
      }
    ];

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

    final scaleX = size.width / 100;
    final scaleY = size.height / 40;
    canvas.scale(scaleX, scaleY);

    final path = Path();
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