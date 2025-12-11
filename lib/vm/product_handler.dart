
import 'package:shoes_store_app_project/model/product.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class ProductHandler {

  Future<List<Product>> selectQuery(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery('select * from products');

    return data.map((data)=>Product.fromMap(data)).toList();
  }
  
  Future<int> insert(Product prod) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert("""
        insert into products( 
     
            product_name,
            product_description,
            gender,
            product_color,
            product_size,
            product_price,
            product_quantity,
            product_released_date,
   
   ) values (?,?,?,?,?,?,?,?) 
      """,[
        prod.product_name,
        prod.product_description,
        prod.gender,
        prod.product_color,
        prod.product_size,
        prod.product_price,
        prod.product_quantity,
        prod.product_released_date.toString()
      ]);
  }

  Future<int> update(Product prod) async {
    Database db = await Initialize.initDatabase();
    return await db.rawUpdate("""
        update products set 
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