// 신발 카테고리 정보들
class ProductCategory {
  int? category_id;
  String category_name;
  DateTime created_at;

  ProductCategory({
    this.category_id,
    required this.category_name,
    required this.created_at,
  });

  ProductCategory.fromMap(Map<String, dynamic> res)
      : category_id = res['category_id'],
        category_name = res['category_name'],
        created_at = DateTime.parse(res['created_at']);
}
