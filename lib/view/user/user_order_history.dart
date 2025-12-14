import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/util/global_login_data.dart';
import 'package:shoes_store_app_project/vm/order_handler.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  // Property
  late OrderHandler orderHandler;
  late List<Map<String, dynamic>> orders;
  final TextEditingController _search = TextEditingController();

  // 상태 필터
  final List<String> _tabs = ['전체', '요청', '준비중', '픽업완료', '취소'];
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    orders = [];
    orderHandler = OrderHandler();
    getData();
  }

  getData() async {
    orders.clear(); // 중복방지

    final value = await orderHandler.selectQueryByCustomerId(
      GlobalLoginData.customer_id,
    );
    for (var element in value) {
      final orderNo = makeOrderNo(element.created_at, element.order_id ?? 0);
      final dateText = formatDate(element.created_at);
      orders.add({
        'orderNo': orderNo,
        'date': dateText,
        'status': element.order_status,
        'store': element.store_name,
        'totalPrice': element.order_total_price * element.order_quantity,
        'items': [
          {
            'name': element.product_name,
            'qty': element.order_quantity,
            'price': element.order_total_price,
            'image': element.product_mainImageUrl,
            'size': element.product_size,
          },
        ],
      });
      // debugPrint(
      //   'status=${element.order_status}, store=${element.store_name}, img=${element.product_mainImageUrl}',
      // );
    }
    setState(() {});
  }

  // 더미 데이터(나중에 DB에서 가져온 주문 리스트로 교체)
  //   {
  //     'orderNo': '20251208-0012',
  //     'date': '2025.12.08',
  //     'status': '취소',
  //     'store': '나이키 강남',
  //     'totalPrice': 179000,
  //     'items': [
  //       {
  //         'name': '에어포스 1',
  //         'qty': 1,
  //         'price': 179000,
  //         'image':
  //             'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
  //         'size': '275',
  //       },
  //     ],
  //   },
  // ];

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
          '주문내역',
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
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatusTabs(),
          Expanded(
            child: filtered.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildOrderCard(filtered[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 주문번호 만드는 함수
  String makeOrderNo(DateTime createdAt, int orderId) {
    final y = createdAt.year.toString();
    final m = createdAt.month.toString().padLeft(2, '0');
    final d = createdAt.day.toString().padLeft(2, '0');

    final seq = orderId.toString().padLeft(4, '0'); // 0001

    return '$y$m$d-$seq';
  }

  // 날짜 포맷 함수
  String formatDate(DateTime date) {
    final y = date.year.toString();
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y.$m.$d';
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
          hintText: '주문번호 / 상품명 / 매장 검색',
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

  // --- UI: 상태 탭 ---
  Widget _buildStatusTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final selected = i == _tabIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _tabIndex = i),
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
                    _tabs[i],
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

  // --- UI: 주문 카드 ---
  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = (order['status'] ?? '요청') as String;
    final items = (order['items'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final first = items.first;

    final date = (order['date'] ?? '').toString();
    final orderNo = (order['orderNo'] ?? '').toString();
    final store = (order['store'] ?? '').toString();
    final totalPrice = (order['totalPrice'] ?? 0) as int;

    return Container(
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
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // TODO: 주문 상세로 이동 (OrderDetailView)
          // Get.to(() => OrderDetailView(), arguments: order);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단: 날짜/주문번호 + 상태 배지
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '주문번호 $orderNo',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
              const SizedBox(height: 12),

              // 중간: 대표 상품
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _thumb((first['image'] ?? '').toString()),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ((first['name'] ?? '(상품명 없음)').toString()),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '사이즈 ${first['size'] ?? '-'} · 수량 ${first['qty'] ?? 0}개',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _toWon(totalPrice),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '픽업 매장: $store',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 아이템 여러 개면 표시
              if (items.length > 1) ...[
                const SizedBox(height: 10),
                Text(
                  '+ ${items.length - 1}개 상품 더 있음',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // 하단: 액션 버튼(상태별로 다르게)
              Row(
                children: [
                  Expanded(
                    child: _outlineAction(
                      label: '주문 상세',
                      onTap: () {
                        // TODO: 상세 화면
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _primaryAction(
                      status: status,
                      onTap: () {
                        // TODO: 상태별 액션
                        // 준비중 -> "픽업 안내"
                        // 픽업완료 -> "리뷰 작성"
                        // 취소 -> "다시 구매"
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;

    switch (status) {
      case '요청':
        bg = const Color(0xFFF2F2F2);
        fg = Colors.black;
        break;
      case '준비중':
        bg = const Color(0xFF111111);
        fg = Colors.white;
        break;
      case '픽업완료':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF1B5E20);
        break;
      case '취소':
        bg = const Color(0xFFFFEBEE);
        fg = const Color(0xFFB71C1C);
        break;
      default:
        bg = const Color(0xFFF2F2F2);
        fg = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _thumb(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 70,
        height: 70,
        color: const Color(0xFFF3F3F3),
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }

  Widget _outlineAction({required String label, required VoidCallback onTap}) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _primaryAction({required String status, required VoidCallback onTap}) {
    String label = '픽업 안내';
    if (status == '픽업완료') label = '리뷰 작성';
    if (status == '취소') label = '다시 구매';

    final bool disabled = status == '요청'; // 예: 요청 상태는 아직 액션 없음
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: disabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade600,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }

  // --- 필터링 로직 ---
  List<Map<String, dynamic>> _applyFilter() {
    final keyword = _search.text.trim().toLowerCase();
    final tab = _tabs[_tabIndex];

    return orders.where((o) {
      // 상태 필터
      if (tab != '전체' && o['status'] != tab) return false;

      // 검색 필터
      if (keyword.isEmpty) return true;

      final orderNo = (o['orderNo'] ?? '').toString().toLowerCase();
      final store = (o['store'] ?? '').toString().toLowerCase();
      final items = (o['items'] as List).cast<Map<String, dynamic>>();
      final anyName = items.any(
        (i) => (i['name'] ?? '').toString().toLowerCase().contains(keyword),
      );

      return orderNo.contains(keyword) || store.contains(keyword) || anyName;
    }).toList();
  }

  String _toWon(int value) {
    final s = value.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '₩${s.replaceAllMapped(reg, (m) => '${m[1]},')}';
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
              child: const Icon(Icons.receipt_long, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              '주문내역이 없습니다',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              '첫 주문을 만들어보세요.',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
