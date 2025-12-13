import 'package:shoes_store_app_project/model/product.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class ProductHandler {
  // 전체제품
  Future<List<Product>> selectQuery(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery("""
      select p.* from products p
      join(select product_name, product_color, max(product_id) as max_id
            from products group by product_name, product_color) x
      on p.product_id = x.max_id
      order by p.product_released_date desc
      """);
    return data.map((data) => Product.fromMap(data)).toList();
  }

  // Future<List<Product>> selectQuery(int id) async {
  //   Database db = await Initialize.initDatabase();
  //   // 전체제품
  //   final data = await db.rawQuery("""
  //     select products.*,productCategories.category_name,manufactures.manufacture_name from products
  //     inner join manufactures on products.manufacture_id = manufactures.manufacture_id
  //     inner join productCategories on productCategories.category_id=products.category_id
  //     order by products.product_released_date desc

  //     """);

  //   return data.map((data) => Product.fromMap(data)).toList();
  // }

  // 상품 1개 정보가져오기
  Future<List<Product>> selectQueryById(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery(
      """
      select products.*,productCategories.category_name,manufactures.manufacture_name from products 
      inner join manufactures on products.manufacture_id = manufactures.manufacture_id
      inner join productCategories on productCategories.category_id=products.category_id
      where products.product_id=?
      """,
      [id],
    );

    return data.map((data) => Product.fromMap(data)).toList();
  }

  Future<int> insert(Product prod) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert(
      """
        insert into products( 
            store_id,
            category_id,
            manufacture_id,
            product_name,
            product_description,
            gender,
            product_color,
            product_size,
            product_price,
            product_quantity,
            mainImageUrl,
            sub1ImageUrl,
            sub2ImageUrl,
            product_released_date,
            created_at
   ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
   on conflict(store_id, product_name, product_color, product_size)
   do update set
     product_quantity = product_quantity + excluded.product_quantity
      """,
      [
        prod.store_id,
        prod.category_id,
        prod.manufacture_id,
        prod.product_name,
        prod.product_description,
        prod.gender,
        prod.product_color,
        prod.product_size,
        prod.product_price,
        prod.product_quantity,
        prod.mainImageUrl,
        prod.sub1ImageUrl,
        prod.sub2ImageUrl,
        prod.product_released_date.toString(),
        DateTime.now().toString(),
      ],
    );
  }

  Future<int> update(Product prod) async {
    Database db = await Initialize.initDatabase();
    return await db.rawUpdate(
      """
        update products set
            store_id=? 
            category_id=?,
            manufacture_id=?,
            product_name=?,
            product_description=?,
            gender=?,
            product_color=?,
            product_size=?,
            product_price=?,
            product_quantity=?,
            mainImageUrl=?,
            sub1ImageUrl=?,
            sub2ImageUrl=?,
            product_released_date=?
            where product_id=?
      """,
      [
        prod.store_id,
        prod.category_id,
        prod.manufacture_id,
        prod.product_name,
        prod.product_description,
        prod.gender,
        prod.product_color,
        prod.product_size,
        prod.product_price,
        prod.product_quantity,
        prod.mainImageUrl,
        prod.sub1ImageUrl,
        prod.sub2ImageUrl,
        prod.product_released_date.toString(),
        prod.product_id,
      ],
    );
  }

  // 검색부분
  Future<List<Product>> searchProducts(String query) async {
    final Database db = await Initialize.initDatabase();

    // like 검색 (대소문자/공백까지 느슨하게 하려면 query 가공 가능)
    final String q = "%${query.trim()}%";

    final data = await db.rawQuery(
      // 중복안뜨게 + 제조사이름적어도 뜨게 수정
      """
      SELECT p.*,
           pc.category_name,
           m.manufacture_name
      FROM products p
      JOIN (
        SELECT product_name, product_color, MAX(product_id) AS max_id
        FROM products
        GROUP BY product_name, product_color
      ) x ON p.product_id = x.max_id
      JOIN manufactures m ON p.manufacture_id = m.manufacture_id
      JOIN productCategories pc ON pc.category_id = p.category_id
      WHERE p.product_name LIKE ? OR pc.category_name LIKE ?  OR m.manufacture_name LIKE ?
      ORDER BY p.product_released_date DESC
      """,
      [q, q, q],
    );

    return data.map((data) => Product.fromMap(data)).toList();

    // return result;
  }

  // 최신제품 중복으로 안나오게 쿼리(제한10까지)
  Future<List<Product>> selectDuplicationQuery(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery("""
      select p.* from products p
      join(select product_name, product_color, max(product_id) as max_id
            from products group by product_name, product_color) x
      on p.product_id = x.max_id
      order by p.product_released_date desc
      limit 10;
      """);
    return data.map((data) => Product.fromMap(data)).toList();
  }

  // 인기상품
  Future<List<Product>> selectPopularProductQuery() async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery('''
      select p.*, sum(o.order_quantity) as total_qty
      from products p
      join orders o on o.product_id = p.product_id
      group by p.product_id
      order by total_qty desc
      limit 10;
      ''');

    return data.map((data) => Product.fromMap(data)).toList();
  }

  // 각 재고수량 Query
  Future<Map<int, int>> productQuantityQuery(
    String product_name,
    String product_color,
  ) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery(
      '''
      select p.product_size , coalesce(sum(p.product_quantity), 0) as psum
      from products p
      where p.product_name = ? and p.product_color = ?
      group by p.product_size
      ''',
      [product_name, product_color],
    );

    final map = <int, int>{};

    for (final r in data) {
      final sizeRaw = r['product_size'];
      final qtyRaw = r['psum'];

      // size: null이면 스킵
      if (sizeRaw == null) continue;

      // size 변환
      final int size = sizeRaw is int
          ? sizeRaw
          : sizeRaw is num
          ? sizeRaw.toInt()
          : int.tryParse(sizeRaw.toString()) ?? -1;

      if (size == -1) continue;

      // qty 변환 (SUM이라 num일 수 있음)
      final int qty = qtyRaw == null
          ? 0
          : qtyRaw is int
          ? qtyRaw
          : qtyRaw is num
          ? qtyRaw.toInt()
          : int.tryParse(qtyRaw.toString()) ?? 0;

      map[size] = qty;
    }

    return map;
  }

  // 선택 사이즈의 product_id 찾기
  Future<int?> findVariantProductId({
    required String productName,
    required String productColor,
    required int productSize,
  }) async {
    final db = await Initialize.initDatabase();
    final rows = await db.rawQuery(
      '''
    SELECT product_id
    FROM products
    WHERE product_name = ?
      AND product_color = ?
      AND product_size = ?
    LIMIT 1
  ''',
      [productName, productColor, productSize],
    );

    if (rows.isEmpty) return null;

    final v = rows.first['product_id'];
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}
