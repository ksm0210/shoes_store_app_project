
import 'package:shoes_store_app_project/model/product_category.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class CategoryHandler {

  Future<List<ProductCategory>> selectQuery() async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery('select * from productCategories');

    return data.map((data)=>ProductCategory.fromMap(data)).toList();
  }

  
  Future<int> insert(ProductCategory cat) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert("""
        insert into productCategories( 
          category_name,
          created_at) values(?,?)
      """,[cat.category_name,
      cat.created_at.toString()
      ]);
  }
  Future<int> update(ProductCategory cat) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert("""
        update productCategories set category_name=? where category_id=?
      """,[cat.category_name,cat.category_id]);
  }
}