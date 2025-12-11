
import 'package:shoes_store_app_project/model/product.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class ProductHandler {

  Future<List<Product>> selectQuery(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery("""
      select products.*,productCategories.category_name,manufactures.manufacture_name from products 
      inner join manufactures on products.manufacture_id = manufactures.manufacture_id
      inner join productCategories on productCategories.category_id=products.category_id
    
      """);

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
            product_released_date,
            created_at
   ) values (?,?,?,?,?,?,?,?,?,?,?,?) 
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
        prod.product_released_date.toString(),
        prod.product_id
      ]);
  }



}