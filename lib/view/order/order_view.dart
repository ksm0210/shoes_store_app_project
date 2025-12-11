import 'package:flutter/material.dart';
import 'package:shoes_store_app_project/model/customer.dart';
import 'package:shoes_store_app_project/model/manufacture.dart';
import 'package:shoes_store_app_project/model/order.dart';
import 'package:shoes_store_app_project/model/product.dart';
import 'package:shoes_store_app_project/model/product_category.dart';
import 'package:shoes_store_app_project/util/initializeData.dart';
import 'package:shoes_store_app_project/vm/category_handler.dart';
import 'package:shoes_store_app_project/vm/customer_handler.dart';
import 'package:shoes_store_app_project/vm/manufacture_handler.dart';
import 'package:shoes_store_app_project/vm/order_handler.dart';
import 'package:shoes_store_app_project/vm/product_handler.dart';

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
    initializeData();
  } 

  // initxx() async{


  //   ManufactureHandler manf = ManufactureHandler();
  //   List<Manufacture> manfs = await manf.selectQuery();
  //   print('${manfs[0].manufacture_name}');
  //   // await manf.insert(Manufacture(manufacture_name: '나이키', created_at: DateTime.now()));
  //   // await manf.insert(Manufacture(manufacture_name: '아디다스', created_at: DateTime.now()));

  //   CategoryHandler cat = CategoryHandler();
  //   List<ProductCategory> cats = await cat.selectQuery();
  //   print('${cats[0].category_name}');

  //   // await cat.insert(ProductCategory(category_name: '런닝화', created_at: DateTime.now()));
  //   // await cat.insert(ProductCategory(category_name: '스니커즈', created_at: DateTime.now()));
  //   // await cat.insert(ProductCategory(category_name: '농구화', created_at: DateTime.now()));

  //   // CustomerHandler customerHandler = CustomerHandler();
    
  //   // await customerHandler.insert(Customer(customer_email: 'aaa', customer_password: '1234', customer_name: 'Obama', created_at: DateTime.now()));
  //   // await customerHandler.insert(Customer(customer_email: 'bbb', customer_password: '1234', customer_name: 'Bill Gates', created_at: DateTime.now()));
  //   // List<Customer> cc = await customerHandler.selectQuery();
  //   // print('${cc[0].created_at}');

    


  //   // ProductHandler productHandler = ProductHandler();
  //   // List<Product> list =  await productHandler.selectQuery(1);
  //   // for(Product p in list){
  //   //   print('${p.product_name}');
  //   //   print('${p.product_color}');
  //   // }
  //   // await productHandler.insert(
  //   //   Product(
  //   //     store_id: 1, 
  //   //     product_name: '조던에어', 
  //   //     product_color: 'green', 
  //   //     product_size: 270, 
  //   //     product_price: 150000, 
  //   //     product_quantity: 10, 
  //   //     created_at: DateTime.now(), 
  //   //     product_released_date: DateTime.now()
  //   //   )
  //   // );
  //   //  await productHandler.insert(
  //   //   Product(
  //   //     store_id: 1, 
  //   //     product_name: '에어', 
  //   //     product_color: 'green', 
  //   //     product_size: 270, 
  //   //     product_price: 150000, 
  //   //     product_quantity: 15, 
  //   //     created_at: DateTime.now(), 
  //   //     product_released_date: DateTime.now()
  //   //   )
  //   // );
  //   //  await productHandler.insert(
  //   //   Product(
  //   //     store_id: 1, 
  //   //     product_name: '에어조던', 
  //   //     product_color: 'white', 
  //   //     product_size: 275, 
  //   //     product_price: 150000, 
  //   //     product_quantity: 10, 
  //   //     created_at: DateTime.now(), 
  //   //     product_released_date: DateTime.now()
  //   //   )
  //   // );
  //   //  await productHandler.insert(
  //   //   Product(
  //   //     store_id: 1, 
  //   //     product_name: '에어덩크', 
  //   //     product_color: 'red', 
  //   //     product_size: 265, 
  //   //     product_price: 128000, 
  //   //     product_quantity: 5, 
  //   //     created_at: DateTime.now(), 
  //   //     product_released_date: DateTime.now()
  //   //   )
  //   // );



  // }


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
