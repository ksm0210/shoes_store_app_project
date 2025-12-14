import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/model/customer.dart';
import 'package:shoes_store_app_project/model/manufacture.dart';
import 'package:shoes_store_app_project/model/order.dart';
import 'package:shoes_store_app_project/model/product.dart';
import 'package:shoes_store_app_project/model/product_category.dart';
import 'package:shoes_store_app_project/model/shopping_cart.dart';
import 'package:shoes_store_app_project/model/store.dart';
import 'package:shoes_store_app_project/util/controllers.dart';
import 'package:shoes_store_app_project/util/global_login_data.dart';
import 'package:shoes_store_app_project/util/initializeData.dart';
import 'package:shoes_store_app_project/util/utils.dart';
import 'package:shoes_store_app_project/view/home.dart';
import 'package:shoes_store_app_project/vm/category_handler.dart';
import 'package:shoes_store_app_project/vm/customer_handler.dart';
import 'package:shoes_store_app_project/vm/manufacture_handler.dart';
import 'package:shoes_store_app_project/vm/order_handler.dart';
import 'package:shoes_store_app_project/vm/product_handler.dart';
import 'package:shoes_store_app_project/vm/shopcart_handler.dart';
import 'package:shoes_store_app_project/vm/store_handler.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

//-------------------------------------------
// 결제수단은 보여주기식으로 했습니다.
// 나중에 추가할꺼라고하면될듯
//-------------------------------------------

class _OrderViewState extends State<OrderView> {
  // Property
  int? storeId = null;
  int totalPrice = 0;
  int totoalQuantity = 0;
  OrderHandler orderHandler = OrderHandler();
  StoreHandler storeHandler = StoreHandler();

  late List<Order> orders = [];
  late List<Store> storeList = [];
  late Map<int, double> storeDistKm; // store_id -> km
  final CartController controller = Get.find<CartController>();
  // late List<Order> orderList=[];

  late ShopcartHandler shopcartHandler;
  late List<ShoppingCart> cartList;
  late bool isDirectBuy; // 직접결제인지 장바구니결제인지
  late String _selectedPaymentMethod; // 결제수단 선택
  late List<String> _paymentMethod; // 결제수단 종류

  @override
  void initState() {
    super.initState();
    storeDistKm = {};
    shopcartHandler = ShopcartHandler();
    _selectedPaymentMethod = '';
    _paymentMethod = [];

    final args = Get.arguments;
    // direct buy: arguments가 List<Order>로 넘어옴
    if (args is List<Order> && args.isNotEmpty) {
      isDirectBuy = true;
      orders = args;
    } else {
      isDirectBuy = false;
      orders = [];
    }
    getData();
    getDistance();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 매장 불러오고 거리 계산 + 정렬
  getDistance() async {
    storeList = await storeHandler.selectAllStores();

    final myLat = GlobalLoginData.customer_location[0];
    final myLng = GlobalLoginData.customer_location[1];

    storeDistKm.clear();
    for (final s in storeList) {
      final lat = s.store_lat;
      final lng = s.store_lng;

      if (lat == null || lng == null) continue;

      storeDistKm[s.store_id!] = _distanceKm(myLat, myLng, lat, lng);
    }

    // 가까운 순 정렬(원하면)
    storeList.sort((a, b) {
      final da = storeDistKm[a.store_id] ?? 999999;
      final db = storeDistKm[b.store_id] ?? 999999;
      return da.compareTo(db);
    });

    setState(() {});
  }

  getData() async {
    // orders.clear();
    final int customerId = GlobalLoginData.customer_id; // customer id 가져옴
    final raw = await shopcartHandler.selectByCustomer(customerId); // 장바구니 검색
    storeList = await storeHandler.selectQuery(0);

    if (!isDirectBuy) {
      final int customerId = GlobalLoginData.customer_id;

      if (customerId == 0) {
        Get.snackbar("로그인 필요", "로그인 후 이용해주세요");
        orders = [];
      } else {
        cartList = raw.map((e) => ShoppingCart.fromMap(e)).toList();

        orders.clear();

        for (final cart in cartList) {
          orders.add(
            Order(
              customer_id: customerId,
              product_id: cart.product_id,
              product_name: cart.title,
              order_store_id: 0,
              order_quantity: cart.qty,
              order_total_price: cart.price,
              order_status: '요청',
              product_mainImageUrl: cart.image,
              created_at: DateTime.now(),
            ),
          );
        }
      }
    }

    for (Order order in orders) {
      totalPrice += order.order_total_price * order.order_quantity;
      totoalQuantity += order.order_quantity;
    }

    // 결제수단
    _paymentMethod = ["신용/체크카드", "카카오페이", "네이버페이", "매장 결제"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('주문')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '픽업 매장 선택',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 200, // Text 포함이면 250 안에서 리스트는 200 정도가 안전
                        child: ListView.builder(
                          itemCount: storeList.length,
                          itemBuilder: (context, index) {
                            final store = storeList[index];
                            final km = storeDistKm[store.store_id] ?? -1;
                            final distText = km < 0 ? '거리 정보 없음' : _fmtDist(km);
                            return GestureDetector(
                              onTap: () {
                                storeId = storeList[index].store_id;
                                for (int i = 0; i < orders.length; i++) {
                                  orders[i].order_store_id =
                                      storeList[index].store_id!;
                                }
                                setState(() {});
                              },
                              child: SizedBox(
                                height: 80,
                                child: Card(
                                  color:
                                      (storeId != null &&
                                          storeId == storeList[index].store_id)
                                      ? Colors.pink
                                      : Colors.grey[100],
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          "https://static.nike.com/a/images/f_auto/dpr_1.0,cs_srgb/w_1261,c_limit/48f456d0-6fd1-4442-9cad-23f269c04617/%EB%82%98%EC%9D%B4%ED%82%A4-%EA%B0%95%EB%82%A8.jpg",
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${storeList[index].store_name}',
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Text(
                                                      '$distText',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${storeList[index].store_address}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                _buildPaymentMethodSection(),
                Text(
                  ' 총 결제 금액',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                Column(
                  children: List.generate(
                    orders.length,
                    (index) => Row(
                      spacing: 20,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            orders[index].product_mainImageUrl!,
                            width: 60,
                          ),
                        ),
                        Text('${orders[index].product_name}'),
                        Text('${orders[index].order_quantity}개'),
                        SizedBox(
                          width: 158,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${toWon((orders[index].order_total_price * orders[index].order_quantity).toDouble())}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // children: List.generate(
                //   2,
                //   (index) => Card(
                //     child: Row(
                //       spacing: 10,
                //       children: [
                //         Image.network(order.product_mainImageUrl!,width: 30,),
                //         Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [Text('${index+1}개'), Text('${(index+10000)*2}원')],
                //         ),
                //       ],
                //     ),
                //   ),

                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '합계',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(
                      width: 350,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('${toWon(totalPrice.toDouble())}'),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF111111), Color(0xFF3A3A3A)],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => submitOrder(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(16),
                          ),
                        ),
                        child: const Text(
                          '결제하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // == Functions
  // 거리 계산 함수(지도의 거리)
  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0; // 지구 반지름 km
    double d2r(double d) => d * (pi / 180.0);

    final dLat = d2r(lat2 - lat1);
    final dLon = d2r(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(d2r(lat1)) * cos(d2r(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  String _fmtDist(double km) {
    if (km < 1) return '${(km * 1000).round()}m';
    return '${km.toStringAsFixed(1)}km';
  }

  // 주문 dialog
  submitOrder() async {
    // int result = await orderHandler.insert(orders[0]);
    if (_selectedPaymentMethod.isEmpty) {
      Get.snackbar("경고", "결제 수단을 선택해주세요.");
      return;
    }

    if (storeId == null) {
      Get.snackbar("경고", "픽업 매장을 선택해주세요.");
      return;
    }

    //여러 상품 주문이면 insert를 반복 or batch로
    int okCount = 0;
    for (final o in orders) {
      final r = await orderHandler.insert(o);
      if (r != 0) okCount++;
    }

    if (okCount == orders.length) {
      Get.defaultDialog(
        title: '주문하신 오더가 정상적으로 SUBMIT됬습니다.',
        content: Text('주문 해 주셔서 감사합니다'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.offAll(
                () => const Home(),
              ); // 바로 Home으로 새로 보내버리기(인기제품 setstate때문에)
            },
            child: Text('확인'),
          ),
        ],
      );
    } else {
      Get.snackbar('죄송합니다. 주문에 실패했습니다.', '주문에 실패했습니다. 다시 시도해 보세요.');
    }
  }

  // 결제수단
  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '결제 수단',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // 안내 배너(선택)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "결제는 선택하신 수단을 통해 진행됩니다.",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 카드 선택 리스트
        Column(
          children: _paymentMethod.map((method) {
            final isSelected = _selectedPaymentMethod == method;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = method;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // 아이콘
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _paymentIcon(method),
                        color: isSelected ? Colors.black : Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 텍스트
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _paymentSubText(method),
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 라디오 느낌 체크
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade500,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _paymentIcon(String method) {
    if (method.contains("카카오")) return Icons.chat_bubble_outline;
    if (method.contains("네이버")) return Icons.shopping_bag_outlined;
    if (method.contains("현장")) return Icons.storefront;
    return Icons.credit_card;
  }

  String _paymentSubText(String method) {
    if (method.contains("현장")) return "픽업 매장에서 결제합니다";
    return "";
  }
}
