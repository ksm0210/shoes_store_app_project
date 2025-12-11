import 'package:flutter/material.dart';
import 'package:shoes_store_app_project/model/customer.dart';
import 'package:shoes_store_app_project/model/order.dart';
import 'package:shoes_store_app_project/vm/customer_handler.dart';
import 'package:shoes_store_app_project/vm/order_handler.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  // Property
  int? storeId = null;
  int totalPrice = 0;
  OrderHandler orderHandler = OrderHandler();
  // late List<Order> orderList=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initxx();
  } 

  initxx() async{
        CustomerHandler customerHandler = CustomerHandler();
    
    // await customerHandler.insert(Customer(customer_password: '1234', customer_name: 'Obama', created_at: DateTime.now()));
    // await customerHandler.insert(Customer(customer_password: '1234', customer_name: 'Bill Gates', created_at: DateTime.now()));

    List<Customer> cc = await customerHandler.selectQuery();
    print('${cc[0].created_at}');
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('픽업 매장 선택'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        2,
                        (index) => GestureDetector(
                          onTap: () {
                            storeId = index;
                            print('== storeId ${storeId}');
                          },
                          child: Card(
                            child: Row(
                              children: [
                                Text('image'),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('store name'),
                                    Text('store address'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text('결제 수단'),
        
              Text(' 총 결제 금액'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  2,
                  (index) => Card(
                    child: Row(
                      spacing: 10,
                      children: [
                        Text('상품이미지'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('${index+1}개'), Text('${(index+10000)*2}원')],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Text('합계'),
                  Text('${totalPrice}')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
