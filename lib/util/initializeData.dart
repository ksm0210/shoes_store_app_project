import 'dart:math';

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
      store_lat: 37.498,
      store_lng: 127.027,
      created_at: DateTime.now(),
    ),
  );
  await storeHandler.insert(
    Store(
      store_address: '삼성역',
      store_phone: '444-555-6666',
      store_name: '삼성역점',
      store_zipcode: '345',
      store_lat: 37.5085951,
      store_lng: 127.0585787,
      created_at: DateTime.now(),
    ),
  );

  ManufactureHandler manf = ManufactureHandler();
  // List<Manufacture> manfs = await manf.selectQuery();
  // print('${manfs[0].manufacture_name}');
  await manf.insert(
    Manufacture(manufacture_name: '나이키', created_at: DateTime.now()),
  );
  await manf.insert(
    Manufacture(manufacture_name: '아디다스', created_at: DateTime.now()),
  );
  await manf.insert(
    Manufacture(manufacture_name: '퓨마', created_at: DateTime.now()),
  );

  CategoryHandler cat = CategoryHandler();
  // List<ProductCategory> cats = await cat.selectQuery();
  // print('${cats[0].category_name}');

  await cat.insert(
    ProductCategory(category_name: '스니커즈', created_at: DateTime.now()),
  );
  await cat.insert(
    ProductCategory(category_name: '런닝화', created_at: DateTime.now()),
  );
  await cat.insert(
    ProductCategory(category_name: '농구화', created_at: DateTime.now()),
  );

  CustomerHandler customerHandler = CustomerHandler();

  await customerHandler.insert(
    Customer(
      customer_email: 'aaa@aaa.com',
      customer_password: '1234',
      customer_name: 'Obama',
      created_at: DateTime.now(),
    ),
  );
  await customerHandler.insert(
    Customer(
      customer_email: 'bbb@bbb.com',
      customer_password: '1234',
      customer_name: 'Bill Gates',
      created_at: DateTime.now(),
    ),
  );
  // List<Customer> cc = await customerHandler.selectQuery();
  // print('${cc[0].created_at}');

  ProductHandler productHandler = ProductHandler();
  // 랜덤함수
  int randomShoeSize() {
    final random = Random();
    return 220 + random.nextInt(((300 - 220) ~/ 5) + 1) * 5;
  }

  // 사진저장소
  // final List<List<String>> images = [
  //   ['speedcat(pink).jpg', 'speedcat(red).jpg', 'speedcat(black).jpg'],
  //   ['airforce(black).jpg', 'airforce(white).jpg', 'airforce(brown).jpg'],
  //   ['gazelle(black).jpg', 'gazelle(navy).jpg', 'gazelle(red).jpg'],
  //   ['jordan(blue).jpg', 'jordan(green).jpg', 'jordan(red).jpg'],
  //   ['nikeshox(black).jpg', 'nikeshox(pink).jpg', 'nikeshox(white).jpg'],
  //   ['superstar(black).jpg', 'superstar(brown).jpg', 'superstar(white).jpg'],
  //   ['adizero(black).jpg', 'adizero(red).jpg', 'adizero(white).jpg'],
  // ];

  // url Iamge 저장소
  final List<List<String>> images = [
    [
      'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_1000,h_1000/global/398846/04/fnd/KOR/fmt/png/%EC%8A%A4%ED%94%BC%EB%93%9C%EC%BA%A3-OG-brSpeedcat-OG',
      'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_1000,h_1000/global/398846/02/fnd/KOR/fmt/png/%EC%8A%A4%ED%94%BC%EB%93%9C%EC%BA%A3-OG-brSpeedcat-OG',
      'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_1000,h_1000/global/398846/01/fnd/KOR/fmt/png/%EC%8A%A4%ED%94%BC%EB%93%9C%EC%BA%A3-OG-brSpeedcat-OG',
    ],
    [
      'https://kream-phinf.pstatic.net/MjAyNDA2MjFfMjEw/MDAxNzE4OTQ5MjY4OTEy.mpAHau4TE35aMezcGNE0jrpcDeg4lnnygmUJvgYRGgIg.cmMwASld5ZZfcHq3z9wl-pwmaP3tOW4cJsVcp_CGq1sg.PNG/a_740c5e7ac96f48c1b422f11c25c4bdb4.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyNDA2MjJfMTMx/MDAxNzE5MDI5ODMzOTg2.8TsdHQrXy3-tcIMHceZOG5eBSdl_-ybtjFhLVIZDOXEg.TUQIZNOi5ptP4zsfcdsi3EBAgTwh2jruSeKGnbMekaQg.PNG/a_56586590956f4404862cbdaeff6a5e63.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyNTAzMjVfMTA2/MDAxNzQyODg4MzgzMTYz.2NxF64xi8tMUKh7M_-1pEBVqxrpE9vD7LOsBf1yoLRcg.VFp-C17aPtpFEib_4YjmU9m46f3NCS-0t7vAbdHLVlsg.PNG/a_13febd41743e47848ddeb026f772b7ce.png?type=l_webp',
    ],
    [
      'https://kream-phinf.pstatic.net/MjAyNDA2MDVfMTMg/MDAxNzE3NTUyNjMxOTA4.hVhganj8a5fUlxNjUirhyrSIDmCBVe6Xi2lHX1JTaYMg.YFge1lVYt_23qnj3BQP6nxsywXAyPp8hVMjaJ4bMlyQg.PNG/a_af3f581e21e545de93477cc28633ef97.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyMjAzMjFfNjMg/MDAxNjQ3ODUyMTQ0ODE1.rZFusTkS695JjsoAA_wuci9afVsl7iyKXdnlXMH3I2kg.a_RBFsCS7sc4_LiMcUxgTLPzS8sBicMT3rEBcEBc0KEg.PNG/a_54d999b0dcef4c86938a6a31d445eae4.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyNDA2MjhfMTY2/MDAxNzE5NTUyMTQyODEx.wwMEHeRibp6Ub9aCCj06dVa469FXPJTAk1_uD-T8G2Ag.jR3JzGClA8-389HUrOHyC4UqqEMSHt3TMLA-CQ1IcrQg.PNG/a_de164d690f3a4f5fb4c0ba58cc5c6a61.png?type=l_webp',
    ],
    [
      'https://kream-phinf.pstatic.net/MjAyNTExMDdfNjkg/MDAxNzYyNTA5Mjc5NDMy.bjVsGpFlapO9Qe0W6kaRjUbPJ1m0NzgSQidTzffcwTIg.jnAhEThIpg3ERbTleJLX6gb3b2ajfCembogegZVOissg.PNG/a_70c7eda92b0340d3b093174067c05a78.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyMzA0MDRfMTE1/MDAxNjgwNTcyNzI0NDE0.fcP3QMah32g_bWxf8ByocG_HuFNfEBlcZLeuJxIij1Qg.rA3j63FGeHAP6er7RKSL3VqU4VDXWG5l2doQdU10wwYg.PNG/a_1df22db10d704f199753e55783a786bf.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyNTA1MjFfNTIg/MDAxNzQ3ODE5MjA0Mjk4.wR1rXzSU8drxuHIOHuEDi0KjJ_fZtk69Dpv3nT-pOsEg.dQ8zXxX3gcAd4XozZ85kM_wuMxVU3gXxOtGsuFlh9TEg.PNG/a_dd4604f26dd74a4db2370550d5135499.png?type=l_webp',
    ],
    [
      'https://kream-phinf.pstatic.net/MjAyNTA0MDhfNDQg/MDAxNzQ0MDc2ODQxNzAx.9c4JM54PDPLhKsjOSP6cfkyN7HLiDDbY4xMV7ak2PIUg.4k7NDZ5P3_nvG_CajmpwwKXd2J78nVWR-jR0RoASJgQg.PNG/a_fa99e2e802774b3180d079164a0a04e8.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyNTAxMjNfMjYy/MDAxNzM3NjEzNjQyMjkx.uXSJlxDhVxI1earZaCaTJMmk3KFhj3_yqMVVbJcxIRcg.yXSdcVF-6mO_Czzzm46fS50tFSzEkLNqfejqIqwuyzEg.PNG/a_9ac9f5b3bf0f4b18938f74273817e975.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyNDAyMDhfNyAg/MDAxNzA3Mzg0MjgwMjIw.xyuk0-TJFMFoVOipIKnUamd5pEebY44xC0lcU3NFeUYg.POrqNqAB3Pb4wPOT8oSyAH-9nwC3ReIVJ_C7L70zprgg.PNG/a_c96540aed7ee46d1a2c7dd2b4ad8e073.png?type=l_webp',
    ],
    [
      'https://kream-phinf.pstatic.net/MjAyNTAzMDdfNTYg/MDAxNzQxMzMyMjAxNzUw.3z8LvbLuNZVziAMyCWTa_ilwg54RCRT8NDI7JgiEIP8g.sWCPxqCDRlZF73Kwh2lX0TYJcXCFFq9Cg8QFNXoCzI8g.PNG/a_30eb897614154dfabd1184f4c1db8965.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyNTAyMjdfODEg/MDAxNzQwNjI0OTU3OTM3.rbjDa5CBA6Oeq2nnVIQgcpTj5emfjtvUx_XXqUDXEQIg.0uWtMX4_-QUESxDQWbm-1NGzUXinmUuTIOQJIgkblRsg.PNG/a_41d7b69ae9a84836a1e91bf6a3681bdc.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyNTA1MDlfOSAg/MDAxNzQ2NzgyNjU4MjY2.1gG3ZtOZqeNFjDxGjCgVojFPAtSobzkUoqF0k4qjsokg.h_6NhWPqc92tcyN3vmcPEG4gplzb0Bz6DBS0JNPa-H8g.PNG/a_537b5b36f13143f4a3f7ee93d7b009af.png?type=l_webp',
    ],
    [
      'https://kream-phinf.pstatic.net/MjAyNTA3MTZfMTk4/MDAxNzUyNjU0MTI3NDky.2psgoArZAg3QK4CkiJll7NRL6zg3V1KBDb4UNIQzfDYg.u3nY5qaPvcTLI7rQoBKqj_r0o0r_h-Hr1mvjMtVBBX8g.PNG/a_19df71562cf3412083b4b5c97b0434fd.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyNTExMTBfMjkz/MDAxNzYyNzY4MjgyMDQ1.mJy5lXx-ZR_idN3VkcKc36JZTlRuWAJVf4mPPAopuo8g.4eA9BPKhPjOHsLFKM8FF4vxOW2MGhvZ6_O-2LA8aEzog.PNG/a_fc5077fb3f1245e38df3ec96bf9f0e37.png?type=l_webp',
      'https://kream-phinf.pstatic.net/MjAyNTA3MDNfNDUg/MDAxNzUxNTA0NTU4ODUx.Emq3ASoH6n4mmRaImYd_61aJRQSsoq3y5LNc1IjbA3Mg._ZB7l9ldHr-dO7Q9GoTlcDhMsLjD3deCTTHMdvr7JXEg.PNG/a_94591aa56d6d4e8a9aefc8a0cd25e48d.png?type=l_webp',
    ],
  ];

  // 퓨마 신발 리스트
  List<String> speedcat_color = ['pink', 'red', 'black'];
  for (int j = 0; j < speedcat_color.length; j++) {
    for (int i = 0; i < 5; i++) {
      await productHandler.insert(
        Product(
          store_id: 1,
          manufacture_id: 3,
          category_id: 1,
          product_name: '스피드캣',
          product_color: speedcat_color[j],
          product_size: randomShoeSize(),
          mainImageUrl: images[0][j],
          sub1ImageUrl: '',
          sub2ImageUrl: '',
          gender: '여성',
          product_price: 139000,
          product_description:
              '레이스 트랙의 속도에서 영감을 받은 푸마의 아이콘: Speedcat. 클래식한 레이싱 슈즈에서 착안한 실루엣, 모터스포츠의 빠른 스피드를 연상시키는 라인과 PUMA의 아이코닉한 디자인이 특징입니다. 이는 모터스포츠 세계에서 가장 상징적인 실루엣으로, 스트릿 컬쳐와 만나 착용하는 즐거움을 선사합니다.',
          product_quantity: 10,
          created_at: DateTime.now(),
          product_released_date: DateTime.now(),
        ),
      );
    }
  }
  // 나이키 신발 리스트
  // 에어포스
  List<String> airforce_color = ['black', 'white', 'brown'];
  for (int j = 0; j < airforce_color.length; j++) {
    for (int i = 0; i < 5; i++) {
      await productHandler.insert(
        Product(
          store_id: 1,
          manufacture_id: 1,
          category_id: 1,
          product_name: '에어포스',
          product_color: airforce_color[j],
          product_size: randomShoeSize(),
          mainImageUrl: images[1][j],
          sub1ImageUrl: '',
          sub2ImageUrl: '',
          gender: '남성',
          product_price: 139000,
          product_description:
              '편안함과 내구성, 그리고 유행을 타지 않는 스타일까지. 1번 모델이 된 데는 그만한 이유가 있습니다. 스웨이드 가죽과 매칭되는 밑창으로 모노크롬 룩을 연출하는 에어 포스 1입니다. 대담한 스우시가 드라마틱한 마무리를 선사합니다.',
          product_quantity: 20,
          created_at: DateTime.now(),
          product_released_date: DateTime.now(),
        ),
      );
    }
  }
  // 조던
  List<String> jordan_color = ['blue', 'green', 'red'];
  for (int j = 0; j < jordan_color.length; j++) {
    for (int i = 0; i < 5; i++) {
      await productHandler.insert(
        Product(
          store_id: 1,
          manufacture_id: 1,
          category_id: 3,
          product_name: '에어조던',
          product_color: jordan_color[j],
          product_size: randomShoeSize(),
          mainImageUrl: images[3][j],
          sub1ImageUrl: '',
          sub2ImageUrl: '',
          gender: '남성',
          product_price: 159000,
          product_description:
              '농구와 대중문화 역사에서 많은 사랑을 받은 아이콘, 에어 조던 4는 1989년 첫선을 보인 이래 수많은 전설적인 컬러웨이를 선보여왔습니다. ',
          product_quantity: 10,
          created_at: DateTime.now(),
          product_released_date: DateTime.now(),
        ),
      );
    }
  }
  //샥스
  List<String> shox_color = ['black', 'pink', 'white'];
  for (int j = 0; j < jordan_color.length; j++) {
    for (int i = 0; i < 5; i++) {
      await productHandler.insert(
        Product(
          store_id: 1,
          manufacture_id: 1,
          category_id: 1,
          product_name: '에어조던',
          product_color: shox_color[j],
          product_size: randomShoeSize(),
          mainImageUrl: images[4][j],
          sub1ImageUrl: '',
          sub2ImageUrl: '',
          gender: '여성',
          product_price: 159000,
          product_description:
              '모던한 클래식 아이템인 샥스 라이드 2는 뒤꿈치 아래를 받쳐주는 네 개의 기둥과 앞꿈치의 맥스 에어 기술로 반응성이 탁월한 쿠셔닝을 선사합니다. 통기성 좋은 직물 소재와 천연 가죽을 적용한 갑피는 편안하며 내구성이 뛰어납니다.',
          product_quantity: 10,
          created_at: DateTime.now(),
          product_released_date: DateTime.now(),
        ),
      );
    }
  }

  // 아디다스 신발 리스트
  List<String> adizero_color = ['black', 'red', 'white'];
  for (int j = 0; j < adizero_color.length; j++) {
    for (int i = 0; i < 5; i++) {
      await productHandler.insert(
        Product(
          store_id: 1,
          manufacture_id: 2,
          category_id: 2,
          product_name: '아디제로',
          product_color: adizero_color[j],
          product_size: randomShoeSize(),
          mainImageUrl: images[6][j],
          sub1ImageUrl: '',
          sub2ImageUrl: '',
          gender: '남성',
          product_price: 220600,
          product_description: '삶에 속도를 더해줄 패스트 컬처를 위해 진화한 아디제로',
          product_quantity: 10,
          created_at: DateTime.now(),
          product_released_date: DateTime.now(),
        ),
      );
    }
  }
  // 가젤
  List<String> gazelle_color = ['black', 'navy', 'red'];
  for (int j = 0; j < adizero_color.length; j++) {
    for (int i = 0; i < 5; i++) {
      await productHandler.insert(
        Product(
          store_id: 1,
          manufacture_id: 2,
          category_id: 1,
          product_name: '가젤',
          product_color: gazelle_color[j],
          product_size: randomShoeSize(),
          mainImageUrl: images[2][j],
          sub1ImageUrl: '',
          sub2ImageUrl: '',
          gender: '여성',
          product_price: 117600,
          product_description: '자연스러운 데일리 스타일로 돌아온 아이코닉한 슈즈',
          product_quantity: 10,
          created_at: DateTime.now(),
          product_released_date: DateTime.now(),
        ),
      );
    }
  }
  // 슈퍼스타
  List<String> superstar_color = ['black', 'brown', 'white'];
  for (int j = 0; j < adizero_color.length; j++) {
    for (int i = 0; i < 5; i++) {
      await productHandler.insert(
        Product(
          store_id: 1,
          manufacture_id: 2,
          category_id: 1,
          product_name: '슈퍼스타',
          product_color: superstar_color[j],
          product_size: randomShoeSize(),
          mainImageUrl: images[5][j],
          sub1ImageUrl: '',
          sub2ImageUrl: '',
          gender: '남성',
          product_price: 139000,
          product_description: '클래식한 라운드 쉘 토가 돋보이는 사랑받는 아디다스 슈퍼스타 슈즈',
          product_quantity: 10,
          created_at: DateTime.now(),
          product_released_date: DateTime.now(),
        ),
      );
    }
  }
  await productHandler.insert(
    Product(
      store_id: 1,
      manufacture_id: 1,
      category_id: 1,
      product_name: '에어 조던',
      product_color: 'green',
      product_size: 270,
      gender: '남성',
      product_price: 150000,
      product_description:
          '페가수스 플러스로 차원이 다른 반응성과 쿠셔닝을 느껴보세요. 전체적으로 적용된 초경량 줌X 폼이 일상의 러닝에 높은 에너지 반환력을 제공하기 때문에 활력 있게 달릴 수 있습니다. 그리고 신축성 좋은 플라이니트 갑피가 발을 꼭 맞게 감싸 매끄러운 핏을 선사합니다.',
      product_quantity: 10,
      mainImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDpON7VqeimHWNLI8BpsZ9Y-hdvZG7u0bMyzKuJdc-peEtlDNEEFdDgJsYlG-0ff2exA6lqoBzSB6XSjwrgoLVsdx0626XQjp8N8rjDq5DDeVeH-1ycJKeHN3Nm1UMvhSJ-kImWboyzIZdbK4xX93L1xVQyr1dRmSC_7fHftIjE-Ia0sgQduae4idKGcvvQ4tsR0wdPGbWBz2TDMOvVI4AorfQXXH2XrStY8udjRoG7Ukvzv3Ifhf0jrvKhH9-r7gj7-UXzsIHI2_o',
      sub1ImageUrl: '',
      sub2ImageUrl: '',
      created_at: DateTime.now(),
      product_released_date: DateTime.now(),
    ),
  );
  await productHandler.insert(
    Product(
      store_id: 1,
      manufacture_id: 2,
      category_id: 2,
      product_name: '에어 맥스 90',
      product_color: 'green',
      product_size: 270,
      product_price: 170000,
      product_quantity: 15,
      product_description:
          '페가수스 플러스로 차원이 다른 반응성과 쿠셔닝을 느껴보세요. 전체적으로 적용된 초경량 줌X 폼이 일상의 러닝에 높은 에너지 반환력을 제공하기 때문에 활력 있게 달릴 수 있습니다. 그리고 신축성 좋은 플라이니트 갑피가 발을 꼭 맞게 감싸 매끄러운 핏을 선사합니다.',
      gender: '여성',
      mainImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDHdQ1ILK_dUdEh8XOt6ViOw16Hab9Oc0UaFIxMFrWsQMa78xaiFWexjQJV__ym7gr_q6ifzRDPkvgJafjCRXxYSBarIcfbmFUYzhf1YQzTdish8OTP7LTwHODxHRni5TUks-RD8A-thv73eLbEzCOOJxhsQzIKxevRYsVPuvUavNGsycBFNhpFEpFra4FrxuH-UfgMogp5rIAUdpVjqAJQtps74W5ND9msWtNiF-vAVscFG6yhHsU9Dh96OtnZR6tIsV5dZdt3ye4',
      sub1ImageUrl: '',
      sub2ImageUrl: '',
      created_at: DateTime.now(),
      product_released_date: DateTime.now(),
    ),
  );
  await productHandler.insert(
    Product(
      store_id: 1,
      manufacture_id: 1,
      category_id: 1,
      product_name: '에어 포스1',
      product_color: 'white',
      product_size: 275,
      product_price: 160000,
      product_quantity: 10,
      gender: '남성',
      product_description:
          '페가수스 플러스로 차원이 다른 반응성과 쿠셔닝을 느껴보세요. 전체적으로 적용된 초경량 줌X 폼이 일상의 러닝에 높은 에너지 반환력을 제공하기 때문에 활력 있게 달릴 수 있습니다. 그리고 신축성 좋은 플라이니트 갑피가 발을 꼭 맞게 감싸 매끄러운 핏을 선사합니다.',

      mainImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA5TAFbKthcnj0ocsMMjbiUmYNKoCdlQcOFVqwqiC4J4N4ARFiealFz7uZ-9h683p_PcG3Tla2CmnavgRpHIw_2qEbY5bC20QsVzEk0lKov_X2eI9cM5dX-whZYKdEPkMXqRCGLD-yrLdTR52MftHTJXR4bphU-5uiwWT-FQBDvIeMT5VhnfhhxCYy-JKG7gVnAP015l9uPUSv-3Uxn-_yxTouAUjZM1_uDZ6O_QoTXCDIdof7tYvoaYSG5jO_jWymPcOPUQhJtCrk',
      sub1ImageUrl: '',
      sub2ImageUrl: '',
      created_at: DateTime.now(),
      product_released_date: DateTime.now(),
    ),
  );
  await productHandler.insert(
    Product(
      store_id: 1,
      manufacture_id: 1,
      category_id: 1,
      product_name: '에어 맥스 270',
      product_color: 'red',
      gender: '여성',
      product_size: 265,
      product_price: 128000,
      product_quantity: 5,
      product_description:
          '페가수스 플러스로 차원이 다른 반응성과 쿠셔닝을 느껴보세요. 전체적으로 적용된 초경량 줌X 폼이 일상의 러닝에 높은 에너지 반환력을 제공하기 때문에 활력 있게 달릴 수 있습니다. 그리고 신축성 좋은 플라이니트 갑피가 발을 꼭 맞게 감싸 매끄러운 핏을 선사합니다.',

      mainImageUrl:
          'https://static.nike.com/a/images/t_web_pdp_535_v2/f_auto/ee7dcded-2ccf-4a8d-bbaa-91c250873e4b/PEGASUS+PLUS.png',
      created_at: DateTime.now(),
      product_released_date: DateTime.now(),
    ),
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
    Review(
      customer_id: 1,
      product_id: 1,
      review_rating: 3,
      review_content: '아주 좋아요',
      created_at: DateTime.now(),
    ),
  );
  await reviewHandler.insert(
    Review(
      customer_id: 2,
      product_id: 1,
      review_rating: 4,
      review_content: '편하고 러닝화로 최고입니다. 역시 나이키.',
      created_at: DateTime.now(),
    ),
  );
}
