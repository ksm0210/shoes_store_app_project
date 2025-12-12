

import 'package:shoes_store_app_project/model/customer.dart';
import 'package:shoes_store_app_project/model/manufacture.dart';
import 'package:shoes_store_app_project/model/product.dart';
import 'package:shoes_store_app_project/model/product_category.dart';
import 'package:shoes_store_app_project/vm/category_handler.dart';
import 'package:shoes_store_app_project/vm/customer_handler.dart';
import 'package:shoes_store_app_project/vm/manufacture_handler.dart';
import 'package:shoes_store_app_project/vm/product_handler.dart';

initializeData() async {

    
  

    ManufactureHandler manf = ManufactureHandler();
    // List<Manufacture> manfs = await manf.selectQuery();
    // print('${manfs[0].manufacture_name}');
    await manf.insert(Manufacture(manufacture_name: '나이키', created_at: DateTime.now()));
    await manf.insert(Manufacture(manufacture_name: '아디다스', created_at: DateTime.now()));
    await manf.insert(Manufacture(manufacture_name: '퓨마', created_at: DateTime.now()));
    

    CategoryHandler cat = CategoryHandler();
    // List<ProductCategory> cats = await cat.selectQuery();
    // print('${cats[0].category_name}');

    await cat.insert(ProductCategory(category_name: '스니커즈', created_at: DateTime.now()));
    await cat.insert(ProductCategory(category_name: '런닝화', created_at: DateTime.now()));
    await cat.insert(ProductCategory(category_name: '농구화', created_at: DateTime.now()));



    CustomerHandler customerHandler = CustomerHandler();
    
    await customerHandler.insert(Customer(customer_email: 'aaa', customer_password: '1234', customer_name: 'Obama', created_at: DateTime.now()));
    await customerHandler.insert(Customer(customer_email: 'bbb', customer_password: '1234', customer_name: 'Bill Gates', created_at: DateTime.now()));
    // List<Customer> cc = await customerHandler.selectQuery();
    // print('${cc[0].created_at}');

    


    ProductHandler productHandler = ProductHandler();

    await productHandler.insert(
      Product(
        store_id: 1,
        manufacture_id: 1,
        category_id: 1, 
        product_name: '조던에어', 
        product_color: 'green', 
        product_size: 270, 
        product_price: 150000, 
        product_quantity: 10, 
        created_at: DateTime.now(), 
        product_released_date: DateTime.now()
      )
    );
     await productHandler.insert(
      Product(
        store_id: 1, 
        manufacture_id: 1,
        category_id : 2,
        product_name: '에어', 
        product_color: 'green', 
        product_size: 270, 
        product_price: 150000, 
        product_quantity: 15, 
        created_at: DateTime.now(), 
        product_released_date: DateTime.now()
      )
    );
     await productHandler.insert(
      Product(
        store_id: 1, 
        manufacture_id: 1,
        category_id : 1,
        product_name: '에어조던', 
        product_color: 'white', 
        product_size: 275, 
        product_price: 150000, 
        product_quantity: 10, 
        created_at: DateTime.now(), 
        product_released_date: DateTime.now()
      )
    );
     await productHandler.insert(
      Product(
        store_id: 1, 
        manufacture_id: 1,
        category_id : 1,
        product_name: '에어덩크', 
        product_color: 'red', 
        product_size: 265, 
        product_price: 128000, 
        product_quantity: 5, 
        created_at: DateTime.now(), 
        product_released_date: DateTime.now()
      )
    );
    //     List<Product> list =  await productHandler.selectQuery(1);
    // for(Product p in list){
    //   print('${p.product_name}');
    //   print('${p.product_color}');
      
    //   print('${p.category_name}');
    //    print('${p.manufacture_name}');
    
    // }

}