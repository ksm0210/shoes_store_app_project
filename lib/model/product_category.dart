// 신발 카테고리 정보들
class ProductCategory {
  final int productcategory_categoryid;
  final String productcategory_categoryName;

  ProductCategory({
    required this.productcategory_categoryid,
    required this.productcategory_categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'productcategory_categoryid': productcategory_categoryid,
      'productcategory_categoryName': productcategory_categoryName,
    };
  }

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      productcategory_categoryid: map['productcategory_categoryid'],
      productcategory_categoryName: map['productcategory_categoryName'],
    );
  }
}
