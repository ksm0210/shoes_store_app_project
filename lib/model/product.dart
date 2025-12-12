// 상품, 재고 정보

class Product{
  int? product_id;
  int store_id;
  int category_id;
  int manufacture_id;
  String? category_name;
  String? manufacture_name;
  String product_name;
  String? product_description;
  String? gender;
  String product_color;
  int product_size;
  int product_price;
  int product_quantity;
  String? mainImageUrl;
  String? sub1ImageUrl;
  String? sub2ImageUrl;
  
  DateTime product_released_date;
  DateTime created_at;

  Product({
    required this.store_id,
    required this.category_id,
    required this.manufacture_id,
    required this.product_name,
    this.product_description,
    this.gender,
    required this.product_color,
    required this.product_size,
    required this.product_price,
    required this.product_quantity,
    this.mainImageUrl,
    this.sub1ImageUrl,
    this.sub2ImageUrl,
    required this.product_released_date,
    required this.created_at,
  });

  Product.fromMap(Map<String,dynamic> json) : 

  store_id = json['store_id'],
  category_id = json['category_id'],
  manufacture_id = json['manufacture_id'],
  category_name = json['category_name'],
  manufacture_name = json['manufacture_name'],
  product_name = json['product_name'],
  product_description = json['product_description'],
  gender = json['gender'],
  product_color = json['product_color'],
  product_size = json['product_size'],
  product_price = json['product_price'],
  product_quantity = json['product_quantity'],
  mainImageUrl = json['mainImageUrl'],
  sub1ImageUrl = json['sub1ImageUrl'],
  sub2ImageUrl = json['sub2ImageUrl'],
  product_released_date = DateTime.parse(json['product_released_date']),
  created_at = DateTime.parse(json['created_at']);
}

