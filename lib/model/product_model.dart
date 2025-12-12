// lib/models/product_model.dart

class ProductModel {
  final String title;
  final String price; // String 형태 유지 (예: "₩139,000")
  final String imageUrl; // 메인 이미지 URL
  final String selectedSize;
  final String selectedColorImageUrl; // 장바구니에 담긴 선택된 색상 이미지
  final int qty; // 장바구니에 담긴 수량

  ProductModel({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.selectedSize,
    required this.selectedColorImageUrl,
    this.qty = 1,
  });

  // CartController의 Map 데이터를 ProductModel 객체로 변환하는 팩토리 생성자
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      title: map['title'] as String,
      // CartController에서 price는 int로 변환되어 저장되므로, 다시 String으로 변환합니다.
      // 만약 포맷이 필요하다면 intl을 사용해야 하지만, 여기서는 간단히 문자열화 합니다.
      price: '₩${(map['price'] as int).toString()}', // ₩ 포맷이 OrderScreen에서 필요하다고 가정
      imageUrl: map['image'] as String,
      selectedSize: map['size'] as String, 
      selectedColorImageUrl: map['image'] as String, 
      qty: map['qty'] as int,
    );
  }
}