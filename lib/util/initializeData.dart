

import 'package:shoes_store_app_project/model/customer.dart';
import 'package:shoes_store_app_project/model/manufacture.dart';
import 'package:shoes_store_app_project/model/product.dart';
import 'package:shoes_store_app_project/model/product_category.dart';
import 'package:shoes_store_app_project/model/review.dart';
import 'package:shoes_store_app_project/model/store.dart';
import 'package:shoes_store_app_project/vm/category_handler.dart';
import 'package:shoes_store_app_project/vm/customer_handler.dart';
import 'package:shoes_store_app_project/vm/manufacture_handler.dart';
import 'package:shoes_store_app_project/vm/product_handler.dart';
import 'package:shoes_store_app_project/vm/review_handler.dart';
import 'package:shoes_store_app_project/vm/store_handler.dart';

initializeData() async {

    
    StoreHandler storeHandler = StoreHandler();
    await storeHandler.insert(
      Store(
        store_address: '강남역', 
        store_phone: '111-222-3333', 
        store_name: '강남역 본점', 
        store_zipcode: '123', 
        created_at: DateTime.now()
      )
    );
     await storeHandler.insert(
      Store(
        store_address: '삼성역', 
        store_phone: '444-555-6666', 
        store_name: '삼성역점', 
        store_zipcode: '345', 
        created_at: DateTime.now()
      )
    );

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
    
    await customerHandler.insert(Customer(customer_email: 'aaa@aaa.com', customer_password: '1234', customer_name: 'Obama', created_at: DateTime.now()));
    await customerHandler.insert(Customer(customer_email: 'bbb@bbb.com', customer_password: '1234', customer_name: 'Bill Gates', created_at: DateTime.now()));
    // List<Customer> cc = await customerHandler.selectQuery();
    // print('${cc[0].created_at}');

    


    ProductHandler productHandler = ProductHandler();

    await productHandler.insert(
      Product(
        store_id: 1,
        manufacture_id: 1,
        category_id: 1, 
        product_name: '에어 조던', 
        product_color: 'green', 
        product_size: 270, 
        product_price: 150000,
        product_description: '페가수스 플러스로 차원이 다른 반응성과 쿠셔닝을 느껴보세요. 전체적으로 적용된 초경량 줌X 폼이 일상의 러닝에 높은 에너지 반환력을 제공하기 때문에 활력 있게 달릴 수 있습니다. 그리고 신축성 좋은 플라이니트 갑피가 발을 꼭 맞게 감싸 매끄러운 핏을 선사합니다.', 
        product_quantity: 10, 
        mainImageUrl:'https://lh3.googleusercontent.com/aida-public/AB6AXuDpON7VqeimHWNLI8BpsZ9Y-hdvZG7u0bMyzKuJdc-peEtlDNEEFdDgJsYlG-0ff2exA6lqoBzSB6XSjwrgoLVsdx0626XQjp8N8rjDq5DDeVeH-1ycJKeHN3Nm1UMvhSJ-kImWboyzIZdbK4xX93L1xVQyr1dRmSC_7fHftIjE-Ia0sgQduae4idKGcvvQ4tsR0wdPGbWBz2TDMOvVI4AorfQXXH2XrStY8udjRoG7Ukvzv3Ifhf0jrvKhH9-r7gj7-UXzsIHI2_o',
        sub1ImageUrl:'',
        sub2ImageUrl:'',
        created_at: DateTime.now(), 
        product_released_date: DateTime.now()
      )
    );
     await productHandler.insert(
      Product(
        store_id: 1, 
        manufacture_id: 2,
        category_id : 2,
        product_name: '에어 맥스 90', 
        product_color: 'green', 
        product_size: 270, 
        product_price: 150000, 
        product_quantity: 15,
         product_description: '페가수스 플러스로 차원이 다른 반응성과 쿠셔닝을 느껴보세요. 전체적으로 적용된 초경량 줌X 폼이 일상의 러닝에 높은 에너지 반환력을 제공하기 때문에 활력 있게 달릴 수 있습니다. 그리고 신축성 좋은 플라이니트 갑피가 발을 꼭 맞게 감싸 매끄러운 핏을 선사합니다.', 
       
        mainImageUrl:'https://lh3.googleusercontent.com/aida-public/AB6AXuDHdQ1ILK_dUdEh8XOt6ViOw16Hab9Oc0UaFIxMFrWsQMa78xaiFWexjQJV__ym7gr_q6ifzRDPkvgJafjCRXxYSBarIcfbmFUYzhf1YQzTdish8OTP7LTwHODxHRni5TUks-RD8A-thv73eLbEzCOOJxhsQzIKxevRYsVPuvUavNGsycBFNhpFEpFra4FrxuH-UfgMogp5rIAUdpVjqAJQtps74W5ND9msWtNiF-vAVscFG6yhHsU9Dh96OtnZR6tIsV5dZdt3ye4',
        sub1ImageUrl:'',
        sub2ImageUrl:'',
        created_at: DateTime.now(), 
        product_released_date: DateTime.now()
      )
    );
     await productHandler.insert(
      Product(
        store_id: 1, 
        manufacture_id: 1,
        category_id : 1,
        product_name: '에어 포스1', 
        product_color: 'white', 
        product_size: 275, 
        product_price: 150000, 
        product_quantity: 10,
         product_description: '페가수스 플러스로 차원이 다른 반응성과 쿠셔닝을 느껴보세요. 전체적으로 적용된 초경량 줌X 폼이 일상의 러닝에 높은 에너지 반환력을 제공하기 때문에 활력 있게 달릴 수 있습니다. 그리고 신축성 좋은 플라이니트 갑피가 발을 꼭 맞게 감싸 매끄러운 핏을 선사합니다.', 
       
        mainImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA5TAFbKthcnj0ocsMMjbiUmYNKoCdlQcOFVqwqiC4J4N4ARFiealFz7uZ-9h683p_PcG3Tla2CmnavgRpHIw_2qEbY5bC20QsVzEk0lKov_X2eI9cM5dX-whZYKdEPkMXqRCGLD-yrLdTR52MftHTJXR4bphU-5uiwWT-FQBDvIeMT5VhnfhhxCYy-JKG7gVnAP015l9uPUSv-3Uxn-_yxTouAUjZM1_uDZ6O_QoTXCDIdof7tYvoaYSG5jO_jWymPcOPUQhJtCrk',
        sub1ImageUrl:'',
        sub2ImageUrl:'',
        created_at: DateTime.now(), 
        product_released_date: DateTime.now()
      )
    );
     await productHandler.insert(
      Product(
        store_id: 1, 
        manufacture_id: 1,
        category_id : 1,
        product_name: '에어 맥스 270', 
        product_color: 'red', 
        product_size: 265, 
        product_price: 128000, 
        product_quantity: 5,
         product_description: '페가수스 플러스로 차원이 다른 반응성과 쿠셔닝을 느껴보세요. 전체적으로 적용된 초경량 줌X 폼이 일상의 러닝에 높은 에너지 반환력을 제공하기 때문에 활력 있게 달릴 수 있습니다. 그리고 신축성 좋은 플라이니트 갑피가 발을 꼭 맞게 감싸 매끄러운 핏을 선사합니다.', 
       
        mainImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAWT5XtZPPiASQ8v75AKCbnfIgfTjhgk5Dj_gZr9bzaJQKrKplCfMVmgOgJtbWv4j-r7MrvNRUHqIPXGKxCvdfeAcWnB1nLp_8rkPfnBewikUnse8MFk4Uo06qfh8-sq_Rvly7PPKRpL3vB5wu4dwzd_aVDZANNvo0slxuaHN9brDT6P0XM01CiHxmTgaU',
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

    ReviewHandler reviewHandler = ReviewHandler();
    await reviewHandler.insert(
      Review(customer_id: 1, product_id: 1, review_rating: 3, review_content: '아주 좋아요', created_at: DateTime.now())
    );
    await reviewHandler.insert(
      Review(customer_id: 2, product_id: 1, review_rating: 4, review_content: '편하고 러닝화로 최고입니다. 역시 나이키.', created_at: DateTime.now())
    );

}