
import 'package:shoes_store_app_project/model/product.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class ProductHandler {

  Future<List<Product>> selectQuery(int id) async {
    Database db = await Initialize.initDatabase();
    // 최신제품
    final data = await db.rawQuery("""
      select products.*,productCategories.category_name,manufactures.manufacture_name from products 
      inner join manufactures on products.manufacture_id = manufactures.manufacture_id
      inner join productCategories on productCategories.category_id=products.category_id
      order by products.product_released_date desc
      """);

    return data.map((data)=>Product.fromMap(data)).toList();
  }

  Future<List<Product>> selectQueryById(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery("""
      select products.*,productCategories.category_name,manufactures.manufacture_name from products 
      inner join manufactures on products.manufacture_id = manufactures.manufacture_id
      inner join productCategories on productCategories.category_id=products.category_id
      where products.product_id=?
      """,[id]);

    return data.map((data)=>Product.fromMap(data)).toList();
  }
  



  Future<int> insert(Product prod) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert("""
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
      """,[
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
        DateTime.now().toString()
      ]);
  }

  Future<int> update(Product prod) async {
    Database db = await Initialize.initDatabase();
    return await db.rawUpdate("""
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
      """,[
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
        prod.product_id
      ]);
  }

   // 검색부분 
   Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final Database db = await Initialize.initDatabase();

    // like 검색 (대소문자/공백까지 느슨하게 하려면 query 가공 가능)
    final String q = "%${query.trim()}%";

    // 여기에 product_image 넣으면 나옴
    final result = await db.rawQuery("""
      SELECT product_id, product_name, product_price
      FROM products
      WHERE product_name LIKE ?
      ORDER BY created_at DESC
    """, [q]);

    return result;
  }

}