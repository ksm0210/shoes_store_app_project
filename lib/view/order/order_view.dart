import 'package:flutter/material.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  // Property
  int? storeId = null;
  int totalPrice = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
