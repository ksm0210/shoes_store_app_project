
import 'package:shoes_store_app_project/model/order.dart';
import 'package:shoes_store_app_project/model/product_category.dart';

class GlobalLoginData {
  static bool isLogin = false;
  static int customer_id = 0;
  static List<double> customer_location = [37.498,127.027]; // lat, long 유저의 로케이션 저장.
  // 강남으로 설정.


  // 유저의 Bebahvior데이터 
  static List<int> viewList = [];

  // 기본 category data
  static List<ProductCategory> categories = [];

  // 임시 쇼핑카트 정보
  static List<Order> shopping_cart = [];

}
