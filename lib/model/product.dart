// 상품, 재고 정보

class Product{
  int? product_id;
  int store_id;
  String product_name;
  String? product_description;
  String? gender;
  String product_color;
  int product_size;
  int product_price;
  int product_quantity;
  DateTime? product_released_date;
  DateTime created_at;

  Product({
        this.product_id, 
    required this.store_id,
    required this.product_name,
    this.product_description,
    this.gender,
    required this.product_color,
    required this.product_size,
    required this.product_price,
    required this.product_quantity,
    this.product_released_date,
    required this.created_at,
  });

  Product.fromMap(Map<String,dynamic> json) : 
  product_id = json['product_id'],
  store_id = json['store_id'],
  product_name = json['product_name'],
  product_description = json['product_description'],
  gender = json['gender'],
  product_color = json['prouect_color'],
  product_size = json['prouect_size'],
  product_price = json['prouect_price'],
  product_quantity = json['prouect_quantity'],
  product_released_date = json['product_released_date'],
  created_at = DateTime.now();
}