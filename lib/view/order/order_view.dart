import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/model/customer.dart';
import 'package:shoes_store_app_project/model/manufacture.dart';
import 'package:shoes_store_app_project/model/order.dart';
import 'package:shoes_store_app_project/model/product.dart';
import 'package:shoes_store_app_project/model/product_category.dart';
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
import 'package:shoes_store_app_project/vm/store_handler.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  // Property
  int? storeId = null;
  int totalPrice = 0;
  int totoalQuantity = 0;
  OrderHandler orderHandler = OrderHandler();
  StoreHandler storeHandler = StoreHandler();

  List<Order> orders = Get.arguments ?? [];
  late List<Store> storeList = [];
  final CartController controller = Get.find<CartController>();
  // late List<Order> orderList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  getData() async {
    storeList = await storeHandler.selectQuery(0);
    for (Order order in orders) {
      totalPrice += order.order_total_price * order.order_quantity;
      totoalQuantity += order.order_quantity;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('주문')),
      body: Padding(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        storeList.length,
                        (index) => GestureDetector(
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
                                  storeId != null &&
                                      storeId == (storeList[index].store_id)
                                  ? Colors.pink
                                  : Colors.grey[100],
                              child: Row(
                                spacing: 10,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      "https://static.nike.com/a/images/f_auto/dpr_1.0,cs_srgb/w_1261,c_limit/48f456d0-6fd1-4442-9cad-23f269c04617/%EB%82%98%EC%9D%B4%ED%82%A4-%EA%B0%95%EB%82%A8.jpg",
                                      width: 80,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${storeList[index].store_name}'),
                                      Text('${storeList[index].store_address}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '결제 수단',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                      child: Text('기본 결제 수단 사용'),
                    ),
                  ],
                ),
              ),

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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => submitOrder(),
                    child: Text('결제하기'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // == Functions
  submitOrder() async {
    int result = await orderHandler.insert(orders[0]);

    if (result != 0) {
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
}
